class KnowledgeSource {
  String userId; // Unique identifier for the knowledge source
  String name; // Name of the source
  String description; // Description of the source
  List<Unit>? units; // List of associated units (optional)
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? deletedAt;
  String id;
  String numUnits;
  String totalSize;
  KnowledgeSource({
    required this.userId,
    required this.name,
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
      name: json['name'] as String,
      description: json['description'] as String,
      // units: (json['units'] as List<dynamic>?)
      //     ?.map((unit) => Unit.fromJson(unit))
      //     .toList(),
      createdAt: json['createdAt'] as DateTime,
      updatedAt: json['updatedAt'] as DateTime,
      createdBy: json['createdBy'] as Null,
      updatedBy: json['updatedBy'] as Null,
      deletedAt: json['deletedAt'] as Null,
      id: json['id'] as String,
      numUnits: json['numUnits'] as String,
      totalSize: json['totalSize'] as String,
    );
  }

  /// Convert KnowledgeSource to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'units': units?.map((unit) => unit.toJson()).toList(),
    };
  }
}

class Unit {
  String id; // Unique identifier for the unit
  String name; // Name of the unit
  UnitType unitType; // Type of the unit
  bool? isEnabled; // Whether the unit is enabled (default: true)

  Unit({
    required this.id,
    required this.name,
    required this.unitType,
    this.isEnabled = true,
  });

  /// Convert JSON to Unit
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as String,
      name: json['name'] as String,
      unitType:
          UnitType.values.firstWhere((type) => type.name == json['unitType']),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  /// Convert Unit to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitType': unitType.name,
      'isEnabled': isEnabled,
    };
  }
}

enum UnitType { localfile, googleDrive, slack, website, confluence }
