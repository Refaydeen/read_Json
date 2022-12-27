import 'dart:convert';
import 'dart:core';
import 'package:app_server/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Home Screen'),
      backgroundColor: Colors.redAccent,
    ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: readJsonData(),
        builder: (context, data) {
          if (data.hasError) {
            return Text("$data.error");
          } else if (data.hasData) {
            var items = data.data as List<Product>;
            return ListView.builder(
                itemCount: items==null? 0:items.length,
                itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Image(
                          image: NetworkImage(
                            items[index].imageUrl.toString(),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Text(items[index].name.toString(),style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Text(items[index].price.toString()),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Product>> readJsonData() async {
    final jsonData =
    await root.rootBundle.loadString('jsonFile/productList.json');
    final list = json.decode(jsonData) as List<dynamic>;
    return list.map((e) => Product.fromJson(e)).toList();
  }
}


