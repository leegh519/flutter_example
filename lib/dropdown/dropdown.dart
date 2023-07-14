import 'package:flutter/material.dart';
import 'package:my_test/home/layout.dart';

class CustomDropdown extends StatelessWidget {
  final LayerLink link = LayerLink();

  CustomDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'dropdown',
      body: Column(
        children: [
          DropdownButton(
            value: 5,
            items: [
              DropdownMenuItem(
                child: Text('data1'),
                value: 1,
                onTap: () {},
              ),
              DropdownMenuItem(
                child: Text('data2'),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text('data3'),
                value: 3,
              ),
              DropdownMenuItem(
                child: Text('data4'),
                value: 4,
              ),
              DropdownMenuItem(
                child: Text('data5'),
                value: 5,
              ),
            ],
            onChanged: (_) {},
          ),
          Stack(
            children: [
              Center(
                child: CompositedTransformTarget(
                  link: link,
                  child: TextButton(
                    onPressed: () => showOverlay(context),
                    child: Text('data'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showOverlay(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    final overlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          child: CompositedTransformFollower(
            targetAnchor: Alignment.bottomLeft,
            link: link,
            child: Material(
              child: SizedBox(
                height: 500,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Text('$index'),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
    overlayState.insert(overlay);
    await Future.delayed(const Duration(seconds: 2));

    overlay.remove();
  }
}
