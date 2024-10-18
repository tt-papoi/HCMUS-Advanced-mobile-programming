import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';  // Import file picker

class EditBotPage extends StatefulWidget {
  final String initialName;
  final String initialBaseBot;
  final String initialPrompt;
  final String initialGreeting;
  final List<String> initialDataSources;

  const EditBotPage({
    super.key,
    required this.initialName,
    required this.initialBaseBot,
    required this.initialPrompt,
    required this.initialGreeting,
    this.initialDataSources = const [],
  });

  @override
  EditBotPageState createState() => EditBotPageState();
}

class EditBotPageState extends State<EditBotPage> {
  late TextEditingController nameController;
  late TextEditingController promptController;
  late TextEditingController greetingController;
  late List<String> dataSources;
  String? selectedBaseBot;

  final List<String> baseBots = ['Claude-3-Haiku', 'Other'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    promptController = TextEditingController(text: widget.initialPrompt);
    greetingController = TextEditingController(text: widget.initialGreeting);
    dataSources = List<String>.from(widget.initialDataSources);
    selectedBaseBot = baseBots.contains(widget.initialBaseBot)
        ? widget.initialBaseBot
        : baseBots.first; // Assign default value if initialBaseBot is not in baseBots
  }

  @override
  void dispose() {
    nameController.dispose();
    promptController.dispose();
    greetingController.dispose();
    super.dispose();
  }

  // Dialog to add a website knowledge source
  void _showWebsiteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController urlController = TextEditingController();

        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.language),
              SizedBox(width: 8),
              Text('Website'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter website name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Web URL',
                  hintText: 'Enter website URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return; // Guard with mounted check
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  dataSources.add('${nameController.text} (${urlController.text})');
                });
                if (!mounted) return; // Guard with mounted check
                Navigator.of(context).pop();
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  // Dialog to add a local file as a knowledge source
void _showLocalFileDialog() {
  TextEditingController nameController = TextEditingController(); // Controller cho trường Name
  PlatformFile? selectedFile; // Để lưu thông tin tệp đã chọn

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.upload_file),
                SizedBox(width: 8),
                Text('Local file'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trường nhập Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter a name for this file',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Hộp upload file giống như phần Google Drive
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '* Upload local file:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        // Sử dụng FilePicker để chọn tệp từ thiết bị
                        final result = await FilePicker.platform.pickFiles(type: FileType.any);
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            selectedFile = result.files.single; // Cập nhật thông tin tệp đã chọn
                          });
                        }
                      },
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: selectedFile != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Selected file: ${selectedFile!.name}',  // Hiển thị tên tệp đã chọn
                                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Type: ${selectedFile!.extension?.toUpperCase() ?? "Unknown"}',  // Hiển thị định dạng tệp
                                      style: const TextStyle(fontSize: 14, color: Colors.black45),
                                    ),
                                    Text(
                                      'Size: ${_formatFileSize(selectedFile!.size)}',  // Hiển thị kích thước tệp
                                      style: const TextStyle(fontSize: 14, color: Colors.black45),
                                    ),
                                  ],
                                )
                              : const Text(
                                  'Click or drag file to this area to upload',
                                  style: TextStyle(fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Support for single or bulk upload. Strictly prohibit from uploading restricted or banned files.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (!mounted) return; // Kiểm tra nếu widget còn đang mounted
                  Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn Cancel
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && selectedFile != null) {
                    setState(() {
                      dataSources.add(
                          'Local file: ${nameController.text} (File: ${selectedFile!.name}, Type: ${selectedFile!.extension?.toUpperCase()}, Size: ${_formatFileSize(selectedFile!.size)})');  // Thêm dữ liệu vào danh sách
                    });
                  }
                  if (!mounted) return; // Kiểm tra nếu widget còn đang mounted
                  Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn Connect
                },
                child: const Text('Connect'),
              ),
            ],
          );
        },
      );
    },
  );
}

// Hàm chuyển đổi kích thước file từ bytes sang KB, MB
String _formatFileSize(int size) {
  if (size < 1024) {
    return '$size B'; // Hiển thị byte nếu kích thước nhỏ hơn 1KB
  } else if (size < 1024 * 1024) {
    return '${(size / 1024).toStringAsFixed(2)} KB'; // Hiển thị KB nếu kích thước nhỏ hơn 1MB
  } else {
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB'; // Hiển thị MB nếu kích thước lớn hơn 1MB
  }
}

