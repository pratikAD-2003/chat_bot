import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/chat_message_model.dart';
import '../../utils/my_theme.dart';
import 'chat_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.find<ChatController>();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.screenBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "AI Chat Bot",
          style: TextStyle(
            color: MyTheme.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Show loader while fetching initial data from Firestore
              if (controller.isInitialLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final messageList = controller.chatMessages;
              final bool showingThinking = controller.isLoading.value;

              if (messageList.isEmpty && !showingThinking) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 48.sp, color: MyTheme.textSecondary.withOpacity(0.5)),
                      SizedBox(height: 16.h),
                      Text(
                        "No messages yet.\nStart the conversation!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: MyTheme.textSecondary, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                reverse: true,
                itemCount: messageList.length + (showingThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (showingThinking && index == 0) {
                    return _buildThinkingIndicator();
                  }

                  final actualIndex = showingThinking ? index - 1 : index;
                  if (actualIndex < 0 || actualIndex >= messageList.length) {
                    return const SizedBox.shrink();
                  }

                  final message = messageList[actualIndex];
                  final bool isSender = message.sender == MessageSender.user;

                  bool showDateChip = false;
                  if (actualIndex == messageList.length - 1) {
                    showDateChip = true;
                  } else {
                    final nextOlderMessage = messageList[actualIndex + 1];
                    if (!DateUtils.isSameDay(message.timestamp, nextOlderMessage.timestamp)) {
                      showDateChip = true;
                    }
                  }

                  return Column(
                    children: [
                      if (showDateChip) _buildDateChip(message.timestamp),
                      isSender ? _buildSenderMessage(message) : _buildReceiverMessage(message),
                    ],
                  );
                },
              );
            }),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h, right: 60.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12.w,
              height: 12.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: MyTheme.primary.withOpacity(0.5),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "AI is thinking...",
              style: TextStyle(
                color: MyTheme.textSecondary,
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(DateTime date) {
    String formattedDate;
    final now = DateTime.now();
    if (DateUtils.isSameDay(date, now)) {
      formattedDate = "Today";
    } else if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1)))) {
      formattedDate = "Yesterday";
    } else {
      formattedDate = DateFormat('MMMM d, y').format(date);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        formattedDate,
        style: TextStyle(
          color: MyTheme.textSecondary,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSenderMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h, left: 60.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: MyTheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(4.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(color: Colors.white70, fontSize: 9.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h, right: 60.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(4.r),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: message.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: MyTheme.textPrimary, fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(color: MyTheme.textSecondary, fontSize: 9.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 8.h, bottom: 8.h + Get.mediaQuery.padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.userInput,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: MyTheme.textSecondary, fontSize: 14.sp),
                border: InputBorder.none,
              ),
              onSubmitted: (value) => controller.sendMessage(),
            ),
          ),
          Obx(() => IconButton(
            onPressed: controller.isLoading.value ? null : () => controller.sendMessage(),
            icon: Icon(
              Icons.send_rounded,
              color: controller.isLoading.value ? Colors.grey : MyTheme.primary,
            ),
          )),
        ],
      ),
    );
  }
}
