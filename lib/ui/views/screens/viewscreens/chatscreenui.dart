// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/ChatMessagesModel.dart';
import 'package:new_horizon/core/services/apis/user/getchat.dart';
import 'package:new_horizon/core/services/apis/user/sendchat.dart';
import 'package:new_horizon/ui/widgets/receiver_row_view.dart';
import 'package:new_horizon/ui/widgets/sender_row_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var controller = TextEditingController();
  var scrollController = ScrollController();
  var message = '';
  bool isLoadingInitial = true; // Assume true until messages are loaded

  void loadChatMessages() async {
    try {
      List<ChatModel> messages =
          await GetExistingChat.fetchChatMessages(context);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      setState(() {
        chatModelList = messages;
        isLoadingInitial = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List<ChatModel> chatModelList = [];

  @override
  void initState() {
    super.initState();
    loadChatMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    }
  }

  void animateList() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      Future.delayed(const Duration(milliseconds: 120), () {
        if (scrollController.hasClients &&
            scrollController.offset !=
                scrollController.position.maxScrollExtent) {
          animateList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F3),
        appBar: AppBar(
          elevation: 12,
          titleSpacing: 10,
          backgroundColor: const Color.fromRGBO(3, 111, 173, 1),
          leadingWidth: 22,
          leading: IconButton(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios_new_outlined,
                  size: 20, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: ListTile(
            leading: CircleAvatar(
              radius: 19,
              child: Image.asset(AssetConstants.new_horizonlogo),
            ),
            title: const Text(
              'NHM Admin',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'online',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: GroupedListView<ChatModel, String>(
                key: const PageStorageKey<String>('page'),
                controller: scrollController,
                elements: chatModelList,
                groupBy: (element) => element.time.substring(0, 10),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) =>
                    item2.time.compareTo(item1.time),
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                itemBuilder: (context, ChatModel message) {
                  // Note: No index here
                  return message.isMe
                      ? SenderRowView(chat: message)
                      : ReceiverRowView(chat: message);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controller,
                onFieldSubmitted: (value) {
                  controller.text = value;
                },
                decoration: InputDecoration(
                  focusColor: const Color.fromRGBO(3, 111, 173, 1),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color.fromRGBO(3, 111, 173, 1),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  filled: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          animateList();
                          controller.clear();
                        });
                      },
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: const Color.fromRGBO(0, 68, 106, 1),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_upward,
                            size: 20,
                            color: Colors.white,
                          ), // Calendar icon
                          onPressed: () async {
                            if (controller.text == '') {
                              return;
                            }
                            SendChatMessage.Sendchat(
                                controller.text.toString(), context);
                            setState(() {
                              chatModelList.add(ChatModel(
                                  message: controller.text,
                                  isMe: true,
                                  time: DateTime.now().toIso8601String()));
                              animateList();
                              controller.clear();
                            });
                            print(controller.text);
                          },
                        ),
                      ),
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Type a Message",
                  fillColor: Colors.white70,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
