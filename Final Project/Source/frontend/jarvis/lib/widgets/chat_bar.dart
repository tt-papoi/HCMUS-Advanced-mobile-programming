import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jarvis/models/chat_message.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/screens/email_reply_screen.dart';
import 'package:jarvis/widgets/icons.dart';
import 'package:jarvis/views/dialogs/prompt_library_dialog.dart';

class ChatBar extends StatefulWidget {
  final String hintMessage;
  final Function(ChatMessage) onSendMessage;

  const ChatBar({
    super.key,
    required this.hintMessage,
    required this.onSendMessage,
  });

  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Show options menu for image, file, etc.
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
              const Divider(
                height: 0,
              ),
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
              const Divider(
                height: 0,
              ),
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

  // Upload image from gallery
  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      setState(() {
        _selectedImage = imageFile; // Set the selected image
      });
    }
  }

  // Take photo with the camera
  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      setState(() {
        _selectedImage = imageFile; // Set the selected image
      });
    }
  }

  // Build thumbnail for the selected image
  Widget _buildImageThumbnail() {
    if (_selectedImage != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Stack(
          alignment:
              const Alignment(0.85, -0.85), // Align button to the top-right
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: FileImage(_selectedImage!), // Load image from file
                  fit: BoxFit.cover, // Cover the entire container
                ),
              ),
            ),
            // Set explicit width and height for the close button container
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
                  // Clear the selected image
                  setState(() {
                    _selectedImage = null; // Remove the image
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      height: 0,
    ); // Return an empty container if no image is selected
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showOptionsMenu,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(15, 0, 0, 0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display selected image as a thumbnail
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
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

          // Send button
          IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: () {
              ChatMessage message = ChatMessage(
                messageType: MessageType.user,
                sendTime: DateTime.now(),
                textMessage: '',
              );
              // Check if the message is not empty
              if (_messageController.text.isEmpty && (_selectedImage == null)) {
                return;
              }

              message.textMessage = _messageController.text;
              message.image = _selectedImage;

              // Callback send message to chat_screen/home_screen
              widget.onSendMessage(message);

              _messageController.clear(); // Clear input after sending
              setState(() {
                _selectedImage = null; // Clear the selected image
              });
            },
          ),
        ],
      ),
    );
  }
}
