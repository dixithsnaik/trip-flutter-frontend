import 'package:equatable/equatable.dart';
import '../../../../core/models/chat_message_model.dart';
import '../../../../core/models/chat_model.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatMessage> messages;
  final List<ChatModel> chats;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.chats = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    List<ChatModel>? chats,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      chats: chats ?? this.chats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, chats, errorMessage];
}
