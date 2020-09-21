import 'package:flutter/material.dart';
import 'package:json_bd/src/Demo.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'JSON BD OFFLINE',
            initialRoute: 'home',
            routes: {
                'home' : (BuildContext context) => GridViewDemo(),
            },
        );
    }
}