import 'package:chat_bot/service/chat_service.dart';
import 'package:chat_bot/ui/home/chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatService>(ChatService(), permanent: true);
    Get.put<ChatController>(ChatController(), permanent: false);
    print('ChatBinding: ChatService and ChatController created and registered');
  }
}
