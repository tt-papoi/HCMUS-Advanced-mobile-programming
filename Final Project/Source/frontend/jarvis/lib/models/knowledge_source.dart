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
  bool? isEnabled;
  Unit({
    required this.id,
    required this.name,
    required this.unitType,
    this.isEnabled = true,
  });
  UnitType unitType;
}

enum UnitType { localfile, googleDrive, slack, website, confluence }
