import 'package:flutter/material.dart';
import 'package:my_test/animation/card_3d.dart';
import 'package:my_test/animation/card_light.dart';
import 'package:my_test/animation/insta_check.dart';
import 'package:my_test/animation/webtoon.dart';
import 'package:my_test/customPaint/custom_paint_page.dart';
import 'package:my_test/draggable/draggable.dart';
import 'package:my_test/dropdown/custom_dropdown.dart';
import 'package:my_test/websocket/socketio_page.dart';
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
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StompPage(),
                  ),
                ),
                child: const Text("WebsocketIO Test"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Webtoon(),
                  ),
                ),
                child: const Text("Kakao Webtoon Interaction"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InstaCheck(),
                  ),
                ),
                child: const Text("Insta Check Interaction"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CustomDropdown(),
                  ),
                ),
                child: const Text("Custom Dropdown"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Card3D(),
                  ),
                ),
                child: const Text("3D Card"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CardLight(),
                  ),
                ),
                child: const Text("Card Light"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
