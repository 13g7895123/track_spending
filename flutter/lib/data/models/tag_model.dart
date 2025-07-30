import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

@JsonSerializable()
class Tag {
  final String id;
  final String name;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color color;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  Tag copyWith({
    String? id,
    String? name,
    Color? color,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tag && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, color: $color)';
  }

  // Color JSON 轉換輔助方法
  static Color _colorFromJson(int colorValue) => Color(colorValue);
  static int _colorToJson(Color color) => color.value;
}