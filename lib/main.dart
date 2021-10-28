// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefoodies/recipe_model.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
      //theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebPage extends StatelessWidget {
  final url;
  WebPage({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      
    );
  }
}
class SearchPage extends StatefulWidget {
  String? search;
  SearchPage({this.search});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
    List<Model> list = <Model>[];
  String? text;
  //String appId = "4b06fc10";
 // String appKey ="8663ef87406bc2be7a6e7758d244154a";


  getApiData(search) async {
    final url = "https://api.edamam.com/search?q=$search&app_id=4b06fc10&app_key=8663ef87406bc2be7a6e7758d244154a&from=0&to=50&calories=591-722&health=alcohol-free";
    
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    //print(response.body);
    json['hits'].forEach((e){
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
      );

      setState(() {
        list.add(model);
      });


    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiData(widget.search);
  }
  @override
  Widget build(BuildContext context) {
    //var isVisible = true;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
        title: Text(
          'FridgeFoodies',
          style: TextStyle(
            color: Colors.limeAccent[400],
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ), 
      body: SafeArea(
        child: Container(
            //margin: EdgeInsets.symmetric(horizontal: 2,vertical: 3),
            padding: EdgeInsets.all(7.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff213A50),
                  Color(0xff071930),
                ],
              ),
            ),
            
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                    "What recipe are you looking for?",
                    style: TextStyle(
                      color: Colors.blueGrey[100],
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter Ingredients and we will try to find the best recipes for you!",
                    style: TextStyle(
                      color: Colors.lime.shade700,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                TextField(
                  onChanged: (v){
                    text=v;
                  },
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.bold,
                    
                    //fontSize: 20
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(
                        search: text,
                      
                      )));
                      
                    },
                     icon: Icon(Icons.search,color: Colors.white,)),
                    hintText: "Enter food name for recipe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Colors.white.withOpacity(0.4),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 15,),
                GridView.builder(
                  shrinkWrap: true,
                  primary: true,
                  physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,mainAxisSpacing: 15,crossAxisSpacing: 10),
                itemCount: list.length,
                
                 itemBuilder: (BuildContext context, int index) { 
                   final x = list[index];
                   return InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>WebPage(
                         url: x.url,
                       )));
                     },
                     child: Container(
                       decoration: BoxDecoration(
                         //border: Border(top:BorderSide.none),
                         image: DecorationImage(
                           image: NetworkImage(x.image.toString()),
                           fit: BoxFit.fill,
                         ),
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Container(
                             padding: EdgeInsets.all(4),
                             height: 60,
                             width: MediaQuery.of(context).size.width,
                             child: Text(x.label.toString(),
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 22,
                               //fontFamily: 'Zen'
                             ),
                             ),
                             color: Colors.grey.withOpacity(0.3),
                           ),
                           Container(
                             padding: EdgeInsets.all(4),
                             height: 40,
                             child: Center(child: Text("Source: "+ x.source.toString(),
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 15,
                               fontFamily:'Zen' ,
                             ),
                             ),
                             ),
                             color: Colors.grey.withOpacity(0.5),
                           ),
                         ],
                       ),
                     ),
                   );
                  },
                )
            
            
              ],
            ),
          ),
        ),
      ),

    );
  }
}