import 'package:flutter/material.dart';

class PageDemo extends StatefulWidget {
  @override
  _PageDemoState createState() => _PageDemoState();
}

class _PageDemoState extends State<PageDemo>
    with SingleTickerProviderStateMixin {
  List tabs = ["Flutter", "Android", "iOS"];
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState

    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            print("home ...");
          },
        ),
        title: Text("appbar"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        elevation: 20.0, // 阴影
        bottom: TabBar(
          tabs: tabs
              .map((e) => Tab(
                    text: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
