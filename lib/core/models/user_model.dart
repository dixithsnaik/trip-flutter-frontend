class User {
  final String id;
  final String fullName;
  final String username;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String? profileImage;
  final List<String> interests;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    this.profileImage,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      gender: json['gender'] as String,
      profileImage: json['profileImage'] as String?,
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'profileImage': profileImage,
      'interests': interests,
    };
  }
}
