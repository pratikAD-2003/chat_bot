import 'package:chat_bot/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/chat_message_model.dart';
import '../../service/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final ApiService _apiService = ApiService();
  final userInput = TextEditingController();

  // Observable list for chat history
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  
  RxBool isLoading = false.obs;
  
  RxBool isInitialLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Binds the UI list to the Firebase stream for real-time updates
    chatMessages.bindStream(_chatService.getMessagesStream());
    
    // Listen to changes in chatMessages to toggle initial loading state
    once(chatMessages, (_) {
      isInitialLoading.value = false;
    });

    // Also handle empty state if stream emits but list is empty
    _chatService.getMessagesStream().listen((data) {
       isInitialLoading.value = false;
    }, onError: (_) {
       isInitialLoading.value = false;
    });
  }

  Map<String, dynamic> _createChatRequestBody(String message) {
    return {
      "model": "qwen/qwen3-32b",
      "temperature": 0.7,
      "max_output_tokens": 2048,
      "input": [
        {
          "role": "system",
          "content": "You are a helpful and intelligent AI assistant.",
        },
        {"role": "user", "content": message.trim()},
      ],
    };
  }
  Future<void> sendMessage() async {
    if (isLoading.value) return;

    final text = userInput.text.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage(
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    userInput.clear();
    // Save user message to Firestore - UI will update automatically via stream
    await _chatService.saveMessage(userMsg);

    isLoading.value = true;
    try {
      final requestBody = _createChatRequestBody(text);
      final response = await _apiService.generateTasks(requestBody);

      if (response != null && response.output != null && response.output!.isNotEmpty) {
        // Find the assistant's message in the output
        final assistantOutput = response.output!.firstWhereOrNull(
          (o) => o.role == 'assistant' || o.type == 'message',
        );

        if (assistantOutput != null && assistantOutput.content != null) {
          final aiContent = assistantOutput.content!.firstWhereOrNull((c) => c.text != null)?.text;

          if (aiContent != null) {
            final botMsg = ChatMessage(
              text: aiContent,
              sender: MessageSender.bot,
              timestamp: DateTime.now(),
            );
            // Save bot response to Firestore
            await _chatService.saveMessage(botMsg);
          }
        }
      }
    } catch (e) {
      print("Error sending message: $e");
      Get.snackbar("Error", "Failed to get response from AI");
    } finally {
      isLoading.value = false;
    }
  }
}
