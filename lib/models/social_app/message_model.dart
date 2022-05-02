// @dart=2.9
class MessageModel {
  String senderId;
  String receiverId;
  String groupId;
  String dateTime;
  String text;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.groupId,
    this.dateTime,
    this.text,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
  {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    groupId = json['groupId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'senderId':senderId,
      'receiverId':receiverId,
      'groupId':groupId,
      'dateTime':dateTime,
      'text':text,
    };
  }
}