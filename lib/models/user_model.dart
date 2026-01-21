import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing user profile information
/// Stored in Firestore 'users' collection
class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;
  final String? dietaryPreference;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.dietaryPreference,
  });

  /// Convert UserModel to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'dietaryPreference': dietaryPreference,
    };
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dietaryPreference: data['dietaryPreference'],
    );
  }

  /// Create UserModel from Map
  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      dietaryPreference: map['dietaryPreference'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'dietaryPreference': dietaryPreference,
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? createdAt,
    String? dietaryPreference,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        uid == other.uid &&
        email == other.email &&
        name == other.name;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ email.hashCode ^ name.hashCode;
  }
}
