import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadChatMessagesEvent>(_onLoadChatMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onLoadChats(LoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    final chats = [
      const Chat(
        id: '1',
        name: 'Dixith',
        lastMessage: 'done 👍',
        time: '15:15',
        unreadCount: 1,
      ),
      const Chat(
        id: '2',
        name: 'Nihal',
        lastMessage: "Don't read the caption,",
        time: '15:15',
        unreadCount: 1,
      ),
      const Chat(
        id: '3',
        name: 'Avinash',
        lastMessage: "You: its all same, you dumb dumb",
        time: '15:15',
        unreadCount: 1,
      ),
      const Chat(
        id: '4',
        name: 'Subbu',
        lastMessage: 'You: done 👍',
        time: '15:15',
        unreadCount: 0,
      ),
    ];

    emit(ChatsLoaded(chats: chats));
  }

  void _onLoadChatMessages(
    LoadChatMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    final messages = [
      const ChatMessage(id: '1', text: 'Tuesday (Jan 23)', isDate: true),
      const ChatMessage(
        id: '2',
        text: 'Glad to see the excitement',
        isSent: false,
      ),
      const ChatMessage(
        id: '3',
        text: "That's very nice place!! Can't wait to attend this event.",
        isSent: false,
        time: '12:30 PM',
      ),
      const ChatMessage(
        id: '4',
        text: "That's very nice place!! Can't wait to attend this event.",
        isSent: true,
        time: '1:04 PM',
      ),
      const ChatMessage(id: '5', text: 'Today', isDate: true),
      const ChatMessage(
        id: '6',
        text: 'Hey, shared a note. Check it out',
        isSent: false,
      ),
      const ChatMessage(
        id: '7',
        text: "That's very nice place!! Can't wait to attend this event.",
        isSent: true,
        time: '1:04 PM',
      ),
    ];

    emit(ChatMessagesLoaded(chatId: event.chatId, messages: messages));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    if (event.message.isEmpty) {
      emit(const ChatError(message: 'Message cannot be empty'));
      return;
    }

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.message,
      isSent: true,
      time: _formatTime(DateTime.now()),
    );

    emit(MessageSent(message: message));
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
