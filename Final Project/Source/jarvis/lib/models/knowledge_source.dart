import 'package:jarvis/models/unit.dart';

class KnowledgeSource {
  String userId; // Unique identifier for the knowledge source
  String knowledgeName; // Name of the source
  String description; // Description of the source
  List<Unit>? units; // List of associated units (optional)
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? deletedAt;
  String id;
  int? numUnits;
  int? totalSize;
  KnowledgeSource({
    required this.userId,
    required this.knowledgeName,
    required this.description,
    this.units,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    required this.id,
    required this.numUnits,
    required this.totalSize,
  });

  /// Convert JSON to KnowledgeSource
  factory KnowledgeSource.fromJson(Map<String, dynamic> json) {
    return KnowledgeSource(
      userId: json['userId'] as String,
      knowledgeName: json['knowledgeName'] as String,
      description: json['description'] as String,
      // units: (json['units'] as List<dynamic>?)
      //     ?.map((unit) => Unit.fromJson(unit))
      //     .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      createdBy: json['createdBy'] as Null,
      updatedBy: json['updatedBy'] as Null,
      deletedAt: json['deletedAt'] as Null,
      id: json['id'] as String,
      numUnits: json['numUnits'] as int,
      totalSize: json['totalSize'] as int,
    );
  }

  /// Convert KnowledgeSource to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': knowledgeName,
      'description': description,
      'units': units?.map((unit) => unit.toJson()).toList(),
    };
  }
}
