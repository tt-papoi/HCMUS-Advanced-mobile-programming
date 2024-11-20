// ignore_for_file: constant_identifier_names
class Prompt {
  String id;
  String prompt;
  String name;
  Category category;
  PromptType promptType;
  bool isMine;
  bool isFavorite;
  List<Map<String, String>>? placeholders; //  placeholder and value

  Prompt({
    required this.id,
    required this.prompt,
    required this.category,
    required this.promptType,
    required this.isMine,
    required this.name,
    required this.isFavorite,
  }) {
    placeholders = extractStringsInBrackets(prompt);
  }

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['_id'],
      prompt: json['content'],
      category: Category.values.firstWhere((e) =>
          e.toString().split('.').last.toLowerCase() ==
          json['category'].toLowerCase()),
      promptType: json['isPublic'] ? PromptType.public : PromptType.private,
      isMine: json['isPublic'],
      name: json['title'],
      isFavorite: json['isFavorite'],
    );
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
    String finalPrompt = prompt;

    for (var placeholder in placeholders!) {
      String key = placeholder.keys.first;
      String value = placeholder[key] ?? '';
      finalPrompt = finalPrompt.replaceAll('[$key]', value);
    }

    return finalPrompt;
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
}
