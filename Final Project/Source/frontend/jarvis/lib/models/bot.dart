// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:jarvis/models/knowledge_source.dart';

class Bot {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final BotType botType;
  final String? prompt;

  List<KnowledgeSource>? knowledgeSources;

  Bot({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.botType,
    this.prompt,
    this.knowledgeSources,
  });
}

enum BotType { offical, createdBot }
