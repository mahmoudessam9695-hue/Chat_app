import 'package:chat_app/consts.dart';

class MessageModal {
  final String message;
  final String id;
  MessageModal(this.message, this.id);
  factory MessageModal.fromjson(jsondata) {
    return MessageModal(jsondata[kmessages], jsondata['id']);
  }
}
