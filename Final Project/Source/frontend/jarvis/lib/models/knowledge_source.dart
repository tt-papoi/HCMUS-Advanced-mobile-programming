class KnowledgeSource {
  String id; // Unique identifier for the knowledge source
  String name; // Name of the source
  String description; // Description of the source
  List<Unit>? units; // List of associated units (optional)

  KnowledgeSource({
    required this.id,
    required this.name,
    required this.description,
    this.units,
  });

  /// Convert JSON to KnowledgeSource
  factory KnowledgeSource.fromJson(Map<String, dynamic> json) {
    return KnowledgeSource(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      units: json['units'] != null
          ? (json['units'] as List)
              .map((unitJson) => Unit.fromJson(unitJson))
              .toList()
          : null,
    );
  }

  /// Convert KnowledgeSource to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
