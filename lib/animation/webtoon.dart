import 'package:flutter/material.dart';

class Webtoon extends StatefulWidget {
  const Webtoon({super.key});

  @override
  State<Webtoon> createState() => _WebtoonState();
}

class _WebtoonState extends State<Webtoon> with TickerProviderStateMixin {
  final scroller = ScrollController();
  final clipScroller = ScrollController();
  late final AnimationController animationController;
  late final AnimationController listController;
  late final Animation animation;
  late final Animation listAnimation;
  bool animationFinished = false;
  bool clip = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);

    listAnimation =
        CurvedAnimation(parent: listController, curve: Curves.bounceInOut);

    animationController.addStatusListener((status) {
      animationFinished = status == AnimationStatus.completed;
      setState(() {});
    });
    scroller.addListener(() {
      if (clipScroller.hasClients) {
        clipScroller.jumpTo(scroller.offset);
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          animationFinished
              ? listController.reverse().then(
                    (value) => animationController.reverse().then(
                      (value) {
                        setState(() {
                          clip = false;
                        });
                      },
                    ),
                  )
              : setState(() {
                  clip = true;
                  animationController.forward().then(
                        (value) => listController.forward(),
                      );
                });
        },
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return Stack(
              children: [
                Visibility(
                  visible: animationController.value != 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 160,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                    ),
                  ),
                ),
                Opacity(
                  opacity: clip ? 1 : 0,
                  child: Transform.translate(
                    offset: Offset(-80 * animationController.value, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        controller: clipScroller,
                        child: ClipPath(
                          clipper: CustomRectClipper(left: true),
                          child: Image.asset(
                            'asset/image/webtoon/webtoon.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: clip ? 1 : 0,
                  child: Transform.translate(
                    offset: Offset(80 * animationController.value, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        controller: clipScroller,
                        child: ClipPath(
                          clipper: CustomRectClipper(left: false),
                          child: Image.asset(
                            'asset/image/webtoon/webtoon.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: clip ? 0 : 1,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      controller: scroller,
                      child: Image.asset(
                        'asset/image/webtoon/webtoon.png',
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: animationController.value != 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black
                        .withOpacity(animationController.value * 0.6),
                  ),
                ),
                AnimatedBuilder(
                  animation: listAnimation,
                  builder: (context, _) {
                    return Visibility(
                      visible: listController.value != 0,
                      child: Opacity(
                        opacity: listController.value,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 160,
                            child: ListView.separated(
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Image.asset(
                                        'asset/image/webtoon/thumbnail.jpg',
                                        width: 140,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${index + 1}화',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '가비지타임',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) {
                                return const SizedBox(
                                  height: 20,
                                );
                              },
                              itemCount: 50,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomRectClipper extends CustomClipper<Path> {
  final bool left;

  CustomRectClipper({
    required this.left,
  });

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..addRect(left
          ? Rect.fromLTRB(0, 0, size.width / 2, size.height)
          : Rect.fromLTRB(size.width / 2, 0, size.width, size.height));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
