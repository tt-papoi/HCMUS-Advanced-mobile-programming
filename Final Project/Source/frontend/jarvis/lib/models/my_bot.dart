// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:jarvis/models/knowledge_source.dart';

class Assistant {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final BotType botType;
  final String? prompt;

  List<KnowledgeSource>? knowledgeSources;

  Assistant({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.botType,
    this.prompt,
    this.knowledgeSources,
  });

  /// Convert JSON to Bot
  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      botType:
          json['botType'] == 'official' ? BotType.offical : BotType.createdBot,
      prompt: json['prompt'] as String?,
      knowledgeSources: (json['knowledgeSources'] as List<dynamic>?)
          ?.map((source) => KnowledgeSource.fromJson(source))
          .toList(),
    );
  }

  /// Convert Bot to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'botType': botType == BotType.offical ? 'official' : 'createdBot',
      'prompt': prompt,
      'knowledgeSources':
          knowledgeSources?.map((source) => source.toJson()).toList(),
    };
  }
}

enum BotType { offical, createdBot }
