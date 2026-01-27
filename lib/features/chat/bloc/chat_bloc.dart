import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpconnect/core/models/chat_model.dart' show ChatModel;
import '../../../../core/api/trip_api.dart';
import '../../../../core/models/chat_message_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<LoadChatsEvent>(_onLoadChats);
  }

  Future<void> _onLoadChats(LoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      // Mock Data for now
      await Future.delayed(const Duration(milliseconds: 500));
      final chats = [
        const ChatModel(
          id: '1', 
          name: 'Goa Trip 2024', 
          lastMessage: 'Pack your bags!', 
          time: '10:30 AM',
          unreadCount: 2,
        ),
        const ChatModel(
          id: '2', 
          name: 'Weekend Hike', 
          lastMessage: 'Meeting point at 6 AM', 
          time: 'Yesterday',
        ),
      ];
      emit(state.copyWith(status: ChatStatus.loaded, chats: chats));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final messages = await TripApi.getMessages(event.tripId);
      emit(state.copyWith(status: ChatStatus.loaded, messages: messages));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    // For smoother UI, we could optimistically add message, but adhering to strict mock API logic here
    try {
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'current_user_id',
        text: event.text,
        timestamp: DateTime.now(),
        isMe: true,
      );
      
      await TripApi.sendMessage(event.tripId, newMessage);
      
      // Refresh messages
      final messages = await TripApi.getMessages(event.tripId);
      emit(state.copyWith(status: ChatStatus.loaded, messages: messages));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }
}
