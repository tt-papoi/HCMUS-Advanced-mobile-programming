import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis/models/email.dart';
import 'package:jarvis/widgets/remain_token.dart';

class EmailReplyScreen extends StatefulWidget {
  const EmailReplyScreen({
    super.key,
  });

  @override
  State<EmailReplyScreen> createState() => _EmailReplyScreenState();
}

class _EmailReplyScreenState extends State<EmailReplyScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Email latestReceivedEmail = Email(
      content:
          "Chào Trần A,\n\nCảm ơn bạn đã ứng tuyển vào vị trí Lập trình viên Fullstack tại Công ty Công nghệ ABC. Chúng tôi xin mời bạn tham gia buổi phỏng vấn: \n\nThời gian: 9:00 sáng, Thứ Hai, 28/10/2024\nĐịa điểm: Tầng 12, Tòa nhà Landmark 81, Quận Bình Thạnh, TP.HCM\nLiên hệ: Nguyễn Văn A, Trưởng phòng Nhân sự (0901234567)\n\nVui lòng xác nhận tham gia hoặc liên hệ để sắp xếp thời gian khác nếu cần. Rất mong được gặp bạn!\n\nTrân trọng,\nNguyễn Văn A",
      emailType: EmailType.received);
  List<Email> emailList = [];

  @override
  void initState() {
    super.initState();
    emailList.add(latestReceivedEmail);
  }

  void _requestReply() {
    setState(() {
      Email replyEmail = Email(
          content:
              "Chào bạn,\n\nCảm ơn bạn đã sử dụng dịch vụ của chúng tôi. Tính năng này sẽ được ra mắt trong bản cập nhật mới. \n\nTrân trọng,\nJarvis.",
          emailType: EmailType.reply);
      emailList.add(replyEmail);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _addReceivedEmail(Email email) {
    setState(() {
      emailList.add(email);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Email reply",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: const [
          RemainToken(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: emailList.length,
              itemBuilder: (context, index) {
                final Email email = emailList[index];
                return _buildEmail(email);
              },
            ),
          ),
          _buildActionList(),
          _buildChatBar(),
        ],
      ),
    );
  }

  Widget _buildEmail(Email email) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: email.emailType == EmailType.received
              ? const Color.fromARGB(15, 0, 0, 0)
              : Colors.transparent,
          border: email.emailType == EmailType.received
              ? Border.all(color: const Color.fromARGB(0, 0, 0, 0))
              : Border.all(color: const Color.fromARGB(15, 0, 0, 0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                email.emailType == EmailType.received
                    ? "Received Email"
                    : "Jarvis Reply",
                style: TextStyle(
                    fontSize: 16,
                    color: email.emailType == EmailType.received
                        ? Colors.black87
                        : Colors.blueAccent,
                    fontWeight: FontWeight.bold),
              ),

              // copy reply email
              if (email.emailType == EmailType.reply) ...[
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: email.content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: const Icon(
                    Icons.copy,
                    size: 15,
                  ),
                )
              ],
            ],
          ),
          const Divider(
            thickness: 0.5,
          ),
          Text(
            email.content,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBar() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              _showInsertReceivedMail(context);
            },
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(15, 0, 0, 0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _messageController,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: "Tell Jarvis how you want to reply...",
                      border: OutlineInputBorder(
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
              setState(() {
                _messageController.clear();
                _requestReply();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionList() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        _buildAction(
          onTap: () {
            _requestReply();
          },
          text: "Thanks",
          iconPath: 'lib/assets/icons/thanks.png',
        ),
        _buildAction(
          onTap: () {
            _requestReply();
          },
          text: "Sorry",
          iconPath: 'lib/assets/icons/sad.png',
        ),
        _buildAction(
          onTap: () {
            _requestReply();
          },
          text: "Yes",
          iconPath: 'lib/assets/icons/yes.png',
        ),
        _buildAction(
          onTap: () {
            _requestReply();
          },
          text: "No",
          iconPath: 'lib/assets/icons/no.png',
        ),
        _buildAction(
          onTap: () {
            _requestReply();
          },
          text: "Follow up",
          iconPath: 'lib/assets/icons/shedule.png',
        ),
        _buildAction(
          onTap: () {
            _requestReply();
          },
          text: "Request for more information",
          iconPath: 'lib/assets/icons/request.png',
        ),
      ],
    );
  }

  Widget _buildAction({
    required VoidCallback onTap,
    required String iconPath,
    required String text,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(15, 0, 0, 0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showInsertReceivedMail(BuildContext context) async {
    TextEditingController emailController = TextEditingController();

    String? error;

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
                    // Enter email
                    const Text.rich(
                      TextSpan(
                        text: 'Received email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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
                      controller: emailController,
                      minLines: 1,
                      maxLines: 10,
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
                        hintText: 'Enter your received email',
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
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          error!,
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
                            'Send',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              error = null; // Reset error

                              if (emailController.text.isEmpty) {
                                error = 'The field is required.';
                              }

                              if (error == null) {
                                Email email = Email(
                                    content: emailController.text,
                                    emailType: EmailType.received);
                                _addReceivedEmail(email);
                                Navigator.of(context).pop();
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
}
