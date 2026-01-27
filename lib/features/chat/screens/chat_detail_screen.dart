import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/chat_message_model.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/background_widget.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatDetailScreen extends StatefulWidget {
  final String tripId;
  final String tripName;

  const ChatDetailScreen({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(widget.tripId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(tripId: widget.tripId, text: text));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.tripName,
        gradient: AppColors.headerGradient,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(widget.tripName),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Trip Details'),
                      const SizedBox(height: 8),
                      Text('Trip ID: ${widget.tripId}'),
                      // Add more details if available in context or arguments
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BackgroundWidget(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state.status == ChatStatus.loaded) {
                     Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
                  } else if (state.status == ChatStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage ?? 'Error')),
                    );
                  }
                },
                builder: (context, state) {
                   if (state.status == ChatStatus.loading) {
                     return const Center(child: CircularProgressIndicator());
                   }
                   
                   final messages = state.messages;
                   if (messages.isEmpty) {
                     return Center(
                       child: Text(
                         'No messages yet. Start the conversation!',
                         style: TextStyle(color: AppColors.textSecondary),
                       ),
                     );
                   }

                   return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSizes.screenPadding),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isFirstMessage = index == 0;
                      final isNewDay = isFirstMessage ||
                          !_isSameDay(
                            messages[index - 1].timestamp,
                            message.timestamp,
                          );

                      return Column(
                        children: [
                          if (isNewDay) _buildDateSeparator(message.timestamp),
                          _buildMessageBubble(message),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDateSeparator(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMedium,
          vertical: AppSizes.spacingXSmall,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: Text(
          DateFormat('MMMM d, yyyy').format(date),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.spacingSmall),
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.primary : AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSizes.radiusMedium),
            topRight: const Radius.circular(AppSizes.radiusMedium),
            bottomLeft: Radius.circular(
              message.isMe ? AppSizes.radiusMedium : 0,
            ),
            bottomRight: Radius.circular(
              message.isMe ? 0 : AppSizes.radiusMedium,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMe ? AppColors.textWhite : AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(
                color: message.isMe
                    ? AppColors.textWhite.withOpacity(0.7)
                    : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: AppColors.textLight),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textLight),
                  ),
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacingSmall),
            BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: state.status == ChatStatus.loading 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            ) 
                          : const Icon(Icons.send, color: AppColors.textWhite),
                      onPressed: state.status == ChatStatus.loading ? null : _handleSendMessage,
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
