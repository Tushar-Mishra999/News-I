import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, this.string, this.func, this.size})
      : super(key: key);
  final string;
  final func;
  final size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func();
      },
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            gradient: LinearGradient(
                colors: [Colors.yellow, Colors.orange, Colors.red])),
        margin: const EdgeInsets.all(5),
        child: Center(
          child: Text(
            string,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
