import 'package:flutter/material.dart';
import 'package:jarvis/views/dialogs/view_prompt_dialog.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/views/dialogs/confirm_delete_dialog.dart';
import 'package:jarvis/views/dialogs/create_prompt_dialog.dart';
import 'package:jarvis/views/dialogs/edit_prompt_dialog.dart';
import 'package:jarvis/views/dialogs/used_prompt_dialog.dart';
import 'package:jarvis/widgets/custom_search_bar.dart';
import 'package:jarvis/providers/prompt_provider.dart';

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  State<PromptLibrary> createState() => _PromptLibraryState();
}

class _PromptLibraryState extends State<PromptLibrary> {
  bool isShowMyPrompt = true;
  bool isActiveFavoriteFilter = false;
  Category selectedCategory = Category.All;
  bool isShowAllCategories = false;
  late PromptProvider promptProvider;

  @override
  void initState() {
    super.initState();
    promptProvider = Provider.of<PromptProvider>(context, listen: false);
    promptProvider.isLoading = true;
    _fetchPrompts(limit: 50, isPublic: !isShowMyPrompt);
  }

  Future<void> _fetchPrompts({
    String query = '',
    int offset = 0,
    int limit = 20,
    bool isFavorite = false,
    bool isPublic = true,
  }) async {
    await promptProvider.fetchPrompts(
      query: query,
      isFavorite: isFavorite,
      isPublic: isPublic,
      offset: offset,
      limit: limit,
    );
    if (mounted) {
      setState(() {
        promptProvider.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PromptProvider>(
      builder: (context, promptProvider, child) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildToggleButtonRow(),
              ),
              const SizedBox(height: 10),
              _buildSearchBar(),
              _buildPromptList(promptProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Prompt Library",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                _showCreatePromptDialog(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButtonRow() {
    return Container(
      width: 250,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(15, 0, 0, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton('My prompts', isShowMyPrompt),
          _buildToggleButton('Public prompts', !isShowMyPrompt),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            setState(() {
              isShowMyPrompt = text == 'My prompts';
              selectedCategory = Category.All;
              promptProvider.isLoading = true;
              _fetchPrompts(isPublic: !isShowMyPrompt);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return isShowMyPrompt
        ? CustomSearchBar(
            hintText: "Search",
            onChanged: (String value) {
              setState(() {
                promptProvider.isLoading = true;
                _fetchPrompts(
                  query: value,
                  isPublic: false,
                );
              });
            })
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                        hintText: "Search",
                        onChanged: (String value) {
                          setState(() {
                            promptProvider.isLoading = true;
                            _fetchPrompts(
                              query: value,
                              isPublic: true,
                            );
                          });
                        }),
                  ),
                  const SizedBox(width: 10),
                  _buildFavoriteFilterButton(),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: isShowAllCategories
                        ? _buildAllCategoryFilter()
                        : _buildSmallCategoryFilter(),
                  ),
                  const SizedBox(width: 5),
                  _buildCategoryToggleButton(),
                ],
              ),
            ],
          );
  }

  Widget _buildFavoriteFilterButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          isActiveFavoriteFilter = !isActiveFavoriteFilter;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isActiveFavoriteFilter
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: isActiveFavoriteFilter ? Colors.blueAccent : Colors.black38,
          size: 25,
        ),
      ),
    );
  }

  Widget _buildCategoryToggleButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        setState(() {
          isShowAllCategories = !isShowAllCategories;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(15, 0, 0, 0),
            borderRadius: BorderRadius.circular(5)),
        child: Icon(
          isShowAllCategories ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildPromptList(PromptProvider promptProvider) {
    if (promptProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: ListView.separated(
        itemCount: promptProvider.prompts.length,
        itemBuilder: (context, index) {
          Prompt prompt = promptProvider.prompts[index];

          if (
              // My prompts/Public prompts Filter
              // If the user has selected "My prompts",
              // this checks if the current prompt is not mine.
              // If true, it skips the prompt by returning an empty Container
              isShowMyPrompt && !prompt.isMine ||

                  // If the user has selected "Public" prompts,
                  // this checks if the current prompt is not public.
                  // If true, it skips the prompt
                  !isShowMyPrompt && prompt.promptType != PromptType.public ||

                  // Favorite filter
                  // Applies only when public prompts are selected.
                  // Checks if the favorite filter is active and
                  // the current prompt is not marked as favorite.
                  // If both conditions are true, it skips the prompt
                  !isShowMyPrompt &&
                      isActiveFavoriteFilter &&
                      !prompt.isFavorite ||

                  // Category filter
                  selectedCategory != Category.All &&
                      selectedCategory != prompt.category) {
            return Container();
          }

          return _buildPromptTile(prompt, index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 0,
            thickness: 0.5,
          );
        },
      ),
    );
  }

  void _showPromptInput(Prompt prompt) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return UsedPromptDialog(
          prompt: prompt,
        );
      },
    );

    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Widget _buildPromptTile(Prompt prompt, int index) {
    return ListTile(
      onTap: () {
        _showPromptInput(prompt);
      },
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      title: Text(
        prompt.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        prompt.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isShowMyPrompt
              // edit prompt
              ? IconButton(
                  onPressed: () {
                    _showEditPromptDialog(context, index);
                  },
                  icon: const Icon(Icons.mode_edit_outlined,
                      size: 20, color: Colors.black54),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      if (prompt.isFavorite) {
                        promptProvider.removePromptFromFavorite(prompt.id);
                      } else {
                        promptProvider.addPromptToFavorite(prompt.id);
                      }
                    });
                  },
                  icon: prompt.isFavorite
                      ? const Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: Colors.blueAccent,
                        )
                      : const Icon(
                          Icons.star_border_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),
                ),
          isShowMyPrompt
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          onDelete: (index) {
                            Provider.of<PromptProvider>(context, listen: false)
                                .deletePrompt(prompt);
                          },
                          parameter: index,
                          title: 'Delete prompt',
                          content:
                              'Are you sure you want to delete this prompt?',
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    // View info
                    _showPublicPromptInfo(context, prompt);
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.blueAccent,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSmallCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < Category.values.length; i++) ...[
            _buildCategoryButton(Category.values[i]),
            const SizedBox(width: 10.0),
          ],
        ],
      ),
    );
  }

  Widget _buildAllCategoryFilter() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        for (var i = 0; i < Category.values.length; i++)
          _buildCategoryButton(Category.values[i]),
      ],
    );
  }

  Widget _buildCategoryButton(Category category) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: selectedCategory == category
              ? Colors.blueAccent
              : const Color.fromARGB(15, 0, 0, 0),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 14,
            color: selectedCategory == category ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Future<void> _showCreatePromptDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CreatePromptDialog();
      },
    );
  }

  Future<void> _showEditPromptDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EditPromptDialog(
            prompt: promptProvider.prompts[index], index: index);
      },
    );
  }

  Future<void> _showPublicPromptInfo(
      BuildContext context, Prompt prompt) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PublicPromptInfoDialog(
          prompt: prompt,
        );
      },
    );
  }
}
