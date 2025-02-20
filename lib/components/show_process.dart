import 'package:flutter/material.dart';

class ShowProcess extends StatefulWidget {
  final String message;

  ShowProcess({required this.message, super.key});

  @override
  State<ShowProcess> createState() => SshowProcessState();
}

class SshowProcessState extends State<ShowProcess> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children;

    children = <Widget>[
      SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          widget.message,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
