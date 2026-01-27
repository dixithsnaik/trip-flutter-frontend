class Trip {
  final String id;
  final String name;
  final String date;
  final String description;
  final List<Checkpoint> checkpoints;
  final String hostId;
  final List<String> participants;
  final String type; // 'Group' or 'Solo'

  Trip({
    required this.id,
    required this.name,
    required this.date,
    required this.description,
    required this.checkpoints,
    required this.hostId,
    required this.participants,
    required this.type,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      checkpoints: (json['checkpoints'] as List<dynamic>)
          .map((e) => Checkpoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      hostId: json['hostId'] as String,
      participants: List<String>.from(json['participants'] ?? []),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'description': description,
      'checkpoints': checkpoints.map((e) => e.toJson()).toList(),
      'hostId': hostId,
      'participants': participants,
      'type': type,
    };
  }
}

class Checkpoint {
  final String id;
  final String name;
  final String location;
  final String? time;

  Checkpoint({
    required this.id,
    required this.name,
    required this.location,
    this.time,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      time: json['time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'time': time,
    };
  }
}
