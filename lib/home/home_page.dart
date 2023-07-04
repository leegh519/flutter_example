import 'package:flutter/material.dart';
import 'package:my_test/custom_paint/custom_paint_page.dart';
import 'package:my_test/draggable/draggable.dart';
import 'package:my_test/websocket/websocket_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여러가지 테스트'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DraggablePage(),
                  ),
                ),
                child: const Text("Draggable Test"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CustomPaintPage(),
                  ),
                ),
                child: const Text("Custom Paint Test"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WebsocketPage(),
                  ),
                ),
                child: const Text("Websocket Test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
