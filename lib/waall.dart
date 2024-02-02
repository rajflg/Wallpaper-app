import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';


class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {

  Color myHexColor = Color(0xFF92D6DB);
  List data=[];

  TextEditingController searchImage=TextEditingController();

  final List<String> categories = [
    'Animal',
    'Architecture',
    'Food',
    'Movie',
    'Nature',
    'Sport',
    'Travel',
  ];

  @override
  void initState() {
    super.initState();
    getphoto(categories[0]);
  }

  getphoto(search)async{

    setState(() {
      data=[];
    });

    try{

      final url=Uri.parse('https://api.unsplash.com/search/photos/?client_id=WTT1T9N_MBgtVZ6-V__mO8kzMySTALVbK30GvjOv0Ws&query=$search&per_page=30');

      var response=await http.get(url);

      var result=jsonDecode(response.body);

      data=result['results'];
      print(data);

      setState(() {});

    }catch(e){
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 10,),
          topRow(),
          searchbar(),
          Center(child: Text('Categories can have a look at',style: TextStyle(fontWeight: FontWeight.bold),)),
          SizedBox(height: 20,),
          horizontalbuilder(),
          SizedBox(height: 20,),
          verticalBuilder(),
        ],
      ),
    );
  }

  Widget verticalBuilder(){
    return data.isNotEmpty?MasonryGridView.count(
        crossAxisCount: 2,
        itemCount: data.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          double ht=index%2==0?200:100;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InstaImageViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(data[index]['urls']['regular'],
                  height: ht,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }):Container(
        height: 500,
        child: Center(child: SpinKitCircle(color: Colors.grey),));
  }

  Widget horizontalbuilder(){
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              getphoto(categories[index]);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage('assets/image/${categories[index]}.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchbar(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: searchImage,
                decoration: InputDecoration(
                  hintText: 'Search images (nature, animals)...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: myHexColor,
            iconSize: 30,
            onPressed: () {
              if(searchImage.text.isNotEmpty){
                getphoto(searchImage.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget topRow(){
    return Row(
      children: [
        SizedBox(width: 20,),
        ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset('assets/Dog.png',fit: BoxFit.cover,height: 40,width: 40,)),

        SizedBox(width: 50,),
        RichText(text: TextSpan(
            children:[
              TextSpan(text:'DARVAIES ',style: TextStyle(fontSize: 32,fontWeight: FontWeight.w600,color:myHexColor,fontFamily: 'cv'),),
              TextSpan(text:'Wallpapers',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.grey,fontFamily: 'cv'),),
            ]
        )),
      ],
    );
  }

}