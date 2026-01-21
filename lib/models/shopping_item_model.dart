import 'package:cloud_firestore/cloud_firestore.dart';

/// Shopping list item model
class ShoppingItemModel {
  final String? itemId;
  final String userId;
  final String itemName;
  final String quantity;
  final bool isPurchased;
  final DateTime addedAt;

  ShoppingItemModel({
    this.itemId,
    required this.userId,
    required this.itemName,
    required this.quantity,
    this.isPurchased = false,
    required this.addedAt,
  });

  /// Convert ShoppingItemModel to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'itemName': itemName,
      'quantity': quantity,
      'isPurchased': isPurchased,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  /// Create ShoppingItemModel from Firestore document
  factory ShoppingItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingItemModel(
      itemId: doc.id,
      userId: data['userId'] ?? '',
      itemName: data['itemName'] ?? '',
      quantity: data['quantity'] ?? '1',
      isPurchased: data['isPurchased'] ?? false,
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  /// Create ShoppingItemModel from Map
  factory ShoppingItemModel.fromMap(String itemId, Map<String, dynamic> map) {
    return ShoppingItemModel(
      itemId: itemId,
      userId: map['userId'] ?? '',
      itemName: map['itemName'] ?? '',
      quantity: map['quantity'] ?? '1',
      isPurchased: map['isPurchased'] ?? false,
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userId': userId,
      'itemName': itemName,
      'quantity': quantity,
      'isPurchased': isPurchased,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  ShoppingItemModel copyWith({
    String? itemId,
    String? userId,
    String? itemName,
    String? quantity,
    bool? isPurchased,
    DateTime? addedAt,
  }) {
    return ShoppingItemModel(
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      isPurchased: isPurchased ?? this.isPurchased,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  String toString() {
    return 'ShoppingItemModel(itemId: $itemId, itemName: $itemName, isPurchased: $isPurchased)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItemModel &&
        other.itemId == itemId &&
        other.userId == userId &&
        other.itemName == itemName &&
        other.quantity == quantity &&
        other.isPurchased == isPurchased &&
        other.addedAt == addedAt;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^
        userId.hashCode ^
        itemName.hashCode ^
        quantity.hashCode ^
        isPurchased.hashCode ^
        addedAt.hashCode;
  }
}
