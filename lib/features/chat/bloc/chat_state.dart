import 'package:equatable/equatable.dart';

class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;

  const Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isSent;
  final String? time;
  final bool isDate;

  const ChatMessage({
    required this.id,
    required this.text,
    this.isSent = false,
    this.time,
    this.isDate = false,
  });
}

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;

  const ChatsLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class ChatMessagesLoaded extends ChatState {
  final String chatId;
  final List<ChatMessage> messages;

  const ChatMessagesLoaded({
    required this.chatId,
    required this.messages,
  });

  @override
  List<Object?> get props => [chatId, messages];
}

class MessageSent extends ChatState {
  final ChatMessage message;

  const MessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

