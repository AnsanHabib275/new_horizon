// ignore_for_file: file_names

// class ChatModel {
//   final String _messages;
//   final bool _isMe;

//   ChatModel(this._messages, this._isMe);

//   String get message => _messages;

//   bool get isMee => _isMe;
// }

class ChatModel {
  final String message;
  final bool isMe;
  final String time; // Add a time field

  ChatModel({required this.message, required this.isMe, required this.time});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['MessageContent'],
      isMe:
          json['MessageBy'] == "User", // Assuming 'User' means the current user
      time: json['Time'],
    );
  }
}
