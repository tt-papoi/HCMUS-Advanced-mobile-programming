import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/services/prompt_service.dart';

class PromptProvider with ChangeNotifier {
  final PromptService promptService = PromptService();
  final AuthProvider authProvider = AuthProvider();
  List<Prompt> _prompts = [];
  bool isLoading = true;

  List<Prompt> get prompts => _prompts;

  Future<void> fetchPrompts({
    String query = '',
    int offset = 0,
    int limit = 20,
    bool isFavorite = false,
    bool isPublic = true,
  }) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    try {
      await authProvider.loadTokens();
      await authProvider.refreshAccessToken();
      promptService.setToken(authProvider.accessToken!);

      final response = await promptService.getPrompts(
        query: query,
        offset: offset,
        limit: limit,
        isFavorite: isFavorite,
        isPublic: isPublic,
      );

      if (response != null &&
          response.containsKey('items') &&
          response['items'] != null) {
        _prompts = [];
        for (var item in response['items']) {
          _prompts.add(await Prompt.fromJson(item as Map<String, dynamic>));
        }
      } else {
        _prompts = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching prompts: $e");
      }
    } finally {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  Future<void> createPrompt(Prompt prompt) async {
    isLoading = true;
    notifyListeners();

    try {
      await authProvider.refreshAccessToken();
      await promptService.setToken(authProvider.accessToken!);
      await promptService.createPrompt(prompt.toJson());
      await fetchPrompts(limit: 50, isPublic: !prompt.isMine);
    } catch (e) {
      if (kDebugMode) {
        print("Error creating prompt: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePrompt(Prompt prompt) async {
    isLoading = true;
    notifyListeners();

    try {
      await authProvider.refreshAccessToken();
      await promptService.setToken(authProvider.accessToken!);
      await promptService.updatePrompt(prompt.id, prompt.toJson());
      await fetchPrompts(limit: 50, isPublic: !prompt.isMine);
    } catch (e) {
      if (kDebugMode) {
        print("Error updating prompt: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePrompt(Prompt prompt) async {
    isLoading = true;
    notifyListeners();

    try {
      await promptService.deletePrompt(prompt.id);
      await fetchPrompts(limit: 50, isPublic: !prompt.isMine);
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting prompt: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPromptToFavorite(String promptId) async {
    try {
      await promptService.addPromptToFavorite(promptId);
      // Update the local prompt list without fetching all prompts again
      int index = _prompts.indexWhere((prompt) => prompt.id == promptId);
      if (index != -1) {
        _prompts[index] = _prompts[index].copyWith(isFavorite: true);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding prompt to favorite: $e");
      }
    }
  }

  Future<void> removePromptFromFavorite(String promptId) async {
    try {
      await promptService.removePromptFromFavorite(promptId);
      // Update the local prompt list without fetching all prompts again
      int index = _prompts.indexWhere((prompt) => prompt.id == promptId);
      if (index != -1) {
        _prompts[index] = _prompts[index].copyWith(isFavorite: false);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error removing prompt from favorite: $e");
      }
    }
  }
}
