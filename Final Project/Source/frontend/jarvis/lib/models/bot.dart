// ignore_for_file: public_member_api_docs, sort_constructors_first
class Bot {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final BotType botType;
  final String? prompt;

  Bot({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.botType,
    this.prompt,
  });
}

enum BotType { offical, createdBot }
