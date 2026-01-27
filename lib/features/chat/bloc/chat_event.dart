import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessagesEvent extends ChatEvent {
  final String tripId;

  const LoadMessagesEvent(this.tripId);

  @override
  List<Object> get props => [tripId];
}

class SendMessageEvent extends ChatEvent {
  final String tripId;
  final String text;

  const SendMessageEvent({required this.tripId, required this.text});

  @override
  List<Object> get props => [tripId, text];
}

class LoadChatsEvent extends ChatEvent {
  const LoadChatsEvent();
}
