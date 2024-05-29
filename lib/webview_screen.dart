import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Article'),
      ),
      body: WebViewPage(
        url: url,

      ),
    );
  }
}