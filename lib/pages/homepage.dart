import 'dart:io';
import 'dart:async';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memeshare/services/service.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String _imageUrl;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _updateImage();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isLoading) _updateImage();
    });
  }

  // This method is use to update the URL of image '_imageURL' variable
  void _updateImage() {
    setState(() {
      _isLoading = true;
    });
    getImageFromAPI().then((value) {
      setState(() {
        _imageUrl = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: "Network Error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16,
      );
    });
  }

// This method will save the image on temp space and send it
  Future<void> sendImage() async {
    final imageResponse = await http.get(Uri.parse(_imageUrl));
    final imageBytes = imageResponse.bodyBytes;
    final tempStorage = await getTemporaryDirectory();
    final fileExtension = _imageUrl.substring(_imageUrl.lastIndexOf("."));
    final tempImagePath = "${tempStorage.path}/image$fileExtension";
    File(tempImagePath).writeAsBytes(imageBytes);
    Share.shareFiles([tempImagePath]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.2),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  : Image(
                      image: NetworkImage(_imageUrl),
                    ),
            ),
          ),
          Container(
            // alignment: FractionalOffset.bottomCenter,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: sendImage,
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2.1,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Share",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _updateImage,
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2.1,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
