import 'package:jarvis/models/assistant.dart';

class ProjectConstants {
  static const String baseUrl = 'https://api.dev.jarvis.cx';
  static const String kbUrl = 'https://knowledge-api.dev.jarvis.cx';

  static List<Assistant> defaultAssistants = [
    Assistant(
      name: "Claude 3 Haiku",
      model: "dify",
      id: 'claude-3-haiku-20240307',
      imagePath: "lib/assets/icons/claude-ai-icon.png",
    ),
    Assistant(
      name: "GPT-4o",
      model: "dify",
      id: "gpt-4o",
      imagePath: "lib/assets/icons/gpt-4o.png",
    ),
    Assistant(
      name: "Gemini 1.5 Flash",
      model: "dify",
      id: 'gemini-1.5-flash-latest',
      imagePath: "lib/assets/icons/google-gemini-icon.png",
    ),
    Assistant(
      name: "Gemini 1.5 Pro",
      model: "dify",
      id: 'gemini-1.5-pro-latest',
      imagePath: "lib/assets/icons/google-gemini-icon.png",
    ),
    Assistant(
      name: "gpt-4o-mini",
      model: "dify",
      id: "gpt-4o-mini",
      imagePath: "lib/assets/icons/gpt-4o-mini.png",
    ),
    // Assistant(
    //   name: "Claude 3 Sonnet",
    //   model: "dify",
    //   id: 'claude-3-sonnet-20240229',
    //   imagePath: "lib/assets/icons/claude-ai-icon.png",
    // ),
  ];
}
