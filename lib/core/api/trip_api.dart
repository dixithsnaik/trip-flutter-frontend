import 'dart:math';
import '../models/trip_model.dart';
import '../models/chat_message_model.dart';

class TripApi {
  // Mock Data store
  static final List<Trip> _trips = [
    Trip(
      id: '1',
      name: 'Manali Road Trip',
      date: '15 Aug 2024',
      description: 'A fun road trip to the mountains.',
      checkpoints: [
        Checkpoint(id: 'c1', name: 'Start', location: 'Delhi', time: '06:00 AM'),
        Checkpoint(id: 'c2', name: 'Stop 1', location: 'Chandigarh', time: '10:00 AM'),
        Checkpoint(id: 'c3', name: 'End', location: 'Manali', time: '06:00 PM'),
      ],
      hostId: 'user1',
      participants: ['user1', 'user2', 'user3'],
      type: 'Group Trips',
    ),
    Trip(
      id: '2',
      name: 'Goa Beach Party',
      date: '20 Dec 2024',
      description: 'Sun, sand and sea.',
      checkpoints: [
        Checkpoint(id: 'c4', name: 'Airport', location: 'Goa Airport', time: '12:00 PM'),
        Checkpoint(id: 'c5', name: 'Hotel', location: 'North Goa', time: '02:00 PM'),
      ],
      hostId: 'user2',
      participants: ['user2', 'user4'],
      type: 'Group Trips',
    ),
    Trip(
      id: '3',
      name: 'Solo Bike Ride',
      date: '10 Sep 2024',
      description: 'Just me and my bike.',
      checkpoints: [
        Checkpoint(id: 'c6', name: 'Start', location: 'Bangalore', time: '05:00 AM'),
      ],
      hostId: 'user1',
      participants: ['user1'],
      type: 'Solo Trips',
    ),
  ];

  static final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      senderId: 'user2',
      text: 'Hey everyone, ready for the trip?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isMe: false,
    ),
    ChatMessage(
      id: 'm2',
      senderId: 'user1',
      text: 'Yes! Can\'t wait.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: true,
    ),
  ];

  // API Methods
  static Future<List<Trip>> getTrips(String type) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate latency
    if (type == 'All') {
      return _trips;
    }
    return _trips.where((trip) => trip.type == type).toList();
  }

  static Future<void> createTrip(Trip trip) async {
    await Future.delayed(const Duration(seconds: 1));
    _trips.add(trip);
  }

  static Future<List<ChatMessage>> getMessages(String tripId) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, filter by tripId. For mock, returning same messages.
    return List.from(_messages);
  }

  static Future<void> sendMessage(String tripId, ChatMessage message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _messages.add(message);
  }
}
