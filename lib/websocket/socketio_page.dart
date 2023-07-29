// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'package:my_test/home/layout.dart';

class StompPage extends StatefulWidget {
  const StompPage({super.key});

  @override
  State<StompPage> createState() => _WebsocketPageState();
}

class _WebsocketPageState extends State<StompPage> {
  // late final WebSocketChannel channel;
  final chatList = <MessageModel>[];
  final scrollController = ScrollController();
  final textController = TextEditingController();

  late final StompClient client;

  @override
  void initState() {
    super.initState();
    client = StompClient(
      config: StompConfig.SockJS(
        url: 'http://119.18.116.193:12345/chat',
        onConnect: onConnectCallback,
      ),
    );
    client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    print('connect!!!!');
    client.subscribe(
        destination: '/app/test/1',
        headers: {},
        callback: (frame) {
          print(frame.body);
          // Received a frame for this subscription
          if (frame.body != null) {
            // final data = jsonDecode(frame.body!);
            chatList.insert(0, MessageModel.fromJson(frame.body!));
          }
          setState(() {});
        });
  }

  void sendMessage() {
    client.send(
      destination: '/send/message/test/1',
      body: jsonEncode({
        'content': textController.text,
        'sender': '나임',
      }),
      headers: {},
    );
    textController.text = '';
    setState(() {});
  }

  @override
  void dispose() {
    client.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    });
    return DefaultLayout(
      title: 'Websocket IO Test',
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  return ChatBox(message: chatList[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
                itemCount: chatList.length,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        sendMessage();
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      sendMessage();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromRGBO(80, 146, 78, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  final MessageModel message;

  const ChatBox({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final mine = message.sender == '나임';
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: UnconstrainedBox(
        child: Container(
          width: 300,
          padding: const EdgeInsets.only(
            top: 14,
            left: 20,
            bottom: 14,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: mine
                ? const Color.fromRGBO(80, 146, 78, 1)
                : const Color.fromARGB(255, 216, 187, 43),
            borderRadius: BorderRadius.only(
              bottomLeft:
                  mine ? const Radius.circular(13) : const Radius.circular(3),
              bottomRight:
                  mine ? const Radius.circular(3) : const Radius.circular(13),
              topLeft: const Radius.circular(13),
              topRight: const Radius.circular(13),
            ),
          ),
          child: Text(
            message.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class MessageModel {
  final String content;
  final String sender;

  const MessageModel({
    required this.content,
    required this.sender,
  });

  MessageModel copyWith({
    String? content,
    String? sender,
  }) {
    return MessageModel(
      content: content ?? this.content,
      sender: sender ?? this.sender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'sender': sender,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      content: map['content'] as String,
      sender: map['sender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MessageModel(content: $content, sender: $sender)';

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.content == content && other.sender == sender;
  }

  @override
  int get hashCode => content.hashCode ^ sender.hashCode;
}
