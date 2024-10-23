class KnowledgeSource {
  String id;
  String name;
  String description;
  List<Unit>? units;
  KnowledgeSource({
    required this.id,
    required this.name,
    required this.description,
    this.units,
  });
}

class Unit {
  String id;
  String name;
  Unit({
    required this.id,
    required this.name,
    required this.unitType,
  });
  UnitType unitType;
}

enum UnitType { file, googleDrive, slack, website, confluence }
