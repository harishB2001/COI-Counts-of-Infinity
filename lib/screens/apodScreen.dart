// ignore_for_file: file_names, unnecessary_null_comparison

import 'package:coi/models/apodModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ApodScreen extends StatefulWidget {
  const ApodScreen({Key? key}) : super(key: key);

  @override
  State<ApodScreen> createState() => _ApodScreenState();
}

class _ApodScreenState extends State<ApodScreen> {
  Future<dynamic> _selectDate(BuildContext context) async {
    var apodModel = Provider.of<ApodModel>(context, listen: false);
    DateTime? picked = await showDatePicker(
      errorInvalidText: "Range from 1995 Jun 16",
      context: context,
      firstDate: DateTime.parse("1995-06-16 00:00:00.000"),
      initialDate: ApodModel.currentDate,
      lastDate: DateTime.now(),      
    );
    if (picked != null) {
      apodModel.dateClick(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => ApodModel(),
        child: Consumer<ApodModel>(
          builder: (context, apodModel, child) {
            return Material(
              color: Colors.black,
              child: Column(
                children: [
                  const Divider(
                    color: Colors.white,
                    thickness: 0.3,
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      Container(
                        color: Colors.black38,
                        height: MediaQuery.of(context).size.height / 2.2,
                        child: Center(child: fetchImage(context, apodModel)),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: AutoSizeText(
                          apodModel.title,
                          style: GoogleFonts.patuaOne(
                              color: Colors.white,
                              fontSize: 30,
                              wordSpacing: 1),
                          maxLines: 3,
                          minFontSize: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: AutoSizeText(
                          apodModel.copyright,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              textStyle:
                                  const TextStyle(fontStyle: FontStyle.italic,color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, left: 15, right: 15, bottom: 30),
                        child: AutoSizeText(
                          "       " + apodModel.explanation,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.notoSerif(
                              fontSize: 20, color: Colors.white54),
                        ),
                      ),
                    ],
                  )),
                  Container(
                    color: Colors.white24,
                    child: Row(
                      children: [
                        //previous icon
                        Expanded(
                          child: Visibility(
                            maintainAnimation: true,
                            maintainSemantics: true,
                            maintainSize: true,
                            maintainState: true,
                            visible: apodModel.visiblePreviousIcon,
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  apodModel.previousClick();
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue.shade50),
                                side: MaterialStateProperty.all(
                                    const BorderSide(width: 0.53))),
                            icon:  Icon(Icons.calendar_today_outlined,
                                color: Colors.orangeAccent.shade700
                                ),
                            onPressed: () {
                              _selectDate(context);
                            },
                            label: AutoSizeText(
                              
                              apodModel.currentDateAsText,
                              maxLines: 1,
                              style:  TextStyle(color: Colors.blue.shade900),
                            ),
                          ),
                        ),
                        //next Icon
                        Expanded(
                          child: Visibility(
                            maintainAnimation: true,
                            maintainSemantics: true,
                            maintainSize: true,
                            maintainState: true,
                            visible: apodModel.visibleNextIcon,
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  apodModel.nextClick();
                                },
                                icon: const Icon(Icons.arrow_forward_ios)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  dynamic fetchImage(context, ApodModel apodModel) {
    if (apodModel.media == null) {
      return apodModel.playLoop();
    }
    try {
      return apodModel.media;
    } catch (e) {
      return const Center(child: Text("Could not Load the Media"));
    }
  }
}
