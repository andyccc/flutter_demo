import 'package:flutter/material.dart';

class InputDemo extends StatefulWidget {
  @override
  _InputDemoState createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  GlobalKey _key = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          TextField(
              controller: _controller,
              decoration: InputDecoration(
                // icon: Icon(Icons.add),
                prefixIcon: Icon(Icons.add),
                labelText: "label",
                hintText: "default",
              )),
          SizedBox(
            height: 16,
          ),
          RaisedButton(
            onPressed: () {
              print(_controller.text);
            },
            color: Colors.blue,
            child: Text("提交"),
          ),
        ],
      ),
    );
  }
}
