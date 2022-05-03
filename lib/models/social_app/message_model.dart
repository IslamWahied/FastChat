// @dart=2.9
class MessageModel {
  String senderId;
  String receiverId;
  int groupId;
  String dateTime;
  String text;
  double latitude;
  double longitude;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.groupId,
    this.dateTime,
    this.text,
    this.longitude,
    this.latitude
  });

  MessageModel.fromJson(Map<String, dynamic> json)
  {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    groupId = json['groupId'];
    dateTime = json['dateTime'];
    text = json['text'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'senderId':senderId,
      'receiverId':receiverId,
      'groupId':groupId,
      'dateTime':dateTime,
      'text':text,
      'longitude':longitude,
      'latitude':latitude,
    };
  }
}