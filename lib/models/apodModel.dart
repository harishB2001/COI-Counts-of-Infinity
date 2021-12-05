// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

enum DateToString{
  forUI,
  forAPIRequests
}

class ApodModel with ChangeNotifier {
  static DateTime todayDate = DateTime.now();
  static DateTime currentDate = todayDate.subtract(Duration(days: 1));
  DateTime previousDate = currentDate.subtract(Duration(days: 1));
  DateTime nextDate = currentDate.add(Duration(days: 1));
  String explanation = "";
  String copyright = "";
  String mediaType = "";
  String title = "";
  late String pictureURL;
  late String videoURL;
  String currentDateAsText = dateToString(DateToString.forUI, currentDate);
  bool visiblePreviousIcon = true;
  bool visibleNextIcon = true;
  dynamic media;

  ApodModel() {
    getApodDetails(DateTime.now().subtract(Duration(days: 1)));
  }
  static String dateToString(dateToStringReason, DateTime dateTime) {
    if (dateToStringReason == DateToString.forUI) {
      const monthAsString = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      String date = dateTime.toString().substring(8, 10);
      String month =
          monthAsString[int.parse(dateTime.toString().substring(5, 7)) - 1];
      String year = dateTime.toString().substring(0, 4);
      return date + " " + month + " " + year;
    } else {
      String date = dateTime.toString().substring(8, 10);
      String month = dateTime.toString().substring(5, 7);
      String year = dateTime.toString().substring(0, 4);
      return year + "-" + month + "-" + date;
    }
  }

  void previousClick() {
    nextDate = currentDate;
    currentDate = previousDate;
    previousDate = currentDate.subtract(Duration(days: 1));
    currentDateAsText = dateToString(DateToString.forUI, currentDate);
    media = null;
    explanation = "";
    copyright = "";
    title = "";
    setIconVisibility();
    notifyListeners();
  }

  void nextClick() {
    previousDate = currentDate;
    currentDate = nextDate;
    nextDate = currentDate.add(Duration(days: 1));
    currentDateAsText = dateToString(DateToString.forUI, currentDate);
    media = null;
    explanation = "";
    copyright = "";
    title = "";
    setIconVisibility();
    notifyListeners();
  }

  void dateClick(DateTime dateTime) {
    previousDate = dateTime.subtract(Duration(days: 1));
    nextDate = dateTime.add(Duration(days: 1));
    currentDate = dateTime;
    currentDateAsText = dateToString(DateToString.forUI, currentDate);
    media = null;
    explanation = "";
    copyright = "";
    title = "";
    setIconVisibility();
    notifyListeners();
  }

  void setIconVisibility() async {
    if (currentDate.isBefore(
        DateTime.parse("1995-06-16 00:00:00.000").add(Duration(days: 1)))) {
      visiblePreviousIcon = false;
    } else {
      visiblePreviousIcon = true;
    }
    if (currentDate.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      visibleNextIcon = false;
    } else {
      visibleNextIcon = true;
    }
    getApodDetails(currentDate);
  }

  Future<dynamic> getApodDetails(DateTime dateTime) async {
    String date = dateToString(DateToString.forAPIRequests, dateTime);
    try {
      var response = await http.get(Uri.parse(
          "https://api.nasa.gov/planetary/apod?date=$date&api_key=K5bgSHotYfh3folVTwyfY9dsllUi8RJx9SlyP3v3"));

      if (response.statusCode != 200) {
        media = Center(
            child: AutoSizeText(
          "Info Will Be available in a Short time..Explore the Other APODs",
          maxLines: 2,
          style: TextStyle(color: Colors.white),
        ));
        notifyListeners();
      } else if (response.statusCode == 200) {
        var resp = jsonDecode(response.body);
        explanation = resp["explanation"] ?? "Explanation not found";
        if (resp["copyright"] == null) {
          copyright = "Credit:  APOD.com ";
        } else {
          copyright = "Credit: " + resp["copyright"];
        }

        mediaType = resp["media_type"] ?? "type_not_found";
        title = resp["title"] ?? "Title Not Found";
        pictureURL = resp["url"] ?? "URL not found";

        fetchMedia();
      }
    } catch (e) {
      // getApodDetails(currentDate);
    }
  }

  dynamic fetchMedia() {
    try {
      if (mediaType == "image") {
        //assigning image to media
        media = Image.network(
          pictureURL,
          errorBuilder: (context, error, stacktrace) => Center(
            child: playLoop(),
          ),
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(child: playLoop());
          },
        );
      } else if (mediaType == "video") {
        videoURL = pictureURL.substring(30, 41);
        media = ApodVideoPlayer();
      }
    } catch (e) {
      getApodDetails(currentDate);
    }
    notifyListeners();
    return "received";
  }

  dynamic playLoop() {
    return Image.asset('assets/infinity.gif');
  }
}

class ApodVideoPlayer extends StatefulWidget {
  const ApodVideoPlayer({Key? key}) : super(key: key);

  @override
  _ApodVideoPlayerState createState() => _ApodVideoPlayerState();
}

class _ApodVideoPlayerState extends State<ApodVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApodModel>(builder: (context, apodModel, child) {
      _controller = YoutubePlayerController(
          initialVideoId: apodModel.videoURL,
          flags: YoutubePlayerFlags(autoPlay: true, loop: true, mute: true));
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            _controller.play();
          },
        ),
      );
    });
  }
}
