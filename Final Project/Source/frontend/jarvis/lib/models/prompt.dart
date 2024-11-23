// ignore_for_file: constant_identifier_names
import 'package:jarvis/services/storage_service.dart';

class Prompt {
  String id;
  String username;
  String content;
  String description;
  String name;
  Category category;
  PromptType promptType;
  bool isMine;
  bool isFavorite;
  List<Map<String, String>>? placeholders; //  placeholder and value

  Prompt({
    required this.id,
    required this.content,
    required this.category,
    required this.description,
    required this.promptType,
    required this.isMine,
    required this.name,
    required this.isFavorite,
    required this.username,
  }) {
    placeholders = extractStringsInBrackets(content);
  }

  static Future<Prompt> fromJson(Map<String, dynamic> json) async {
    StorageService storageService = StorageService();
    String userId = await storageService.getUserId() ?? '';
    return Prompt(
      id: json['_id'],
      username: json['userName'],
      content: json['content'],
      description: json['description'],
      category: Category.values.firstWhere((e) =>
          e.toString().split('.').last.toLowerCase() ==
          json['category'].toLowerCase()),
      promptType: json['isPublic'] ? PromptType.public : PromptType.private,
      isMine: json['userId'] == userId,
      name: json['title'],
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': username,
      'content': content,
      'description': description,
      'category': category.toString().split('.').last.toLowerCase(),
      'isPublic': promptType == PromptType.public,
      "language": "English",
      'title': name,
    };
  }

  List<Map<String, String>> extractStringsInBrackets(String input) {
    // Find strings in []
    final RegExp regex = RegExp(r'\[(.*?)\]');

    // find all strings match with RegExp
    final matches = regex.allMatches(input);

    // Create List Map for placeholder and value
    return matches.map((match) {
      String placeholder = match.group(1)!; // Lấy placeholder
      return {placeholder: ''}; // Giá trị mặc định là chuỗi rỗng
    }).toList();
  }

  String getFinalPrompt() {
    String finalPrompt = content;

    for (var placeholder in placeholders!) {
      String key = placeholder.keys.first;
      String value = placeholder[key] ?? '';
      finalPrompt = finalPrompt.replaceAll('[$key]', value);
    }

    return finalPrompt;
  }

  Prompt copyWith({
    String? id,
    String? content,
    String? username,
    String? name,
    String? description,
    Category? category,
    PromptType? promptType,
    bool? isMine,
    bool? isFavorite,
    List<Map<String, String>>? placeholders,
  }) {
    return Prompt(
      id: id ?? this.id,
      username: username ?? this.username,
      content: content ?? this.content,
      description: description ?? this.description,
      name: name ?? this.name,
      category: category ?? this.category,
      promptType: promptType ?? this.promptType,
      isMine: isMine ?? this.isMine,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

enum PromptType { private, public }

enum Category {
  All,
  Other,
  Marketing,
  Coding,
  Writing,
  Career,
  SEO,
  Business,
  Education,
  Fun,
  Productivity,
  Chatbot,
}
