import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_test/home/layout.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketPage extends StatefulWidget {
  const WebsocketPage({super.key});

  @override
  State<WebsocketPage> createState() => _WebsocketPageState();
}

class _WebsocketPageState extends State<WebsocketPage> {
  late final WebSocketChannel channel;
  final chatList = <String>[];
  final scrollController = ScrollController();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://146.56.47.128:18080/ws'),
    );
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
      title: 'Websocket Test',
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  chatList.insert(0, snapshot.data);
                }
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear,
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return ChatBox(text: chatList[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    itemCount: chatList.length,
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        channel.sink.add(value);
                        textController.text = '';
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      channel.sink.add(textController.text);

                      textController.text = '';
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
  final String text;

  const ChatBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: UnconstrainedBox(
        child: Container(
          width: 300,
          padding: const EdgeInsets.only(
            top: 14,
            left: 20,
            bottom: 14,
            right: 20,
          ),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(80, 146, 78, 1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(13),
              bottomRight: Radius.circular(3),
              topLeft: Radius.circular(13),
              topRight: Radius.circular(13),
            ),
          ),
          child: Text(
            text,
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
