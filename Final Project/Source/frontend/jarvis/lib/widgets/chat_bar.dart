import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jarvis/models/chat_message.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/providers/prompt_provider.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/dialogs/used_prompt_dialog.dart';
import 'package:jarvis/views/screens/email_reply_screen.dart';
import 'package:jarvis/widgets/icons.dart';
import 'package:jarvis/views/dialogs/prompt_library_dialog.dart';
import 'package:provider/provider.dart';

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
  File? _selectedImage;
  bool _showDropdown = false;
  late PromptProvider promptProvider;

  @override
  void initState() {
    super.initState();
    promptProvider = Provider.of<PromptProvider>(context, listen: false);
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onMessageChanged() async {
    String text = _messageController.text;
    String lastWord = text.split(' ').last;
    String query = lastWord.replaceAll(RegExp(r'^/'), "");

    if (lastWord.startsWith('/') && !lastWord.endsWith(' ')) {
      setState(() {
        _showDropdown = true;
        promptProvider.isLoading = true;
      });
      if (widget.onSlashTyped != null) {
        widget.onSlashTyped!(true);
      }
      await promptProvider.fetchPrompts(query: query);

      setState(() {
        promptProvider.isLoading = false;
      });
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
        _selectedImage = imageFile;
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      setState(() {
        _selectedImage = imageFile;
      });
    }
  }

  Widget _buildImageThumbnail() {
    if (_selectedImage != null) {
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
                  image: FileImage(_selectedImage!),
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
                    _selectedImage = null;
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
    if (promptProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        constraints: promptProvider.prompts.isEmpty
            ? const BoxConstraints(maxHeight: 50)
            : const BoxConstraints(maxHeight: 180), // Limit the height
        child: promptProvider.prompts.isEmpty
            ? const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'No prompts found',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: promptProvider.prompts.length,
                itemBuilder: (context, index) {
                  final prompt = promptProvider.prompts[index];
                  return ListTile(
                    title: Text(
                      prompt.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
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
                          sendTime: DateTime.now(),
                          textMessage: '',
                        );
                        if (_messageController.text.isEmpty &&
                            (_selectedImage == null)) {
                          return;
                        }

                        message.textMessage = _messageController.text;
                        message.image = _selectedImage;

                        widget.onSendMessage(message);

                        _messageController.clear();
                        setState(() {
                          _selectedImage = null;
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
