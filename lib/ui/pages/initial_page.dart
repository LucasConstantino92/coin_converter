import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('COIN CONVERSION', style: TextStyle(color: Colors.amberAccent, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            TextFormField(
              controller: _controller,
              style: TextStyle(color: Colors.amberAccent),
              decoration: InputDecoration(
                label: Text('Valor a ser convertido'),
                labelStyle: TextStyle(color: Colors.amberAccent),
                floatingLabelStyle: TextStyle(color: Colors.amberAccent)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
