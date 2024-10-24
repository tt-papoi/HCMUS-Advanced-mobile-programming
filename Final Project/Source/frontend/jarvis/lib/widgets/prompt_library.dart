import 'package:flutter/material.dart';
import 'package:jarvis/models/prompt.dart';

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  State<PromptLibrary> createState() => _PromptLibraryState();
}

class _PromptLibraryState extends State<PromptLibrary> {
  bool isPrivatePrompt = true;
  bool isActiveFavoriteFilter = false;
  Category selectedCategory = Category.All;
  bool isShowAllCategories = false;

  List<Prompt> promptList = [
    Prompt(
        id: "0",
        prompt:
            "You are a machine that check all language grammar mistake and make the sentence more fluent.You take all the user input and auto correct it. Just reply to user input with correct grammar\nyou: correct tex\nuser:Grammatically correct text\nyou: Sounds good.\nUser input is : [Text]",
        category: Category.Writing,
        promptType: PromptType.private,
        name: 'Grammar corrector',
        isFavorite: false),
    Prompt(
        id: "1",
        prompt:
            "I want you to act as a professional writer. You will need to research a given topic , formulate a thesis outline based on the topic described by the user, and create a persuasive piece of work that is both informative and engaging . \nUser input is: [Thesis Topic]",
        category: Category.Writing,
        promptType: PromptType.public,
        name: 'Essay outline',
        isFavorite: false),
    Prompt(
        id: "2",
        prompt:
            "I want you to act as a resume editor . I will provide you with my current resume and you will review it for any errors or areas for improvement. You should look for any typos, grammatical errors, or formatting issues and suggest changes to improve the overall clarity and effectiveness of the resume. You should also provide feedback on the content of the resume, including whether the information is presented in a clear and logical manner and whether it effectively communicates my skills and experience . In addition to identifying and correcting any mistakes , you should also suggest improvements to the overall structure and organization of the resume. Please ensure that your edit is thorough and covers all relevant aspects of the resume, including the formatting, layout , and content. Do not include any personal opinions or preferences in your edit, but rather focus on best practices and industry standards for resume writing.\nHere is my resume: [Resume]",
        category: Category.Writing,
        promptType: PromptType.public,
        name: 'Resume Editing',
        isFavorite: false),
    Prompt(
        id: "3",
        prompt:
            "SOLVE [User Input] GIVE ONLY THE ANSWER DO NOT PROVIDE ANYTHING ELSE ONLY THE ANSWER!!!",
        category: Category.Writing,
        promptType: PromptType.public,
        name: 'SOLVE PROBLEM',
        isFavorite: false),
    Prompt(
        id: "4",
        prompt: "Tell me a story about [Topic]",
        category: Category.Writing,
        promptType: PromptType.private,
        name: 'Tell a story',
        isFavorite: false),
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
      width: 200,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(10, 0, 0, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton('Private', isPrivatePrompt),
          _buildToggleButton('Public', !isPrivatePrompt),
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
              isPrivatePrompt = text == 'Private';
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
    return isPrivatePrompt
        ? _buildSearchField()
        : Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildSearchField()),
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

  Widget _buildSearchField() {
    return TextField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black45),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.black45,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black12, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black12, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.0),
        ),
      ),
      onChanged: (value) {
        // Implement filtering logic here based on the value
      },
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
            color: const Color.fromARGB(10, 0, 0, 0),
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

          // Private/Public Filter
          // If the user has selected "Private" prompts,
          // this checks if the current prompt is not private.
          // If true, it skips the prompt by returning an empty Container

          if (isPrivatePrompt && prompt.promptType != PromptType.private ||

              // If the user has selected "Public" prompts,
              // this checks if the current prompt is not public.
              // If true, it skips the prompt
              !isPrivatePrompt && prompt.promptType != PromptType.public) {
            return Container();
          }

          // Favorite filter
          // Applies only when public prompts are selected.
          // Checks if the favorite filter is active and
          // the current prompt is not marked as favorite.
          // If both conditions are true, it skips the prompt
          if (!isPrivatePrompt &&
              isActiveFavoriteFilter &&
              !prompt.isFavorite) {
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

  Widget _buildPromptTile(Prompt prompt, int index) {
    return ListTile(
      onTap: () {},
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
          isPrivatePrompt
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mode_edit_outlined),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      promptList[index].isFavorite =
                          !promptList[index].isFavorite;
                    });
                  },
                  icon: prompt.isFavorite
                      ? const Icon(Icons.star_rounded, color: Colors.blueAccent)
                      : const Icon(Icons.star_border_rounded),
                ),
          isPrivatePrompt
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            'Delete Prompt',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to delete this prompt?',
                          ),
                          actions: [
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
                                backgroundColor: Colors.red,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng hộp thoại
                                _deletePrompt(index); // Gọi hàm xóa mục
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_outlined),
                )
              : IconButton(
                  onPressed: () {
                    // View info
                  },
                  icon: const Icon(Icons.info_outline),
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
              : const Color.fromARGB(10, 0, 0, 0),
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
    Category? selectedDropdownCategory = Category.Other;
    TextEditingController nameController = TextEditingController();
    TextEditingController promptController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Adjust the size to fit content
                  children: <Widget>[
                    // Title
                    Text(
                      isPrivatePrompt
                          ? "New Private prompt"
                          : "New Public Prompt",
                      style: const TextStyle(
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
                        fillColor: const Color.fromARGB(10, 0, 0, 0),
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

                    // Category field
                    isPrivatePrompt
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  fillColor: const Color.fromARGB(10, 0, 0, 0),
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
                                    selectedDropdownCategory = newValue;
                                  });
                                },
                                items: Category.values
                                    .map<DropdownMenuItem<Category>>(
                                        (Category value) {
                                  return DropdownMenuItem<Category>(
                                    value: value,
                                    child: Text(value.name),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

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
                      maxLines: 3,
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
                        fillColor: const Color.fromARGB(10, 0, 0, 0),
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
                            Prompt prompt = Prompt(
                                id: "id",
                                prompt: promptController.text,
                                category: selectedDropdownCategory!,
                                promptType: isPrivatePrompt
                                    ? PromptType.private
                                    : PromptType.public,
                                name: nameController.text,
                                isFavorite: false);
                            Navigator.of(context).pop();
                            _addPrompt(prompt);
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

  void _deletePrompt(int index) {
    setState(() {
      promptList.removeAt(index);
    });
  }
}
