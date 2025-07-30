import 'package:json_annotation/json_annotation.dart';
import 'tag_model.dart';

part 'income_model.g.dart';

@JsonSerializable()
class Income {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final String source;
  final DateTime date;
  final List<Tag> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Income({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.source,
    required this.date,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);
  Map<String, dynamic> toJson() => _$IncomeToJson(this);

  Income copyWith({
    String? id,
    String? userId,
    double? amount,
    String? description,
    String? source,
    DateTime? date,
    List<Tag>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Income(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      source: source ?? this.source,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Income && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Income(id: $id, amount: $amount, description: $description, source: $source, date: $date)';
  }
}

// 收入來源枚舉
enum IncomeSource {
  salary('薪水'),
  bonus('獎金'),
  investment('投資'),
  freelance('兼職'),
  gift('禮金'),
  other('其他');

  const IncomeSource(this.displayName);
  final String displayName;

  static IncomeSource fromString(String source) {
    return IncomeSource.values.firstWhere(
      (e) => e.name == source,
      orElse: () => IncomeSource.other,
    );
  }
}