void _showGoogleDriveDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController nameController = TextEditingController();
      String? selectedFile; // To hold selected file name

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.drive_folder_upload),
                SizedBox(width: 8),
                Text('Google Drive'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name field
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Google Drive Credential upload box
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '* Google Drive Credential:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        // Use file picker to select the Google Drive credentials file
                        final result = await FilePicker.platform.pickFiles(type: FileType.any);
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            selectedFile = result.files.single.name; // Update selected file name
                          });
                        }
                      },
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            selectedFile != null
                                ? 'Selected file: $selectedFile' // Display selected file
                                : 'Click or drag file to this area to upload',
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Support for a single or bulk upload. Strictly prohibit from uploading company data or other banned files.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (!mounted) return; // Guard with mounted check
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add selected file to dataSources with Google Drive info
                  if (nameController.text.isNotEmpty && selectedFile != null) {
                    setState(() {
                      dataSources.add('Google Drive: ${nameController.text} (File: $selectedFile)');
                    });
                  }
                  if (!mounted) return; // Guard with mounted check
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Connect'),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showConfluenceDialog() {
  TextEditingController nameController = TextEditingController();  // Controller cho trường Name
  TextEditingController urlController = TextEditingController();   // Controller cho trường URL
  TextEditingController usernameController = TextEditingController();  // Controller cho trường Username
  TextEditingController tokenController = TextEditingController();  // Controller cho trường Access Token

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.link),  // Biểu tượng Confluence
                SizedBox(width: 8),
                Text('Confluence'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trường nhập Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter a name for this connection',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Trường nhập Wiki Page URL
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Wiki Page URL',
                    hintText: 'Enter the Confluence page URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Trường nhập Confluence Username
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Confluence Username',
                    hintText: 'Enter your Confluence username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Trường nhập Confluence Access Token
                TextField(
                  controller: tokenController,
                  obscureText: true,  // Để bảo mật cho token
                  decoration: const InputDecoration(
                    labelText: 'Confluence Access Token',
                    hintText: 'Enter your Confluence access token',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (!mounted) return; // Kiểm tra nếu widget còn đang mounted
                  Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn Cancel
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      urlController.text.isNotEmpty &&
                      usernameController.text.isNotEmpty &&
                      tokenController.text.isNotEmpty) {
                    setState(() {
                      // Thêm thông tin Confluence vào danh sách dataSources
                      dataSources.add(
                        'Confluence: ${nameController.text} (URL: ${urlController.text}, Username: ${usernameController.text})',
                      );
                    });
                  }
                  if (!mounted) return; // Kiểm tra nếu widget còn đang mounted
                  Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn Connect
                },
                child: const Text('Connect'),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showSlackDialog() {
  TextEditingController nameController = TextEditingController();  // Controller cho trường Name
  TextEditingController workspaceController = TextEditingController();  // Controller cho trường Workspace
  TextEditingController tokenController = TextEditingController();  // Controller cho trường Bot Token

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.message),  // Biểu tượng Slack
                SizedBox(width: 8),
                Text('Slack'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trường nhập Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter a name for this connection',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Trường nhập Slack Workspace
                TextField(
                  controller: workspaceController,
                  decoration: const InputDecoration(
                    labelText: 'Slack Workspace',
                    hintText: 'Enter your Slack workspace',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Trường nhập Slack Bot Token
                TextField(
                  controller: tokenController,
                  obscureText: true,  // Để bảo mật cho token
                  decoration: const InputDecoration(
                    labelText: 'Slack Bot Token',
                    hintText: 'Enter your Slack bot token',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (!mounted) return; // Kiểm tra nếu widget còn đang mounted
                  Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn Cancel
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      workspaceController.text.isNotEmpty &&
                      tokenController.text.isNotEmpty) {
                    setState(() {
                      // Thêm thông tin Slack vào danh sách dataSources
                      dataSources.add(
                        'Slack: ${nameController.text} (Workspace: ${workspaceController.text})',
                      );
                    });
                  }
                  if (!mounted) return; // Kiểm tra nếu widget còn đang mounted
                  Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn Connect
                },
                child: const Text('Connect'),
              ),
            ],
          );
        },
      );
    },
  );
}


  void _showKnowledgeSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Data Sources'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Local files'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showLocalFileDialog();  // Show local file dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Website'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showWebsiteDialog();
                },
              ),
             ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Confluence'),
                onTap: () {
                    Navigator.of(context).pop();
                    _showConfluenceDialog();
                  // Handle Confluence selection
                },
              ),
              ListTile(
              leading: const Icon(Icons.drive_folder_upload),
              title: const Text('Google Drive'),
              onTap: () {
                Navigator.of(context).pop();
                _showGoogleDriveDialog();  // Show Google Drive dialog
              },
            ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Slack'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showSlackDialog();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return; // Guard with mounted check
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bot: ${widget.initialName}'),
        actions: [
          TextButton(
            onPressed: () {
              if (!mounted) return; // Guard with mounted check
              Navigator.of(context).pop({
                'name': nameController.text,
                'baseBot': selectedBaseBot,
                'prompt': promptController.text,
                'greeting': greetingController.text,
                'dataSources': dataSources,
              });
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Bot Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Base Bot',
                border: OutlineInputBorder(),
              ),
              value: selectedBaseBot,
              items: baseBots.map((bot) {
                return DropdownMenuItem(
                  value: bot,
                  child: Text(bot),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBaseBot = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: promptController,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Prompt',
                border: OutlineInputBorder(),
                hintText: 'Describe bot behavior and response. Be clear and specific.',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Knowledge Base',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Provide custom knowledge that your bot will access to inform its responses.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showKnowledgeSourceDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add knowledge source'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Greeting Message',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The bot will send this message at the beginning of every conversation.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: greetingController,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Hi there! I\'m your assistant. How can I help you today?',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}



