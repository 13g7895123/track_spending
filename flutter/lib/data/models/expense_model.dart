import 'package:json_annotation/json_annotation.dart';
import 'tag_model.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class Expense {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final String category;
  final DateTime date;
  final String? receiptImageUrl;
  final List<Tag> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    this.receiptImageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  Expense copyWith({
    String? id,
    String? userId,
    double? amount,
    String? description,
    String? category,
    DateTime? date,
    String? receiptImageUrl,
    List<Tag>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Expense(id: $id, amount: $amount, description: $description, category: $category, date: $date)';
  }
}

// 支出分類枚舉
enum ExpenseCategory {
  food('食物'),
  transport('交通'),
  entertainment('娛樂'),
  shopping('購物'),
  health('醫療'),
  education('教育'),
  utilities('水電'),
  housing('住房'),
  other('其他');

  const ExpenseCategory(this.displayName);
  final String displayName;

  static ExpenseCategory fromString(String category) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.name == category,
      orElse: () => ExpenseCategory.other,
    );
  }
}