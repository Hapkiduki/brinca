import 'package:flutter/material.dart';

class AppFeedback extends StatelessWidget {
  const AppFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Material(
      color: Colors.black,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Stack(children: [
          Center(
              child: Card(
            color: Colors.black.withOpacity(0.5),
            child: Padding(
                padding: EdgeInsets.all(size.width - size.width * 93 / 100),
                child: Text(
                  "tenkan@gmail.com",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height - size.height * 95 / 100),
                )),
          )),
          Positioned(
              child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.topLeft,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
        ]),
      ),
    );
  }
}
