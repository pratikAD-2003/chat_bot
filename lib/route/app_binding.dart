import 'package:chat_bot/binding.dart';
import 'package:chat_bot/ui/home/chat_screen.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppBinding {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.chatScreen,
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),
  ];
}
