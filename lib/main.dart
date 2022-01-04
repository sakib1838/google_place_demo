
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DetailsResult detailsResult;
  List<Uint8List> images = [];

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions=[];

  @override
  void initState() {
    String apiKey = "AIzaSyAX9IFfgZfH0jTzY888Nz-m0ftttvexERw";
    googlePlace = GooglePlace(apiKey);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min ,
            children: [

              TextField(
                decoration: InputDecoration(
                  labelText: "Search",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                  ),

                ),

                onChanged: (value){
                  if(value.isNotEmpty){
                    autoCompleteSearch(value);
                  }else{
                    if(predictions.length>0 && mounted){
                      setState(() {
                        predictions=[];
                      });
                    }
                  }
                },

              ),
              SizedBox(height: 10,),
              Expanded(
                  child: ListView.builder(
                    itemCount: predictions.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.pin_drop,color: Colors.white,),
                          ),
                          title: Text(predictions[index].description!),

                          onTap: (){
                            debugPrint("place id: ${predictions[index].placeId!}");
                            getDetils(predictions[index].placeId!);
                            if(detailsResult.geometry!=null && detailsResult.geometry?.location!=null){
                              print("lat:${detailsResult.geometry?.location?.lat.toString()}    lng:${detailsResult.geometry?.location?.lng.toString()}");
                            }

                          },

                        );
                      }
                  )
              ),

            ],
          ),
        ),

      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }


  void getDetils(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result!;
        print(detailsResult);
      });

    }
  }


}



