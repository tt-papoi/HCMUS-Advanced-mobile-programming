import 'package:flutter/foundation.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/services/prompt_service.dart';

class PromptProvider with ChangeNotifier {
  final PromptService promptService = PromptService();
  final AuthProvider authProvider = AuthProvider();
  List<Prompt> _prompts = [];
  bool _isLoading = false;

  List<Prompt> get prompts => _prompts;
  bool get isLoading => _isLoading;

  Future<void> fetchPrompts(
      {String query = '',
      int offset = 0,
      int limit = 20,
      bool isFavorite = false,
      bool isPublic = true}) async {
    try {
      authProvider.loadTokens();
      authProvider.refreshAccessToken();
      promptService.setToken(authProvider.accessToken!);
      final response = await promptService.getPrompts(
          query: query,
          offset: offset,
          limit: limit,
          isFavorite: isFavorite,
          isPublic: isPublic);

      if (response != null &&
          response.containsKey('items') &&
          response['items'] != null) {
        _prompts = [];
        for (var item in response['items']) {
          _prompts.add(Prompt.fromJson(item as Map<String, dynamic>));
        }
      } else {
        _prompts = []; // If there are no 'items', the list is empty
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching prompts: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPrompt(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await promptService.createPrompt(data);
      await fetchPrompts();
    } catch (e) {
      if (kDebugMode) {
        print("Error creating prompt: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePrompt(String promptId, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await promptService.updatePrompt(promptId, data);
      await fetchPrompts();
    } catch (e) {
      if (kDebugMode) {
        print("Error updating prompt: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePrompt(String promptId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await promptService.deletePrompt(promptId);
      await fetchPrompts();
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting prompt: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPromptToFavorite(String promptId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await promptService.addPromptToFavorite(promptId);
      await fetchPrompts();
    } catch (e) {
      if (kDebugMode) {
        print("Error adding prompt to favorite: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removePromptFromFavorite(String promptId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await promptService.removePromptFromFavorite(promptId);
      await fetchPrompts();
    } catch (e) {
      if (kDebugMode) {
        print("Error removing prompt from favorite: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
