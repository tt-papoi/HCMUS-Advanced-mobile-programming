class Assistant {
  final String name;
  final String model;
  final String id;
  final String? imagePath;

  Assistant({
    required this.name,
    required this.model,
    required this.id,
    this.imagePath,
  });

  /// Convert JSON to Assistant
  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      name: json['name'] as String,
      model: json['model'] as String,
      id: json['id'] as String,
    );
  }

  /// Convert Assistant to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'model': model,
      'id': id,
    };
  }
}
