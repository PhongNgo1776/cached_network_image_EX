import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_dynamic_app/cached_network_image/image_provider/cached_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

const ROOT_URL = 'https://phongngo1776.github.io/BEAUTIFUL_GIRLS/IMG/AoDai/';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Dynamic Links Example',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => _MainScreen(),
        '/helloworld': (BuildContext context) => _DynamicLinkScreen(),
      },
    ),
  );
}

class _MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  String imageName = '';
  int? count;
  late SharedPreferences _prefs;

  @override
  void initState() {
    Future.delayed(Duration.zero, initSharePreferences);
    super.initState();
  }

  Future<void> initSharePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      count = _prefs.getInt('count') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (count != null)
                    CachedNetworkImage(
                      cacheKey: count.toString(),
                      imageUrl: '$ROOT_URL$imageName',
                      height: 400,
                      errorWidget: (context, _, __) {
                        return Container(
                          color: Colors.red,
                          height: 50,
                          width: 50,
                        );
                      },
                    ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => setState(() {
                          var currId = IMGS.indexOf(imageName);
                          var newId = currId + 1;
                          if (newId == IMGS.length) newId = 0;
                          imageName = IMGS[newId];

                          count = count! + 1;
                          _prefs.setInt('count', count ?? 0);
                        }),
                        child: const Text('change image'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => imageName = ''),
                        child: const Text('Clear current image link'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DynamicLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World DeepLink'),
        ),
        body: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
