// ignore_for_file: public_member_api_docs, sort_constructors_first
class Email {
  String content;
  EmailType emailType;
  Email({
    required this.content,
    required this.emailType,
  });
}

enum EmailType { received, reply }
