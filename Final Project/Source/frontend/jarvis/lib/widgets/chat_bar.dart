import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jarvis/models/chat_message.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/dialogs/used_prompt_dialog.dart';
import 'package:jarvis/views/screens/email_reply_screen.dart';
import 'package:jarvis/widgets/icons.dart';
import 'package:jarvis/views/dialogs/prompt_library_dialog.dart';

class ChatBar extends StatefulWidget {
  final String hintMessage;
  final Function(ChatMessage) onSendMessage;
  final Function(bool)? onSlashTyped;

  const ChatBar({
    super.key,
    required this.hintMessage,
    required this.onSendMessage,
    this.onSlashTyped,
  });

  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;
  bool _showDropdown = false;
  final List<Prompt> _promptList = [
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
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    if (_messageController.text.endsWith('/')) {
      setState(() {
        _showDropdown = true;
      });
      if (widget.onSlashTyped != null) {
        widget.onSlashTyped!(true);
      }
    } else {
      setState(() {
        _showDropdown = false;
      });
      if (widget.onSlashTyped != null) {
        widget.onSlashTyped!(false);
      }
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload Image'),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePhoto();
                },
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(
                  CustomIcons.terminal_1,
                  size: 15,
                ),
                title: const Text('Prompt'),
                onTap: () {
                  Navigator.of(context).pop();
                  _buildPromptLibrary();
                },
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email reply'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    FadeRoute(page: const EmailReplyScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      setState(() {
        _selectedFile = imageFile;
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      setState(() {
        _selectedFile = imageFile;
      });
    }
  }

  Widget _buildImageThumbnail() {
    if (_selectedFile != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Stack(
          alignment: const Alignment(0.85, -0.85),
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: FileImage(_selectedFile!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 87, 87, 87),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(size: 20, Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _selectedFile = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return Container(height: 0);
  }

  Future<void> _buildPromptLibrary() async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return const PromptLibrary();
      },
    );
    if (result != null) {
      setState(() {
        _messageController.text = result;
      });
    }
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

    if (result != null) {
      setState(() {
        _messageController.text = result;
      });
    }
  }

  Widget _showQuickAccessPrompt() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        constraints: const BoxConstraints(maxHeight: 180), // Limit the height
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _promptList.length,
          itemBuilder: (context, index) {
            final Prompt prompt = _promptList[index];
            return ListTile(
              title: Text(
                prompt.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  _messageController.text = '';
                  _showDropdown = false;
                });
                _showPromptInput(prompt);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if (_showDropdown) _showQuickAccessPrompt(),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _showOptionsMenu,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(15, 0, 0, 0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageThumbnail(),
                            TextField(
                              controller: _messageController,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.normal,
                                ),
                                hintText: widget.hintMessage,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded),
                      onPressed: () {
                        ChatMessage message = ChatMessage(
                          messageType: MessageType.user,
                          textMessage: '',
                        );
                        if (_messageController.text.isEmpty &&
                            (_selectedFile == null)) {
                          return;
                        }

                        message.textMessage = _messageController.text;
                        message.file = _selectedFile;

                        widget.onSendMessage(message);

                        _messageController.clear();
                        setState(() {
                          _selectedFile = null;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
