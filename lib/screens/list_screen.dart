import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../models/item.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Item> _list = [];
  int _page = 1;

  @override
  void initState() {
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("newnews"),
      ),
      body: LazyLoadScrollView(
        onEndOfPage: () {
          _page++;
          getList();
        },
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(
              _list.length,
              (index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) {
                          return DetailScreen(item: _list[index]);
                        },
                      ));
                    },
                    child: Column(
                      children: [
                        Text(_list[index].title.trim()),
                        Text(_list[index].detailUrl),
                      ],
                    ),
                  )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            getList();
          },
          child: Icon(CupertinoIcons.refresh)),
    );
  }

  Future<void> getList() async {
    var client = http.Client();
    var response = await client.get(
      Uri.parse('https://dpg.danawa.com/news/list?boardSeq=60&page=' +
          _page.toString()),
    );
    String responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
    dom.Document document = parse(responseBody);
    List<dom.Element> imageList = document.querySelectorAll("div.list_item");

    for (dom.Element row in imageList) {
      String? imageUrl = row.querySelector("img")!.attributes["src"];
      String? title = row.querySelectorAll("a")[1].text.trim();
      String? detailUrl = row.querySelectorAll("a")[1].attributes["href"];
      _list.add(Item(imageUrl!, title, detailUrl!));
      setState(() {});
    }
  }
}
