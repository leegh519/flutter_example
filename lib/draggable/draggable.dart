import 'package:flutter/material.dart';
import 'package:my_test/home/layout.dart';

class DraggablePage extends StatefulWidget {
  const DraggablePage({super.key});

  @override
  State<DraggablePage> createState() => _DraggablePageState();
}

class _DraggablePageState extends State<DraggablePage> {
  bool isEat = false;

  @override
  Widget build(BuildContext context) {
    if (isEat) {
      Future.delayed(const Duration(milliseconds: 2500)).then((_) {
        setState(() {
          isEat = !isEat;
        });
      });
    }
    return DefaultLayout(
      title: 'Draggable 테스트',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DragTarget(
              builder: (context, candidateData, rejectedData) {
                return !isEat
                    ? Image.asset(
                        'asset/image/draggable/cat.png',
                        height: 250,
                      )
                    : Image.asset(
                        'asset/image/draggable/cat_heart.gif',
                        height: 250,
                      );
              },
              onAccept: (data) {
                if (data == '츄르') {
                  setState(() {
                    isEat = !isEat;
                  });
                }
              },
              onLeave: (data) {
                debugPrint('onLeave $data');
              },
              onMove: (details) {
                debugPrint('onMove ${details.data}');
                debugPrint('onMove ${details.offset}');
              },
              onAcceptWithDetails: (details) {
                debugPrint('onAcceptWithDetails ${details.offset}');
              },
              onWillAccept: (data) {
                return true;
              },
            ),
            const SizedBox(
              height: 100,
            ),
            Draggable(
              data: '츄르',
              feedback: RotatedBox(
                quarterTurns: 1,
                child: Image.network(
                  'https://cdnimg.catpang.com/catpang/data/goods/2/1715_web_original_1491832849664054.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              childWhenDragging: const SizedBox(
                width: 100,
                height: 100,
              ),
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.network(
                  'https://cdnimg.catpang.com/catpang/data/goods/2/1715_web_original_1491832849664054.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
