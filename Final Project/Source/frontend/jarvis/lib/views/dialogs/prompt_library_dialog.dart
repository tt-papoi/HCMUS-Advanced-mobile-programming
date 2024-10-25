import 'package:flutter/material.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/views/dialogs/confirm_delete_dialog.dart';
import 'package:jarvis/views/dialogs/used_prompt_dialog.dart';
import 'package:jarvis/widgets/custom_search_bar.dart';

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

  List<Prompt> promptList = [
    Prompt(
        id: "0",
        prompt:
            "You are a machine that check all language grammar mistake and make the sentence more fluent.You take all the user input and auto correct it. Just reply to user input with correct grammar\nyou: correct tex\nuser:Grammatically correct text\nyou: Sounds good.\nUser input is : [Text]",
        category: Category.Education,
        promptType: PromptType.private,
        name: 'Grammar corrector',
        isFavorite: false,
        isMine: true),
    Prompt(
        id: "1",
        prompt:
            "I want you to act as a professional writer. You will need to research a given topic , formulate a thesis outline based on the topic described by the user, and create a persuasive piece of work that is both informative and engaging . \nUser input is: [Thesis Topic]",
        category: Category.Writing,
        promptType: PromptType.public,
        name: 'Essay outline',
        isFavorite: false,
        isMine: false),
    Prompt(
        id: "2",
        prompt:
            "I want you to act as a resume editor . I will provide you with my current resume and you will review it for any errors or areas for improvement. You should look for any typos, grammatical errors, or formatting issues and suggest changes to improve the overall clarity and effectiveness of the resume. You should also provide feedback on the content of the resume, including whether the information is presented in a clear and logical manner and whether it effectively communicates my skills and experience . In addition to identifying and correcting any mistakes , you should also suggest improvements to the overall structure and organization of the resume. Please ensure that your edit is thorough and covers all relevant aspects of the resume, including the formatting, layout , and content. Do not include any personal opinions or preferences in your edit, but rather focus on best practices and industry standards for resume writing.\nHere is my resume: [Resume]",
        category: Category.Career,
        promptType: PromptType.public,
        name: 'Resume Editing',
        isFavorite: false,
        isMine: false),
    Prompt(
        id: "3",
        prompt:
            "SOLVE [User Input] GIVE ONLY THE ANSWER DO NOT PROVIDE ANYTHING ELSE ONLY THE ANSWER!!!",
        category: Category.Writing,
        promptType: PromptType.public,
        name: 'SOLVE PROBLEM',
        isFavorite: false,
        isMine: false),
    Prompt(
        id: "4",
        prompt: "Please tell me a story about [characters] related to [Topic]",
        category: Category.Fun,
        promptType: PromptType.private,
        name: 'Tell a story',
        isFavorite: false,
        isMine: true),
  ];

  @override
  Widget build(BuildContext context) {
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
          _buildPromptList(),
        ],
      ),
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
        ? CustomSearchBar(hintText: "Search", onChanged: (String value) {})
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                        hintText: "Search", onChanged: (String value) {}),
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

  Widget _buildPromptList() {
    return Expanded(
      child: ListView.separated(
        itemCount: promptList.length,
        itemBuilder: (context, index) {
          Prompt prompt = promptList[index];

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
        prompt.prompt,
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
                      promptList[index].isFavorite =
                          !promptList[index].isFavorite;
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
                          onDelete: _deletePrompt,
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
                    _showPublicPromptInfo(context, index);
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
    Category selectedDropdownCategory = Category.Other;
    TextEditingController nameController = TextEditingController();
    TextEditingController promptController = TextEditingController();
    bool isPrivatePrompt = true;

    String? nameError;
    String? promptError;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Title

                    const Text(
                      "New Prompt",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: isPrivatePrompt,
                              onChanged: (bool? value) {
                                setState(() {
                                  isPrivatePrompt = value!;
                                });
                              },
                              activeColor: Colors.blueAccent,
                            ),
                            const Text(
                              "Private",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<bool>(
                              value: false,
                              groupValue: isPrivatePrompt,
                              onChanged: (bool? value) {
                                setState(() {
                                  isPrivatePrompt = value!;
                                  selectedDropdownCategory = Category.Other;
                                });
                              },
                              activeColor: Colors.blueAccent,
                            ),
                            const Text(
                              "Public",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Name of the prompt
                    const Text.rich(
                      TextSpan(
                        text: 'Name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      minLines: 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        hintText: 'Name of the prompt',
                        filled: true,
                        fillColor: const Color.fromARGB(15, 0, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(0, 0, 0, 0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    if (nameError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          nameError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // Category field
                    if (!isPrivatePrompt) ...[
                      const SizedBox(height: 15),
                      const Text.rich(
                        TextSpan(
                          text: 'Category',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Category>(
                        menuMaxHeight: 200,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(15, 0, 0, 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(0, 0, 0, 0),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(0, 0, 0, 0),
                              width: 1.0,
                            ),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                        value: selectedDropdownCategory,
                        hint: const Text('Select a category'),
                        onChanged: (Category? newValue) {
                          setState(() {
                            selectedDropdownCategory = newValue!;
                          });
                        },
                        items: Category.values
                            .where((category) => category != Category.All)
                            .map<DropdownMenuItem<Category>>((Category value) {
                          return DropdownMenuItem<Category>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 15),

                    // Prompt field
                    const Text.rich(
                      TextSpan(
                        text: 'Prompt',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: promptController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        hintText:
                            'Use square brackets [ ] to specify user input.',
                        filled: true,
                        fillColor: const Color.fromARGB(15, 0, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(0, 0, 0, 0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    if (promptError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          promptError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: const Text(
                            'Create',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              nameError = null; // Reset error
                              promptError = null; // Reset error

                              if (nameController.text.isEmpty) {
                                nameError = 'The field is required.';
                              }
                              if (promptController.text.isEmpty) {
                                promptError = 'The field is required.';
                              }

                              // check empty field
                              if (nameError == null && promptError == null) {
                                Prompt prompt = Prompt(
                                  id: "id",
                                  prompt: promptController.text,
                                  category: selectedDropdownCategory,
                                  promptType: isPrivatePrompt
                                      ? PromptType.private
                                      : PromptType.public,
                                  name: nameController.text,
                                  isFavorite: false,
                                  isMine: true,
                                );
                                Navigator.of(context).pop();
                                _addPrompt(prompt);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditPromptDialog(BuildContext context, int index) async {
    Category? selectedDropdownCategory = Category.Other;
    TextEditingController nameController = TextEditingController();
    TextEditingController promptController = TextEditingController();

    nameController.text = promptList[index].name;
    promptController.text = promptList[index].prompt;

    String? nameError;
    String? promptError;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Title

                    const Text(
                      "Edit prompt",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Name of the prompt
                    const Text.rich(
                      TextSpan(
                        text: 'Name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      minLines: 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        hintText: 'Name of the prompt',
                        filled: true,
                        fillColor: const Color.fromARGB(15, 0, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(0, 0, 0, 0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    if (nameError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          nameError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // Category field
                    if (promptList[index].promptType == PromptType.public) ...[
                      const SizedBox(height: 15),
                      const Text.rich(
                        TextSpan(
                          text: 'Category',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Category>(
                        menuMaxHeight: 200,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(15, 0, 0, 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(0, 0, 0, 0),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(0, 0, 0, 0),
                              width: 1.0,
                            ),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                        value: selectedDropdownCategory,
                        hint: const Text('Select a category'),
                        onChanged: (Category? newValue) {
                          setState(() {
                            selectedDropdownCategory = newValue!;
                          });
                        },
                        items: Category.values
                            .where((category) => category != Category.All)
                            .map<DropdownMenuItem<Category>>((Category value) {
                          return DropdownMenuItem<Category>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 15),

                    // Prompt field
                    const Text.rich(
                      TextSpan(
                        text: 'Prompt',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: promptController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        hintText:
                            'Use square brackets [ ] to specify user input.',
                        filled: true,
                        fillColor: const Color.fromARGB(15, 0, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(0, 0, 0, 0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    if (promptError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          promptError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              nameError = null; // Reset error
                              promptError = null; // Reset error

                              if (nameController.text.isEmpty) {
                                nameError = 'The field is required.';
                              }
                              if (promptController.text.isEmpty) {
                                promptError = 'The field is required.';
                              }

                              if (nameError == null && promptError == null) {
                                Prompt prompt = Prompt(
                                  id: promptList[index].id,
                                  prompt: promptController.text,
                                  category: selectedDropdownCategory!,
                                  promptType: promptList[index].promptType,
                                  name: nameController.text,
                                  isFavorite: promptList[index].isFavorite,
                                  isMine: promptList[index].isMine,
                                );
                                Navigator.of(context).pop();
                                _editPrompt(prompt, index);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPublicPromptInfo(BuildContext context, int index) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController promptController = TextEditingController();

    nameController.text = promptList[index].name;
    promptController.text = promptList[index].prompt;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Title

                    Text(
                      promptList[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 15),
                    // Prompt field
                    const Text.rich(
                      TextSpan(
                        text: 'Prompt',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      readOnly: true,
                      controller: promptController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(15, 0, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(0, 0, 0, 0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _addPrompt(Prompt prompt) {
    setState(() {
      promptList.add(prompt);
    });
  }

  void _editPrompt(Prompt newPrompt, int index) {
    setState(() {
      promptList[index] = newPrompt;
    });
  }

  void _deletePrompt(int index) {
    setState(() {
      promptList.removeAt(index);
    });
  }
}
