//********************************************************************************************************//
//
//                     * * * * * JaliNativeInstrument * * * * *    *****Developer: misis2009@gmail.com *****
//
//********************************************************************************************************//
// DART-Lang, Musical Tuition Project: African Harp Kora : Player, NotationReader, Tuner:  multi-Platform //
//********************************************************************************************************//
/////////////////////////////////////////////////
import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:developer' as developer;
import 'dart:isolate';
import 'package:jalinativeinstrument/utils/color_utils.dart';
import 'audio/audio_isolate.dart';
import 'constants/app_constants_nd_vars.dart';
import 'audio/audio_data.dart';
import 'custom_painters/various_painters.dart';
import 'dart:developer' as myDeveloper;                           // for logging  (debug printing in a log-file, works differently than print)
import 'package:desktop_window/desktop_window.dart';              // setting Window Size for Desktop App (Win, Linux, MacOS)
import 'package:flutter/gestures.dart';
import 'dart:math';
//
// to generate icons: you should give a short names in pubspec and give a command in terminal "flutter pub run flutter_launcher_icons"     // Uncomment this when you need to Generate app platform icons:
// cd "C:\My_GitHub_Repository_5\"
// flutter create jalinativeinstrument  --platforms=android,windows,macos,ios,linux
// cd "C:\My_GitHub_Repository_5\jalinativeinstrument"
// flutter clean
// dart  run flutter_launcher_icons
//-------------------------------------------------------------------------------------------   /* Select */     Ctrl + Shift + /
import 'package:flutter_launcher_icons/abs/icon_generator.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/config/config.dart';
//import 'package:flutter_launcher_icons/config/config.g.dart';           // some error, commented
import 'package:flutter_launcher_icons/config/macos_config.dart';
//import 'package:flutter_launcher_icons/config/macos_config.g.dart';     // some error, commented
import 'package:flutter_launcher_icons/config/web_config.dart';
//import 'package:flutter_launcher_icons/config/web_config.g.dart';       // some error, commented
import 'package:flutter_launcher_icons/config/windows_config.dart';
//import 'package:flutter_launcher_icons/config/windows_config.g.dart';   // some error, commented
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/logger.dart';
import 'package:flutter_launcher_icons/macos/macos_icon_generator.dart';
import 'package:flutter_launcher_icons/macos/macos_icon_template.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/pubspec_parser.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/web/web_icon_generator.dart';
import 'package:flutter_launcher_icons/web/web_template.dart';
import 'package:flutter_launcher_icons/windows/windows_icon_generator.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
//-------------------------------------------------------------------------------------------
// - Uncomment this when you need to GENERATE app platform icons, and run command Alt+F12 "flutter pub run flutter_launcher_icons"
//
/////////////-//-//-//-//-//-//-//-///////////
// import 'package:flutter_midi/flutter_midi.dart';                             // flutter_midi: commented 1 of 6
/////////////-//-//-//-//-//-//-//-///////////
/////////////////////////////////////////////////
import 'package:tonic/tonic.dart' as tonic;   // for native Web JS playNote method (1 of 2)
//------------------------ Web Only --------------------------//
//   import 'dart:js' as js;    // for native Web JS playNote method (2 of 2), //toDo: comment if build Windows
//-----------------------------------------------------------_//
//import 'package:flutter_fgbg/flutter_fgbg.dart'; // Foreground/Background; iOS, Android: Stop Play if App is in Background // used "extends with WidgetBindingObserver" instead of this
import 'package:jalinativeinstrument/widgets/dropdown_tuningFromDropDown_box.dart' hide WIDTH_2, WIDTH_1;     // custom drop-down menu
import 'dart:async' show Future, Timer;
import 'package:async/async.dart';                        // for cancelable operation
import 'dart:ffi' hide Size;                              // Hide Size !!!   Needed !!!  It contains also in dart:io    !!!  Do not delete !!
import 'dart:io';
import 'dart:io' show File, Platform;
import 'package:csv/csv.dart';                            // converting csv
import 'package:csv/csv_settings_autodetection.dart';     // autodetection csv ?dilimeters
import 'package:flutter/foundation.dart' show ByteData, debugDefaultTargetPlatformOverride, kDebugMode, kIsWeb; // in release mode it should be so
import 'dart:ui';
// import 'package:audioplayers/audioplayers.dart'; // toDo: 2of5 try Web without audioplayers (look pubspec.yaml also! 1of5)
// toDo: 3of5   dart pub remove audioplayers  ,       dart pub get audioplayers
// toDo: 4of5   dart pub remove audioplayers_web  ,   dart pub get audioplayers_web
// toDo: 5of5   dart pub remove soundpool_web  ,      dart pub get soundpool_web
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // csv relative path
import 'package:path_provider/path_provider.dart';      // for getTemporaryDirectory
//import 'package:ml_dataframe/ml_dataframe.dart';              // csv relative path (not Used)
//import 'package:flutter/gestures.dart';                       // gesture binding, key pressing simulation (auto) (not Used, too Slow!)
//import 'package:permission_handler/permission_handler.dart';  // toDo: permissions to open *.csv from storage  (not Used)
import 'package:csv/csv.dart' as csv;                   // converting csv
import 'package:matrix2d/matrix2d.dart';                // for transpose list (rows to cols matrix transform) from csv
import 'package:file_picker/file_picker.dart';          // picking (Open Dialog) the file
import 'dart:convert'; //utf-8 decoder                  // encode/ decode utf-8 (planned to keep Track Name/Artist Name in utf-8)
import 'package:crc32_checksum/crc32_checksum.dart';    // to calculate short checksum of track_performer info string and write it into shared preferences (?or into database?)
import 'package:shared_preferences/shared_preferences.dart'; // to store last seen mode (32/64/128), measure number, selected range by each checksum of track_performer info
import 'dart:typed_data';                               // 1) for pitch detector and (planned:) 2) to read as bytes instruction pdf, editor xlsm (from assets folder) for writing it into Android Download Folder
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ pitch_detector (tuner) with audio_capture  2 of 4  // Only Android, iOS and maybe Linux
import 'package:flutter_audio_capture/flutter_audio_capture.dart';  // audio_capture 1 of 4
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:permission_handler/permission_handler.dart';  // for tuner Mic permission request and Java error prevention
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ end pitch_detector (tuner) with audio_capture  2 of 4
// import 'package:package_info_plus/package_info_plus.dart';                       // for tryToRunXlsmEditorWin() by long press on Info button  no needed
// import 'package:dart_windows_service_support/dart_windows_service_support.dart'; // for tryToRunXlsmEditorWin() by long press on Info button  no needed
import 'package:ffi/ffi.dart';         // for tryToRunXlsmEditorWin() by long press on Info button
import 'package:win32/win32.dart';     // for tryToRunXlsmEditorWin() by long press on Info button_       //     Comment it for Android   Win32  1 of 2
//import 'package:url_launcher/link.dart';         // for hyperlink to github page in InfoPage AlertDialog
import 'package:url_launcher/url_launcher.dart'; // for hyperlink to github page in InfoPage AlertDialog_
import 'package:html/dom.dart' as dom;      //flutter pub add html      // Reading Shared Google Spreadsheet Notation directly via Http request
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;    //flutter pub add http
////////////////////////////  https://pub.dev/packages/fluttericon/install  /////////////////////////////
// (here was import from this Link)
// import removed, you can find it any time by this link
//
//
final SoLoud audioEngine = SoLoud.instance;
Map<String, AudioSource> soundCache = {};
//
//void main() {                                            // was without command line arguments               Adnroid
void main(List<String> arguments) async{                        // with List of Win exe command line arguments  Windows
  WidgetsFlutterBinding.ensureInitialized();
  await SoLoud.instance.init();
  if (arguments.isNotEmpty) {argument0 = arguments[0].replaceAll('\\', '/');} else {}  // replace all \-slashes to /-slashes in Path   Windows
  //***********************************************************      Conditional Target Platform !!! Blank Screen Android!!! Blank Screen Windows!!!! (but Process Runs!)
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;  // for build release, Comment it if Windows process runs but Window DOES NOT shown !!!
  // if(Platform.isAndroid) {debugDefaultTargetPlatformOverride = TargetPlatform.android;}             // if Blank Screen Android !!!!!! (Comment All or old variant: leave Fuchsia)    // White Screen Android !!!
  //   else if (Platform.isWindows) {debugDefaultTargetPlatformOverride = TargetPlatform.windows;}     // if Blank Screen Windows !!!!!! (but Process Runs!)
  //   else if (Platform.isMacOS)   {debugDefaultTargetPlatformOverride = TargetPlatform.macOS;}
  //   else if (Platform.isIOS)     {debugDefaultTargetPlatformOverride = TargetPlatform.iOS;}
  //   else if (Platform.isLinux)   {debugDefaultTargetPlatformOverride = TargetPlatform.linux;}
  //   else {debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;} //end if
  //***********************************************************
  //runApp(MaterialApp(home: Jaliinstrument(),),);          // app runs here, class exemplar creates here (old, see: runApp)
  runApp(const MyApp());
  if (Platform.isWindows) {     // condtitional Build imitation (see also for "conditional Import"):
    csvMode = 1;  playerMode = 2;  extension = 1;  mS =  10; // Windows---WAV--***EXE   (some notes stop sounding on Android, so for Android - another build option)                                    (if plays Slow, it's Power Save Mode of Notebook)
  }
  else if (Platform.isAndroid || Platform.isMacOS  || Platform.isIOS) {
    csvMode = 1;  playerMode = 1;  extension = 1;  mS =  10; // Android,MacOS---WAV--***APK, MacOS***APP,***DMG, yes you can create DMG (like installer) via Node.js "create-dmg"      (if plays Slow, it's hash table mode, comment Windows)
  }
  else if (Platform.isLinux) {
    csvMode = 1;  playerMode = 6;  extension = 1;  mS =  10;
  }
  else {}                       // works without setState()  ???
} // end main()
//
class MyApp extends StatelessWidget {   //toDo: Title Disappeared: after Just Pressed App Button in Android,LoadCSV,DropDownSelect Title of App disappered in Android. Why?
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///////////////////////////// MaterialApp Color Theme and Title ///////////////
      theme: ThemeData(primarySwatch: Colors.blueGrey,),  // Not Used?     // It repeats Twice: see Return MaterialApp (first)
      home: const Jaliinstrument(title: 'Jaliinstrument'),// ? it's NOT the Only Title of App! (See Also the Title at: "Return MaterialApp") toDo: !!!
      //////////////////////////////////////////////////////////////////////////////
    );
  } // end Widget build
} // end StalelessWidget
//
class Jaliinstrument extends StatefulWidget {
  const Jaliinstrument({Key? key, required this.title}) : super(key: key);
  //////////////////////////////////////////////////  // https://www.fluttericon.com/
  static const _kFontFam = 'Jaliinstrument';          // Others From This Package Removed to File "IconData Ready To Use"     // see "fonts" folder in Assets
  static const String? _kFontPkg = null;                                                                                      // json from rar-archieve No needed
  static const IconData add_circle_outline = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData stop = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData play_circle2 = IconData(0xe816, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  //
  static const _kFontFam_1 = 'Jaliinstrument_1';   // 1) see "fonts" folder in Assets, 2) see pubspec.yaml fonts ("fonts" folder in Assets)
  static const String? _kFontPkg_1 = null;
  static const IconData refresh = IconData(0xe800, fontFamily: _kFontFam_1, fontPackage: _kFontPkg_1);
  static const IconData loop_alt = IconData(0xe801, fontFamily: _kFontFam_1, fontPackage: _kFontPkg_1);
  //////////////////////////////////////////////////////
  final String title;
  @override
  State<Jaliinstrument> createState() => _JaliinstrumentState();
} //end class Jaliinstrument
//
// class _JaliinstrumentState extends State<Jaliinstrument> {
///////////////////////////////////////////////  foreground/ background observer for android 1 of 3  ///////////////////////
// toDo: after adding this observer, normilized blayback tempo in Android (became faster), also see inkWell (also good affects on tempo):
// affects on tempo speed, now it is keeping tempo. But the correct use of the Value Notifier and Builder is crucial.
// 1) WidgetsBindingObserver (Android, macOS, iOS), toDo: still accelerates on its own on startUp, but does not slows down !!!
// 2) inkWell (Windows)                             toDo: does not freeze when part of widget rebuilds by valuelistenerBuilder
class _JaliinstrumentState extends State<Jaliinstrument> with WidgetsBindingObserver{   //observer variant: to detect is app in foreground or background in Android
/////////////////////////////////////////////// end foreground/ background observer for android 1 of 3 ///////////////////////
//
  // Set focus on Measure button when widget load, desktop win (to use keyboard Space button to start Play)  1 of 3
  //
  // measuresButtonFocusNode.requestFocus();    // no needed, see "autofocus" on button
  // FocusAttachment nodeAttachment;
  // nodeAttachment = measuresButtonFocusNode.attach(context, onKey: _handleKeyPress);
//
///////     NEW SOLUTION: USING TIMER IN THE SECOND "ISOLATE" 2 OF 3          (FOR SENDING DATA INTO THE MAIN ISOLATE WITH THE GUI)
  Isolate? _playerIsolate;
  SendPort? _sendPortToPlayer;
  ReceivePort? _receivePortFromPlayer;
/////// end NEW SOLUTION: USING TIMER IN THE SECOND "ISOLATE" 2 OF 3
//
  FlutterAudioCapture _audioRecorder = new FlutterAudioCapture();  // NEW recorder from audio_capture 1 of 4
//
//
  Future getAndSetWindowSize() async {
    Size fullScreenSize = await DesktopWindow.getFullScreen();
 // ntTableCaptionTxt = await fullScreenSize.toString(); setState(() {});   // uncomment to see full screen size
    if(fullScreenSize.height > 1600) {
   // await DesktopWindow.setWindowSize(Size(1300,1600));                   // Setting Desktop Window Size // SEE: "windows/runner/main.cpp" to setUp OriginPoint
      await DesktopWindow.setWindowSize(Size(800,1100));                   // Setting Desktop Window Size // SEE: "windows/runner/main.cpp" to setUp OriginPoint
    } else {} //end if
    if(Platform.isLinux && fullScreenSize.height > 1400) {
      await DesktopWindow.setWindowSize(Size(720,1600));
    } else {} //end if
  } // end getAndSetWindowSize via DesktopWindow
///////////////// Replacing setState()s with Value NotifierAndBuilder Listener  (1 of 4) //////////// Increase performance without reloading the widget
// When the value is replaced with something that is not equal to the old value as evaluated by the equality operator ==, this class notifies its listeners
  static final ValueNotifier<List<Map<String, bool>>> buttonsNotifier = ValueNotifier([]); // Creates a ChangeNotifier that wraps this value
  void addButtonsStates(int btnNum, bool locFing) {                                        // See also SplayTreeMap (Sorted! HashMap), "Splay"!
  //if(stringsNum==21 && btnNum==21) { btnNum = 22;} else if(stringsNum==21 && btnNum==22)  { btnNum = 21;} else {}   // remember that in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string, but in csvLst does not changed
    if (btnNum==0)  {
      buttonsPS.clear();
      for (int i = 0; i < 24; i++) {        // to prevent Range error: max index is 23
        buttonsPS.add({'prsd' : false});    // List of unsorted HashMapS (no need to Sort, it's primitive!)
      } //end for
      buttonsPS.add({'fngr' : false});    // for Local showFingering              24th element
      buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
    } else if( (stringsNum==21 && btnNum != 21) || stringsNum==22 ) {             // in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string
//
      buttonsPS = [...buttonsNotifier.value]; // "..." !!! it is called "Spread operator"     // If you want to get previous values!
      buttonsPS[btnNum]['prsd'] = true;
      if (locFing==true) {buttonsPS[24]['fngr'] = true;} else {};
      buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
    } else {} // end if()
  } // end addButtonsStates()
  void releaseButtonsStates(int btnNum) {
  //if(stringsNum==21 && btnNum==21) { btnNum = 22;} else if(stringsNum==21 && btnNum==22)  { btnNum = 21;} else {}   // remember that in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string, but in csvLst does not changed
    buttonsPS = [...buttonsNotifier.value]; // "..." !!! it is called "Spread operator"
    if (btnNum==0)  {
      for (int i = 0; i < 24; i++) {
        buttonsPS[i]['prsd'] = false;
      } //end for
      buttonsPS[24]['fngr'] = false;
      buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
    } else if( (stringsNum==21 && btnNum != 21) || stringsNum==22 ) {             // in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string
//
      buttonsPS[btnNum]['prsd'] = false;
      buttonsPS[24]['fngr'] = false;
      buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
    } else {} // end if()
  } // end releaseButtonsStates()
//////////////////////////////////////// End Value NotifierAndBuilder Listener (1 of 4) /////////////
//
//
///////////////////////////// Web JS tonic and dart:js with Tone.js play Methods ////////////////////
/* // Not Used
void playNote(String note) {            // simple JS tonic
  final midi = tonic.name2midi(note);                                         //name2midi from tonic package (?corresponding table)
  play(midi);
}  // Not Used
 */
//----------------------------------------------------------------------------------------------//
  // For Web Uncomment: js.context.callMethod("playNoteSynth ... and js.context.callMethod("playNote ...
  void playJS(int midi) {               // simple JS tonic
    String note = tonic.Pitch.fromMidiNumber(midi).toString();
    playNoteJS(note);                                                         // works fine, but needs corresponding table (?note2midi)
  }
  void playNoteJS(String note) {
    final fullNote = note.replaceAll('♭', 'b').replaceAll('♯', '#');
//  ------ Uncomment Web 1 of 2 ------
//  js.context.callMethod("playNoteSynth", ["$fullNote", "8n"]);     //toDo: comment build Win; native Web JS playNote method (see JS script) via Tone.js
//  ----------------------------------
  }
//// playJS(60);        playJS(64);         playJS(67);                         // all works fine  (!!!dont use setState()s)
//// playNoteJS('E4');  playNoteJS('G4');   playNoteJS('C4');
////////////////////////////////////////// Web JS Tone.js play Method /////////////////////////////
  void plaYm4a(String note) {           // powerful Tone.js                   // play m4a via Tone.js, all work fine (!!!dont use setState()s)
    final fullNote = note.replaceAll('♭', 'b').replaceAll('♯', '#');
//  ------ Uncomment Web 2 of 2 ------
//  js.context.callMethod("playNote", ["$fullNote", "4", "1"]);      //toDo: comment build Win; native Web JS method (arguments always are List/array) (see JS script)
//  ----------------------------------
////// args of playNote(note, tuning) are "note","tuning","shortOrLong"
//////js.context.callMethod('alert', ["$fullNote"]);                         // native Web JS method (arguments allways is List/array)
  }// end void plaYm4a()
//-----------------------------------------------------------------------------------------------//
//////////////////////////////////////// End Web JS tonic and End Tone.js play Methods /////////////
//
////////////////////// Flutter Midi Support, part 0 ///////////////
// final flutterMidi = FlutterMidi(); // supports only Android and OS, NOT Web, NOT Windows !!!  // flutter_midi: commented 2 of 6
///////////////////////////////////////////////////////////////////
//
//           @override
//           void initState() {        // after ANY dispose() !!!
//             super.initState();
//                            }
//
  //
  void instantlyLoadCSVwinCMD() async {
      //       showAlertDialog1(BuildContext context) {   // alert dialog template
      //         Widget okButton = TextButton(child: Text("OK"), onPressed: () {Navigator.of(context).pop();},);  // dismiss dialog
      //         AlertDialog alert = AlertDialog(title: Text(""),content: Text(argument0), actions: [okButton,],);
      //         showDialog(context: context,builder: (BuildContext context) {return alert;},);
      //       }
      //       await showAlertDialog1(context);
    if (isLoadingCSV == false && userAbortedLoadCSV == false) {  //readCsvFeautr (File('$argument0'));  // see void main, where were replaced all \-slashes to /-slashes in Path  (win-slashes to android-slashes)  //argument0 = "C:/Users/User/Desktop/Test.csv";  //   Right Slashes !!! Not Left !!!
      addNtTblNotifierStates();
      await readCsvFeautr (File('$argument0'));  // see void main, where were replaced all \-slashes to /-slashes in Path  (win-slashes to android-slashes)
    } else {}
  }  // end instantlyLoadCSVwinCMD()
//
  void fillTuningList() {
    droptuningList.clear();
    tuneMap.forEach((key, value) {droptuningList.add(tuneMap[key]!);});
    droptuningList = List.from(droptuningList); // remove null-elements if they are present
  } // end fillTuningList()
//
  @override
  void initState() {
    super.initState();  // should always be the first line in your initState method
  //fillTuningList();   // filling list of the tunings
///////////////////////////////////////////////  foreground/ background observer for android 2 of 3  ///////////////////////
    WidgetsBinding.instance.addObserver(this);
/////////////////////////////////////////////// end foreground/ background observer for android 2 of 3  ///////////////////////
    // await getDataSharedPref();       //CALL  //no needed
//////////
    // themeappLightDarkChange(false);  //ASYNC cannot be there until the List will not be Filled!
    //
///////     NEW SOLUTION: USING TIMER IN THE SECOND "ISOLATE" 1 OF 3          (FOR SENDING DATA INTO THE MAIN ISOLATE WITH THE GUI)
    _setupPlayerIsolate(1, 1, [], csvLst, 1, false);
/////// end NEW SOLUTION: USING TIMER IN THE SECOND "ISOLATE" 1 OF 3
    _audioRecorder.init();              // Initialize NEW recorder from audio_capture 2 of 4
    //
    initStateFunctions();       //CALL
    addNtTblNotifierStates();   // was moved here from initStateFunctions.  //*** IF ASYNC FUNCTION WILL BE BEFORE THE SYNC FUNCTION, IT WILL RETURN RANDOM VALUES !!! SEE print(themeappLightDark) in getAppSettingsSharedPref()
    getAppSettingsSharedPref(); //***ASYNC!  //*** setting App Theme Light/Dark e.t.c. AFTER fillDefaultColorsList(), because it is Sync, but getAppSettingsSharedPref() is Async !!! Data from Async can return later, than color list will be used in widget!!!
  } //end initState ()
  //
  void initStateFunctions() {
    fillDefaultColorsList();    //***THIS IS SYNCHRONOUS FUNCTION
    if(themeappLightDark != 1) {int i=0; for (Color colorEl in keysColorsList) {keysColorsList[i] =  invertCustom(colorEl); i++;}} else {};
    fillDefaultFingeringList(); //CALL
    addButtonsStates(0,false);  // filling buttons states List for Value NotifierAndBuilder Listener (2 of 4)
///////////////////////////////// midi support part 1 of 3 (only for Web)/////    // Special constant kIsWeb
//   if (playerMode==3) {loadSF2(midiValue);} else {flutterMidi.prepare(sf2: null);}  // flutter_midi: commented 3 of 6
//////////////////////////////////////////////////////////////////////////////
    //getAndSetWindowSize();  // setting Window Size for Desktop App (Win, Linux, MacOS) toDo: NotWork! // SEE: "windows/runner/main.cpp" to setUp OriginPoint
    if(tempSMonitor == '') {DesktopWindow.setWindowSize(Size(800,1100));
      if(Platform.isLinux) {DesktopWindow.setWindowSize(Size(860,1600));} else {}
                            } else {} //end if  // Setting Desktop Window Size // SEE: "windows/runner/main.cpp" to setUp OriginPoint
    if (toShowVLbls && !wasShownVLblsOnce) {showBigLabelsShortly();  toShowVLbls = true;} else {showVerticalBigLables = false;}
  //showVerticalBigLables = false; // hide big labels at both side if they were shown
//////////////////////
    if (argument0 != '') {  // see void Main (arguments)
      tempSMonitor = argument0;
      isSwitchedMonitorFile = true; LoadCSVBtnTx='Changes monitor';
                            DesktopWindow.setWindowSize(Size(860,1600));
      if(Platform.isLinux) {DesktopWindow.setWindowSize(Size(430,1600));} else {}
      instantlyLoadCSVwinCMD(); //call
      setState(() {argument0 = '';});
    } else {}
//////////////////////
  } //end initStateFunctions ()
  //
//
  Future<void> showBigLabelsShortly() async { // show big labels shortly
    showVerticalBigLables = true; setState(() {});    // show
    await Future.delayed(const Duration(seconds: 2)); // pause 2 seconds
    showVerticalBigLables = false; setState(() {});   // hide
    wasShownVLblsOnce = true;  setState(() {});
  }
//
///////////////////////////////////////////////  foreground/ background observer for android 3 of 3  ///////////////////////
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {        // after SDK upgrade it stops in background in Windows Too, earlier it was only in Android
    if(Platform.isAndroid || Platform.isIOS) {                      // stop playback if in background on Android, IOS. And do not stop if Windows, MacOS
      switch (state) {
        case AppLifecycleState.resumed:
          setState(() {toggleIcnMsrBtn = true;});
          ntTblNtfrsList = [...ntTblNotifier.value];
          ntTblNtfrsList[5]['msrTgl'] = 0;
          ntTblNotifier.value = ntTblNtfrsList;
          if(isTunerModeEnable==true) {_stopCapture();} else {}    // Turn OFF capturing stream from Mic with turning OFF Green Mic Privacy Indicator
          break;
        case AppLifecycleState.inactive:
          setState(() {toggleIcnMsrBtn = true;});
          ntTblNtfrsList = [...ntTblNotifier.value];
          ntTblNtfrsList[5]['msrTgl'] = 0;
          ntTblNotifier.value = ntTblNtfrsList;
          if(isTunerModeEnable==true) {_stopCapture();} else {}    // Turn OFF capturing stream from Mic with turning OFF Green Mic Privacy Indicator
          break;
        case AppLifecycleState.paused:
          setState(() {toggleIcnMsrBtn = true;});
          ntTblNtfrsList = [...ntTblNotifier.value];
          ntTblNtfrsList[5]['msrTgl'] = 0;
          ntTblNotifier.value = ntTblNtfrsList;
          if(isTunerModeEnable==true) {_stopCapture();} else {}    // Turn OFF capturing stream from Mic with turning OFF Green Mic Privacy Indicator
          break;
        case AppLifecycleState.detached:
          setState(() {toggleIcnMsrBtn = true;});
          ntTblNtfrsList = [...ntTblNotifier.value];
          ntTblNtfrsList[5]['msrTgl'] = 0;
          ntTblNotifier.value = ntTblNtfrsList;
          if(isTunerModeEnable==true) {_stopCapture();} else {}    // Turn OFF capturing stream from Mic with turning OFF Green Mic Privacy Indicator
          break;
        case AppLifecycleState.hidden:
        // TODO: Handle this case.
          break;
      }
    } else {}
  }
/////////////////////////////////////////////// end foreground/ background observer for android 3 of 3  ///////////////////////
//
//////////////////////////////// midi support part 2 of 3 //////////////////////////////////////////////
  void loadSF2(String asset) async {
//   flutterMidi.unmute(); ByteData byteMidi = await rootBundle.load(asset);          // flutter_midi: commented 4 of 6
//   flutterMidi.prepare(sf2: byteMidi, name: midiValue.replaceAll('assets/', ''));   // flutter_midi: commented 5 of 6
  }
//  String midiValue = 'assets/Piano.sf2';                                           // flutter_midi: commented 5a of 6     Piano.sf2 was removed from assets folder
////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////
  String getFileExtension(String fileName) {  // for determine CSV or TSV
    try {
      return fileName.split('.').last;
    } catch(e){
      return 'csv'; // default if unknown
    }
  }
//////////////////////////////////////////////////////////////////////////////////////////
//
//
//   List<List<dynamic>> dataF = [];                       // for playSound, not for visual, base for data1 (visual)    Old SDK works with this Type
//   List<List<dynamic>> dataFbak = [];                    // backup dataF if read CSV error
  List<dynamic> dataF = [];                       // for playSound, not for visual, base for data1 (visual)       Needs for TSV, googleCSV  and also works with excel's csv
  List<dynamic> dataFbak = [];                    // backup dataF if read CSV error                               Needs for TSV, googleCSV  and also works with excel's csv
//
  void loadCSV(file1) async {                           // only known CSV extension, other ignored by Android !!!
    if(clearRangeSharePref) {clearRangeSharePrefA=true;} else {}
    setState(() {toggleIcnMsrBtn = true;}); // toDo: part of reset player function
    String fieldDLMTr = ';';
    if(wasTSVextDetected==true) {
      fieldDLMTr = '\t';                                                                    // TAB
    } else {
      fieldDLMTr = ';';                                                                     // Semicolon
    } //end if TSV or CSV was detected
    final rawData = await rootBundle.loadString(file1); // only root, make it any place
    var detect = new FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
    List<List<dynamic>> listData =        CsvToListConverter(
      //csvSettingsDetector: detect, fieldDelimiter: ";",
        csvSettingsDetector: detect, fieldDelimiter: "$fieldDLMTr",
        shouldParseNumbers: false, allowInvalid: true).convert(rawData);
    dataF.clear();
    setState(() {       // use matrix2d package to transpose Rows to Cols //the last non-empty element could be defined by Excel itself when exporting (but we have not undiscovered cell range)
      dataF = List.from(listData.transpose);
    });
    await loadTagsFirst();
  } // end loadCSV ()
//
  Future<void> readCsvFeautr (notationCsvFile) async {
    if(clearRangeSharePref) {clearRangeSharePrefA=true;} else {}
    setState(() {toggleIcnMsrBtn = true;isLoadingCSV = true;}); // while loading isLoadingCSV set to "true"
    String fieldDLMTr = ';';
    if(wasTSVextDetected==true) {
      fieldDLMTr = ';';                     // was  fieldDLMTr = '\t';       changed to (;) only for next Check Works  // TAB Google-TSV
    } else {
      fieldDLMTr = ';';                     // Semicolon Excel-CSV
    } //end if TSV or CSV was detected by extension
    List <List> csvToList1 (File notationCsvFile) {
    //csv.CsvToListConverter tempC = new csv.CsvToListConverter(eol: "\r\n", fieldDelimiter: ";");
      csv.CsvToListConverter tempC = new csv.CsvToListConverter(eol: "\r\n", fieldDelimiter: "$fieldDLMTr");
      List<List<dynamic>> listCreated = tempC.convert(notationCsvFile.readAsStringSync());
      return listCreated;
    }
    dataF.clear(); dataF = await csvToList1(notationCsvFile); // preliminary reading I of II
    ///////////////
    List <String> cellA1 = dataF[0][0].toString().split('~');           // splitting Excel's A1 cell contents by dilimiter "~"
    String tempperformrsInfo_1 = cellA1[3];
 //print(tempperformrsInfo_1);
             if (tempperformrsInfo_1.toString().contains(',,,,,,,,,,'))	{	// check if it is Google-CSV with comma "," separator instead of excel's semicolon ";" separator
            setState(() {googleCSVdetected = true; wasTSVextDetected = false;  fieldDLMTr = ','; });    // Comma
 //print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
      } else if (tempperformrsInfo_1.toString().contains(RegExp('\t\t\t\t\t\t\t\t\t\t'))) { // REGULAR EXPRESSION, also try   contains(r'\t\t\t\t\t')  // check if it is Google-TSV with TABs "TAB" and wrong extension (if someone renamed the file extension) // check if it is Google-TSV with at least a ten of TABs and No contains at least ten of ";" (i.e. wrong extension)
            setState(() {googleCSVdetected = false; wasTSVextDetected = true;  fieldDLMTr = '\t';});    // Tab
 //print('tttttttttttttttttttttttttttttttttttttttttttttttt');
      } else {
            setState(() {googleCSVdetected = false; wasTSVextDetected = false; fieldDLMTr = ';';});     // Semicolon - in all other cases it is excel
 //print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      } // end if    (finish check 1 of 3 file types by A1-cell-contents)
    dataF.clear();
    dataF = await csvToList1(notationCsvFile); // final reading II of II      main Notation Source
  //dataF = await parseGoogleSpreadsheetHttpData();   // try to reading Google Spreadsheet Notation via http, works fine!
// print(dataF);
    ///////////////
    setState(() {       // use matrix2d package to transpose Rows to Cols //the last non-empty element could be defined by Excel itself when exporting (but we have not undiscovered cell range)
    dataF = List.from(dataF.transpose);
//print(dataF);
    });
    setState(() {
      ntTblNtfrsList = [...ntTblNotifier.value];
      isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
      mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
    });
    addNtTblNotifierStates();                                             //    Needed Only to swith view in common CSV/TSV-file After HTTP Google Spreadsheet Loading
    await loadTagsFirst();
 // tablesBothOnTap(false, false); tablesBothOnTap(false, false); // 1-st and 2-nd tap  //    Needed Only to swith view in common CSV/TSV-file After HTTP Google Spreadsheet Loading
    tablesBothOnTap(false, true); tablesBothOnTap(false, true); // 1-st and 2-nd tap  //    Needed Only to swith view in common CSV/TSV-file After HTTP Google Spreadsheet Loading
    //setState(() {isLoadingCSV = false;}); // moved to the end of the loadTagsFirst()
  } // end readCsvFeautr() async
//
//
//toDo: FILE PICKER       (Open File Dialog)                  !!! WORKS WEB (* -[path]), WIN, ANDROID, LINUX, MacOS !!!
  String? fileNameCSV;  List<PlatformFile>? pathsLst; String? directoryPath; bool isLoadingCSV = false;  bool userAbortedLoadCSV = false;
//
  pickUpCSV() async {     //print('$isLoadingCSV---$userAbortedLoadCSV');
    if(csvMode == 1 && (playerMode == 1 || playerMode == 6)) {          //  "Android, MacOS, Linux"
      try { // sometimes freeze if press monitor second time (only Android), cause was incorrect table view 128/64/32 switching and not a folder deletion
        FilePicker.platform.clearTemporaryFiles(); // SECOND: Trying to clear cached file or entirely folder, because changes in file not applied; reload old version (on Android, MacOS)
      } catch(e) {} //no need to catch
    } else {} // end trying to clear temp files with old caching copy
    showAlertDialog(BuildContext context) {   //pop-up alert message:            // set up the button:
      Widget okButton = TextButton(child: Text("OK"), onPressed: () {Navigator.of(context).pop();},);  // dismiss dialog
      // set up the AlertDialog:
      AlertDialog alert = AlertDialog(title: Text("Selected file is not a appropriate CSV or TSV file"),content: Text("Please choose the correct file"),
        actions: [okButton,],);
      // show the dialog:
      showDialog(context: context,builder: (BuildContext context) {return alert;},);
    } // end show (opening) non-csv-file Alert dialog
    if (isLoadingCSV == false && userAbortedLoadCSV == false) {
      FilePickerResult? csvFile =                       //Android: custom ext 'jni' unsupported and ignored, 'csv' is well-known and used it this app
      await FilePicker.platform.pickFiles(allowedExtensions: ['csv','tsv'], type: FileType.custom, allowMultiple: false);
      if (csvFile != null) {
        //String fileL = csvFile.files.single.name.toString();  // [name,path] near lock symbol
        //loadCSV('assets/csv/$fileL');                         // toDo: only from assets
        String tempS = csvFile.files.single.path.toString();    // toDo: [path] Not support Web, only [name] supports Web
        if(getFileExtension(tempS)=='tsv' || getFileExtension(tempS)=='TSV') {setState(() {wasTSVextDetected = true;});}
        else {setState(() {wasTSVextDetected = false;});} //end if
        File fileL = File('$tempS');    // toDo: !!! !!! !!! !!!!!! !!! Only such: " '$Str' ", not unnecessary ?! // this string interpolation NEEDED in current version SDK or due Android peculiarities
        // await readCsvFeautr (fileL); // works fine, try to check if file csv is correct or not
/////////////// Prevention: if file is Not a CSV/TSV-file ////////////////
        dataFbak.clear(); dataFbak = dataF.map((v) => v).toList();      // make backup   //  it is also NOT a right way to Copy the List !!! it is a mirror of source data list
        try {   // thanks to this function, it will be possible to re-open file
          setState(() {
            ntTblNtfrsList = [...ntTblNotifier.value];
            isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
            mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
          });
          addNtTblNotifierStates();
          await readCsvFeautr (fileL);              // toDo: from any place
          //                                        // if successfully loaded by Pickin Up then. TRY CATCH WORKS SO: code after "await..." will not execute if error
          willGoogleSpreadsheetBeLoaded = false;    // if file and tags was loaded Successfully, then turning OFF HTTP function (if it before was turned ON)
          isNowGoogleSpreadsheetLoaded = false;     // for Online monitor button text does not change to File monitor
// print('local file loaded successfully');
          argument0 = ''; setState(() {});    // let's forget about our player was launched from Excel with the path parameter
          //
        } catch (e) {
          print(e);   // exclude the error "...StateLifecycle.created...", showing the alert message or dialog:
          if(e!='' && e.toString().contains('Uneven array dimension')) {     // uncomment print(e) to see the error text and which words it contains
          //if(e.toString().contains('Uneven array dimension')) {   // uncomment print(e) to see the error text and which words it contains
                showAlertDialog(context);  // handle the error here
                dataF.clear(); dataF = dataFbak.map((v) => v).toList(); // apply backup //  it is also NOT a right way to Copy the List !!! it is a mirror of source data list
              } else {} //end if    // else {} is Not a suitable place for Successful state
          setState(() {isLoadingCSV = false;});
        } // end try-catch
///////////////    End : if file is Not a CSV-file   ////////////////
// if (!mounted) return; // after dispose() before first setState() you should check if widget mounted, see initState(), red screen!
        setState(() {
          directoryPath = null; fileNameCSV = null;
          pathsLst = null;     userAbortedLoadCSV = false;
          ////////// Keeping string csvFile for cyclical file monitoring functions: ////////////
          tempSMonitor = tempS;
        });
        return fileL;
      } else { setState(() { userAbortedLoadCSV = true;  });  }   // User canceled the picker
    } else {}
    ///// hide big labels at both sides if they were shown
    showVerticalBigLables = false;
    setState(() {});
    ///// end hide big labels
  } // end pickUpCSV ()
//
  editorAutoplay() {      // editor autoplay:
    if (ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) != 0 || ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0) { //if Range Slider (Start or End) is not at the default position
      setState(() {toggleIcnMsrBtn = !toggleIcnMsrBtn;});
      ntTblNtfrsList = [...ntTblNotifier.value];
      ntTblNtfrsList[5]['msrTgl'] = 1;
      ntTblNotifier.value = ntTblNtfrsList;
      playFromList (0);  // playing selected fragment immediately after contents loaded without pressing the Measures Button
    } else {
      // do nothing
    }; // end if Range Slider (Start or End) is not at the default position
  }  // end editor autoplay
//
/////////////////////////////////// Cyclical file monitoring functions: //////////////////// Not yet cyclically automatic! Only manual!
  MonitorFile() async{              // So far, manually cyclical monitoring
    ///////////////////////////////  only on Android, MacOS platform file should be Re-Picked if it was changed externally
    bool isSliderResetNeeded = false; if(fromTheBegin == true) {isSliderResetNeeded = true;} else {}
    setState(() {
      ntTblNtfrsList = [...ntTblNotifier.value];
      isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
      mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
    });
    ntTblNtfrsList = [...ntTblNotifier.value];
    if(willGoogleSpreadsheetBeLoaded != true) {
      if(csvMode == 1 && (playerMode == 1 || playerMode == 6)) {          //  "Android, MacOS, Linux"
        if(isSwitchedMonitorFile==true) {
          try { // sometimes freeze if press monitor second time (only Android), cause was incorrect table view 128/64/32 switching and not a folder deletion
            FilePicker.platform.clearTemporaryFiles(); // FIRST: Trying to clear cached file or entirely folder, because changes in file not applied; reload old version (on Android, MacOS)
          } catch(e) {} //no need to catch
          pickUpCSV();                               // in the Android build Monitor works only as Re-Pick
        } else {
          if (tempSMonitor!='') {
            addNtTblNotifierStates(); //////////////////// TRY 001
            await readCsvFeautr(File('$tempSMonitor'));
          } else {}     // Re-Read existing. You can paste here autostart playback like in Win-variant:
        }
      } else {                                       // Windows          // in all cases (except Android, MacOS) using monitor
        if (tempSMonitor!='') {
          addNtTblNotifierStates(); //////////////////// TRY 001
          await readCsvFeautr(File('$tempSMonitor'));
        } else {}      // in all other cases (Windows), Monitor works just like a monitor
        editorAutoplay(); // Call
      }
    } else {
      readGoogleSpreadsheet(isSliderResetNeeded);
    } // end willGoogleSpreadsheetBeLoaded
    ///////////////////////////////
    await checkIfTCCareOutOfLimits(); // if previous session ends incorrectly
    ///----------------------------------------------------------------- reset Range Slider ---------------------------------------------------------------
    if(isSliderResetNeeded == true) {
      if(isSwitchedMonitorFile==false) {
        addNtTblNotifierStates();
        ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[21]['nTcolS']!*4;  ntTblNtfrsList[20]['rngEndSlider'] = rngEnd;
        ntTblNotifier.value = ntTblNtfrsList;    // resetting Range Slider, right handle - to the Right
        setState(() {});
      } else {} //end if file changes monitor
    } else {} // end if isSliderResetNeeded
    ///----------------------------------------------------------------------------------------------------------------------------------------------------
    switch (isSwitched_32_64_128) {
      case 32:  ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 0; break;   // '⬤〇〇'
      case 64:  ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1; break;   // '〇⬤〇'
      case 128: ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 2; break;   // '〇〇⬤'
      default:  ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1;          // '〇⬤〇'
      strTxtNotifier.value = strTxtNotifierList;
    } // end switch()
  } // end MonitorFile
////////////////////////////////// End cyclical file monitoring functions. /////////////////
//
//
  Future<void> readGoogleSpreadsheetDialog() async {
  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    setState(() {
      ntTblNtfrsList = [...ntTblNotifier.value];
      isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
      mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
    });
    String defaultURLfieldText = "Paste here URL to your shared Google Spreadsheet Notation (link)";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Online Google Spreadsheet Notation (first 96 columns)'),
          content: TextField(
            maxLength: 300,
            controller: _textFieldController,
            decoration: InputDecoration(hintText: defaultURLfieldText),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('REPAIR RANGE'),
              onPressed: () {
                googleSpreadsheetLink = _textFieldController.text;
                clearRangeSharePref = true; clearRangeSharePrefA = true; setState(() {});
                addNtTblNotifierStates();
                readGoogleSpreadsheet(true);  // was true
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                if(isNowGoogleSpreadsheetLoaded !=true) {willGoogleSpreadsheetBeLoaded = false; setState(() {});} else {}     // for Online monitor button text does not change to File monitor
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('LOAD'),
              onPressed: () {
              //print(_textFieldController.text);\
                if(_textFieldController.text != '' && _textFieldController.text != defaultURLfieldText) {
                  googleSpreadsheetLink = _textFieldController.text; setState(() {});
                  addNtTblNotifierStates();
                  readGoogleSpreadsheet(false);
                } else {}
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  _displayTextInputDialog(context); // call
}
//
  Future<void> readGoogleSpreadsheet(bool _isSliderResetNeeded) async {
/////////////// Prevention: if response in not 200 ////////////////
    dataFbak.clear(); dataFbak = dataF.map((v) => v).toList();      // make backup   //  it is also NOT a right way to Copy the List !!! it is a mirror of source data list
    try {   // thanks to this operator, it will be possible to continue to work offline
      dataF.clear();
      dataF = await parseGoogleSpreadsheetHttpData();   //  reading Google Spreadsheet Notation via http, works fine!
      argument0 = ''; setState(() {});                  // let's forget about our player was launched from Excel with the path parameter
    } catch (e) {
      print(e);   // exclude the error "...StateLifecycle.created...", showing the alert message or dialog:
    //if(e.toString().contains('No host specified in URI')) {     // uncomment print(e) to see the error text and which words it contains
      if(e.toString().contains('No host specified in URI')) {     // uncomment print(e) to see the error text and which words it contains
        //showAlertDialog(context);  // handle the error here
        dataF.clear(); dataF = dataFbak.map((v) => v).toList(); // apply backup //  it is also NOT a right way to Copy the List !!! it is a mirror of source data list
      } else {} //end if
      //dataF.clear(); dataF = dataFbak.map((v) => v).toList(); // apply backup //  it is also NOT a right way to Copy the List !!! it is a mirror of source data list
      if(isNowGoogleSpreadsheetLoaded !=true) {willGoogleSpreadsheetBeLoaded = false; setState(() {});} else {}     // for Online monitor button text does not change to File monitor
      setState(() {isLoadingCSV = false;});
      //
                showAlertDialog(BuildContext context) {   //pop-up alert message:            // set up the button:
                  Widget okButton = TextButton(child: Text("OK"), onPressed: () {Navigator.of(context).pop();},);  // dismiss dialog
                  // set up the AlertDialog:
                  AlertDialog alert = AlertDialog(
                      content: Container(
                        child: SingleChildScrollView(
                          child:
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xd63f3a32),
                                    fontStyle: FontStyle.normal,
                                    decoration: TextDecoration.none,
                                  ),
                                  text: e.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [okButton,]
                  );
                  // show the dialog:
                  showDialog(context: context,builder: (BuildContext context) {return alert;},);
                }
                showAlertDialog(context);
      //
    } // end try-catch
///////////////    End :  if response in not 200   ////////////////
// print(dataF);
    ///////////////
    setState(() {       // use matrix2d package to transpose Rows to Cols
      dataF = List.from(dataF.transpose);
//print(dataF);
    });
    await loadTagsFirst();
    tablesBothOnTap(false, false); tablesBothOnTap(false, false); // 1-st and 2-nd tap  //
    setState(() {
      ntTblNtfrsList = [...ntTblNotifier.value];
      isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
      mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
    });
    ///----------------------------------------------------------------- reset Range Slider ---------------------------------------------------------------
    if(_isSliderResetNeeded == true) {
      if(isSwitchedMonitorFile==isSwitchedMonitorFile) {  // fake condition
        addNtTblNotifierStates();
        ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[21]['nTcolS']!*4;  ntTblNtfrsList[20]['rngEndSlider'] = rngEnd;
        ntTblNotifier.value = ntTblNtfrsList;    // resetting Range Slider, right handle - to the Right
        setState(() {});
      } else {} //end if file changes monitor
    } else {} // end if isSliderResetNeeded
    ///----------------------------------------------------------------------------------------------------------------------------------------------------
    /// ??? REPAIR RANGE ASYNC WONT TO SET TCC=1 AND CHANGE INDICATOR
    isNowGoogleSpreadsheetLoaded = true; setState(() {});
    editorAutoplay(); // Call
  } // end readGoogleSpreadsheet()
//
  Future<List> parseGoogleSpreadsheetHttpData() async {     // Reading Shared Google Spreadsheet Notation directly via Http request
    String link = googleSpreadsheetLink;                    // ONLY THE FIRST 96-COLUMNS WILL BE LOADED BY THIS METHOD, if you want more: use https://support.syncfusion.com/kb/article/11245/how-to-get-the-data-from-google-sheet-and-load-it-to-the-flutter-calendar
    http.Response res = await http.Client().get(Uri.parse(link));
    if (res.statusCode == 200) {
      dom.Document body = parse(res.body);
      dom.Element table = body.getElementsByTagName("table").first;
      dom.Element tbody = table.getElementsByTagName("tbody").first;
      int u = 0; int v = 0;
      for (dom.Element tr in tbody.getElementsByTagName("tr")) {      // first we are determine the dimension
        // StringBuffer sb = StringBuffer();
        for (dom.Element td in tr.getElementsByTagName("td")) {
          // sb.write(td.text);
          // sb.write(";");      // dilimiter   (" ")   (";")   (",")
          v++;
        }
//print(sb.toString()); // works fine
        u++;
      } // end for
// print(u);  // ~100
// print(v);  // ~10100
      //List<List<dynamic>> httpCSVlst = List.generate(u,(i) => List.generate(v + 1, (j) => '', growable: true), growable: true);
      //List<List<dynamic>> httpCSVlst = List.generate(u,(i) => List.generate(v + 0, (j) => '', growable: true), growable: true);
      var httpCSVlst = List.generate(u,(i) => List.generate(v + 1, (j) => '', growable: true), growable: true);
///////////////////////////////////////////////////////////////////
      u = 0; v = 0;
      for (dom.Element tr in tbody.getElementsByTagName("tr")) {
        // print(tr.text.toString());
        StringBuffer sb = StringBuffer();         // Needed, without it no line breaks          // multiple Redefining variable, it's OK
        for (dom.Element td in tr.getElementsByTagName("td")) {
          sb.write(td.text);
          sb.write(";");      // dilimiter   (" ")   (";")   (",")
          httpCSVlst[u] = sb.toString().split(";");                   // then we are filling up the List by splitting the StringBuffer value
          v++;
        }
        u++;
        //print(httpCSVlst);
      } // end for
      // print(httpCSVlst[0]);                       // works fine
      // print(httpCSVlst[1]);
      // print(httpCSVlst[3]);
      // print(httpCSVlst.sublist(0,23));            // works fine
      // print(httpCSVlst.sublist(0,23).transpose);  // works fine
///////////////////////////////////////////////////////////////////
    //return httpCSVlst.sublist(0,23).transpose;
      return httpCSVlst.sublist(0,23);
    } // end if
    throw 'Google Sheets cannot be read at this URL';
  } // end parseGoogleSpreadsheetHttpData() async
//
//
  Future <void> playerInitWithEmptyNote() async {
    if (csvMode != 2 && playerMode != 6) { // not for Web, not for Linux
      // final player = AudioPlayer(); // only one final audioPlayer
      // player.setVolume(0.9);
      // player.play(AssetSource('m4a/000L.m4a'), mode: PlayerMode.lowLatency);  // try to initialize player, 000L is silent sample
    } else {} //end if
  }
//
  fromTheBeginBySliderCoincidence() {             // Suggest to Start Over (begin) by Slider Values Coincidence
    ntTblNtfrsList = [...ntTblNotifier.value];
    if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) == 0){
      fromTheBegin = false;
      if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == false) {LoadCSVBtnTx='Changes monitor';} else if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == true) {LoadCSVBtnTx='Online spreadsheet monitor';} else {LoadCSVBtnTx='Load csv/tsv file, web';} //end if
    } else {
      fromTheBegin = false;
      if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == false) {LoadCSVBtnTx='Changes monitor';} else if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == true) {LoadCSVBtnTx='Online spreadsheet monitor';} else {LoadCSVBtnTx='Load csv/tsv file, web';} //end if
    }
    if(ntTblNtfrsList[0]['rangeStart']?.round() == ntTblNtfrsList[1]['rangeEnd']?.round() && ntTblNtfrsList[1]['rangeEnd']?.round() != nTcolS*2 && ntTblNtfrsList[4]['tableChangeCount'] != 1){
      fromTheBegin = true;
      LoadCSVBtnTx = 'Start Over (begin)';
      showArrowMoveToTheLeft=false;
    } else {
      fromTheBegin = false;
      if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == false) {LoadCSVBtnTx='Changes monitor';} else if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == true) {LoadCSVBtnTx='Online spreadsheet monitor';} else {LoadCSVBtnTx='Load csv/tsv file, web';} //end if
    } //end if
    if(ntTblNtfrsList[0]['rangeStart']?.round() == ntTblNtfrsList[1]['rangeEnd']?.round() && ntTblNtfrsList[1]['rangeEnd']?.round() == nTcolS*4){
      clearRangeSharePref = true;
      LoadCSVBtnTx = 'Clear Range Pref. (for the file being opn.)'; // if both slider handles are at all the way to the right position
      showArrowMoveToTheLeft=false;
    } else {
      clearRangeSharePref = false;
    } //end if
    ntTblNotifier.value = ntTblNtfrsList;
 // tablesBothOnTap(false); tablesBothOnTap(false);   // CALL twice //  fix saving the Range after Range Change            see: range slider
    setState(() { }); // setting states of All Upper values, because you do not have to write they inside the "setState"
  }
//
/////////////////////////////////////////////////////~~~~~ loadTagsFirst() Future ~~~~~//////////////////////////////////////////////////
  Future <void> loadTagsFirst() async {
    ntTblNtfrsList = [...ntTblNotifier.value];
    // if(    !Platform.isLinux    ) {playerInitWithEmptyNote();} else {}  // initialize player and wait 0.8 seconds     //if Not Linux!
    // keeping only 0...22 rows because the file exported from other Offices and depends on undiscovered range may contain more rows (list row 23,24):
////////////////
    dataF = List.from(dataF.transpose);  // additional, 2nd
////////////////                                       // !!! !!! !!! Another warning about "List.From" method !!! !!! !!! You can also try methods:   "List.Of"   "List.Copy"  or  var YOURCOPY = YOURLIST.map((v) => v).toList();
    try {dataF = dataF.sublist(0,23);} catch(e) {};    // keeping only 24 rows (0, 1 .. 23)  // [0] is a row of A1 and extra marks or bookmarks, [1...22] is rows corresponding to strings
//  try {dataF = dataF.sublist(0,22);} catch(e) {};    // with <= notesByBit+1 you will give an error in readCSV Future because of "List.From". This "Strange" method changes parameters of the Parent List, from which the Child List is taken !!!
////////////////
    dataF = List.from(dataF.transpose);  // back, 3rd
////////////////
    List <String> cellA1 = dataF[0][0].toString().split('~');                             // splitting Excel's A1 cell contents by dilimiter "~"       excel[row][column]
    int tempStringsNum      =   int.parse(cellA1[0]);
    int tempselectedtuningNum = int.parse(cellA1[1]);
    if (cellA1[2] != null) {                                                              //  Null Check  //  clamp 0.1 ... 2.0
      tempoCoeff =  double.tryParse(cellA1[2])!.clamp(0.1,2.0); } else {tempoCoeff = 1.0;}  // clamp(0.1,2.0) is Fit in Range 0.1 ... 2.0, if less or more, then equal 0.1 and 2.0 accordingly
    tempperformrsInfo = cellA1[3];
    if (tempStringsNum.clamp(21,22) == tempStringsNum) {stringsNum = tempStringsNum;} else {}  // Clamp - is checking if it is within the range // if out of range, used nearest boundary value
    if (tempselectedtuningNum.clamp(1,15) == tempselectedtuningNum) {setState(() {selectedtuningNum = tempselectedtuningNum;});} else {} // end if clamp
    // ~~~~~~~~~~~~~~finding Max Non-empty Position (if csv contains many ";;;;;" without notes at the end)~~~~~~~~~~~~:
    csvLst.clear();
    csvLst = dataF.map((v) => v).toList();                 // it is also NOT a right way to Copy the List !!! it is a mirror of source data list
    int notesByBit = 22;                                        // allways 22        if 21 string: 22         if 22 string: 22         For F2 Button To Work!
//  int notesByBit = stringsNum;                                // !!!!!!!!!!!!!!!!!!! Not ReDefine Variables !!!!!!!!!!!!!!! Not to Mix With Global Variables !!!
    int maxLength_1 = csvLst.length;                            // !!! do not re-define variable (int maxLength) here!!! Will not be errors, and not result
    maxNotEmptyPos = 1;     bool isFound = false;               // !!! do not re-define variable (maxNotEmptyPos) !!!
    for (int i = 1; i < maxLength_1; i++) {
      for (int j = 0; j <= notesByBit; j++) {                   //  <=    <=    <=    less or equal
        if (csvLst[i][j] != "") {isFound = true;} else {}
      } // end for (j)
      if (isFound == true) {maxNotEmptyPos = i + 0 + 0;  isFound = false;} else {}  // changed to   i + 0 + 0  try to break loop via mark "outerloop:" and keywork "break;"  // was (i + 1) because of last bit; (i + 1 + 1) because when stops, last bit should not sounds
    } // end for (i)
// print(csvLst); print(maxLength_1);    // DEBUG PRINT HERE 1
///////////////////////////////////////////////////////////////////////////////////////////////////////
    final List<dynamic>emptyFillingList_00a = List.generate(1,(i) => List.generate((cols1 + 1),(j) => '', growable: true), growable: true);
    if(maxLength_1==1) {dataF=[['', '','' , '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],[' ', '','' , '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']];} else {}  //Prevention of range error if csv file is empty
    if (googleCSVdetected == true)	{
          // NOT REQUIRED
    } else if (wasTSVextDetected == true) {
          // NOT REQUIRED
    } else {  // excel CSV
          // NOT REQUIRED
    } // end if
      if(wasTSVextDetected==true || googleCSVdetected==true) {             // NOT REQUIRED        // was: TSV needs one additional element at the end (this is the difference from CSV):
      //csvLst = csvLst + emptyFillingList_00a  + emptyFillingList_00a; // prevention of freeze at the end of TSV List playing // if you will use "add" instead of "+" you will give not element add but list of elements add
       } else {} //end if TSV was detected.
///////////////////////////////////////////////////////////////////////////////////////////////////////    end TSV adding elements at the end   1 of 5
    setState(() {                                              // you dont have to write all assignments inside the setState(...)
      maxNotEmptyPos = maxNotEmptyPos;
      maxLength = maxNotEmptyPos;                              // this will be the end point where player stops
      measureBtnTx = 'measures 1 - ' + (maxNotEmptyPos / ntTblNtfrsList[21]['nTcolS']!).ceil().toString();            // nTcolS=32 is a cell layout in excel template
    });
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
// print(dataF[0].toString());
////////////////////////////////////////////////// LIST FROM !!! LIST FROM !!! LIST FROM !!!///////////// Necessarily !!!///////////////////////////
    dataF = List.from(dataF.sublist(0, maxNotEmptyPos + 1));       //  List shrink to remove extra empty elements "[,,,,,,,]"    From now, (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!
  //dataF = dataF.removeWhere((key, value) => key == null || value == null); // some error
////////////////////////      Map.from will Remove the Null elements      List.from will Remove the Null elements   !!!     This is the Right way to Remove the Null elements !!!
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//print('maxLength:'); print(maxLength);
// print(csvLst); print(maxLength); if(wasTSVextDetected) {print('TSV');} else if(googleCSVdetected) {print('googleCSV');} else {print('excelCSV');}       // DEBUG PRINT HERE 2
    // ~~~~~~~~~~~~~Splitting Notation List by Two Tables (by every constant number of Columns)~~~~~~~~~~~~~~~~~~~~~~~:
    data1.clear();                                          // "List.from" is not a copy of the list! But it good removes null-elements!
    data1 = dataF.map((v) => v).toList();                   //  it is also NOT a right way to Copy the List !!! it is a mirror of source data list
    data1 = List.from(data1);                               // no needed! removing null-elements
//print(data1);
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
//     for (var el in dataF) {
//   //myDeveloper.log(el.toString());   // difference Print from Log is a Queue, Log will pass other messages between output
//     print(el.toString());             // (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!  ??????  It's very strange!
//     }
//myDeveloper.log(dataF.toString());
/////////////////////////////////////////////////////////////////////////// Prevention of extra spaces and long note names in Tables:
    int tmpSlength = 0;
    for (int i = 1; i < data1.length; i++) {
      for (int j = 0; j < stringsNumExcel - 1; j++) {     //  "    iB*note"   =>   "  iB*"
        if(data1[i][j] != '') {data1[i][j] = data1[i][j].toString().replaceAll(' ', '');
        tmpSlength = (data1[i][j]).length;
        if(tmpSlength > 3) {data1[i][j] = (data1[i][j]).substring(0,3);} else {}
        data1[i][j] = '  ' + data1[i][j];                 // so, Cell contains:  {SPACE}{SPACE}iA*   {SPACE}{SPACE}tB*   {SPACE}{SPACE}C    {SPACE}{SPACE}D
        } else {}
      } // end for (j)
      if(stringsNum==21){String tempData22EL = data1[i][22]; data1[i][22] = data1[i][21]; data1[i][21] = tempData22EL;} else {} // Changing places 22 and 21 elements to display them in the lower row of the table if 21-strings
    } // end for (i)
//
    //////////////////////////////// ONLY ONE RIGHT WAY TO COPY THE LIST IS LIST.GENERATE AND NESTED CYCLE/////////////////////////////
    csvLst.clear();
  //csvLst = List.generate(dataF.length,(i) => List.generate(dataF[0].length,(j) => '' , growable: true), growable: true);           // fill with empty elements, not null's
    csvLst = List.generate(dataF.length,(i) => List.generate(dataF[0].length,(j) => dataF[i][j] , growable: true), growable: true);  // assigning elements values of the source list, as the same as the nested loops i,j  // for (int i = 1; i < csvLst.length; i++) { for (int j = 0; j <= stringsNumExcel; j++) {csvLst[i][j] = dataF[i][j];} } // end for (i,j)
    tmpSlength = 0;
    for (int i = 1; i < csvLst.length; i++) {if(stringsNum==21){String tempData22EL = csvLst[i][22]; csvLst[i][22] = csvLst[i][21]; csvLst[i][21] = tempData22EL;} else {} // Changing places 22 and 21 elements to display them in the lower row of the table if 21-strings
    } // end for (i)
    csvLst = csvLst.sublist(1);              // minus 1 column at the begin, this method returns null-elements !!! It will nor change them in places, and not to remove them !!!
    csvLst = List.from(csvLst);              // removing empty elements
                                             // see:  addButtonsStates()  and  releaseButtonsStates()  if  (B) and (F) are reversed
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
////////////////////////// ------------------ Grey Screen Prevention at the End: -----------------////////////////////
////// Prevention Widget Crash (grey screen, when ends naturally) when list ends earlier than expected table width, ///////
////// this generated list will fill in the missing columns at the end before length dividing without a remainder: ////////
  //final List <dynamic> emptyFillingList = List.generate(cols1 + 1,(i) => '', growable: true);       // [ ,  ,  ,  ,  ,  , ..23..  ,  ,  ,  ,  ,  ]
    final List <dynamic> emptyFillingList = List.generate(data1[0].length,(i) => '', growable: true); // [ ,  ,  ,  ,  ,  , ..23..  ,  ,  ,  ,  ,  ]
//
    while ((data1.length).remainder(ntTblNtfrsList[21]['nTcolS']!*2) != 0) { // adding an empty column until the total width of the two tables is a multiple of 64th
      data1.add(emptyFillingList);
    } // end while()
////////////////////////// ------------------- End Grey Screen Prevention at the End -------------////////////////////
//
//////////////////// Prevention of Grey Screen When Opening CSV: if number of strings (rows in csv) in Lower than expected: /////////////
    //final List<dynamic>listFillingWith_1 = List.generate(1,(i) => List.generate(data1[0].length,(j) => '1', growable: true), growable: true);
    final List <dynamic> listFillingWith_1   = List.generate(1,(i) => List.generate((cols1 + 1),(j) => '1', growable: true), growable: true); //  [1, 1, 1, 1, 1, 1, ..23.. , 1, 1, 1, 1, 1]
    final List <dynamic> emptyFillingList_0a = List.generate(1,(i) => List.generate((cols1 + 1),(j) => '' , growable: true), growable: true); //  [ ,  ,  ,  ,  ,  , ..23.. ,  ,  ,  ,  ,  ]
////////////////
    data1 = data1.transpose;   // 1st, normal, for Map in Widget
////////////////
    // very long element of empty elements, it's length (thousands):
    final  List<dynamic>emptyFillingList_1 = List.generate(data1[0].length,(i) => '', growable: true); // [ ,  ,  ,  ,  ,  , ..Long.. ,  ,  ,  ,  ,  ]
    while ((data1.length < (cols1 + 1 + 0))) { // adding an empty column
      data1.add(emptyFillingList_1);           //keeping the shape of the table in width
    } // end while()
////////////////
    data1 = data1.transpose;   // additional, 2nd
////////////////
    data1 = listFillingWith_1 + data1;      //keeping the shape of the table in height
    data1 = data1.sublist(2);               //minus 2 columns at the begin
///////////////////////////////////////////////////////////////////////////////////////////////////////
           if (googleCSVdetected == true)	{
      for (int i = 1; i < 129; i++) {data1 = data1 + emptyFillingList_0a;}    // was < 2    // prevention of grey screen after CSV-TSV-HTTP-TSV-CSV loading
      data1 = data1 + listFillingWith_1;    //plus (001)  N filled-up with "" columns and 1 column filled-up with "1" at the end
    } else if (wasTSVextDetected == true) {
      for (int i = 1; i < 129; i++) {data1 = data1 + emptyFillingList_0a;}    // was < 129
      data1 = data1 + listFillingWith_1;    //plus (128)  N filled-up with "" columns and 1 column filled-up with "1" at the end
    } else {  // excel CSV
      for (int i = 1; i < 129; i++) {data1 = data1 + emptyFillingList_0a;}    // was < 2
      data1 = data1 + listFillingWith_1;    //plus (001)  N filled-up with "" columns and 1 column filled-up with "1" at the end
    } // end if
///////////////////////////////////////////////////////////////////////////////////////////////////////    end TSV adding elements at the end   2 of 5
////////////////
    data1 = data1.transpose; // additional, 3rd
////////////////
    dataF = dataF.sublist(1);               //minus 1 column at the begin
    //
    // myDeveloper.log("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
    // myDeveloper.log(dataF.toString());
///////////////  ------------------ End Grey Screen Prevention when Opening the CSV file with unsufficient number of strings ---------///
// print(data1.transpose);print(data1.transpose.length);     // DEBUG PRINT HERE 3
// print(dataF);print(dataF.length);
// print(csvLst);
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
// for (var el in ntTblNtfrsList) {print(el.toString());}      // The BEST WAY TO PRINT ALL THE LIST !!!   //myDeveloper.log(el.toString());   // difference Print from Log is a Queue, Log will pass other messages between output    // (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!  ??????  It's very strange!
    crc32trackPerfInfo = Crc32.calculate(tempperformrsInfo).toString();
    clearOneFileSharedPrefByCondition(crc32trackPerfInfo); // call BEFORE settingState !! // CLEAR or NOT: individual shared pref. for one file !!!
    setState(() {
      dropdownValue = tuneMap[tempselectedtuningNum].toString();  // Type String for Drop Down Menu
      tempperformrsInfo = tempperformrsInfo;
      crc32trackPerfInfo = crc32trackPerfInfo;
      data1 = data1; dataF = dataF; csvLst = csvLst;                //  "List.From" removing null elements needed ???
    }); //end setState()
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
// for (var el in ntTblNtfrsList) {print(el.toString());}      // The BEST WAY TO PRINT ALL THE LIST !!!   //myDeveloper.log(el.toString());   // difference Print from Log is a Queue, Log will pass other messages between output    // (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!  ??????  It's very strange!
           if(fromTheBegin == true) {     //from the begin means: all reset to 1-st measure view and aplly tags defaults
             setState(() {
               ntTblNtfrsList = [...ntTblNotifier.value];
               isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
               mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
             });
             addNtTblNotifierStates();
           } else {}
    await getDataSharedPref();
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
// for (var el in ntTblNtfrsList) {print(el.toString());}      // The BEST WAY TO PRINT ALL THE LIST !!!   //myDeveloper.log(el.toString());   // difference Print from Log is a Queue, Log will pass other messages between output    // (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!  ??????  It's very strange!
//         if(    !Platform.isLinux    ) {playerInitWithEmptyNote();} else {}  // initialize player and wait 0.8 seconds
    loading__3264_or_64128();
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
// for (var el in ntTblNtfrsList) {print(el.toString());}      // The BEST WAY TO PRINT ALL THE LIST !!!   //myDeveloper.log(el.toString());   // difference Print from Log is a Queue, Log will pass other messages between output    // (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!  ??????  It's very strange!
    await setDataSharedPref();
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output! 
// for (var el in ntTblNtfrsList) {print(el.toString());}      // The BEST WAY TO PRINT ALL THE LIST !!!   //myDeveloper.log(el.toString());   // difference Print from Log is a Queue, Log will pass other messages between output    // (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!  ??????  It's very strange!
    if (isSwitchedMonitorFile==true) {
      addButtonsStates(0,false);          // only left and right key buttons setting to init state, notation table do not touch
    } else {
    initStateFunctions();                 // buttons and notifiers brought to the initial state!!!
    } // end if
    if(fromTheBegin == true) {
      decreaseMeasureByButton();  // fix: shift table 32 and 64 one column left
    } else {
    traversingForNavigate(csvLst, (ntTblNtfrsList[4]['tableChangeCount']!*2-1) + 0); //CALL
    } // end if from the begin
//
    await checkIfTCCareOutOfLimits(); // if previous session ends incorrectly
//
// print("==============================================================");  // debug print into log file or console, Log and Print is NOT the same! Log have a gaps in output!
// for (var el in ntTblNtfrsList) {      // The BEST WAY TO PRINT ALL THE LIST !!!
//   //myDeveloper.log(el.toString());   // difference Print from Log is a Queue, Log will pass other messages between output
//   print(el.toString());             // (Log) shows element [0] is equal to Null, but (Print) still prints the element !!!  ??????  It's very strange!
// }
//
    setState(() {
      isLoadingCSV = false; // completely loading process finished // regardless of the result, the main thing is that the process is completed
      fromTheBegin = false; // for Load CSV Button text ("start over (begin)" will change to "Load csv/tsv file, web")
    });
    await setDataSharedPref();
    fromTheBeginBySliderCoincidence();  // Suggestion to Start Over (begin) if slider values Match:
    await setDataSharedPref();  // needed!
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
////////////////////////////////////////////////////////////////// getDataSharedPref, get only One item no 14
//     stringValSharedPref = '';
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     stringValSharedPref = preferences.getString(crc32trackPerfInfo)!;
//     if (stringValSharedPref != '') {
//       try {
//         List<String> stLSP = stringValSharedPref.split("~");
//         isSwitched_32_64_128 = int.parse(stLSP[14]);
//         mode_3264_or_64128 = int.parse(stLSP[15]);
//         setState(() {});
//       } catch(e){}
//     } else {}
////////////////////////////////////////////////////////////////// end get only One item no 14
//
//
  } //end loadTagsFirst() Future
///////////////////////////////////////////////////~~~~~ End loadTagsFirst() Future ~~~~~/////////////////////////////////////////////////
//
  checkIfTCCareOutOfLimits() async {   // if previous session ends incorrectly or table change view ends incorrectly, grey screen prevention when file opening
    ntTblNtfrsList = [...ntTblNotifier.value];
    var tccLim = (maxNotEmptyPos / ntTblNtfrsList[21]['nTcolS']!).ceil();
    if(tccLim.isOdd) {tccLim = tccLim + 1;} else {}
    if( ((ntTblNtfrsList[4]['tableChangeCount']!*2)    > tccLim) ||
        (((ntTblNtfrsList[6]['tableChangeCount32']!*2)  > tccLim) && ntTblNtfrsList[15]['listener_32_64_128']!  == 32) ||
        (((ntTblNtfrsList[7]['tableChangeCount64']!*2)  > tccLim) && ntTblNtfrsList[15]['listener_32_64_128']!  == 64) ||
        (((ntTblNtfrsList[8]['tableChangeCount128']!*2) > tccLim) && ntTblNtfrsList[15]['listener_32_64_128']!  == 128)
    ) {
      setState(() {
        ntTblNtfrsList = [...ntTblNotifier.value];
        isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
        mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
      });
      addNtTblNotifierStates(); // needed!
      await setDataSharedPref();
      var requiredMeasToStop = tccLim - 1;  // allways is Odd
      traversingForNavigate(csvLst, requiredMeasToStop); //CALL
      await setDataSharedPref();
      showArrowMoveToTheLeft=false; setState(() {});
    } else {}
  } // end checkIfTCCareOutOfLimits()
//
  // creating exemplar of sharedPreferences:
  //    getDataSharedPref() async {
  //    SharedPreferences preferences = await SharedPreferences.getInstance();
  //    }
//
  Future<void> setAppSettingsSharedPref() async{      // Not used
    String stringValSettingsSharedPref = '';
    SharedPreferences preferencesAppSettings = await SharedPreferences.getInstance();
    //**********************************************************************//
    String colorScheme = themeappLightDark.toString(); // light, dark
    String appParameter_01 = '---'; //
    //**********************************************************************//
    stringValSettingsSharedPref = '${colorScheme.toString()}~${appParameter_01.toString()}';
    preferencesAppSettings.setString('appSettingsKeys', stringValSettingsSharedPref);
  } // end Future setAppSharedPref()
  //
  Future<void> getAppSettingsSharedPref() async{
    String stringValSettingsSharedPref = '';
    SharedPreferences preferencesAppSettings = await SharedPreferences.getInstance();
//await preferences.clear();                                           				// CLEAR (APP SETTINGS) SHARED PREFERENCES ALL !!!
    stringValSettingsSharedPref = preferencesAppSettings.getString('appSettingsKeys')!;
    if (stringValSettingsSharedPref != '') {
      try {
        List<String> stLSSP = stringValSettingsSharedPref.split("~");
        //**********************************************************************//
        themeappLightDark = int.parse(stLSSP[0]);
      //appParameter_01  = int.parse(stLSSP[1]);
        setState(() {});
        //**********************************************************************//
      } catch(e){
        //
      }
    } else {}
    // print(themeappLightDark);
    if(themeappLightDark != 1) {
      fillDefaultColorsList(); int i=0; for (Color colorEl in keysColorsList) {keysColorsList[i] =  invertCustom(colorEl); i++;}
    } else {
      fillDefaultColorsList();
    };
  } //end Future getAppSettingsSharedPref()
  //
  Future<void> setDataSharedPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //**********************************************************************//  "Assembler-style" variables names:
    ntTblNtfrsList = [...ntTblNotifier.value];
    var TCC128 = ntTblNtfrsList[8]['tableChangeCount128']!;
    var TCC064 = ntTblNtfrsList[7]['tableChangeCount64']!;
    var TCC032 = ntTblNtfrsList[6]['tableChangeCount32']!;
    var PBIT   = ntTblNtfrsList[3]['playingBit']!;
    var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
    var SBIT   = ntTblNtfrsList[2]['startBit']!;
    var rSTART = ntTblNtfrsList[0]['rangeStart']!;
    var rEND = ntTblNtfrsList[1]['rangeEnd']!;
    var STB128 = ntTblNtfrsList[13]['rangeStart128bak']!;
    var ENB128 = ntTblNtfrsList[14]['rangeEnd128bak']!;
    var STB064 = ntTblNtfrsList[11]['rangeStart64bak']!;
    var ENB064 = ntTblNtfrsList[12]['rangeEnd64bak']!;
    var STB032 =  ntTblNtfrsList[9]['rangeStart32bak']!;
    var ENB032 = ntTblNtfrsList[10]['rangeEnd32bak']!;
    //**********************************************************************//
    stringValSharedPref = '${TCC128.toString()}~${TCC064.toString()}~${TCC032
        .toString()}~${PBIT.toString()}~${TCC.toString()}~${SBIT.toString()}~${rSTART
        .toString()}~${rEND.toString()}~${STB128.toString()}~${ENB128
        .toString()}~${STB064.toString()}~${ENB064.toString()}~${STB032
        .toString()}~${ENB032.toString()}~${ntTblNtfrsList[15]['listener_32_64_128']!.toString()}~${ntTblNtfrsList[16]['listener_3264_64128']!.toString()}';
    if (crc32trackPerfInfo!='') {preferences.setString(crc32trackPerfInfo, stringValSharedPref);} else {}
  //
  } // end Future setDataSharedPref()
//
  Future<void> clearOneFileSharedPrefByCondition(String crc32TPI) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();  //  preferences.clear(); // if Uncommented:  CLEARING ALL SHARED PREFERENCES !!!
    if(clearRangeSharePrefA == true) {
      await preferences.remove(crc32TPI);                                                            // remove Range Shared Preferences for ONE now Opening File
      clearRangeSharePref = false; clearRangeSharePrefA = false;
      ntTblNtfrsList = [...ntTblNotifier.value];
      isSwitched_32_64_128 = 64;  // resetting to default view and mode
      mode_3264_or_64128 = 3264;
      addNtTblNotifierStates();
      loading__3264_or_64128(); // CALL
      if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == false) {LoadCSVBtnTx='Changes monitor';MonitorFile();} else if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == true) {LoadCSVBtnTx='Online spreadsheet monitor';MonitorFile();} else {LoadCSVBtnTx='Load csv/tsv file, web';}
      ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[21]['nTcolS']!*4;  // resetting Range Slider
      setState(() {});} else {}
      await setDataSharedPref();
  }
  Future<void> getDataSharedPref() async{
    stringValSharedPref = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
//await preferences.clear();                                                                                                   // CLEAR SHARED PREFERENCES ALL !!!
    stringValSharedPref = preferences?.getString(crc32trackPerfInfo) ?? ''; // Provide a default value if string was null
    if (stringValSharedPref != '') {
      try {
        List<String> stLSP = stringValSharedPref.split("~");
        //**********************************************************************//
        ntTblNtfrsList[8]['tableChangeCount128'] = int.parse(stLSP[0]);
        ntTblNtfrsList[7]['tableChangeCount64']  = int.parse(stLSP[1]);
        ntTblNtfrsList[6]['tableChangeCount32']  = int.parse(stLSP[2]);
        ntTblNtfrsList[3]['playingBit']  = int.parse(stLSP[3]);
        ntTblNtfrsList[4]['tableChangeCount']  = int.parse(stLSP[4]);
        ntTblNtfrsList[2]['startBit']  = int.parse(stLSP[5]);
        ntTblNtfrsList[0]['rangeStart']  = int.parse(stLSP[6]);
        ntTblNtfrsList[1]['rangeEnd']  = int.parse(stLSP[7]);
        ntTblNtfrsList[13]['rangeStart128bak']  = int.parse(stLSP[8]);
        ntTblNtfrsList[14]['rangeEnd128bak']  = int.parse(stLSP[9]);
        ntTblNtfrsList[11]['rangeStart64bak']  = int.parse(stLSP[10]);
        ntTblNtfrsList[12]['rangeEnd64bak']  = int.parse(stLSP[11]);
        ntTblNtfrsList[9]['rangeStart32bak']  = int.parse(stLSP[12]);
        ntTblNtfrsList[10]['rangeEnd32bak']  = int.parse(stLSP[13]);
        ntTblNtfrsList[15]['listener_32_64_128'] = int.parse(stLSP[14]);
        ntTblNtfrsList[16]['listener_3264_64128'] = int.parse(stLSP[15]);
        ntTblNotifier.value = ntTblNtfrsList;
        setState(() {});
        //**********************************************************************//
      } catch(e){
        //
      }
    } else {}
    loading__3264_or_64128(); // CALL     // partly fix opening the right wiew        // fix works BECAUSE  ASYNC  ?!!!
    //
    //
  } //end Future getDataSharedPref()
//
//
  Future rootCsvListOfFiles() async {  // Not Used Yet      // parsing assets manifest file to create list of csv in assets folder
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final csvPaths = manifestMap.keys
        .where((String key) => key.contains('csv/'))
        .where((String key) => key.contains('.csv'))
        .toList();
    setState(() {
      csvListOfFiles = csvPaths; //csvListOfFiles is a List[]
    });
  } // end rootCsvListOfFiles()
//
//
  openInfoPage() async {
    showAlertDialog(BuildContext context) {   //pop-up alert message:            // set up the button:
        Widget okButton = TextButton(child: Text("OK"), onPressed: () {Navigator.of(context).pop();},);  // dismiss dialog
        // set up the AlertDialog:
        AlertDialog alert = AlertDialog(
          content: Container(
            child: SingleChildScrollView(
              child:
              // Text("https://github.com/iatndiag/jalinativeinstrument" +"\n"+"\n"+ "Notations 2024 by ear, user manual and full Source code" +"\n"+"\n"+ "Music notations contains in CSV/TSV files. You can create them using JNI Excel Macro (Windows Excel 2016 64-bit xlsm file, it contains in CSV folder in Assets of APK and in Windows release folder) or using Google Spreadsheets TSV format..." +"\n"+"\n"+ "In the Application screen four objects have not only shortly press function but a long press function too (table, performers name, info button and key-button)" +"\n"+"\n"+ "The simplest notation file in Excel is a blank sheet with cell A1, the basis of the text: 21~1~1~Template" +"\n"+"\n"+ "Cells A2:A23 should be filled with any data. Non-empty cells starting from column B sounds like notes. When Excel exporting to CSV, the delimiter is semicolon"
              // ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xd63f3a32),
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                      text: "Jalinativeinstrument"+ "\n",
                    ),
                    const TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xd63f3a32),
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                      text: "Android, Windows, Linux, MacOS (press the orange link)"+ "\n"+"\n",
                    ),
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xd6f9af1e),
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                      text: "Notations by ear",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = 'https://github.com/iatndiag/jalinativeinstrument/';
                          if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));   // see: app  src  main    androidManifest.xml   Windows OK, Android needs <intent> in manifest than OK
                          }
                        },
                    ),
                    const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xd63f3a32),
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                      text: ", user manual, releases and other info" +"\n"+"\n"+ "Music notations contains in CSV/TSV files. You can create them using JNI Excel Macro (Windows Excel 2016 64-bit xlsm file, it contains in CSV folder in Assets of every release folder) or using Google Spreadsheets TSV format or Online HTTP mode (without using GoogleAppScript only 96 columns will be loaded). Also JNI xlsm Editor can produce average quality Midi" +"\n"+"\n"+ "Control objects have not only the shortly press function. Summary LONG PRESS or MOUSE HOLD functions:"+ "\n"+"1) Table in mode ○◍○ switches 16/32 to 32/64"+ "\n"+"2) Performers Name (hide/show controls),"+ "\n"+"3) info-Button (launch Excel via CMD Win)"+ "\n"+"4) Key-Button (Android Сhromatic Tuner via microphone, shows Hz)"+ "\n"+"5) Load csv/tsv (Open Google Spreadsheet in Online mode via http)" +"\n" + "6) Any button at the Left (Light Theme/ Dark Theme)" +"\n"+"\n"+ "SHORTLY press functions on:" + "\n"+"1) Table (change view)" + "\n"+"2) Performer or TrackName (show Decrease/Increase NAVIGATION Buttons)" + "\n"+"3) MachineHead (F G A B C/ [Hz] precisely/ [Hz] roughly/ string gauge/ fingering)" +"\n"+"\n"+ "The simplest notation file in Excel is a blank sheet with cell A1, the basis of the text ( 21~1~1~Template ) including Mode and global Tempo coeff." +"\n"+"\n"+ "Cells A2:A23 should be filled with any data. Non-empty cells starting from column B sounds like notes. Note can contain max 3 UTF-8 symbols at any order, example ( iE* ), including special: index ( i ), thumb ( t ), short note ( * ).  Accepted dilimiters are: comma ( , ), semicolon ( ; ) or tab (   ). Do not use them and a Space symbol in worksheet."+ "\n"+"\n" + "To Repair Range (if the file opens with a gray screen): Move both handles of the Range Slider all the way to the Right" + "\n"+"\n" + "To Repair Range of the HTTP Notation: turn Off Monitor, long press on Load button, click on Repair Range" + "\n"+"\n" + "Known issues: 1) at extremely high playback speeds, the cursor may run away after a long press on the table and immediately a short press (switching the 64/32 view), 2) errors are possible when opening the table via HTTP" + "\n"+"\n",
                    ),
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xd6f9af1e),
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                      text: "https://github.com/iatndiag/jalinativeinstrument",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = 'https://github.com/iatndiag/jalinativeinstrument/';
                          if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));   // see: app  src  main    androidManifest.xml   Windows OK, Android needs <intent> in manifest than OK
                          }
                        },
                    ),
                  ],
                ),
            ),
          ),
        //   title: Text("Jalinativeinstrument for African Harp Kora notation: brief information"),content: Text("Music notations contains in CSV/TSV files. You can create them using JNI Excel Macro (Windows Excel 2016 64-bit xlsm file, it contains in CSV folder in Assets of APK and in Windows release folder) or using Google Spreadsheets TSV format..." +"\n"+"\n"+ "In the Application screen three objects have not only shortly press function but a long press function too (table, performers name and key-button)" +"\n"+"\n"+ "The simplest notation file in Excel is a blank sheet with cell A1, the basis of the text: 21~1~1~Template" +"\n"+"\n"+ "Cells A2:A23 should be filled with any data. Non-empty cells starting from column B sound like notes. When Excel exporting to CSV, the delimiter is semicolon"
        // ),
          ),
          actions: [okButton,]
        );
        // show the dialog:
        showDialog(context: context,builder: (BuildContext context) {return alert;},);
      }
    showAlertDialog(context);
  } //end openInfoPage()
//
  tryToRunXlsmEditorWin() { //     Comment it for Android   Win32  2 of 2
if (Platform.isWindows) {
          try {
            final verb = 'open'.toNativeUtf16();
            final process = 'editor_launch.bat'.toNativeUtf16();    // written directly in code, better from bat, because if you try to close parent window form excel, then excel chashes !!!
            final params = ''.toNativeUtf16();
            final nullParams = ''.toNativeUtf16();
            ShellExecute(0, verb, process, params, nullParams, SW_SHOW);
            return true;
          }catch(_){
            return false;
          }
} else {}
  } //end tryToRunXlsmEditorWin()
//
// Tuning (musical Scale/Mode) variant selection (one of 9): // Open visualMarks in Visual Studio CODE editor or other with syntax highlighting
//shortOrLong variant of the playing note selection, (most commonly used ~90% long notes and only ~10% of the short):
//int shortOrLong = 1;//Long WAV (by default) //int shortOrLong = 2;//Short WAV           //You can made notes shorter by using Audacity and it's tempo correction without pitch change
////////////////////////////////////////////////////////////////////////
  int stringsNum = 21; int selectedtuningNum = 4; int shortOrLongNum = 1; // stringsNum = 21 or 22, shortOrLongNum = 1 or 2 (Long|Short)
////////////////////////////////////////////////////////////////////////
//tuning has been selected
//
//
  Future<void> playSound(int tuning, int number, int shortOrLong, double nVol, int ext) async {
    if (!audioEngine.isInitialized) {
      await audioEngine.init();
    }
    String xtsn_ = '';
    String aP_ = '';
    int tI_ = tuning - 1;
    int nI_ = number - 1;
    int sOl_ = shortOrLong - 1;
    switch (ext) {
      case 1: xtsn_ = 'wav'; aP_ = 'assets/wav/'; break;
      case 2: xtsn_ = 'm4a'; aP_ = 'assets/m4a/'; break;
      case 4: xtsn_ = 'mp3'; aP_ = 'assets/mp3/'; break;
      default: xtsn_ = 'wav'; aP_ = 'assets/wav/'; break;
    }
    if (tuning == 11) { tI_ = 3 - 1; aP_ = 'assets/wavn/'; }
    if (tuning == 12) { tI_ = 4 - 1; aP_ = 'assets/wavn/'; }
    if (tuning == 14) { tI_ = 10 - 1; aP_ = 'assets/wav/'; }
    if (tuning == 15) { tI_ = 11 - 1; aP_ = 'assets/wav/'; }
    String fileName = krSnd[tI_][nI_][sOl_].toString();
    String fullPath = '$aP_$fileName.$xtsn_';
    try {
      AudioSource? source;
      if (soundCache.containsKey(fullPath)) {
        source = soundCache[fullPath];
      } else {
        source = await audioEngine.loadAsset(fullPath);
        soundCache[fullPath] = source;
      }
      if (source != null) {
        await audioEngine.play(source, volume: nVol);
      }
    } catch (e) {
      print(e);
    }
  }// end PlaySound ()
//
//
  void harmonicFunctions (int soundNum) {                         // optional Harmonic Functions to visual Display Consonance and Dissonance
    int gcd(int a, int b) {return a.gcd(b);}                // Greatest Common Divisor (gcd)
    int getLCM(int a, int b) {return (a * b) ~/ gcd(a, b);} // Least Common Multiple (LCM)
    double logBase(num x, num base) => log(x) / log(base);
    double log2(num x) => logBase(x, 2);
    dynamic keyTuning = visualMarks (selectedtuningNum);          // https://arxiv.org/ftp/arxiv/papers/1603/1603.08904.pdf
    int intFreq = (double.parse(keyTuning[soundNum].values.elementAt(3))).ceil();
    int compareIntFreq; int j;
    String keyNote_; String logResult;    // Still Type String, change type to double !
    int CY; // Complexity of Chord (parameter we are interested in)
    List<double> LCY = [];  // Log(2)Complexity, logarithm
    for(int i = 0; i < stringsNum; i++) {
      compareIntFreq = (double.parse(keyTuning[i+1].values.elementAt(3))).ceil();
      CY = getLCM(intFreq, compareIntFreq)~/gcd(intFreq, compareIntFreq);
      LCY.add(log2(CY)); j = i + 1;
      //print('LCM$j:'); print(getLCM(intFreq, compareIntFreq));
      //print('gcd$j:'); print(gcd(intFreq, compareIntFreq).toStringAsFixed(2));
      keyNote_ = keyTuning[i+1].values.elementAt(1).toString(); logResult = (LCY[i]).toStringAsFixed(1);
//print(keyNote_+ ' ' +logResult);
    } //end for()
//print('');
  } // end harmonicFunctions()
//
/////////////////////////// Value Notifiers (instead of setState()'s) /////////////////////////////
//
  static final ValueNotifier<bool> cnslDelay1Ntfr = ValueNotifier<bool>(false);   // Not used yet,  CancelDelay Notifier // "false" is it's default value, BOOL notifier
//
  static final ValueNotifier<List<Map<String, int>>> ntTblNotifier = ValueNotifier([]);     // "empty List[]" is the default notifier's Value, INT notifier
//
  static final ValueNotifier<List<Map<String, String>>> strTxtNotifier = ValueNotifier([]); // "empty List[]" is the default notifier's Value, STRING notifier
//
  switchRangeEndDependsColsNumb() {
    if(isSwitched_32_64_128==32) {nTcolS=nTTcolSHalf;} else if(isSwitched_32_64_128==64) {nTcolS=nTTcolSN;}  else if(isSwitched_32_64_128==128) {nTcolS=nTTcolSDouble;} //end if
    rngEnd=4*nTcolS;
    setState(() {});
  } //end switchRangeEndDependsColsNumb()
//                                        // FOR INFORMATION: ALSO LOOK FOR DART-PACKAGE " MULTI - VALUE LISTENABLE BUILDER"
  void addNtTblNotifierStates() {         // DO NOT USE SETSTATE() AT ALL WHILE PLAYBACK, USE VALUE NOTIFIER. IT GIVES VERY SMOOTH BEAT DURATION. IT'S VERY USEFUL !!!
    switchRangeEndDependsColsNumb();
    ntTblNtfrsList.clear();                           // ntTblNtfrsList is a Global
    ntTblNtfrsList = [...ntTblNotifier.value];        // ADDING LISTENER before EVERY usage, otherwise the values IN WIDGET will not change!
    //////////////////////////////////////////////////// !!! To prevent "Null Check Operator on Null Value", numbers of Elements are very important !
    ntTblNtfrsList.add({'rangeStart' :        0});    //[0]: Range Slider Selection Range (Start 0,2,4...64 End)
    ntTblNtfrsList.add({'rangeEnd'   :   rngEnd});    //[1]: End of selection Range = 64
    ntTblNtfrsList.add({'startBit' :          0});    //[2]: From Where To Start a new View (first bit without shifting), (upper left) for current table view
    ntTblNtfrsList.add({'playingBit' :        0});    //[3]: Bit Under Cursor
    ntTblNtfrsList.add({'tableChangeCount' :  1});    //[4]: Counts every table view change, switch to 'Next View'
    ntTblNtfrsList.add({'msrTgl' :            0});    //[5]: Measure button Toggle instead of setState()
    ntTblNtfrsList.add({'tableChangeCount32' :1});    //[6]: Counts every table view change 32
    ntTblNtfrsList.add({'tableChangeCount64' :1});    //[7]: Counts every table view change 64
    ntTblNtfrsList.add({'tableChangeCount128':1});    //[8]: Counts every table view change 128
    ntTblNtfrsList.add({'rangeStart32bak':                 0});    //[9]: Saving RangeStart view 32
    switch (isSwitched_32_64_128) {
      case 128:
        ntTblNtfrsList.add({'rangeEnd32bak':  (rngEnd/4).round()});    //[10]:Saving RangeEnd   view 128
        ntTblNtfrsList.add({'rangeStart64bak':                 0});    //[11]:Saving RangeStart view 64
        ntTblNtfrsList.add({'rangeEnd64bak':  (rngEnd/2).round()});    //[12]:Saving RangeEnd   view 64
        ntTblNtfrsList.add({'rangeStart128bak':                0});    //[13]:Saving RangeStart view 128
        ntTblNtfrsList.add({'rangeEnd128bak':             rngEnd});    //[14]:Saving RangeEnd   view 128
        break;
      case  64:
        ntTblNtfrsList.add({'rangeEnd32bak':  (rngEnd/2).round()});    //[10]:Saving RangeEnd   view 32
        ntTblNtfrsList.add({'rangeStart64bak':                 0});    //[11]:Saving RangeStart view 64
        ntTblNtfrsList.add({'rangeEnd64bak':              rngEnd});    //[12]:Saving RangeEnd   view 64
        ntTblNtfrsList.add({'rangeStart128bak':                0});    //[13]:Saving RangeStart view 128
        ntTblNtfrsList.add({'rangeEnd128bak':           2*rngEnd});    //[14]:Saving RangeEnd   view 128
        break;
      case  32:
        ntTblNtfrsList.add({'rangeEnd32bak':    (rngEnd).round()});    //[10]:Saving RangeEnd   view 128
        ntTblNtfrsList.add({'rangeStart64bak':                 0});    //[11]:Saving RangeStart view 64
        ntTblNtfrsList.add({'rangeEnd64bak':            2*rngEnd});    //[12]:Saving RangeEnd   view 64
        ntTblNtfrsList.add({'rangeStart128bak':                0});    //[13]:Saving RangeStart view 128
        ntTblNtfrsList.add({'rangeEnd128bak':           4*rngEnd});    //[14]:Saving RangeEnd   view 128
        break;
    } // end switch
    ntTblNtfrsList.add({'listener_32_64_128' :   isSwitched_32_64_128});         //[15]:  // try to prevent randomly incorrect view change after tables both ontap
    ntTblNtfrsList.add({'listener_3264_64128' :    mode_3264_or_64128});         //[16]:  // try to prevent randomly incorrect view change after tables both ontap
    ntTblNtfrsList.add({'Reserved_17' :           0});         //[17]:  // try to prevent randomly incorrect view change after tables both ontap
    ntTblNtfrsList.add({'Reserved_18' :           0});         //[18]:  // try to prevent randomly incorrect view change after tables both ontap
    ntTblNtfrsList.add({'Reserved_19' :           0});         //[19]:  // try to prevent randomly incorrect view change after tables both ontap
    //
    ntTblNtfrsList.add({'rngEndSlider'   :   rngEnd});    //[20]: // Solution to TEMPO and BEAT DURATION!, but try to prevent randomly incorrect view change after tables both ontap: ntTblNtfrsList[20]['rngEndSlider']
    ntTblNtfrsList.add({'nTcolS'   :   nTcolS});          //[21]: // Solution to TEMPO and BEAT DURATION!, try to prevent randomly incorrect view change after tables both ontap: ntTblNtfrsList[21]['nTcolS']
    ntTblNtfrsList.add({'ntTableCaptionTxt_0_variant'   :   1});          //[22]  // Text of the first caption over the table '〇⬤〇'
    ntTblNtfrsList.add({'ntTableCaptionTxt_1_variant'   :   1});          //[23]  // (second caption over the table)
      ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1;              //  setting 22 element  to int 1    NULL CHECK ON NULL VALUE  resolve
      ntTblNtfrsList[23]['ntTableCaptionTxt_1_variant'] = 1;              //  setting 23 element  to int 1    '〇⬤〇'  64
    ntTblNtfrsList.add({'counterPlayerLinux'   :   0});                   //[24] index, counter, Player Number for Linux (to prevent multiple volume regulators)
      ntTblNtfrsList[24]['counterPlayerLinux'] = 0;                       //  setting 24 element  to int 0
    ntTblNtfrsList.add({'onTapCollisionPrevention_1'   :   0});           //[25]  // onTap collision prevention while playback: inside changetableview() 1 of 3
    ntTblNtfrsList.add({'onTapCollisionPrevention_2'   :   0});           //[26]  // onTap collision prevention while playback: inside tablesBothOnTap() 2 of 3
    ntTblNtfrsList.add({'onTapCollisionPrevention_3'   :   0});           //[27]  // onTap collision prevention while playback: inside tablesBothOnTap() 3 of 3
    ntTblNotifier.value = ntTblNtfrsList;                                 // without this assingment you will give red screen in widget
  //
    strTxtNotifierList.clear();               // strTxtNotifierList is a Global
    strTxtNotifierList = [...strTxtNotifier.value];
    strTxtNotifierList.add({'ntTableCaptionTxt' : ''});                   // strTxtNotifierList[0]['ntTableCaptionTxt']
    strTxtNotifier.value = strTxtNotifierList;                            // without this assingment you will give red screen in widget
  //
  } // END OF VERY USEFUL VALUE NOTIFIER AND BUILDER ELEMENTS FIRST ADDING
//
///////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//   Future<void> delTempDir() async {   // Not used Yet, maybe will be used to clear cache to reload externally changed file on android
//     Directory dirT = await getTemporaryDirectory();     // Not used at all, you can delete it
//     dirT.deleteSync(recursive: true);
//     dirT.create(); // This will create the temporary directory again. So temporary files will only be deleted
//   }
//
//
  Future<void> showNavButtonsForSomeSeconds() async { // navigate buttons under measure button (Left and Right to change Measure Number) are shown temporary
    showNavButtonsForThreeSeconds = true; isTempoSliderDisabled = true; setState(() {});
    restartableTimer1 = RestartableTimer(Duration(seconds: 5), () {showNavButtonsForThreeSeconds = false; isTempoSliderDisabled=false; setState(() {});});
    final tempTimer = Timer(Duration(milliseconds: 500), () {isTempoSliderDisabled = false; setState(() {});});
  } // end showNavButtonsForSomeSeconds() async
//
  Future<void> increaseMeasureByButton() async { //  Measure Up by User
    if(restartableTimer1!=null)restartableTimer1.reset(); // add more Time to show Nav Buttons, then hide them
    //showNavButtonsForSomeSeconds();
    ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[21]['nTcolS']!*4;  // resetting Range Slider
    ntTblNotifier.value = ntTblNtfrsList;
    int requiredMeasToStop;
    ntTblNtfrsList = [...ntTblNotifier.value];
    requiredMeasToStop = (ntTblNtfrsList[4]['tableChangeCount']!*2-1) + 0;
    if((ntTblNtfrsList[4]['tableChangeCount']!*2-1) < (maxNotEmptyPos / ntTblNtfrsList[21]['nTcolS']!).ceil() - 1) {requiredMeasToStop = (ntTblNtfrsList[4]['tableChangeCount']!*2-1) + 2;} else {}
    await traversingForNavigate(csvLst, requiredMeasToStop); //CALL
    setState(() {});
    setState(() {
      ntTblNtfrsList = [...ntTblNotifier.value];
      isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
      mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
    });
    await setDataSharedPref();
  } // end future increase measure
//
  Future<void> decreaseMeasureByButton() async { //  Measure Down by User
    if(restartableTimer1!=null)restartableTimer1.reset(); // add more Time to show Nav Buttons, then hide them
    //showNavButtonsForSomeSeconds();
    ntTblNtfrsList = [...ntTblNotifier.value];
    ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[21]['nTcolS']!*4;  // resetting Range Slider
    ntTblNotifier.value = ntTblNtfrsList;
    int requiredMeasToStop; requiredMeasToStop = (ntTblNtfrsList[4]['tableChangeCount']!*2-1) + 0;         // TABLE CHANGE COUNT CHECK IT !!!
    int requiredView;       requiredView = ntTblNtfrsList[15]['listener_32_64_128']!;
    toShowVLbls = false;                  // false  =  without showing big side labels
  //initStateFunctions(); //assertion error
    setState(() {
   // ntTblNtfrsList = [...ntTblNotifier.value];  // here: cause incorrect count, commented
      isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
      mode_3264_or_64128   = ntTblNtfrsList[16]['listener_3264_64128']!;
    });
    addNtTblNotifierStates();            // instead of initState()  because  assertion error, but won't to startPlay at 1st view         resetting all TCC's to "1"
    isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128'] = requiredView;
    ntTblNotifier.value = ntTblNtfrsList;
    if(requiredMeasToStop>=3) {
      requiredMeasToStop = requiredMeasToStop - 2;
    } else {}
    await traversingForNavigate(csvLst, requiredMeasToStop); //CALL
    showArrowMoveToTheLeft=false;        // hide Arrow "Move Left"
    setState(() {});
    switch (isSwitched_32_64_128) {
      case 32:  ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 0; break;   // '⬤〇〇'
      case 64:  ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1; break;   // '〇⬤〇'
      case 128: ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 2; break;   // '〇〇⬤'
      default:  ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1;          // '〇⬤〇'
      strTxtNotifier.value = strTxtNotifierList;
    } // end switch()
    await setDataSharedPref();
  } // end future decrease measure
//
// toDo: cancelable delay (cancel can be made if operation is too long): Not Used at all! // Not used Yet
  late CancelableOperation cnOP1;
//
  Future<dynamic> fromCancelable(Future<dynamic> future1) async {   // Not used Yet
    cnOP1?.cancel(); cnOP1 = CancelableOperation.fromFuture(future1, onCancel: () {print('Operation Cancelled');});return cnOP1.value;
  } // end fromCancelable()
//
//
// Do not use delay less than 0.001s or 1ms or 1000 us (microseconds)! Delay breakdown occurs!
  reCalculateMD () {  // minimum possible duration // const mS look in Build Options at the beginning:
    double mSiC = ((mS + mS*(1.0-crntSldrValT))/tempoCoeff); // int = round ((double + (1-double))/double)
    if (0.79 < crntSldrValT && crntSldrValT < 0.81) {mSiC = (mSiC*1.2);}   // imitation of Slider's log or exponential Slowdown
    else if (0.69 < crntSldrValT && crntSldrValT < 0.71) {mSiC = (mSiC*1.6);}   //because slider returns something like 0.7999999997
    else if (0.59 < crntSldrValT && crntSldrValT < 0.61) {mSiC = (mSiC*2.4);}
    else if (0.49 < crntSldrValT && crntSldrValT < 0.51) {mSiC = (mSiC*4.0);}
    else if (0.39 < crntSldrValT && crntSldrValT < 0.41) {mSiC = (mSiC*7.2);}    // Log or Exponent Slider Imitation
    else if (0.29 < crntSldrValT && crntSldrValT < 0.31) {mSiC = (mSiC*13.6);}   //because slider returns something like 0.3000000007
    else if (0.19 < crntSldrValT && crntSldrValT < 0.21) {mSiC = (mSiC*26.4);}
    else if (0.09 < crntSldrValT && crntSldrValT < 0.11) {mSiC = (mSiC*52.0);} else {}  //70mS*52=3.64 Sec
    num mSiCn = num.parse((mSiC/5).toStringAsFixed(3));   // round to 3 digits
    int mSiC5 = (mSiCn * 1000).round(); Duration mD1 = Duration(microseconds: mSiC5);  // print(mSiC);  print(mD1);
    return mD1;
  } // end reCalculateMD()
  reCalculateMD2 () {  // minimum possible duration // const mS look in Build Options at the beginning:
    double mSiC = ((mS + mS*(1.0-crntSldrValT))/tempoCoeff); // int = round ((double + (1-double))/double)
    if (0.79 < crntSldrValT && crntSldrValT < 0.81) {mSiC = (mSiC*1.2);}   // imitation of Slider's log or exponential Slowdown
    else if (0.69 < crntSldrValT && crntSldrValT < 0.71) {mSiC = (mSiC*1.6);}   //because slider returns something like 0.7999999997
    else if (0.59 < crntSldrValT && crntSldrValT < 0.61) {mSiC = (mSiC*2.4);}
    else if (0.49 < crntSldrValT && crntSldrValT < 0.51) {mSiC = (mSiC*4.0);}
    else if (0.39 < crntSldrValT && crntSldrValT < 0.41) {mSiC = (mSiC*7.2);}    // Log or Exponent Slider Imitation
    else if (0.29 < crntSldrValT && crntSldrValT < 0.31) {mSiC = (mSiC*13.6);}   //because slider returns something like 0.3000000007
    else if (0.19 < crntSldrValT && crntSldrValT < 0.21) {mSiC = (mSiC*26.4);}
    else if (0.09 < crntSldrValT && crntSldrValT < 0.11) {mSiC = (mSiC*52.0);} else {}  //70mS*52=3.64 Sec
    int mSiCi = (mSiC).round(); Duration mD = Duration(milliseconds: mSiCi);  // print(mSiCi);  print(mD);
    return mD;
  } // end reCalculateMD2()
  changeTableView(i,iStarts,dontChangeView) {  //changes view Only in UP direction, by "i"
    ntTblNtfrsList[25]['onTapCollisionPrevention_1'] = 1; ntTblNotifier.value = ntTblNtfrsList;
    //**********************************************************************//  "Assembler-style" variables names:
    ntTblNtfrsList = [...ntTblNotifier.value];
    var TCC128 = ntTblNtfrsList[8]['tableChangeCount128']!;
    var TCC064 = ntTblNtfrsList[7]['tableChangeCount64']!;
    var TCC032 = ntTblNtfrsList[6]['tableChangeCount32']!;
    var PBIT   = ntTblNtfrsList[3]['playingBit']!;
    var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
    var SBIT   = ntTblNtfrsList[2]['startBit']!;
    var OisLEFT =  ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2);  // Range slider left Handle at the Left position
    var OisRIGHT = ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4);    // Range slider right Handle at the Right position
    var rSTART = ntTblNtfrsList[0]['rangeStart']!;
    var rEND = ntTblNtfrsList[1]['rangeEnd']!;
    var STB128 = ntTblNtfrsList[13]['rangeStart128bak']!;
    var ENB128 = ntTblNtfrsList[14]['rangeEnd128bak']!;
    var STB064 = ntTblNtfrsList[11]['rangeStart64bak']!;
    var ENB064 = ntTblNtfrsList[12]['rangeEnd64bak']!;
    var STB032 =  ntTblNtfrsList[9]['rangeStart32bak']!;
    var ENB032 = ntTblNtfrsList[10]['rangeEnd32bak']!;
    var ALLCOL = ntTblNtfrsList[21]['nTcolS']!*2;
    var STARTr = rSTART?.round();
    //**********************************************************************//
    //
    if(ntTblNtfrsList[15]['listener_32_64_128']! ==128) {
      TCC=TCC128;
      if ((i - 1).remainder(ALLCOL) == 0 && i != 1 && TCC == 1 && STARTr != ALLCOL) {                                                			 // if (i - 1) !!!
        TCC032 = TCC032 + 4;
        TCC064 = TCC064 + 2;
        TCC128 = TCC128 + 1;
        TCC = TCC128;
        iStarts = ((rSTART)/2).round() + 1 + (TCC - 1) * (ALLCOL);
        SBIT = ((rSTART)/2).round() + ALLCOL + 0;
        PBIT = iStarts;
      } else if((i).remainder(ALLCOL) == 0 && TCC == 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i)
        TCC032 = TCC032 + 4;
        TCC064 = TCC064 + 2;
        TCC128 = TCC128 + 1;
        TCC = TCC128;
        iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ALLCOL);
        SBIT = iStarts + 0;
        PBIT = iStarts + 0;
      } else if((i).remainder(ALLCOL) == 0 && TCC > 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i)
        TCC032 = TCC032 + 4;
        TCC064 = TCC064 + 2;
        TCC128 = TCC128 + 1;
        TCC = TCC128;
        iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ALLCOL);
        SBIT = iStarts + 0;
        PBIT = iStarts + 0;
      } else {} //end if //
    } else if(ntTblNtfrsList[15]['listener_32_64_128']! ==64) {
      TCC=TCC064;
      if ((i - 1).remainder(ALLCOL) == 0 && i != 1 && TCC == 1 && STARTr != ALLCOL) {          						                                 // if (i - 1)  !!!
        if ((TCC032).remainder(2) != 0) {TCC032 = TCC032 + 2;} else {TCC032 = TCC032 + 1;}
        TCC064 = TCC064 + 1;
        TCC = TCC064;
        if ((TCC032).remainder(2) != 0 && TCC064.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
        iStarts = ((rSTART) / 2).round() + 1 + (TCC - 1) * (ALLCOL);
        SBIT = ((rSTART) / 2).round() + ALLCOL + 0;
        PBIT = iStarts;
      } else if ((i).remainder(ALLCOL) == 0 && TCC == 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
        if ((TCC032).remainder(2) != 0) {TCC032 = TCC032 + 2;} else {TCC032 = TCC032 + 1;}
        TCC064 = TCC064 + 1;
        TCC = TCC064;
        if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
        iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
        SBIT = iStarts + 0;
        PBIT = iStarts + 0;
      } else if ((i).remainder(ALLCOL) == 0 && TCC > 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
        if ((TCC032).remainder(2) != 0) {TCC032 = TCC032 + 2;} else {TCC032 = TCC032 + 1;}
        TCC064 = TCC064 + 1;
        TCC = TCC064;
        if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
        iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
        SBIT = iStarts + 0;
        PBIT = iStarts + 0;
      } else {} //end if //
    } else if (ntTblNtfrsList[15]['listener_32_64_128']!  == 32) {
      TCC=TCC032;
      if ((i - 1).remainder(ALLCOL) == 0 && i != 1 && TCC == 1 && STARTr != ALLCOL) {         					                                 	  // if (i - 1)  !!!
        TCC032 = TCC032 + 1;
        TCC = TCC032;
        if (TCC032.remainder(2) != 0 && TCC032 != 1) {TCC064 = TCC064 + 1;} else {}
        if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0 && TCC128.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
        iStarts = ((rSTART) / 2).round() + 1 + (TCC - 1) * (ALLCOL);
        SBIT = ((rSTART) / 2).round() + ALLCOL + 0;
        PBIT = iStarts;
      } else if ((i).remainder(ALLCOL) == 0 && TCC == 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
        TCC032 = TCC032 + 1;
        TCC = TCC032;
        if (TCC032.remainder(2) != 0 && TCC032 != 1) {TCC064 = TCC064 + 1;} else {}
        if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0 && TCC128.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
        iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
        SBIT = iStarts + 0;
        PBIT = iStarts + 0;
      } else if ((i).remainder(ALLCOL) == 0 && TCC > 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
        TCC032 = TCC032 + 1;
        TCC = TCC032;
        if (TCC032.remainder(2) != 0 && TCC032 != 1) {TCC064 = TCC064 + 1;} else {}
        if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0 && TCC128.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
        iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
        SBIT = iStarts + 0;
        PBIT = iStarts + 0;
      } else {} //end if //
    } else {} //end if (128 64 32)
//
//
//**********************************************************************//
    ntTblNtfrsList[8]['tableChangeCount128'] = TCC128;
    ntTblNtfrsList[7]['tableChangeCount64'] = TCC064;
    ntTblNtfrsList[6]['tableChangeCount32'] = TCC032;
    ntTblNtfrsList[3]['playingBit'] = PBIT;
    ntTblNtfrsList[2]['startBit'] = SBIT;
    ntTblNtfrsList[4]['tableChangeCount'] = TCC;
    ntTblNtfrsList[0]['rangeStart'] = rSTART;
    ntTblNtfrsList[1]['rangeEnd'] = rEND;
    ntTblNtfrsList[13]['rangeStart128bak'] = STB128;
    ntTblNtfrsList[14]['rangeEnd128bak'] = ENB128;
    ntTblNtfrsList[11]['rangeStart64bak'] = STB064;
    ntTblNtfrsList[12]['rangeEnd64bak'] = ENB064;
    ntTblNtfrsList[9]['rangeStart32bak'] = STB032;
    ntTblNtfrsList[10]['rangeEnd32bak'] = ENB032;
    ////////////////////////////
    ntTblNotifier.value = ntTblNtfrsList;     // without setState()
    ////////////////////////////
//**********************************************************************//
//
    ntTblNtfrsList[25]['onTapCollisionPrevention_1'] = 0; ntTblNotifier.value = ntTblNtfrsList;
  } // end changeTableView()
//
//
//
///////     NEW SOLUTION: USING TIMER IN THE SECOND "ISOLATE" 3 OF 3          (FOR SENDING DATA INTO THE MAIN ISOLATE WITH THE GUI)
  void _setupPlayerIsolate(int iStarts, int iEnds, List jBtnRelease, List csvLst, int notesByBit, bool rngExtend) async {
/////// SEND INITIAL DATA, add New Data Here:
    List<List<dynamic>> allData = [[ntTblNtfrsList], [iStarts], [iEnds], jBtnRelease, csvLst, [notesByBit], [rngExtend], [toggleIcnMsrBtn],
      [fromTheBegin], [shortOrLongNum], [selectedtuningNum], [noteVolume], [extension], [cnslDelay1Ntfr.value], [buttonsNotifier.value]];
///////
// developer.log(allData.toString());
// List<List<dynamic>> allData = [[notesByBit], [rngExtend]];
    _receivePortFromPlayer = ReceivePort();
    _playerIsolate = await Isolate.spawn(playerIsolateEntryPoint, _receivePortFromPlayer!.sendPort);
    void _sendDataToPlayer(allData) {
      if (_sendPortToPlayer != null) {
        _sendPortToPlayer!.send(allData);
        // developer.log("test_1: Data sent to player isolate.");
      } else {
        // developer.log("Error: _sendPortToPlayer is null.");
      }
    }
    _receivePortFromPlayer!.listen((message) {
   // if (message is SendPort) {_sendPortToPlayer = message;_sendDataToPlayer(allData);developer.log("main_isolate: Port received. Ready to send data.");}
      if (message is SendPort) {_sendPortToPlayer = message;_sendDataToPlayer(allData);}
   //
      if (message is String) {
        final parts = message.split(':');
        final key = parts[0];
        final value = parts.length > 1 ? parts[1] : null;
        switch (key) {
          case 'oneTraversingInstanceLaunched': oneTraversingInstanceLaunched = (value == 'true'); break;
          case 'showArrowMoveToTheLeft': showArrowMoveToTheLeft = (value == 'true'); break;
          case 'showVerticalBigLables': showVerticalBigLables = (value == 'true'); break;
          case 'toggleIcnMsrBtn': toggleIcnMsrBtn = (value == 'true'); break;
          case 'fromTheBegin': fromTheBegin = (value == 'true'); break;
          case 'onTapCollisionPrevention_1': ntTblNtfrsList[25]['onTapCollisionPrevention_1'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'msrTgl': ntTblNtfrsList[5]['msrTgl'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'tableChangeCount128': ntTblNtfrsList[8]['tableChangeCount128'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'tableChangeCount64': ntTblNtfrsList[7]['tableChangeCount64'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'tableChangeCount32': ntTblNtfrsList[6]['tableChangeCount32'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'tableChangeCount': ntTblNtfrsList[4]['tableChangeCount'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'rangeStart': ntTblNtfrsList[0]['rangeStart'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'rangeEnd': ntTblNtfrsList[1]['rangeEnd'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'isSwitched_32_64_128': isSwitched_32_64_128 = int.tryParse(value ?? '32') ?? 32; break;
          case 'playingBit': playingBit = int.tryParse(value ?? '0') ?? 0; break;
          case 'startBit': ntTblNtfrsList[2]['startBit'] = int.tryParse(value ?? '0') ?? 0; break;
          case 'mode_3264_or_64128': mode_3264_or_64128 = int.tryParse(value ?? '0') ?? 0; break;
          case 'SETBUTTONSNOTIFIERREQUEST': buttonsNotifier.value = []; break;
          case 'GETNOTIFIERREQUEST': _sendDataToPlayer(allData); break;
          case 'SETNOTIFIERREQUEST': ntTblNotifier.value = ntTblNtfrsList; break;
          case 'setDataSharedPref': setDataSharedPref(); break;
          case 'checkIfTCCareOutOfLimits': checkIfTCCareOutOfLimits(); break;
          case 'SETSTATE': setState(() {}); break;
        } // end switch
      } // end if
      //
      // if (message is String && message == "SETSTATE")                     {setState(() {});}
      // if (message is String && message == "SETBUTTONSNOTIFIERREQUEST")    {setState(() {});}
      // if (message is String && message == "onTapCollisionPrevention_1:1") {setState(() {});}
      // if (message is String && message == "SETNOTIFIERREQUEST")           {setState(() {});}
      // if (message is String && message == "GETNOTIFIERREQUEST")           {setState(() {});}
      // if (message is String && message == "tableChangeCount128") {setState(() {});}
      // if (message is String && message == "tableChangeCount64") {setState(() {});}
      // if (message is String && message == "tableChangeCount32") {setState(() {});}
      // if (message is String && message == "playingBit") {setState(() {});}
      // if (message is String && message == "startBit") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // if (message is String && message == "SETSTATE") {setState(() {});}
      // SETSTATE
      // SETBUTTONSNOTIFIERREQUEST
      // onTapCollisionPrevention_1:1
      // SETNOTIFIERREQUEST
      // GETNOTIFIERREQUEST
      // tableChangeCount128:
      // tableChangeCount64:
      // tableChangeCount32:
      // playingBit:
      // startBit:
      // tableChangeCount:
      // rangeStart:
      // rangeEnd:
      // if (message is String && message == "oneTraversingInstanceLaunched") {oneTraversingInstanceLaunched = true; setState(() {});}
      // if (message is String && message == "showArrowMoveToTheLeft") {showArrowMoveToTheLeft = false;  setState(() {});}
      // if (message is String && message == "showVerticalBigLables")  {showVerticalBigLables = false; setState(() {});}
      // msrTgl:1
      // toggleIcnMsrBtn:false
      // fromTheBegin:false
      // isSwitched_32_64_128:
      // mode_3264_or_64128:
      // setDataSharedPref
      // checkIfTCCareOutOfLimits
      //
      if (message is int) {}
    });
  }
  void _stopPlayer() {
    _sendPortToPlayer?.send('STOP');
    _playerIsolate?.kill(priority: Isolate.immediate);
    _playerIsolate = null;
    _receivePortFromPlayer?.close();
  }
  void _play() {                        // Start playback
    if (_sendPortToPlayer != null) {
      _sendPortToPlayer!.send('START'); // Send the command to start
    }
  }
//
//
  Future listTraversal (int iStarts, int iEnds, List jBtnRelease, List csvLst, int notesByBit, bool rngExtend) async {
    _setupPlayerIsolate(iStarts, iEnds, jBtnRelease, csvLst, notesByBit, rngExtend);  // see SEND INITIAL DATA
  } //end listTraversal
//
//
/////// end NEW SOLUTION: USING TIMER IN THE SECOND "ISOLATE" 3 OF 3
//
//
                                    Future listTraversal_orig (int iStarts, int iEnds, List jBtnRelease, List csvLst, int notesByBit, bool rngExtend) async {
                                  //**********************************************************************//
                                      var PBIT   = ntTblNtfrsList[3]['playingBit']!;
                                      var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
                                      var OisLEFT =  ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2);  // Range slider left Handle at the Left position
                                      var OisRIGHT = ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4);    // Range slider right Handle at the Right position
                                      var rSTART = ntTblNtfrsList[0]['rangeStart']!;
                                      var rEND = ntTblNtfrsList[1]['rangeEnd']!;
                                  //**********************************************************************//
                                      oneTraversingInstanceLaunched = true; setState(() {}); // prevention of double- or multi- starts
                                      showArrowMoveToTheLeft=false;                     // hide Arrow "Move Left"
                                      showVerticalBigLables = false; setState(() {});   // hide
                                      bool showLocalFinger = false;
                                      int iEndsTmp;                                             // for dynamical shortening or extending range by slider
                                      bool shouldChangeView = true;                             // to not increase TCC when stopped by user
                                      if(TCC == 1) {iEndsTmp = ((rEND)/2).round() + 0;} else {iEndsTmp = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);}
                                  //////////////////////////// Playback speed Slowdown correction using Stopwatch (part 1 of 3): /////////////////
                                  // Android: first ~3 measures after first file load - playback accelerates, then slows down,
                                  // Windows: in background - playback accelerates (when result of widget rebuild is not visible)
                                  // Conclusion: needs speed correction, SLOWDOWN (!), so used stopwatch steps 1-3:
                                      Stopwatch stopwatch;  // measure execution duration in between lines of code 1 of 2
                                  // print('Elapse Start: ${stopwatch.elapsed}'); // works fine
                                  ////////////////////////////////////////////////// End Stopwatch 1 of 2 ////////////////////////////////////////
                                      bool dontChangeView = true;     // don't change Current Page View with Current Numbers of Measures
                                      ntTblNtfrsList = [...ntTblNotifier.value];
                                  ///////////////////////////////////     // toDo: issue: measure toggle
                                  // range Extends: if range was already set and now it extends by user using range slider
                                      if (rngExtend == true) {
                                        PBIT = iStarts;
                                        ntTblNtfrsList[5]['msrTgl'] = 1;
                                        ntTblNotifier.value = ntTblNtfrsList;
                                        ntTblNtfrsList[3]['playingBit'] = PBIT;
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                        setState(() {toggleIcnMsrBtn = false;});
                                      } else {}
                                  ///////////////////////////////////
                                      if (iEnds > csvLst.length) {iEnds = csvLst.length - 0;} else {} // end if toDo: (prevention of grey screen) when List Naturally Ended
                                  //print(iEnds);print(wasTSVextDetected);
                                  //--------------------------------------- Main Cycle Loops Begin ---------------------------------------//
                                      outerloop:                // NOT Used    try to break for-loop by label and keyword "break outerloop;"   No very good idea!
                                      for (int i = iStarts; i < iEnds; i++) { // traversing a list from start to finish //"mS" could be changed at any time by Slider
                                        //
                                        var sw = Stopwatch()..start();
                                        while((ntTblNtfrsList[25]['onTapCollisionPrevention_1'] == 1 || ntTblNtfrsList[26]['onTapCollisionPrevention_2'] == 1 || ntTblNtfrsList[27]['onTapCollisionPrevention_3'] == 1)  && sw.elapsedMilliseconds < 625)
                                        {
                                          // NO ENDLESS LOOP !!!  2 SECONDS
                                        }
                                        //
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                        TCC    = ntTblNtfrsList[4]['tableChangeCount']!;    // try to fix incorrect view change after bothTables onTap
                                        if(TCC == 1) {iEndsTmp = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0;} else {iEndsTmp = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);}  // use listenable value ntTblNtfrsList[1]['rangeEnd']!
                                        if((i==iEnds-1) && OisLEFT == 0 && OisRIGHT == 0 && rSTART==0 && TCC > 1) {showArrowMoveToTheLeft=true;setState(() {});} else {};      // show suggest to move to the left handle of the range slider to start from the beginning // fix rSTART==0  arrow Move Left appears at the middle Left Handle position
                                  ////////// Stopwatch (part 2 of 3)///////////
                                        stopwatch = Stopwatch()..start();
                                        stopwatch.reset();
                                        //print('Elapse Start: ${stopwatch.elapsed}');
                                  /////////// End Stopwatch (part 2 of 3)//////
                                  //
                                        /////////////// Animation of Cursor Move
                                        PBIT       = i;  // animation of cursor move
                                        ntTblNtfrsList[3]['playingBit'] = PBIT;
                                        ntTblNotifier.value = ntTblNtfrsList;        // instead of previous value attach
                                        /////////////// End Animation of Cursor Move
                                  //
                                  //
                                        // if range slider became All the way to the left and All the way to the right, then:
                                        if (OisLEFT == 0 && OisRIGHT == 0 && fromTheBegin == true) { // restore cursor position when range released by user
                                          setState(() {fromTheBegin = false;}); // will not start from the begin of the List   toDo: !!! setState Remove It !!!
                                        } else {} // end if
                                  //
                                  //////////////////////////////////////////////////////////////////// // range WAS all the way to the left and right (not set), and NOW it changed by user, then Stop:
                                        if((OisLEFT==0 && ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) != 0) || (OisRIGHT==0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) != 0)) {
                                          setState(() {toggleIcnMsrBtn = true;});
                                          ntTblNtfrsList = [...ntTblNotifier.value];
                                          ntTblNtfrsList[5]['msrTgl'] = 0;
                                          ntTblNotifier.value = ntTblNtfrsList;
                                          setState(() {
                                            ntTblNtfrsList = [...ntTblNotifier.value];
                                            isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
                                            mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
                                          });
                                        }
                                        else {}
                                  ////////////////////////////////////////////////////////////////////
                                  //
                                  //
                                  /////////////////////////////////////////////////////////////////////////////////////////
                                        if (toggleIcnMsrBtn) {  // if measure button pressed by user
                                          shouldChangeView = false;
                                          if (fromTheBegin) {
                                            i = iEnds - 1; // exit from cycle = release, stop
                                            //break outerloop;  // was: i = iEnds - 1;    // try to break outerloop by label
                                            ntTblNtfrsList[2]['startBit']         = 0;
                                            ntTblNtfrsList[3]['playingBit']       = 0;
                                            ntTblNtfrsList[4]['tableChangeCount'] = 1;
                                            ntTblNtfrsList[5]['msrTgl'] = 0;
                                            ntTblNtfrsList[6]['tableChangeCount32']  = 1;
                                            ntTblNtfrsList[7]['tableChangeCount64']  = 1;
                                            ntTblNtfrsList[8]['tableChangeCount128'] = 1;
                                            ntTblNotifier.value = ntTblNtfrsList;
                                            setState(() {toggleIcnMsrBtn = true;oneTraversingInstanceLaunched = false;});
                                          } else {
                                            i = iEnds - 1; // exit from cycle = release, stop
                                            //break outerloop;  // was: i = iEnds - 1;    // try to break outerloop by label
                                            //                                            // So that there is no empty space at the cursor position after stopping:
                                            ntTblNtfrsList[3]['playingBit']       = maxLength;
                                            ntTblNotifier.value = ntTblNtfrsList;
                                            //
                                            setState(() {toggleIcnMsrBtn = true;oneTraversingInstanceLaunched = false;});
                                          } // end if (start from the begin)
                                          setState(() {
                                            ntTblNtfrsList = [...ntTblNotifier.value];
                                            isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
                                            mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
                                          });
                                        } else {} // end exiting cycle (stop play), measure button pressed by user
                                  /////////////////////////////////////////////////////////////////////////////////////////
                                        ///////////////////////////////////////////////////////////////////////////////
                                        // if range dynamically changed by user (rangeEnd became less than playingBit):
                                        if ((iEndsTmp <= PBIT && (OisLEFT != 0 || OisRIGHT != 0))) {  // if range dynamically changed by user
                                          i = iEnds - 1; // exit from cycle = release, stop
                                          // break outerloop;  // was: i = iEnds - 1;    // try to break outerloop by label
                                          setState(() {i = iEnds - 1;});
                                        } else {} // end if
                                        //////////////////////////////////////////////////////////////////////////////
                                  //////////////////////////// Current Bit Traversal by "j", PlayingNotes ////////////////////////////////
                                        for (int j = 1; j <= notesByBit; j++) {     // (j) is number of playing string at the moment, and  shortOrLong - is variant of note's length // <=   <=   <=  less or equal
                                          if (csvLst[i][j] != "") {                 // for simple Lists Use "add" method!!          // shortOrLongNum = 1 or 2 (Long|Short)  // You not to have to escape "asterisk", or "\" an "raw"
                                            if (csvLst[i][j].toString().contains("*")) {shortOrLongNum = 2; jBtnRelease.add(j);} else {} // note with (*) is a Short Note, sounds faster //LONG NOTES NOT WORKED BY THE REASON OF LIST.FROM data1, inherit changed it's parent!!! You not to have to escape symbol '\' or use a raw string
                                            if(ntTblNtfrsList[5]['msrTgl'] == 0) {noteVolumeBack = noteVolume; noteVolume = 0.0;} else {}           // to (iEnds - 1) note will not hear    1 of 2
                                            playSound(selectedtuningNum, j, shortOrLongNum, noteVolume, extension);  // sounds from here !
                                            if(ntTblNtfrsList[5]['msrTgl'] == 0) {noteVolume = noteVolumeBack;} else {}   //restoring normal Vol    // to (iEnds - 1) note will not hear    2 of 2
                                            shortOrLongNum = 1; // resetting to Long ones !!!
                                            if((csvLst[i][j].toString().contains("i") && showFingeringOnButtons[j] == 0) || (csvLst[i][j].toString().contains("t") && showFingeringOnButtons[j] == 1)) {
                                              showLocalFinger=true;    // if notation contains "index finger" and by default rule this string played not by Index
                                            } else {
                                              showLocalFinger=false;   // if notation contains "thumb finger" and by default rule this string played not by Thumb
                                            } // end if, for show Locally Fingering   // As planned, local finger is shown ONLY if the default fingering rule is not followed
                                            addButtonsStates(j, showLocalFinger);        // pressing the button
                                          }  // will be hear async parallel simultaneously sounds notes by one bit and aftertones of previous bits notes
                                        } // ind for (j)
                                  //////////////////////////// End Current Bit Traversal by "j", PlayingNotes ////////////////////////////
                                        var sw1 = Stopwatch()..start();
                                        while((ntTblNtfrsList[25]['onTapCollisionPrevention_1'] == 1 || ntTblNtfrsList[26]['onTapCollisionPrevention_2'] == 1 || ntTblNtfrsList[27]['onTapCollisionPrevention_3'] == 1)  && sw1.elapsedMilliseconds < 625)
                                        {
                                          // NO ENDLESS LOOP !!!  2 SECONDS
                                        }
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                          if(ntTblNtfrsList[25]['onTapCollisionPrevention_1'] == 0 && ntTblNtfrsList[26]['onTapCollisionPrevention_2'] == 0 && ntTblNtfrsList[27]['onTapCollisionPrevention_3'] == 0) {
                                            if (shouldChangeView == true) {
                                              await changeTableView(i, iStarts, dontChangeView);  // await added!
                                            } else {} // instead of 256 "ntTblNtfrsList[21]['nTcolS']!" replace to  "ntTblNtfrsList[21]['ntTblNtfrsList[21]['nTcolS']!']" . It seems impossible!
                                          } else {} //  end onTap collision prevention
                                        //
                                        //
                                        if(OisLEFT == 0 && OisRIGHT == 0 && rSTART?.round() != 2*ntTblNtfrsList[21]['nTcolS']!) {
                                          iEnds = maxLength;
                                          // if TSV, prevention of iEnds range error at the end of playback (2 of 2):
                                          if(wasTSVextDetected==true || googleCSVdetected==true) { // ??? TSV needs minus one element at the end (this is the difference from CSV):
                                            iEnds = csvLst.length - 0;
                                          } else {
                                          } //end if TSV was detected
                                        } else {}; //end if
                                        if((i+1).remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0) {dontChangeView = false;} else {} //end if // don't change table view after manually toggle button play
                                        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                  ///////////////////////------End Change table View------////////////////////////
                                  //
                                  //////////////////////// imitation of cancelable Delay: ///////////////// Eeach time calling function, because "crntSldrValT" may changed any time by user
                                        if(tempoCoeff<=1.8) { // Do cancelable delay:
                                          // toDo: first pause of 3 (silence) before short-sounding notes buttons release:
                                          for (int u = 0; u < 3; u++) {await Future.delayed(reCalculateMD());if(cnslDelay1Ntfr.value==true){u=3; cnslDelay1Ntfr.value=false;}} // end for
                                          if (jBtnRelease.isNotEmpty) {                                                                 // toDo: setState() N2
                                            for (int k in jBtnRelease){   // for simple Lists Use simple construction "in"
                                              releaseButtonsStates(k);    // release shortly sounded notes buttons
                                            } // end for (k)
                                          } else {} // end if (jBtnRelease.length)
                                          jBtnRelease.clear();  // the best way to clear List
                                          // toDo: second pause of 3 (silence) before normal long-sounding notes buttons release:
                                          for (int u = 0; u < 7; u++) {await Future.delayed(reCalculateMD());if(cnslDelay1Ntfr.value==true){u=7; cnslDelay1Ntfr.value=false;}} // end for
                                          releaseButtonsStates(0);         // release All notes buttons                                // toDo: setState() N3
                                          // toDo: third pause of 3 (silence) before starting next bit:
                                          for (int u = 0; u < 5; u++) {await Future.delayed(reCalculateMD());if(cnslDelay1Ntfr.value==true){u=5; cnslDelay1Ntfr.value=false;}} // end for
                                        } else {      // too high table visualisation speed, NO cancelable delay:
                                          // toDo: first pause of 3 (silence) before short-sounding notes buttons release:
                                          await Future.delayed(reCalculateMD2());
                                          if (jBtnRelease.isNotEmpty) {                                                                 // toDo: setState() N2
                                            for (int k in jBtnRelease){   // for simple Lists Use simple construction "in"
                                              releaseButtonsStates(k);    // release shortly sounded notes buttons
                                            } // end for (k)
                                          } else {} // end if (jBtnRelease.length)
                                          jBtnRelease.clear();  // the best way to clear List
                                          // toDo: second pause of 3 (silence) before normal long-sounding notes buttons release:
                                          await Future.delayed(reCalculateMD2());
                                          releaseButtonsStates(0);         // release All notes buttons                                // toDo: setState() N3
                                          // toDo: third pause of 3 (silence) before starting next bit:
                                          await Future.delayed(reCalculateMD2());
                                        } //end if additional tempo coeff > 1
                                  ////////////////////// End imitation of cancelable Delay//////////////////                            // toDo: setState() N4
                                  //
                                  ////////////////////// Completion naturally //////////////////////
                                        if (i == iEnds - 1) {      // completion naturally upon reaching iEnds OR at the end of the List
                                          shouldChangeView = false;
                                          // print('ends naturally');
                                          ntTblNtfrsList = [...ntTblNotifier.value];
                                          if(fromTheBegin) {
                                            ntTblNtfrsList[2]['startBit']         = 0;
                                            ntTblNtfrsList[3]['playingBit']       = 0;
                                            ntTblNtfrsList[4]['tableChangeCount'] = 1;
                                            ntTblNtfrsList[5]['msrTgl'] = 0;
                                            ntTblNtfrsList[6]['tableChangeCount32']  = 1;
                                            ntTblNtfrsList[7]['tableChangeCount64']  = 1;
                                            ntTblNtfrsList[8]['tableChangeCount128'] = 1;
                                            setState(() {toggleIcnMsrBtn = true;oneTraversingInstanceLaunched = false;});
                                          } else {                          // completion naturally at the end of the selected Range
                                            ntTblNtfrsList[5]['msrTgl'] = 0;
                                            //                           // So that there is no empty space at the cursor position after stopping:
                                            ntTblNtfrsList[3]['playingBit']       = maxLength;
                                            ntTblNotifier.value = ntTblNtfrsList;
                                            //
                                            setState(() {toggleIcnMsrBtn = true;oneTraversingInstanceLaunched = false;});
                                          } //end if(start from the begin)
                                          ntTblNotifier.value = ntTblNtfrsList;
                                          setState(() {
                                            ntTblNtfrsList = [...ntTblNotifier.value];
                                            isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
                                            mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
                                          });
                                        } // end if(): setting Icon on Measure Button to "Play" (default)
                                  /////////////////// End Completion naturally /////////////////////
                                  //
                                  //
                                  //// Extra Delay (especially relevant: to Android - ONLY at App launch and first file load - it is accelerating, so, it needs to some slowDown):
                                  //// toDo: There was a very significant smoothness, it's very good:
                                        if(stopwatch.elapsedMilliseconds < 100) {   // < 100 mS clean code execution time
                                          for (int u = 0; u < 6; u++) {await Future.delayed(reCalculateMD());} // end for(u)
                                        } else {} //end if
                                  //
                                  //
                                  ///////////////////////////////////////////// End Stopwatch 3 of 3 ////////////////////////////////////////////////
                                        await setDataSharedPref();   // CALL
                                      } // end for (i)                                        // "oneTraversingInstanceLaunched" is a Double-start prevention
                                      await checkIfTCCareOutOfLimits();  // if previous session ends incorrectly or table change view ends incorrectly
                                      oneTraversingInstanceLaunched = false; setState(() {}); // after additional list traversal it could be "true", so setting it to "false" at the end
                                    } // end listTraversal()
//
  Future<void> playFromList (int istartsRestart) async {      // ASYNC because we use "await", resolves a problem with disappeared buttons with status 'pressed'
    int iStarts = 1;
    int iEnds = maxLength;
    ntTblNtfrsList = [...ntTblNotifier.value];
    ntTblNtfrsList[5]['msrTgl'] = 1;
    cnslDelay1Ntfr.value = false;
    noteVolume = 0.9;
        // if(    !Platform.isLinux    ) {playerInitWithEmptyNote();} else {}  // initialize player and wait 0.8 seconds  // initialize player and wait 0.8 seconds
    await Future.delayed(Duration(milliseconds: 800)); // give time to initialize the player. // Map: See also SplayTreeMap (Sorted! HashMap), "Splay"!
    if (playerMode==2) {audioPlayersMap = Map.fromEntries(audioPlayersMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));} else {} // sorting HashMap (optional part of Win Memory Leak Resolve)
    List jBtnRelease = [];                  // release the buttons of short-sounding notes a little earlier, List of numbers of short notes by one beat
 // List csvLst = List.from(dataF);  // needed! removing empty elements // again !!! creating csvLst, like in loadTagsFirst() func.    dataF  will be changed if csvLst canged!!! It is not a copy of the List!!!
    int notesByBit = 22;                                        // allways 22        if 21 string: 22         if 22 string: 22         For F2 Button To Work!
//    int notesByBit = stringsNum;
//
//**********************************************************************//
    var OisLEFT =  ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2);  // Range slider left Handle at the Left position
    var OisRIGHT = ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4);    // Range slider right Handle at the Right position
    var rSTART  = ntTblNtfrsList[0]['rangeStart']!;
    var rEND    = ntTblNtfrsList[1]['rangeEnd']!;
    var PBIT   = ntTblNtfrsList[3]['playingBit']!;
    var TCC     = ntTblNtfrsList[4]['tableChangeCount']!;
    var SBIT    = ntTblNtfrsList[2]['startBit']!;
//**********************************************************************//
/////////////////////////////////// iStarts, iEnds = depends on selected Range: //////////////////////////////////////////////////////////////////
    if (OisLEFT == 0 && OisRIGHT == 0 && rSTART?.round() != 2*ntTblNtfrsList[21]['nTcolS']!)  {
      iStarts = SBIT + 0;
      iEnds = maxLength;
      // if TSV, prevention of iEnds range error at the end of playback (2 of 2):
      if(wasTSVextDetected==true || googleCSVdetected==true) { // ??? TSV needs minus one element at the end (this is the difference from CSV):
        iEnds = csvLst.length - 0;
      } else {
      } //end if TSV was detected
      PBIT = iStarts;
    } else {  // Range is Not Default (Not All The Way To The Left And Rigth) and Not Equal 64:
      if(TCC == 1) { //first view (tableChangeCount=1)
        if(OisLEFT == 0) { // rangeStart is all the way to the left
          iStarts = ((rSTART)/2).round() + 0;
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0;
        } else { // left range is NOT all the way to the left
          iStarts = ((rSTART)/2).round() + 0;
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0;
        } //end if
        if(OisRIGHT == 0) {   //rangeEnd is all the way to the right
          iEnds = ((rEND)/2).round() + 0;
        } else {
        } //end if(range End is all the way to the right)
      } else if(TCC == 2) { //second and subsequent views (tableChangeCount==2)
        if(OisLEFT == 0) { // rangeStart is all the way to the left
          iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } else { // left range is NOT all the way to the left
          iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } //end if
        if(OisRIGHT == 0) { //rangeEnd is all the way to the right
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } else {
        } //end if(range End is all the way to the right)
      } else if(TCC == 3) { //second and subsequent views (tableChangeCount==3)
        if(OisLEFT == 0) { // rangeStart is all the way to the left
          iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } else { // left range is NOT all the way to the left
          iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } //end if
        if(OisRIGHT == 0) { //rangeEnd is all the way to the right
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } else {
        } //end if(range End is all the way to the right)
      } else if(TCC > 3) {
        if(OisLEFT == 0) { // rangeStart is all the way to the left
          iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } else { // left range is NOT all the way to the left
          iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
          PBIT = iStarts - 0;
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } //end if
        if(OisRIGHT == 0) { //rangeEnd is all the way to the right
          iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
        } else {
        } //end if(range End is all the way to the right)
      } else {} //end if(tableChangeCount)
    } // end if(range is all the way to the left and to the right)
    // Range Slider Left pos is 64:
    if(rSTART?.round() == 2*ntTblNtfrsList[21]['nTcolS']!) {iStarts = SBIT + ntTblNtfrsList[21]['nTcolS']! + 0;} else {}//end if Start: 64
    if(istartsRestart!=0) {iStarts = istartsRestart;} else {}
    PBIT = iStarts - 0;
//**********************************************************************//
    ntTblNtfrsList[3]['playingBit'] = PBIT;
    ntTblNotifier.value = ntTblNtfrsList;
//**********************************************************************//
/////////////////////////////////////////// End iStarts, iEnds - range definition///////////////////////////////////////////////////////////////
//
///////////////////////////////////////////
    if (oneTraversingInstanceLaunched==false) {     // Double or Multiply Starts prevention
      await listTraversal (iStarts, iEnds, jBtnRelease, csvLst, notesByBit, false); // await! List Traversal, Main Nested Loops
    } else {} //end if
/////////////////////////////////////////// additional second list traversal, range was extended while playing by user:
    int iEndsTmp1;                                             // for dynamical shortening or extending range by slider (for extending)
    if(TCC == 1) {iEndsTmp1 = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0;} else {iEndsTmp1 = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0 + (TCC - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);}
    if (iEndsTmp1 > iEnds) { // addtitional list traversal if the range is dynamically extended further by the user
      if (OisLEFT != 0 || OisRIGHT != 0) { // only if range was set
        iStarts = iEnds + 0; iEnds = iEndsTmp1; // use only listenable value !!! ntTblNtfrsList[1]['rangeEnd']!
/////////////////////////////////////////// see rngExtend=true:
        await listTraversal (iStarts, iEnds, jBtnRelease, csvLst, notesByBit, true); // additional second list traversal, after main traversal ends
///////////////////////////////////////////
      } else {} //end if
    } else {} //end if
    await setDataSharedPref(); // CALL
  } //end future playFromList() async
//
//
  Future traversingForNavigate(List csvLst1, int requiredMeasToStop) async{
//**********************************************************************//
    var PBIT   = ntTblNtfrsList[3]['playingBit']!;
//**********************************************************************//
    oneTraversingInstanceLaunched = true; setState(() {}); // prevention of double- or multi- starts
    bool dontChangeView = true;     // don't change Current Page View with Current Numbers of Measures
    ntTblNtfrsList = [...ntTblNotifier.value];
    int iStarts; iStarts = 0;
    int iEnds;   iEnds = csvLst1.length - 0;
    if(wasTSVextDetected==true || googleCSVdetected==true) {iEnds = csvLst1.length - 0;} else {} //end if TSV was detected  // ??? if TSV, prevention of iEnds range error at the end of playback (1 of 2) // TSV needs minus one element at the end (this is the difference from CSV)
//--------------------------------------- Main Cycle Loops Begin ---------------------------------------//
    for (int i = iStarts; i < iEnds; i++) { // traversing a list from start to finish
      ntTblNtfrsList = [...ntTblNotifier.value];
      /////////////// Animation of Cursor Move        // here it is imitation
      PBIT       = i;  // animation of cursor move
      ntTblNtfrsList[3]['playingBit'] = PBIT;
      ntTblNotifier.value = ntTblNtfrsList;
      /////////////// End Animation of Cursor Move
///////////////////////--------Change table View---------///////////////////////
      await changeTableView(i,iStarts,dontChangeView);           // without _at_the_moment
      if((i+1).remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0) {dontChangeView = false;} else {} //end if // don't change table view after manually toggle button play
///////////////////////------End Change table View------////////////////////////
//
////////////////////// Completion naturally //////////////////////
      if(ntTblNtfrsList[4]['tableChangeCount']!*2-1 == requiredMeasToStop) {i = iEnds - 1;} else {}
      if (i == iEnds - 1) {      // completion naturally upon reaching iEnds OR at the end of the List
        ntTblNtfrsList = [...ntTblNotifier.value];
        ntTblNtfrsList[5]['msrTgl'] = 0;
        ntTblNtfrsList[3]['playingBit']       = maxLength;
        ntTblNotifier.value = ntTblNtfrsList;
        setState(() {
          ntTblNtfrsList = [...ntTblNotifier.value];
          isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
          mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
        });
        setState(() {toggleIcnMsrBtn = true;oneTraversingInstanceLaunched = false;});
      } else {}
/////////////////// End Completion naturally /////////////////////
//
    } // end for (i)                                        // "oneTraversingInstanceLaunched" is a Double-start prevention
    oneTraversingInstanceLaunched = false; setState(() {}); // after additional list traversal it could be "true", so setting it to "false" at the end
  } // end traversingForNavigate()
//
  tablesBothOnTap  (bool isLongSwitching, bool isFromRangeSlider) async { // IF ASYNC FUNCTION NOT FINISHED AT THE MOMENT, IT WILL RETURN RANDOM VALUES !!! CHECK ALL AWAITS !!!
    ntTblNtfrsList = [...ntTblNotifier.value];    // The solution to resolve Incorrect table view change dynamically while playback is to Use this line
    var sw = Stopwatch()..start();
    while(ntTblNtfrsList[25]['onTapCollisionPrevention_1'] == 1 && sw.elapsedMilliseconds < 625)
    {
      // NO ENDLESS LOOP !!!  2 SECONDS
    }
    ntTblNtfrsList[26]['onTapCollisionPrevention_2'] = 1; ntTblNotifier.value = ntTblNtfrsList;
    ntTblNtfrsList = [...ntTblNotifier.value];         // The solution to resolve Incorrect table view change dynamically while playback is to Use this line
    strTxtNotifierList = [...strTxtNotifier.value];    // ADDING LISTENER, otherwise the values IN WIDGET will not change!
//**********************************************************************//
    // by Default:   nTTcolSHalf=8     nTTcolSN=16     nTTcolSDouble=32
//**********************************************************************//
//
    // print('${ntTblNtfrsList[7]['tableChangeCount64']!}   ${ntTblNtfrsList[8]['tableChangeCount128']!*2}');
    ////////////////  tapMadeOnUpperOrLowerTable - at the moment when cursor ON IT        64=>128       128=>64  128=>64       64=>32  64=>32        32=>64
    if(isLongSwitching ==false && ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 64128){
      tapMadeOnUpperOrLowerTable = '064=>128';
      ////////////////////////////////////////////////////// FIX 0: //////////////////////// ( > ) ////////////////////  fix 0 NOT works, fix 1 works fine, fix 2 works fine    at extreme high tempo
      // if(ntTblNtfrsList[7]['tableChangeCount64']! > ntTblNtfrsList[8]['tableChangeCount128']!*2
      //     && ntTblNtfrsList[8]['tableChangeCount128']! >1
      // ) {ntTblNtfrsList[8]['tableChangeCount128'] = ntTblNtfrsList[8]['tableChangeCount128']! + 1;
      // ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[6]['tableChangeCount32']! + 2;} else {}
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[8]['tableChangeCount128']!;
        ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
        ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
        ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[13]['rangeStart128bak']!;
        ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[14]['rangeEnd128bak']!;
        ntTblNtfrsList[21]['nTcolS'] = nTTcolSDouble;
        if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {
          ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']! * 2) + 0;
        } else {
          ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']! * 2) + 0;}
        ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 2; // '〇〇⬤'
        ntTblNtfrsList[15]['listener_32_64_128'] = 128;  // 32  64  128
        ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if(isLongSwitching ==true && ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 3264){
      tapMadeOnUpperOrLowerTable = '064=>128';
      // if()
      // {ntTblNtfrsList[8]['tableChangeCount128'] = }
      // else {ntTblNtfrsList[8]['tableChangeCount128'] = }
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[8]['tableChangeCount128']!;
      ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
      ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[13]['rangeStart128bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[14]['rangeEnd128bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSDouble;
      ntTblNtfrsList[16]['listener_3264_64128'] = 64128;
      ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 2; // '〇〇⬤'
      ntTblNtfrsList[15]['listener_32_64_128'] = 128;  // 32  64  128
      ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if(isLongSwitching ==false && ntTblNtfrsList[15]['listener_32_64_128']! ==128 && (((ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1) <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! <= (ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*2)) || ntTblNtfrsList[0]['rangeStart']! >= nTTcolSDouble)){
      tapMadeOnUpperOrLowerTable = '128LOW=>064';
      ////////////////////////////////////////////////////// FIX 1: //////////////////////// ( < ) ////////////////////
      if(!isFromRangeSlider) {
        if(ntTblNtfrsList[7]['tableChangeCount64']! < ntTblNtfrsList[8]['tableChangeCount128']!*2) {
          ntTblNtfrsList[7]['tableChangeCount64'] = ntTblNtfrsList[7]['tableChangeCount64']! + 1;
          ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[6]['tableChangeCount32']! + 2;} else {};
      } else {} // end isFromRangeSlider
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[7]['tableChangeCount64']!;
      ntTblNtfrsList[13]['rangeStart128bak'] = ntTblNtfrsList[0]['rangeStart']!;
      ntTblNtfrsList[14]['rangeEnd128bak'] = ntTblNtfrsList[1]['rangeEnd']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[11]['rangeStart64bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[12]['rangeEnd64bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSN;
      ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2);
      ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1; // '〇⬤〇'
      ntTblNtfrsList[15]['listener_32_64_128'] = 64;  // 32  64  128
      ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if(isLongSwitching ==false && ntTblNtfrsList[15]['listener_32_64_128']! ==128 && (((ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*0) <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! < (ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1)) || ntTblNtfrsList[0]['rangeStart']! < nTTcolSDouble)){
      tapMadeOnUpperOrLowerTable = '128UP=>064';
      ////////////////////////////////////////////////////// FIX 2: //////////////////////// ( >= ) ////////////////////
      if(!isFromRangeSlider) {
        if(ntTblNtfrsList[7]['tableChangeCount64']! >= ntTblNtfrsList[8]['tableChangeCount128']!*2
            && ntTblNtfrsList[8]['tableChangeCount128']! >1
        ) {ntTblNtfrsList[7]['tableChangeCount64'] = ntTblNtfrsList[7]['tableChangeCount64']! - 1;
        ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[6]['tableChangeCount32']! - 2;} else {}
      } else {} // end isFromRangeSlider
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[7]['tableChangeCount64']!;
      ntTblNtfrsList[13]['rangeStart128bak'] = ntTblNtfrsList[0]['rangeStart']!;
      ntTblNtfrsList[14]['rangeEnd128bak'] = ntTblNtfrsList[1]['rangeEnd']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[11]['rangeStart64bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[12]['rangeEnd64bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSN;
      if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {
        ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;
      } else {
        ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;}
      ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1; // '〇⬤〇'
      ntTblNtfrsList[15]['listener_32_64_128'] = 64;  // 32  64  128
      ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if(isLongSwitching ==false && ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 3264 && (((ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1) <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! <= (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*2)) || ntTblNtfrsList[0]['rangeStart']! >= nTTcolSN)){
      tapMadeOnUpperOrLowerTable = '064LOW=>032';     //// PlayingBit is at Second (Lower) Row of 64 view
        ////////////////////////////////////////////////////// FIX 3: //////////////////////// ( < ) ////////////////////
      if(!isFromRangeSlider) {
        if(ntTblNtfrsList[6]['tableChangeCount32']! < ntTblNtfrsList[7]['tableChangeCount64']!*2) {
          ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[6]['tableChangeCount32']! + 1;} else {};
      } else {} // end isFromRangeSlider
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[6]['tableChangeCount32']!;
        ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
        ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
        ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[9]['rangeStart32bak']!;
        ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[10]['rangeEnd32bak']!;
        ntTblNtfrsList[21]['nTcolS'] = nTTcolSHalf;
        if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {
          ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;
        } else {
          ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;}
        ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 0; // '⬤〇〇'
        ntTblNtfrsList[15]['listener_32_64_128'] = 32;  // 32  64  128
        ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if(isLongSwitching ==true && ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 64128 && (((ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1) <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! <= (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*2)) || ntTblNtfrsList[0]['rangeStart']! >= nTTcolSN)){
      tapMadeOnUpperOrLowerTable = '064LOW=>032';     //// PlayingBit is at Second (Lower) Row of 64 view
      if(((ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*0)
          <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! <
          (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1)) || ntTblNtfrsList[0]['rangeStart']! < nTTcolSN)
      {ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[7]['tableChangeCount64']!*2 - 0;}
      else {ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[7]['tableChangeCount64']!*2 + 1;}
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[6]['tableChangeCount32']!;
      ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
      ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[9]['rangeStart32bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[10]['rangeEnd32bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSHalf;
      if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {
        ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;
      } else {
        ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;}
      ntTblNtfrsList[16]['listener_3264_64128'] = 3264;
      ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 0; // '⬤〇〇'
      ntTblNtfrsList[15]['listener_32_64_128'] = 32;  // 32  64  128
      ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if(isLongSwitching ==false && ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 3264 && (((ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*0) <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! < (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1)) || ntTblNtfrsList[0]['rangeStart']! < nTTcolSN)) {
      tapMadeOnUpperOrLowerTable = '064UP=>032';
        ////////////////////////////////////////////////////// FIX 4: //////////////////////// ( >= ) ////////////////////
      if(!isFromRangeSlider) {
        if(ntTblNtfrsList[6]['tableChangeCount32']! >= ntTblNtfrsList[7]['tableChangeCount64']!*2
            && ntTblNtfrsList[7]['tableChangeCount64']! >1
        ) {ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[6]['tableChangeCount32']! - 1;} else {}
      } else {} // end isFromRangeSlider
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[6]['tableChangeCount32']!;
        ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
        ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
        ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[9]['rangeStart32bak']!;
        ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[10]['rangeEnd32bak']!;
        ntTblNtfrsList[21]['nTcolS'] = nTTcolSHalf;
        if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {
          ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;
        } else {
          ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;}
        ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 0; // '⬤〇〇'
        ntTblNtfrsList[15]['listener_32_64_128'] = 32;  // 32  64  128
        ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if(isLongSwitching ==true && ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 64128 && (((ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*0) <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! < (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1)) || ntTblNtfrsList[0]['rangeStart']! < nTTcolSN)) {
      tapMadeOnUpperOrLowerTable = '064UP=>032';
      if(((ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*0) <= ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[3]['playingBit']! < (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + (ntTblNtfrsList[21]['nTcolS']!*1)) || ntTblNtfrsList[0]['rangeStart']! < nTTcolSN)
      {ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[7]['tableChangeCount64']!*2 - 1;}
      else {ntTblNtfrsList[6]['tableChangeCount32'] = ntTblNtfrsList[7]['tableChangeCount64']!*2;}
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[6]['tableChangeCount32']!;
      ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
      ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[9]['rangeStart32bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[10]['rangeEnd32bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSHalf;
      ntTblNtfrsList[16]['listener_3264_64128'] = 3264;
      ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 0; // '⬤〇〇'
      ntTblNtfrsList[15]['listener_32_64_128'] = 32;  // 32  64  128
      ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else if (isLongSwitching ==false && ntTblNtfrsList[15]['listener_32_64_128']! ==32 && ntTblNtfrsList[16]['listener_3264_64128']! == 3264) {                                         //// Current View is "32"
      tapMadeOnUpperOrLowerTable = '032=>064';
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[7]['tableChangeCount64']!;
      ntTblNtfrsList[9]['rangeStart32bak'] = ntTblNtfrsList[0]['rangeStart']!;
      ntTblNtfrsList[10]['rangeEnd32bak'] = ntTblNtfrsList[1]['rangeEnd']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[11]['rangeStart64bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[12]['rangeEnd64bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSN;
      if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {
        ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']! * 2) + 0;
      } else {
        ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[7]['tableChangeCount64']! - 1) * (ntTblNtfrsList[21]['nTcolS']! * 2) + 0;}
      ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 1; // '〇⬤〇'
      ntTblNtfrsList[15]['listener_32_64_128'] = 64;  // 32  64  128
      ntTblNtfrsList[20]['rngEndSlider'] = 4*ntTblNtfrsList[21]['nTcolS']!;
// strTxtNotifierList[0]['ntTableCaptionTxt'] = '${ntTblNtfrsList[4]['tableChangeCount']}  ${ntTblNtfrsList[2]['startBit']}';
// strTxtNotifier.value = strTxtNotifierList;
    }
    else {} //end if
//
//**********************************************************************//
    ntTblNotifier.value = ntTblNtfrsList;
    // setState(() {});                    // !!! Unfortunately,  USING SETTING STATE !!! Only when OnTap !!! because of isSwitched_32_64_128
//**********************************************************************//
    await loading__3264_or_64128(); // CALL
    // setState(() {});
    await setDataSharedPref();      // ASYNC
    ntTblNtfrsList[26]['onTapCollisionPrevention_2'] = 0; ntTblNotifier.value = ntTblNtfrsList;
    //
  } // End tablesBothOnTap()
//
  onTapFuncChangeTableView() async {      // ASYNC added, AWAiT  added
    ntTblNtfrsList = [...ntTblNotifier.value];    // The solution to resolve Incorrect table view change dynamically while playback is to Use this line
    if(ntTblNtfrsList[25]['onTapCollisionPrevention_1'] == 0 && ntTblNtfrsList[26]['onTapCollisionPrevention_2'] == 0 && ntTblNtfrsList[27]['onTapCollisionPrevention_3'] == 0) {
      await tablesBothOnTap(false, false);
      // tablesBothOnTap(false); tablesBothOnTap(false); // 1-st and 2-nd tap  //    Needed for ... correct view change???
      } else {}
    } // end onTapFuncChangeTableView()
      //
  onLongPressFuncChangeTableView() async {      // ASYNC added, AWAiT  added
    ntTblNtfrsList = [...ntTblNotifier.value];    // The solution to resolve Incorrect table view change dynamically while playback is to Use this line
    if(ntTblNtfrsList[25]['onTapCollisionPrevention_1'] == 0 && ntTblNtfrsList[26]['onTapCollisionPrevention_2'] == 0 && ntTblNtfrsList[27]['onTapCollisionPrevention_3'] == 0) {
      await switchingTableViewByLongPress();
    } else {}
    } // end onLongPressFuncChangeTableView()
  //
//
  loading__3264_or_64128() {
    ntTblNtfrsList = [...ntTblNotifier.value];    // The solution to resolve Incorrect table view change dynamically while playback is to Use this line
//**********************************************************************//
//**********************************************************************
    if(ntTblNtfrsList[15]['listener_32_64_128']! ==128){
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[8]['tableChangeCount128']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[13]['rangeStart128bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[14]['rangeEnd128bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSDouble;
    }
    else if(ntTblNtfrsList[15]['listener_32_64_128']! ==64) {
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[7]['tableChangeCount64']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[11]['rangeStart64bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[12]['rangeEnd64bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSN;
    }
    else if(ntTblNtfrsList[15]['listener_32_64_128']! ==32) {
      ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[6]['tableChangeCount32']!;
      ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[9]['rangeStart32bak']!;
      ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[10]['rangeEnd32bak']!;
      ntTblNtfrsList[21]['nTcolS'] = nTTcolSHalf;
    }
    else {}
//**********************************************************************//
    ntTblNtfrsList[20]['rngEndSlider'] = ntTblNtfrsList[21]['nTcolS']!*4;
    ntTblNotifier.value = ntTblNtfrsList;
//**********************************************************************//
//     setState(() {});  // needed!!!
    //
  }
//
  switchingTableViewByLongPress() async {
    ntTblNtfrsList = [...ntTblNotifier.value];    // The solution to resolve Incorrect table view change dynamically while playback is to Use this line
    var sw = Stopwatch()..start();
    while((ntTblNtfrsList[25]['onTapCollisionPrevention_1'] == 1 || ntTblNtfrsList[26]['onTapCollisionPrevention_2'] == 1)  && sw.elapsedMilliseconds < 625)
    {
      // NO ENDLESS LOOP !!!  2 SECONDS
    }
    ntTblNtfrsList[27]['onTapCollisionPrevention_3'] = 1; ntTblNotifier.value = ntTblNtfrsList;
    ntTblNtfrsList = [...ntTblNotifier.value];    // The solution to resolve Incorrect table view change dynamically while playback is to Use this line
//**********************************************************************//
//**********************************************************************//

    // if(ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 3264){
    //   ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[8]['tableChangeCount128']!;
    //   ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
    //   ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
    //   ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[13]['rangeStart128bak']!;
    //   ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[14]['rangeEnd128bak']!;
    //   ntTblNtfrsList[16]['listener_3264_64128'] = 64128;
    //   ntTblNtfrsList[15]['listener_32_64_128'] = 128;
    // if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']! * 2) + 0;} else {ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[8]['tableChangeCount128']! - 1) * (ntTblNtfrsList[21]['nTcolS']! * 2) + 0;}
    //   ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 2; // '〇〇⬤'
    // }
    // else if(ntTblNtfrsList[15]['listener_32_64_128']! ==64 && ntTblNtfrsList[16]['listener_3264_64128']! == 64128) {
    //   ntTblNtfrsList[4]['tableChangeCount'] = ntTblNtfrsList[6]['tableChangeCount32']!;
    //   ntTblNtfrsList[11]['rangeStart64bak'] = ntTblNtfrsList[0]['rangeStart']!;
    //   ntTblNtfrsList[12]['rangeEnd64bak'] = ntTblNtfrsList[1]['rangeEnd']!;
    //   ntTblNtfrsList[0]['rangeStart'] = ntTblNtfrsList[9]['rangeStart32bak']!;
    //   ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[10]['rangeEnd32bak']!;
    //   ntTblNtfrsList[16]['listener_3264_64128'] = 3264;
    //   ntTblNtfrsList[15]['listener_32_64_128'] = 32;
    // if(ntTblNtfrsList[4]['tableChangeCount']! ==1) {ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;} else {ntTblNtfrsList[2]['startBit'] = (ntTblNtfrsList[6]['tableChangeCount32']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) + 0;}
    //   ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant'] = 0; // '⬤〇〇'
    // }
    // else {}

    // setState(() {});
//**********************************************************************//    isSwitched_32_64_128 = 64     TILL THE END OF FUNCTION !!!
    ntTblNtfrsList[20]['rngEndSlider'] = ntTblNtfrsList[21]['nTcolS']!*4;
    ntTblNotifier.value = ntTblNtfrsList;
//**********************************************************************//
 // await loading__3264_or_64128(); // SYNC   //call    // fix 32 => 64 end of 64-Range
 // await setDataSharedPref();      // ASYNC  // CALL   //  No Needed
    // setState(() {});
    await tablesBothOnTap(true, false);    // SYNC // CALL    // To immideately change view, needed!  With "True" parameter
 // await tablesBothOnTap(false); await tablesBothOnTap(false); // 1-st and 2-nd tap  //  No Needed,    for view indicator changes immidiately and ... correct view change???
    // setState(() {});
    await setDataSharedPref();   // CALL
    ntTblNtfrsList[27]['onTapCollisionPrevention_3'] = 0; ntTblNotifier.value = ntTblNtfrsList;
  } // end switchingTableViewByLongPress()
//
//
  hideControlsForScreenshotModeByLongPress() {
    hideControlsForScreenshotMode = !hideControlsForScreenshotMode;
    if(hideControlsForScreenshotMode) {
                            DesktopWindow.setWindowSize(Size(800,1100));
      if(Platform.isLinux) {DesktopWindow.setWindowSize(Size(430,1600));} else {}
    } else {}
    setState(() {});
  } // end hideControlsForScreenshotModeByLongPress()
//
//
//
//
//
  tunerModeEnableByKeyLongPress() {
////////////////////////////////////////////////////
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      tunerNotSupportedTextPlatformDepending = "The Tuner can only be implemented in Jalinativeinstrument assemblies for Android and maybe iOS! Not in Windows, Linux, MacOS \n\n";
    } else {tunerNotSupportedTextPlatformDepending = "";}
////////////////////////////////////////////////////
    if(isTunerModeEnable==true) {_stopCapture();} else {}    // Turn OFF capturing stream from Mic with turning OFF Green Mic Privacy Indicator, also see Binding Observer (when App is Inactive)
    isTunerModeEnable = !isTunerModeEnable;
    setState(() {});
  } // end tunerModeEnableByKeyLongPress()
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ pitch_detector (tuner) with audio_capture  3 of 4
  //final _audioRecorder = FlutterAudioCapture();                                              // OLD recorder from audio_capture ! of 4   No Needed, see Extends State and initState
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);  //don't pay attention to the name of the musical instrument
  var currDetectedNote = "";
  var currTuneStatus = "Click on start";
//
  Future<void> _startCapture() async {
    var prmssStatus = await Permission.microphone.status;
    if (prmssStatus.isGranted) {
//////////////////////////////////////
      await _audioRecorder.start(listenerT, onErrorT, sampleRate: 44100, bufferSize: 3000); // recorder from audio_capture 3 of 4
      setState(() {currDetectedNote = ""; currTuneStatus = "Play something";});
//////////////////////////////////////
    } else if (prmssStatus.isDenied) {
      Permission.microphone.request();
    } // Granted Or Refused
  }   // end _startCapture()
//
  Future<void> _stopCapture() async {
    await _audioRecorder.stop();                                                           // recorder from audio_capture 4 of 4
    setState(() {currDetectedNote = ""; currTuneStatus = "Click on start";});
  }   // end _stopCapture()
//
  void listenerT(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();          //Gets the audio sample
    final result = pitchDetectorDart.getPitch(audioSample);    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    if (result.pitched) {    //If there is a pitch - evaluate it
      // Uses the pitchupDart library to check a given pitch for a [Guitar] Instrument which you configured in Package !!!
      // AppData\Local\Pub\Cache\hosted\pub.dev\pitchupdart-0.0.1\lib       pitch_handler.dart     Instrument settings HERE !!! Configure it for Kora !!!
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);
      setState(() {
        currDetectedNote = handledPitchResult.note;
        currDetectedNote = currDetectedNote.replaceAll("C#", "C# D♭");
        currDetectedNote = currDetectedNote.replaceAll("D#", "D# E♭");
        currDetectedNote = currDetectedNote.replaceAll("F#", "F# G♭");
        currDetectedNote = currDetectedNote.replaceAll("G#", "G# A♭");
        currDetectedNote = currDetectedNote.replaceAll("A#", "A# B♭");
        //currTuneStatus   = handledPitchResult.tuningStatus.toString();      // the result
        currTuneStatus   = handledPitchResult.expectedFrequency.toStringAsFixed(2) + '         ' + (handledPitchResult.expectedFrequency - handledPitchResult.diffFrequency).toStringAsFixed(2);
        // toDo: replacement # to ♭:
        // "C",
        // "C# D♭",
        // "D",
        // "D# E♭",
        // "E",
        // "F",
        // "F# G♭",
        // "G",
        // "G# A♭",
        // "A",
        // "A# B♭",
        // "B"
        //
      }); // end setState()
    } else {}
  } // end void listenerT()
//
  void onErrorT(Object e) {print(e);}  // see _audioRecorder
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ end pitch_detector (tuner) with audio_capture  3 of 4
//
  themeappLightDarkChange(bool isLongPressed){    // Application Theme:  1 = light   2 = dark          See invertCustom() function
    if(themeappLightDark==1) {
      if(isLongPressed) {themeappLightDark = 2; int i=0; for (Color colorEl in keysColorsList) {keysColorsList[i] =  invertCustom(colorEl); i++;}
      } else {fillDefaultColorsList();}
    } else {
      if(isLongPressed) {
        themeappLightDark = 1; fillDefaultColorsList();
      } else {fillDefaultColorsList(); int i=0; for (Color colorEl in keysColorsList) {keysColorsList[i] =  invertCustom(colorEl); i++;}}
    };
    setState(() {});
    setAppSettingsSharedPref();
  } // end themeappLightDarkChange
//
static  Color invertCustom(Color color) {   // Change Theme Light-Dark      //static keyword to make this function accessible outside of this class, see Custom Paint
    final r = 255 - color.red;
    final g = 255 - color.green;
    final b = 255 - color.blue;
    return Color.fromARGB((color.opacity * 255).round(), r, g, b);
  }
//
  @override
  Widget build(BuildContext context) {            // Widget Creating
//
    var size = MediaQuery.of(context).size;       // Getting parameters of context Widget (Height, Width, etc)
//
    // toDo: // if(size.width < pxlsWidth) {isSwitched32or64 = true;} else if(size.width >= pxlsWidth && isAppFirstLoad == true) {isSwitched32or64 = false;} else {isSwitched32or64 = true;} // two variants of Table Cols numbers depends on Window Width
//
      double fontSize_i = 16.0;         // font-size of text "Info"
    ////  fontSize = 18.0; fontSizeCnt = 16.0;
    fontSize =    (double.tryParse(size.width.toString()))! * 0.001 + (double.tryParse(size.height.toString()))! * 0.0020 + 16.0;  // font-size of KEY-BUTTONS and CENTS of tuning
    fontSizeCnt = (double.tryParse(size.width.toString()))! * 0.001 + (double.tryParse(size.height.toString()))! * 0.0015 + 13.0;
    //double heightSupportingSize = 5;  // default value is (4), supports Height of each cell of the both tables
    //double heightSupportingSize = 8;
    double? heightSupportingSize;     // in keeps small '1's in the cells, they colors as the same as background so you dont see them
    double? dependsOnMediaWidthSize;  // font-Size  A  B  C  e g f
    double? posYdependsOnMediaSize;   // letters-shift
    double? posXdependsOnMediaSize;
    double? widthDependsOnMediaWIDTH;    // width of Orange Note (it have point on it and letter above it)
  //dropDownXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.020;
//                                                // Expanded Widget Class Used for Repeated Code to fill-up the column or the row:
    Expanded buildKeyLeft   (int soundNum, Color color, double fontSize, bool prsdBool, bool showLocalFingering){
      dynamic keyTuning = visualMarks (selectedtuningNum);
      // var buttonText = keyTuning[soundNum].values.elementAt(3) + '      ' + keyTuning[soundNum].values.elementAt(1); // Freq, Note
      var buttonText = keyTuning[soundNum].values.elementAt(1);                                                         // Note
      var buttonTextCent = keyTuning[soundNum].values.elementAt(2);
      var freqTextPrecisely = keyTuning[soundNum].values.elementAt(3).toString(); //frequency Precisely (machine heads)
      var freqTextRoughly = "";
      if (keyTuning[soundNum].values.elementAt(3) != "") freqTextRoughly = (double.parse((keyTuning[soundNum].values.elementAt(3)))).toStringAsFixed(1); //frequency Roughly (wooden pegs)
      var DmmTextVariant1 = ""; var DmmTextVariant2 = ""; var lbTextForVariant2 = "";
      if (stringsDiamMapVariant1[soundNum] != "") DmmTextVariant1 = stringsDiamMapVariant1[soundNum].toString(); // strings diameter, mm
      if (stringsDiamMapVariant2[soundNum] != "") DmmTextVariant2 = stringsDiamMapVariant2[soundNum].toString(); // strings diameter, mm
      if (stringsLbMapToVariant2[soundNum] != "") lbTextForVariant2 = stringsLbMapToVariant2[soundNum].toString(); // strings load in lbs
      if (soundNum !=23 && showVerticalBigLables == false) {
        return
          Expanded(
            child:
            InkWell (
              child: Stack(      // stack is only to show Fingering under the button Layer   // Stack is like Z-Layers in CSS or transparent Layers in Photoshop. It's a Stack
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: color,
                      backgroundColor: prsdBool ?  themeappLightDark==1 ? Colors.orange[100] : invertCustom(Colors.orange[100]!) : themeappLightDark==1 ? Colors.orange[50] : invertCustom(Colors.orange[50]!),
                      elevation: 3,  //visual effect for button
                    ),
                    onPressed: (){
                      playSound(selectedtuningNum,soundNum,shortOrLongNum,noteVolume,extension);
                      //harmonicFunctions (soundNum); //Complexity calculates well
                    },
                    onLongPress: () {
                      themeappLightDarkChange(true);
                    },
                    child:
                    InkWell(
                      child:
                      MouseRegion(          //restore Win cursor "hand clicks button"
                        cursor: SystemMouseCursors.click,
                        child:
                        Stack(
                          alignment: Alignment.center,      // is Solution how to Align center, do not need to change base point of CustomPainter or it's width
                          children: <Widget>[
                            Column (
                              children: [
                                if (buildKeysNotesOrFreqsMode==1) ...[
                                  size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(freqTextPrecisely, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+2),),
                                  )
                                      :                                                  // if -||-  > 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(freqTextPrecisely, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+6),),
                                  ),
                                ] else if (buildKeysNotesOrFreqsMode==2) ...[
                                  size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(freqTextRoughly, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+5),),
                                  )
                                      :                                                  // if -||-  > 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(freqTextRoughly, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+6),),
                                  ),
                                ] else if (buildKeysNotesOrFreqsMode==3) ...[
                                  size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(DmmTextVariant1, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                  )
                                      :                                                  // if -||-  > 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(DmmTextVariant1, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                  ),
                                ] else if (buildKeysNotesOrFreqsMode==4) ...[
                                  size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(DmmTextVariant2, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                  )
                                      :                                                  // if -||-  > 1280 px
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(DmmTextVariant2, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                  ),
                                ] else ...[
                                  size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(buttonTextCent, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSizeCnt, color: Colors.grey),),
                                  )
                                      :                                              // if -||-  > 1280 px
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(buttonTextCent, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSizeCnt, color: Colors.grey),),
                                  ),
                                  size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(buttonText, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize),),
                                  )
                                      :                                              // if -||-  > 1280 px
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(buttonText, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize),),
                                  ),
                                ],
                              ],
                            ),
                            ///////////////  Fingering:
                            if (((soundNum!=0 && stringsNum==21) || ((soundNum!=0 && soundNum!=21) && stringsNum==22)) && buildKeysNotesOrFreqsMode==5 && showFingeringOnButtons[soundNum] == 1) ...[      // 1 = Index finger (right or left - by context)
                              InkWell(
                                child:
                                Container(
                                    child:
                                    CustomPaint(
                                      size: Size(WIDTH_2,(WIDTH_2*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                      painter: RPSCustomPainter10(themeappLightDark: themeappLightDark),
                                    )
                                ) ,
                              ),
                            ] else if (((soundNum!=0 && stringsNum==21) || ((soundNum!=0 && soundNum!=21) && stringsNum==22)) && buildKeysNotesOrFreqsMode==5 && showFingeringOnButtons[soundNum] == 0)  ...[      // 0 = Thumb finger (right or left - by context)
                              InkWell(
                                child:
                                Container(
                                    child:
                                    CustomPaint(   // Thumb is some bigger than index (WIDTH_2 + WIDTH_2*0.1)
                                      size: Size((WIDTH_2 + WIDTH_2*0.1),((WIDTH_2 + WIDTH_2*0.1)*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                      painter: RPSCustomPainter13(themeappLightDark: themeappLightDark),
                                    )
                                ) ,
                              ),
                            ] else if (((soundNum!=0 && stringsNum==21) || ((soundNum!=0 && soundNum!=21) && stringsNum==22)) && buildKeysNotesOrFreqsMode != 5 && showFingeringOnButtons[soundNum] == 1 && showLocalFingering==true && prsdBool==true) ...[      // 1 = Index finger (right or left - by context)
                              InkWell(
                                child:
                                Container(
                                    child:
                                    CustomPaint(   // Thumb is some bigger than index (WIDTH_2 + WIDTH_2*0.1)
                                      size: Size((WIDTH_2 + WIDTH_2*0.1),((WIDTH_2 + WIDTH_2*0.1)*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                      painter: RPSCustomPainter13(themeappLightDark: themeappLightDark),
                                    )
                                ) ,
                              ),
                            ] else if (((soundNum!=0 && stringsNum==21) || ((soundNum!=0 && soundNum!=21) && stringsNum==22)) && buildKeysNotesOrFreqsMode != 5 && showFingeringOnButtons[soundNum] == 0  && showLocalFingering==true && prsdBool==true)  ...[      // 0 = Thumb finger (right or left - by context)
                              InkWell(
                                child:
                                Container(
                                    child:
                                    CustomPaint(
                                      size: Size(WIDTH_2,(WIDTH_2*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                      painter: RPSCustomPainter10(themeappLightDark: themeappLightDark),
                                    )
                                ) ,
                              ),
                            ] else ...[],
                            /////////////// end Fingering
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
//
      } else if (soundNum ==23) {
        return Expanded(
          child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: prsdBool ?  themeappLightDark==1 ? Colors.orange[100] : invertCustom(Colors.orange[100]!) : themeappLightDark==1 ? Colors.orange[50] : invertCustom(Colors.orange[50]!),   //foregroundColor: color,
              elevation: 2,  //visual effect for button
            ),
            onPressed: () {
              //////////////////////////
              openInfoPage();
              //////////////////////////
              // Open Help Page
            },
            onLongPress: () {
              tryToRunXlsmEditorWin();
            },
            icon:  Icon(Jaliinstrument.info, color: themeappLightDark==1 ? Colors.orange : invertCustom(Colors.orange)),
            label:
            Column (
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('info', style: TextStyle(fontSize: fontSize_i, color: themeappLightDark==1 ? Colors.black38 : invertCustom(Colors.black38))),
                ),
              ],
            ),
          ),
        );
      } else if (soundNum !=23 && showVerticalBigLables == true) {
        return Expanded(
          child:
          Container(),        // empty container
        );
      } else {}; // end if
      throw ''; // non nullable issue resolve
    } // end expanded build key left
    Expanded buildKeyRight  (int soundNum, Color color, double fontSize, bool prsdBool, bool showLocalFingering){
      dynamic keyTuning = visualMarks (selectedtuningNum);
      // var buttonText = keyTuning[soundNum].values.elementAt(1) + '      ' + keyTuning[soundNum].values.elementAt(3); // Note, Freq
      var buttonText = keyTuning[soundNum].values.elementAt(1);                                                         // Note
      var buttonTextCent = keyTuning[soundNum].values.elementAt(2);
      var freqTextPrecisely = keyTuning[soundNum].values.elementAt(3).toString(); //frequency Precisely (machine heads)
      var freqTextRoughly = "";
      if (keyTuning[soundNum].values.elementAt(3) != "") freqTextRoughly = (double.parse((keyTuning[soundNum].values.elementAt(3)))).toStringAsFixed(1); //frequency Roughly (wooden pegs)
      var DmmTextVariant1 = ""; var DmmTextVariant2 = ""; var lbTextForVariant2 = ""; // lbText is for lbs nylon line parameters in pounds
      if (stringsDiamMapVariant1[soundNum] != "") DmmTextVariant1 = stringsDiamMapVariant1[soundNum].toString(); // strings diameter, mm
      if (stringsDiamMapVariant2[soundNum] != "") DmmTextVariant2 = stringsDiamMapVariant2[soundNum].toString(); // strings diameter, mm
      if (stringsLbMapToVariant2[soundNum] != "") lbTextForVariant2 = stringsLbMapToVariant2[soundNum].toString(); // strings load in lbs
      //
      if (showVerticalBigLables==false || (showVerticalBigLables==true && ((soundNum == 0 || soundNum == 21) && stringsNum==21 || (soundNum == 0) && stringsNum==22))) {
        // showFingeringOnButtons[1] = 1; showFingeringOnButtons[2] = 1;  showFingeringOnButtons[13] = 0; showFingeringOnButtons[15] = 0; // for test
        return Expanded(
          child:
          InkWell (            // with InkWell CustomPainter is x-center aligning correctly, children in textButton all listening onPressed event, stack works correctly
            child: Stack(      // stack is only to show Fingering under the button Layer   // Stack is like Z-Layers in CSS or transparent Layers in Photoshop. It's a Stack
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: color,    // needed !!!
                    backgroundColor: prsdBool ?  themeappLightDark==1 ? Colors.orange[100] : invertCustom(Colors.orange[100]!) : themeappLightDark==1 ? Colors.orange[50] : invertCustom(Colors.orange[50]!),
                    elevation: 3,  //visual effect for button, effect disappeared in new SDK
                  ),
                  //////////////////////////////////////////////////////////////////////////////////////////////
                  onPressed: () {  // here was onPressed: () {}   It have been removed to InkWell and replaced by onTap: () {}
                    if ((soundNum==0 && stringsNum==22) || ((soundNum==0 || soundNum==21) && stringsNum==21))  {
                      //fillDefaultColorsList(); //CALL
                      // increasing by One:
                      buildKeysNotesOrFreqsMode = buildKeysNotesOrFreqsMode + 1;
                      if (buildKeysNotesOrFreqsMode > 6) {buildKeysNotesOrFreqsMode = 0;} else {}  // condition to setting default buttons view // F G A B C Default
                      // toDo: shift numbers and add DO RE MI FA SOL LA SI      toDo: add LCM Least Common Multiply for Complexity (see function LCM) gradient button colors
                      if (buildKeysNotesOrFreqsMode==1) {} else {}                                                                              // Freq Precisely
                      if (buildKeysNotesOrFreqsMode==2) {} else {}                                                                              // Freq Roughly
                      if (buildKeysNotesOrFreqsMode==3) {fillVariant1ColorsList();} else {} //CALL                                              // Diam mm var1
                      if (buildKeysNotesOrFreqsMode==4) {fillVariant2ColorsList();} else {} //CALL                                              // Diam mm var2
                      if (buildKeysNotesOrFreqsMode==5) {themeappLightDarkChange(false);} else {}                           //CALL              // Fingering Default
                      if (buildKeysNotesOrFreqsMode==6) {showVerticalBigLables = true;} else {}                                                 // big Labels (vertical text)
                      if (buildKeysNotesOrFreqsMode==7) {} else {}                                                                              // not used, upper is limit ">6"
                      if (buildKeysNotesOrFreqsMode==0) {themeappLightDarkChange(false); showVerticalBigLables = false;} else {} //CALL         // Normal:   F G A B C
                      // ntTableCaptionTxt = buildKeysNotesOrFreqsMode.toString(); //debug
                      setState(() {}); // Setting State()
                    } else {
                      playSound(selectedtuningNum,soundNum,shortOrLongNum,noteVolume,extension);
                      //harmonicFunctions (soundNum); //Complexity calculates well
                    };
                  },
                  onLongPress: () {
                    tunerModeEnableByKeyLongPress();
                  },
                  //////////////////////////////////////////////////////////////////////////////////////////////
                  //child: Text('note$soundNum'),
                  child: InkWell(
                    child:
                    MouseRegion(          //restore Win cursor "hand clicks button"
                      cursor: SystemMouseCursors.click,
                      child:
                      Stack(     // stack is only to show Fingering under the button Layer   // Stack is like Z-Layers in CSS or transparent Layers in Photoshop. It's a Stack
                        alignment: Alignment.center,      // is Solution how to Align center, do not need to change base point of CustomPainter or it's width
                        children: <Widget>[
                          Column (
                            children: [
                              if(((soundNum==0 && stringsNum==22) || ((soundNum==0 || soundNum==21) && stringsNum==21)) && (buildKeysNotesOrFreqsMode==0 || buildKeysNotesOrFreqsMode==1 || buildKeysNotesOrFreqsMode==5 || buildKeysNotesOrFreqsMode==6)) ...[
                                Container(
                                  child:
                                  CustomPaint(
                                    size: Size(WIDTH_2,(WIDTH_2*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter2(themeappLightDark: themeappLightDark),    // machine head
                                  ),
                                ) ,
                              ] else if(((soundNum==0 && stringsNum==22) || ((soundNum==0 || soundNum==21) && stringsNum==21)) && buildKeysNotesOrFreqsMode==2) ...[
                                Container(
                                  child:
                                  CustomPaint(
                                    size: Size(WIDTH_1,(WIDTH_1*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter1(themeappLightDark: themeappLightDark),    // wooden peg
                                  ),
                                ) ,
                              ] else if(((soundNum==0 && stringsNum==22) || ((soundNum==0 || soundNum==21) && stringsNum==21)) && (buildKeysNotesOrFreqsMode==3 || buildKeysNotesOrFreqsMode==4)) ...[
                                Container(
                                  child:
                                  CustomPaint(
                                    size: Size(WIDTH_1,(WIDTH_1*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter7(themeappLightDark: themeappLightDark),    // diam. measuring tool
                                  ),
                                ) ,
                              ] else ...[
// Leave it empty !!!
                              ],
                              if (buildKeysNotesOrFreqsMode==1) ...[
                                size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(freqTextPrecisely, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+2),),
                                )
                                    :                                                  // if -||-  > 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(freqTextPrecisely, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+6),),
                                ),
                              ] else if (buildKeysNotesOrFreqsMode==2) ...[
                                size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(freqTextRoughly, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+5),),
                                )
                                    :                                                  // if -||-  > 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(freqTextRoughly, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize+6),),
                                ),
                              ] else if (buildKeysNotesOrFreqsMode==3) ...[
                                size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(DmmTextVariant1, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                )
                                    :                                                  // if -||-  > 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(DmmTextVariant1, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                ),
                              ] else if (buildKeysNotesOrFreqsMode==4) ...[
                                size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(DmmTextVariant2, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                )
                                    :                                                  // if -||-  > 1280 px
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(DmmTextVariant2, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize-1),),
                                ),
                              ] else ...[
                                size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(buttonTextCent, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSizeCnt, color: Colors.grey),),
                                )
                                    :                                                  // if -||-  > 1280 px
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(buttonTextCent, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSizeCnt, color: Colors.grey),),
                                ),
                                size.width < pxlsWidth ?                           // if width of mediaQuery of context < 1280 px
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(buttonText, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize),),
                                )
                                    :                                                  // if -||-  > 1280 px
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(buttonText, style: TextStyle(fontStyle: FontStyle.normal, fontSize: fontSize),),
                                ),
                              ],
                            ],
                          ),
                          ///////////////  Fingering:
                          if (((soundNum!=0 && stringsNum==22) || ((soundNum!=0 && soundNum!=21) && stringsNum==21)) && buildKeysNotesOrFreqsMode==5 && showFingeringOnButtons[soundNum] == 1) ...[      // 1 = Index finger (right or left - by context)
                            InkWell(
                              child:
                              Container(
                                  child:
                                  CustomPaint(
                                    size: Size(WIDTH_2,(WIDTH_2*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter11(themeappLightDark: themeappLightDark),
                                  )
                              ) ,
                            ),
                          ] else if (((soundNum!=0 && stringsNum==22) || ((soundNum!=0 && soundNum!=21) && stringsNum==21)) && buildKeysNotesOrFreqsMode==5 && showFingeringOnButtons[soundNum] == 0)  ...[      // 0 = Thumb finger (right or left - by context)
                            InkWell(
                              child:
                              Container(
                                  child:
                                  CustomPaint(   // Thumb is some bigger than index (WIDTH_2 + WIDTH_2*0.1)
                                    size: Size((WIDTH_2 + WIDTH_2*0.1),((WIDTH_2 + WIDTH_2*0.1)*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter14(themeappLightDark: themeappLightDark),
                                  )
                              ) ,
                            ),
                          ] else if (((soundNum!=0 && stringsNum==21) || ((soundNum!=0 && soundNum!=21) && stringsNum==22)) && buildKeysNotesOrFreqsMode != 5 && showFingeringOnButtons[soundNum] == 1 && showLocalFingering==true && prsdBool==true) ...[      // 1 = Index finger (right or left - by context)
                            InkWell(
                              child:
                              Container(
                                  child:
                                  CustomPaint(   // Thumb is some bigger than index (WIDTH_2 + WIDTH_2*0.1)
                                    size: Size((WIDTH_2 + WIDTH_2*0.1),((WIDTH_2 + WIDTH_2*0.1)*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter14(themeappLightDark: themeappLightDark),
                                  )
                              ) ,
                            ),
                          ] else if (((soundNum!=0 && stringsNum==21) || ((soundNum!=0 && soundNum!=21) && stringsNum==22)) && buildKeysNotesOrFreqsMode != 5 && showFingeringOnButtons[soundNum] == 0  && showLocalFingering==true && prsdBool==true)  ...[      // 0 = Thumb finger (right or left - by context)
                            InkWell(
                              child:
                              Container(
                                  child:
                                  CustomPaint(
                                    size: Size(WIDTH_2,(WIDTH_2*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter11(themeappLightDark: themeappLightDark),
                                  )
                              ) ,
                            ),
                          ] else ...[],
                          /////////////// end Fingering
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (showVerticalBigLables==true && (soundNum != 0 || soundNum != 21)) {
        return Expanded(
          child:
          Container(),        // empty container
        );
      }
      throw ''; // non nullable issue resolve
    } // end expanded build key right
//
//
//  ///////////////////// MediaQuery parameters ///////////////////
    double width23  = size.width * 0.23; // for buttons width
    double width54  = size.width * 0.54; // for notation zone width
    double width23a = size.width * 0.23;
    //var buttonHeight = MediaQuery.of(context).size.height/2;
    ///* window.viewPadding.top is for notification bar on Android */  // ???
    /// double statusbarHeight = MediaQuery.of(context).padding.top; // padding.top     is height of bar with clock, battery indicator
    /// double contextLowerBarHeight = kToolbarHeight;               // kToolbarHeight  is height of home, back, apps lower bar
    ///////////////////// End MediaQuery parameters ///////////////
//
// toDo: sample: abstract class Container ! Call it from widget build
// // Will be removed Later, No Needed
    Container buildNtColumn (int bitNum, notationNote, int playingBit){   // building Note Cell, abstract Class "Container"
      return Container();
    } // end Container buildNtColumn
//
/////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////
//
    return MaterialApp(             // returning Material Application
      //
      //////////////////////////// Background of Objects with no specified Colour ///////////
      //theme: ThemeData(primarySwatch: Colors.brown,), // theme Background     // you can uncomment it // Variant 1
      // all icons and texts without colour parameters setting are transparent, you will see
      // background through it, blue background of PlayCircle and Text on buttons is because it!
      //////////////////////////////////////////////////////////////////////
      //                           It repeats Twice: see Return MaterialApp (second)
      //////////////////////////// Background of Objects: custom materialColour  /////////// see TOMaterialColor -> ASMaterialColor  in Glogal Assignment at the beginning
      theme: ThemeData(primarySwatch: const Color(0xFFC9F5FC).asMaterialColor), // you can uncomment it // Variant 2
      //////////////////////////////////////////////////////////////////////
      //
      //////////////////// Android: Disappering app Title issue resolve //////////////////// Title of the App in opened AppsList of Android
      title: 'Jalinativeinstrument',
      //////////////////////////////////////////////////////////////////////////////////////
      home: SafeArea(
        child:
        Scaffold(
            backgroundColor: themeappLightDark==1 ? Colors.white : Colors.black, // background color of App
            body:
            Container(
/////////////////////////////////////////////////////////////////////////
              child:
              InkWell (     // with InkWell CustomPainter is x-center aligning correctly, children in textButton all listening onPressed event, stack works correctly
                  child:
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: width23,
                        child: SizedBox.expand(
                          child: Stack(
                            alignment: Alignment.center,      // is Solution how to Align center, do not need to change base point of CustomPainter or it's width
                            children: <Widget>[
                              if (showVerticalBigLables == true) ...[
                                Container(
                                  child: CustomPaint(
                                    size: Size(WIDTH_8,(WIDTH_8*8.75).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter8(themeappLightDark: themeappLightDark),
                                  ),
                                ) ,
                              ] else ...[],
                              Column(
                                children: [
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,  // maybe "_" came up with to easy find a method
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(4, keysColorsList[4], fontSize, buttonsPS[4]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(6, keysColorsList[6], fontSize, buttonsPS[6]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(8, keysColorsList[8], fontSize, buttonsPS[8]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(10, keysColorsList[10], fontSize, buttonsPS[10]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(12, keysColorsList[12], fontSize, buttonsPS[12]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(14, keysColorsList[14], fontSize, buttonsPS[14]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(16, keysColorsList[16], fontSize, buttonsPS[16]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(18, keysColorsList[18], fontSize, buttonsPS[18]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(19, keysColorsList[19], fontSize, buttonsPS[19]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(20, keysColorsList[20], fontSize, buttonsPS[20]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(22, keysColorsList[22], fontSize, buttonsPS[22]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyLeft(23, keysColorsList[23], fontSize_i, buttonsPS[23]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                ],
                              ),                    // Column with buttons in stack is ABOVE the paintings !!!
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width54,
                        child: SizedBox.expand(
                          child:
                          (!isTunerModeEnable) ?
                          Column(
                            children: [
                              InkWell(
                                child:Align(
                                  alignment: Alignment.topLeft,
                                  child:
                                      Row(
                                        children:
                                            [
                                              ValueListenableBuilder <List<Map<String,int>>> (
                                                  valueListenable: _JaliinstrumentState.ntTblNotifier,
                                                  builder: (context, ntTblNtfrsList, __) {
                                                    int  tmpidx  = ntTblNtfrsList[22]['ntTableCaptionTxt_0_variant']!;              // Null check on Null value: if you make a mistake in [22] or [23]
                                                    int  tmpidx1 = ntTblNtfrsList[23]['ntTableCaptionTxt_1_variant']!;
                                                    int  fontIndicator = 0;
                                                         if(Platform.isWindows) {fontIndicator = 1;}
                                                    else if(Platform.isAndroid) {fontIndicator = 0;}
                                                    else if(Platform.isLinux)   {fontIndicator = 0;}
                                                                           else {fontIndicator = 0;}
                                                    return Row (          // mode indicator (three circles utf-8 symbols)        // table caption text, if Platform is Not Windows
                                                      children:
                                                      [  //  if Android, MacOS, Linux:
                                                        Container(height: centralColumnHeaderHeigth, padding: EdgeInsets.only(bottom: 0), child: Text( (!Platform.isWindows) ? ntTableCaptionTxt_0_sym[tmpidx][0] : ntTableCaptionTxt_0_win[tmpidx][0], style: TextStyle(fontFamily: 'Lucida',fontStyle: FontStyle.normal, fontSize: sym_font[fontIndicator], color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber)) ),),
                                                        Container(height: centralColumnHeaderHeigth, padding: EdgeInsets.only(bottom: 0), child: Text( (!Platform.isWindows) ? ntTableCaptionTxt_0_sym[tmpidx][1] : ntTableCaptionTxt_0_win[tmpidx][1], style: TextStyle(fontFamily: 'Lucida',fontStyle: FontStyle.normal, fontSize: sym_font[fontIndicator], color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber)) ),),
                                                        Container(height: centralColumnHeaderHeigth, padding: EdgeInsets.only(bottom: 0), child: Text( (!Platform.isWindows) ? ntTableCaptionTxt_0_sym[tmpidx][2] : ntTableCaptionTxt_0_win[tmpidx][2], style: TextStyle(fontFamily: 'Lucida',fontStyle: FontStyle.normal, fontSize: sym_font[fontIndicator], color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber)) ),),
                                                        Container(height: centralColumnHeaderHeigth, padding: EdgeInsets.only(bottom: 0), child: Text('   ', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber)) ),),
                                                        Container(height: centralColumnHeaderHeigth, child: Text(ntTableCaptionTxt, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber)) ),),
                                                      ],
                                                    );
                                                  }),
                                              ValueListenableBuilder <List<Map<String,String>>> (
                                                  valueListenable: _JaliinstrumentState.strTxtNotifier,
                                                  builder: (context, strTxtNotifierList, __) {
                                                    return
                                                      Container(height: centralColumnHeaderHeigth, child: Text(strTxtNotifierList[0]['ntTableCaptionTxt']!, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber)) ),);
                                                  }),
                                            ],
                                      ),
                                ),
                              ),
//
                              InkWell(
                                child:
                                Container(
                                  clipBehavior: Clip.none,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    border: Border(
                                      left: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber), width: 0,),
                                      right: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber), width: 0,),
                                      top: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber), width: 0,),
                                      bottom: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber), width: 0,),
                                      // color: Colors.orange,
                                      // width: 0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    //color: Colors.orange,
                                  ),
                                  child:
                                  InkWell(    // with InkWell NO FREEZE When Table View Changes !!!
                                    onTap: () => onTapFuncChangeTableView(),                  // without ()  we call the method DURING build process, NO Good: memory leak, switches by itself, No good!
                                    onLongPress: () => onLongPressFuncChangeTableView(),
                                    child:
//////// FIRST: ///////////////////// toDo: variable doesn't have to be inside setState(), widget rebuilds with new value of variable after each setState WITHOUT ValueListenableBuilder!!!, even if variable is not inside the setState() !!!
                                    ValueListenableBuilder<List<Map<String, int>>> (     // works very well!
                                        valueListenable: _JaliinstrumentState.ntTblNotifier,
                                        builder: (context, ntTblNtfrsList, __) {  //As few assignments of new variables as possible! It slows down!
                                          switch(ntTblNtfrsList[15]['listener_32_64_128']!) {    // linear dependence of font size on device screen width and XY-shift on device screen width:
                                            case 32:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;   // height supporting font for table row
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.021 + 6;  // font-Size  A  B  C  e g f   in Notation Table
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.035 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.012 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.072;
                                              break;
                                            case 64:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.015 + 6;
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.030 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.009 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.042;
                                              break;
                                            case 128:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.007 + 6;
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.022 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.004 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.042;
                                              break;
                                            default:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.015 + 6;
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.030 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.009 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.042;
                                          } // wide screen, correction
                                          return Table(
                                              border: TableBorder.all(width: 0, color: themeappLightDark==1 ? Color(0xFFF6EAB4) : invertCustom(Color(0xFFF6EAB4))),  //toDo: uncomment it!
                                              // border: TableBorder.all(width: 0, color: Colors.black12),  // visible grid, but too thick in Win
                                              children:
                                              [
                                                for(int i = 0; i <= stringsNum; i++)  TableRow(children: [    // was i < stringsNum     fix: Note F2 was not shown in Table   1 of 2
                                                  for(int j = ntTblNtfrsList[2]['startBit']!.round(); j! < ntTblNtfrsList[2]['startBit']!.round() + ntTblNtfrsList[21]['nTcolS']!; j++)
// if(data1[i][j] != '') {data1[i][j] = '⬤';} else {}  // replacing all notes with '⬤', filled circle symbol
                                                    if (data1[i][j] != '' && j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                      Container( // SOLUTION 1 of 4 !!!  RED SCREEN and widget rendering EXCEPTION, endless height of ROWS after Range Change by Slider, CONTAINER NEEDED !!! !!! !!!
                                                        child:
                                                        Stack(
                                                            clipBehavior: Clip.none,
                                                            children:
                                                            [
                                                              Positioned(       // ♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL◍◍◍◍◍NOTE SYMBOL◍◍◍◍◍
                                                                bottom: 0,
                                                                //top: -15,
                                                                top: posYdependsOnMediaSize,
                                                                left: posXdependsOnMediaSize,
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //decoration: BoxDecoration(color: Colors.yellow[700],borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: heightSupportingSize!+1,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text(data1[i][j].toString(), style: TextStyle(fontSize: dependsOnMediaWidthSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  padding: EdgeInsets.all(0),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  decoration: BoxDecoration(color: themeappLightDark==1 ? Colors.yellow[700] : invertCustom(Colors.yellow[700]!),borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: widthDependsOnMediaWIDTH!,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                      ),
                                                    ] else if (data1[i][j] != '') ...[
                                                      Container( // SOLUTION 2 of 4 !!!  RED SCREEN and widget rendering EXCEPTION, endless height of ROWS after Range Change by Slider, CONTAINER NEEDED !!! !!! !!!
                                                        child:
                                                        Stack(
                                                            clipBehavior: Clip.none,
                                                            children:
                                                            [
                                                              Positioned(       // ♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL◍◍◍◍◍NOTE SYMBOL◍◍◍◍◍
                                                                bottom: 0,
                                                                //top: -15,
                                                                top: posYdependsOnMediaSize,
                                                                left: posXdependsOnMediaSize,
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //decoration: BoxDecoration(color: Colors.yellow[700],borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: heightSupportingSize!+1,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text(data1[i][j].toString(), style: TextStyle(fontSize: dependsOnMediaWidthSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  padding: EdgeInsets.all(0),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  decoration: BoxDecoration(color: themeappLightDark==1 ? Colors.orange[600] : invertCustom(Colors.orange[600]!),borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: widthDependsOnMediaWIDTH!,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) == 0 && j!=ntTblNtfrsList[3]['playingBit']) ...[
                                                      Container(
                                                        color:   themeappLightDark==1 ? Colors.amber[50] : invertCustom(Colors.amber[50]!),    // Start: divides by 64, End: divides by 128 && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)) || ((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                      Container(                  // Border-L Green Range 1st table
                                                        decoration: BoxDecoration(
                                                          color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),
                                                          border: Border(
                                                            left: BorderSide(color: themeappLightDark==1 ? Color(0xffffce4c) : invertCustom(Color(0xffffce4c)),width: ntTblNtfrsList[15]['listener_32_64_128']! ==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                          ),
                                                        ),                      // Border-L Green Range 1st table (now it's thin Orange)
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)) || ((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                      Container(            // Border-R Green Range 1st table
                                                        decoration: BoxDecoration(
                                                          color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),
                                                          border: Border(
                                                            right: BorderSide(color: themeappLightDark==1 ? Color(0xffffce4c) : invertCustom(Color(0xffffce4c)),width: ntTblNtfrsList[15]['listener_32_64_128']! ==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                          ),
                                                        ),                  // Border-R Green Range 1st table (now it's thin Orange)
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 1) ...[
                                                      Container(                      // Green Range 1st table (see also: second cond.)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[21]['nTcolS']!*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 1) ...[
                                                      Container(                      // Green Range 1st table (second condition)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 2) ...[
                                                      Container(                      // Green Range 1st table (see also: second cond.)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + 1 + (C-1)*(32*2) < = j < = E + 0 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[21]['nTcolS']!*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 2) ...[
                                                      Container(                      // Green Range 1st table (second condition)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 3) ...[
                                                      Container(                      // Green Range 1st table (see also: second cond.)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + 1 + (C-1)*(32*2) < = j < = E + 0 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[21]['nTcolS']!*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 3) ...[
                                                      Container(                      // Green Range 1st table (second condition)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! > 3) ...[
                                                      Container(                      // Green Range 1st table (see also: second cond.)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[21]['nTcolS']!*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! > 3) ...[
                                                      Container(                      // Green Range 1st table (second condition)
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1 && ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) == 0) ...[
                                                      Container(
                                                        color:   themeappLightDark==1 ? Colors.lime[200] : invertCustom(Colors.lime[200]!),    // j: is PlayingBit && msrTgl==1 && S: all the way to the left (divides by 64) && E: all the way to the right (divides by 128)
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                      Container(                      // Light Cursor 1st table
                                                        color:   themeappLightDark==1 ? Colors.lime[50] : invertCustom(Colors.lime[50]!),     // j: is PlayingBit && msrTgl==1
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else ...[
                                                      Container(
                                                        color:   themeappLightDark==1 ? Colors.amber[50] : invertCustom(Colors.amber[50]!),    // in all other cases
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] // end if[]
                                                ]),
                                              ]
                                          );
                                        }),
                                  ),
                                ),
                              ),
                              InkWell(
                                child:
                                Container(
                                  clipBehavior: Clip.none,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    border: Border(
                                      left: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber!), width: 0,),
                                      right: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber!), width: 0,),
                                      top: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber!), width: 0,),
                                      bottom: BorderSide(color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber!), width: 0,),
                                      // color: Colors.orange,
                                      // width: 0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    //color: Colors.orange,
                                  ),
                                  child:
                                  InkWell(    // with InkWell NO FREEZE When Table View Changes !!! To Vibration effect off: use gestureDetector class
                                    onTap: () => onTapFuncChangeTableView(),                  // without ()  we call the method DURING build process, NO Good: memory leak, switches by itself, No good!
                                    onLongPress: () => onLongPressFuncChangeTableView(),
                                    child:
/////// SECOND: // Lower Level of the Table://///////////////
                                    ValueListenableBuilder<List<Map<String, int>>> (
                                        valueListenable: _JaliinstrumentState.ntTblNotifier,
                                        builder: (context, ntTblNtfrsList, __) {  //As few assignments of new variables as possible! It slows down!
                                          switch(ntTblNtfrsList[15]['listener_32_64_128']!) {    // linear dependence of font size on device screen width and XY-shift on device screen width:
                                            case 32:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;   // height supporting font for table row
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.021 + 6;  // font-Size  A  B  C  e g f   in Notation Table
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.035 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.012 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.072;
                                              break;
                                            case 64:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.015 + 6;
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.030 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.009 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.042;
                                              break;
                                            case 128:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.007 + 6;
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.022 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.004 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.042;
                                              break;
                                            default:
                                              heightSupportingSize = (double.tryParse(size.height.toString()))! * 0.0065;
                                              dependsOnMediaWidthSize = (double.tryParse(size.width.toString()))! * 0.015 + 6;
                                              posYdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.030 - (1800 - (double.tryParse(size.width.toString()))!) * 0.003;  // increase: Up
                                              posXdependsOnMediaSize = -(double.tryParse(size.width.toString()))! * 0.009 - (2700 - (double.tryParse(size.width.toString()))!) * 0.001;  // increase: Left
                                              widthDependsOnMediaWIDTH = (double.tryParse(size.width.toString()))! * 0.042;
                                          } // wide screen, correction
                                          return Table(
                                              border: TableBorder.all(width: 0, color: themeappLightDark==1 ? Color(0xFFEFEEE1) : invertCustom(Color(0xFFEFEEE1))),  //toDo: uncomment it!
                                              children:
                                              [
                                                for(int i = 0; i <= stringsNum; i++)  TableRow(children: [    // was i < stringsNum     fix: Note F2 was not shown in Table   2 of 2
                                                  for(int j = ntTblNtfrsList[2]['startBit']!.round() + ntTblNtfrsList[21]['nTcolS']!; j! < ntTblNtfrsList[2]['startBit']!.round() + ntTblNtfrsList[21]['nTcolS']!*2; j++)
// if(data1[i][j] != '') {data1[i][j] = '⬤';} else {}  // replacing all notes with '⬤', filled circle symbol
                                                    if (data1[i][j] != '' && j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                      Container( // SOLUTION 3 of 4 !!!  RED SCREEN and widget rendering EXCEPTION, endless height of ROWS after Range Change by Slider, CONTAINER NEEDED !!! !!! !!!
                                                        child:
                                                        Stack(
                                                            clipBehavior: Clip.none,
                                                            children:
                                                            [
                                                              Positioned(       // ♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL◍◍◍◍◍NOTE SYMBOL◍◍◍◍◍
                                                                bottom: 0,
                                                                //top: -15,
                                                                top: posYdependsOnMediaSize,
                                                                left: posXdependsOnMediaSize,
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //decoration: BoxDecoration(color: Colors.yellow[700],borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: heightSupportingSize!+1,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text(data1[i][j].toString(), style: TextStyle(fontSize: dependsOnMediaWidthSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  padding: EdgeInsets.all(0),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  decoration: BoxDecoration(color: themeappLightDark==1 ? Colors.yellow[700] : invertCustom(Colors.yellow[700]!),borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: widthDependsOnMediaWIDTH!,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                      ),
                                                    ] else if (data1[i][j] != '') ...[
                                                      Container( // SOLUTION 4 of 4 !!!  RED SCREEN and widget rendering EXCEPTION, endless height of ROWS after Range Change by Slider, CONTAINER NEEDED !!! !!! !!!
                                                        child:
                                                        Stack(
                                                            clipBehavior: Clip.none,
                                                            children:
                                                            [
                                                              Positioned(       // ♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩♩NOTE SYMBOL♩♩♩♩♩♩♩NOTE SYMBOL◍◍◍◍◍NOTE SYMBOL◍◍◍◍◍
                                                                bottom: 0,
                                                                //top: -15,
                                                                top: posYdependsOnMediaSize,
                                                                left: posXdependsOnMediaSize,
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //decoration: BoxDecoration(color: Colors.yellow[700],borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: heightSupportingSize!+1,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text(data1[i][j].toString(), style: TextStyle(fontSize: dependsOnMediaWidthSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  padding: EdgeInsets.all(0),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                child:
                                                                Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                                  //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  decoration: BoxDecoration(color: themeappLightDark==1 ? Colors.orange[600] : invertCustom(Colors.orange[600]!),borderRadius: BorderRadius.circular(heightSupportingSize!+1)),  width: widthDependsOnMediaWIDTH!,  height: heightSupportingSize!+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                                  //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                  child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[21]['nTcolS']!*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) == 0 && j!=ntTblNtfrsList[3]['playingBit']) ...[
                                                      Container(
                                                        color:   themeappLightDark==1 ? Colors.amber[50] : invertCustom(Colors.amber[50]!),    // Start: divides by 64 && Start: Not at the Middle Position && End: divides by 128 && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)) || ((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                      Container(                      // Border-L Green Range 2nd table
                                                        decoration: BoxDecoration(
                                                          color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),
                                                          border: Border(
                                                            left: BorderSide(color: themeappLightDark==1 ? Color(0xffffce4c) : invertCustom(Color(0xffffce4c)),width: ntTblNtfrsList[15]['listener_32_64_128']! ==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                          ),
                                                        ),                      // Border-L Green Range 2nd table
                                                        child: Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                      ),
                                                    ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)) || ((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                      Container(                      // Border-R Green Range 2nd table
                                                        decoration: BoxDecoration(
                                                          color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),
                                                          border: Border(
                                                            right: BorderSide(color: themeappLightDark==1 ? Color(0xffffce4c) : invertCustom(Color(0xffffce4c)),width: ntTblNtfrsList[15]['listener_32_64_128']! ==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                          ),
                                                        ),                      // Border-R Green Range 2nd table
                                                        child: Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 1) ...[
                                                      Container(                      // Green Range 2nd table
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + 0 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 2) ...[
                                                      Container(                      // Green Range 2nd table
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + 1 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 3) ...[
                                                      Container(                      // Green Range 2nd table
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + 1 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (ntTblNtfrsList[21]['nTcolS']!*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! > 3) ...[
                                                      Container(                      // Green Range 2nd table
                                                        color:   themeappLightDark==1 ? Colors.lime[100] : invertCustom(Colors.lime[100]!),    // S + 0 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1 && ntTblNtfrsList[0]['rangeStart']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(ntTblNtfrsList[21]['nTcolS']!*4) == 0) ...[
                                                      Container(
                                                        color:   themeappLightDark==1 ? Colors.lime[200] : invertCustom(Colors.lime[200]!),    // j: is PlayingBit && msrTgl==1 && S: all the way to the left && E: all the way to the right
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                      Container(                      // Light Cursor 2nd table
                                                        color:   themeappLightDark==1 ? Colors.lime[50] : invertCustom(Colors.lime[50]!),     // j: is PlayingBit && msrTgl==1
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] else ...[
                                                      Container(
                                                        color:   themeappLightDark==1 ? Colors.amber[50] : invertCustom(Colors.amber[50]!),    // in all other cases
                                                        child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                      ),
                                                    ] // end if[]
                                                ]),
                                              ]
                                          );
                                        }),
                                  ),
                                ),
                              ),
/////// End Both Tables ////////////////////////////////////////////////////////////////////////////
//
                              if (!hideControlsForScreenshotMode) ...[
                                SliderTheme(                                                      // Range Slider (Dynamically changes Range of one of the 3rd views independent)
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: themeappLightDark==1 ? Colors.brown[200] : invertCustom(Colors.brown[200]!),
                                    inactiveTrackColor: themeappLightDark==1 ? Colors.brown[50] : invertCustom(Colors.brown[50]!),
                                    //inactiveTrackColor: Colors.white,
                                    trackShape: RectangularSliderTrackShape(),
                                    trackHeight: 1.0,
                                    disabledInactiveTrackColor: themeappLightDark==1 ? Colors.brown[50] : invertCustom(Colors.brown[50]!),
                                    thumbColor: themeappLightDark==1 ? Colors.brown[50] : invertCustom(Colors.brown[50]!),
                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                    overlayColor: themeappLightDark==1 ? Colors.red.withAlpha(32) : invertCustom(Colors.red.withAlpha(32)!),
                                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                    //showValueIndicator: ShowValueIndicator.never,
                                    valueIndicatorColor: themeappLightDark==1 ? Colors.brown[200] : invertCustom(Colors.brown[200]!),
                                  ),
                                  child:
                                  Stack(
                                    children: <Widget>[                 // Container is OVER the painting, because it is LAST in the List
                                      if (showArrowMoveToTheLeft==true) ...[
                                        Container(
                                          child:
                                          CustomPaint(
                                            size: Size(WIDTH_15,(WIDTH_15*0.3833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                            painter: RPSCustomPainter15(themeappLightDark: themeappLightDark),
                                          ),
                                        ) ,
                                      ] else ...[],
                                      Container( child:
                                      ValueListenableBuilder<List<Map<String, int>>> (
                                          valueListenable: _JaliinstrumentState.ntTblNotifier,
                                          builder: (context, ntTblNtfrsList, __) {
                                            double? doubleVar1 = (ntTblNtfrsList[0]['rangeStart'])?.toDouble();   //to prevent Null check on Null value
                                            double? doubleVar2 = (ntTblNtfrsList[1]['rangeEnd'])?.toDouble();
                                            return RangeSlider(
                                              values: RangeValues(doubleVar1!, doubleVar2!),
                                              /////////////////////////////////////////////////////////////////////////////
                                              //       // max: (4*ntTblNtfrsList[21]['nTcolS']!).toDouble(),   // 128        // try to fix incorrect view change after tables both onTap
                                              //       max: (rngEnd).toDouble(),
                                              //       // divisions: 2*(ntTblNtfrsList[21]['nTcolS']!.toInt()),         // 64
                                              //     //divisions: (rngEnd/2).round(),   // works fine
                                              //     //divisions: (rngEnd/2).toInt(),
                                              //       divisions: (rngEnd~/2),          // ~~~~~~~~~~~~//////////// divide evenly    ~/      (~)
                                              //////////////////////////////////////////////////////////////////////////////
                                                  // max: (4*ntTblNtfrsList[21]['nTcolS']!).toDouble(),   // 128
                                                  max: (ntTblNtfrsList[20]['rngEndSlider'])!.toDouble(),
                                                  // divisions: 2*ntTblNtfrsList[21]['nTcolS']!,          // 64
                                                  divisions: ((ntTblNtfrsList[20]['rngEndSlider'])!/2).toInt(),
                                              //////////////////////////////////////////////////////////////////////////////
                                              // was working without "min" parameter at all, then added min (when switched from range 32...64 occured Start error). Min is unnecessary instance.
                                              //min: isSwitched_32_64_128==64 ? 0.0 : 0.0, // allways zero: if mode is 64 or not
                                                min: 0.0,
                                              labels: RangeLabels(
                                                (ntTblNtfrsList[0]['rangeStart']!).toString(),
                                                (ntTblNtfrsList[1]['rangeEnd']!).toString(),
                                              ),
                                              onChanged: (RangeValues values1) {
                                                cnslDelay1Ntfr.value = true;
                                                // ntTblNtfrsList[0]['rangeStart'] = values1.start.round(); //works fine
                                                // ntTblNtfrsList[1]['rangeEnd'] = values1.end.round();
                                                ntTblNtfrsList[0]['rangeStart'] = values1.start.toInt();
                                                ntTblNtfrsList[1]['rangeEnd'] = values1.end.toInt();
                                                ntTblNotifier.value = ntTblNtfrsList;
                                                tablesBothOnTap(false, true); tablesBothOnTap(false, true); // 1-st and 2-nd tap  //   fix 1) Changes Monitor button reset the Range, 2) suggest to clear range at slider right position
                                                  //loading__3264_or_64128(); // CALL
                                                  //setState(() {});
                                                  //await setDataSharedPref(); // CALL
                                                switchRangeEndDependsColsNumb();    // fix: clear range suggestion not only in 64, but in 32 and 128 views
                                                fromTheBeginBySliderCoincidence(); // contains setState()
                                                setDataSharedPref(); // CALL    // Setting 16 parameters, including slider's Range into Shared Preferences
                                              },  //end onChanged
                                            );
                                          })
                                      ),
                                    ],
                                  ),
                                ),
//
/////////////////////////////////////////DropDown Menu Part////////////////////////////////////////
                                Container(
                                //margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),   // general margins from all edges sets here
                                  margin: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0, bottom: 4.0),   // general margins from all edges sets here
                                  child:
                                  Row(         // toDo: "DropdownTuningBox" is a Class from "dropdown...dart" file, adjacent to our file
                                    children: [
                                      Text("M", style: TextStyle(fontSize: 14, color: themeappLightDark==1 ? Colors.amber[300] : invertCustom(Colors.amber[300]!), fontWeight: FontWeight.bold)),     // "Scale" replaced with "Mode"
                                      Text("ode:", style: TextStyle(fontSize: 14, color: themeappLightDark==1 ? Colors.amber : invertCustom(Colors.amber!))),     // "Scale" replaced with "Mode"
                                      const SizedBox(width: 1),     // used as a "spacer"
                                      Expanded(child:
                                      MouseRegion(          //replaced pointer cursor with Win cursor "hand clicks button"
                                        cursor: SystemMouseCursors.click,
                                        child:              // here 1) getting value from a widget 2) callBack function, 3)we are sending the value to the widget from another file
                                        DropdownTuningBox(dropdownValue,                        // Constructor 1
                                                          callBack: (valueFromDropDown) =>{     // Constructor 2 // Here creates a New class exemplar from the Other dart-file locates in lib: dropdown_tuningFromDropDown_box.dar
                                          setState(() {
                                            dropdownValue = valueFromDropDown;
                                            //MapEntry tuneMapEntry = tuneMap.entries.firstWhere((element) => element.value==valueFromDropDown);
                                            selectedtuningNum = tuneMapRvrsd[dropdownValue]!.round();
                                          }),
                                                                                          },    // end Constructor 2
                                                          themeAppLightDarkVariant: themeappLightDark, // Constructor 3
                                                        tuningListMainToDropdown_1: droptuningList,    // Constructor 4
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                ),
///////////////////////////////////////End DropDown Menu Part/////////////////////////////////////
                                Row(
                                    children: [
                                      Switch(
                                        value: isSwitchedMonitorFile,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitchedMonitorFile = value;  //print(isSwitchedMonitorFile);
                                            if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == false) {LoadCSVBtnTx='Changes monitor';MonitorFile();} else if(isSwitchedMonitorFile==true && willGoogleSpreadsheetBeLoaded == true) {LoadCSVBtnTx='Online spreadsheet monitor';MonitorFile();} else {LoadCSVBtnTx='Load csv/tsv file, web';} //end if
                                          });
                                        },
                                        activeTrackColor: themeappLightDark==1 ? Colors.lightGreen[100] : invertCustom(Colors.lightGreen[100]!),
                                        activeColor: themeappLightDark==1 ? Colors.lightGreen[300] : invertCustom(Colors.lightGreen[300]!),
                                        inactiveTrackColor:  themeappLightDark==1 ? Colors.lightGreen[50] : invertCustom(Colors.lightGreen[50]!),
                                        inactiveThumbColor:  themeappLightDark==1 ? Colors.lightGreen[200] : invertCustom(Colors.lightGreen[200]!),
                                        //
                                        trackOutlineColor: WidgetStateProperty.resolveWith( // works from flutter v3.10 and newer
                                              (final Set<WidgetState> states) {
                                            if (states.contains(WidgetState.selected)) {
                                              return null;
                                            }
                                            if(themeappLightDark==1) {return Color(0xD9BC86D6);} else {return invertCustom(Color(0xD9BC86D6)!);}
                                          },
                                        ),
                                        // trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {    // not work ???
                                        //   if (states.contains(MaterialState.disabled)) {
                                        //     return Colors.lightGreen[200];
                                        //   }
                                        //   return null; // Use the default color.
                                        // }),
                                      ),
                                      Expanded(child:
                                      ConstrainedBox(
                                        constraints:BoxConstraints(
                                          minHeight:45,		 // minHeight of the Box and TextButton
                                        ),
                                        child:
                                        TextButton.icon(
                                          style: TextButton.styleFrom(
                                            backgroundColor: themeappLightDark==1 ? Colors.orange[50] : invertCustom(Colors.orange[50]!), elevation: 2, //foregroundColor: color,
                                          ),
                                          onPressed: (){
                                            //print('isSwitchedMonitorFile $isSwitchedMonitorFile ; fromTheBegin $fromTheBegin');
                                            showArrowMoveToTheLeft=false;                     // hide Arrow "Move Left"
                                            setState(() { userAbortedLoadCSV = false;  });
                                            if(isSwitchedMonitorFile==true && fromTheBegin==false) {
                                              MonitorFile();
                                            } else if (fromTheBegin==true) {
                                              argument0 = ''; setState(() {});// Needed!  Better if arguments[0]='' but it is visible only in void main()
                                              ntTblNtfrsList = [...ntTblNotifier.value];
                                              ntTblNtfrsList[2]['startBit']         = 0;
                                              ntTblNtfrsList[3]['playingBit']       = 0;
                                              ntTblNtfrsList[4]['tableChangeCount'] = 1;
                                              ntTblNtfrsList[5]['msrTgl'] = 0;
                                              ntTblNtfrsList[6]['tableChangeCount32']  = 1;
                                              ntTblNtfrsList[7]['tableChangeCount64']  = 1;
                                              ntTblNtfrsList[8]['tableChangeCount128'] = 1;
                                              ntTblNtfrsList[1]['rangeEnd'] = ntTblNtfrsList[21]['nTcolS']!*4;  // resetting Range Slider
                                              ntTblNotifier.value = ntTblNtfrsList;
                                              setDataSharedPref();
                                              if (csvMode==1) {MonitorFile();} else if (csvMode==2) {loadCSV(file1);} else {pickUpCSV();}  //(1: for Android, Win; 2: for Web variant)
                                            } else {
                                              if (csvMode==1) {pickUpCSV();} else if (csvMode==2) {loadCSV(file1);} else {pickUpCSV();}  //(1: for Android, Win; 2: for Web variant)
                                            } //end if
                                            //
                                            //if (isSwitchedMonitorFile!=true) {argument0 = ''; setState(() {});} else {} // Needed!  Better if arguments[0]='' but it is visible only in void main()
                                            //
                                          },
                                          onLongPress: (){    // show widget with input field to paste http adress of the shared Google Spreadsheet with notation
                                            showArrowMoveToTheLeft=false;                     // hide Arrow "Move Left"
                                            setState(() { userAbortedLoadCSV = false;  });
                                            if(isSwitchedMonitorFile==false && fromTheBegin==false) {
                                              willGoogleSpreadsheetBeLoaded = true; setState(() {});
                                              readGoogleSpreadsheetDialog();    // load notation from Google Spreadsheet
                                            } else {}
                                          }, // end onLongPress
                                          //child: Text('----'),
                                          //////////////////////////////////////  nested ternary operator:
                                          icon: fromTheBegin==false?   (isSwitchedMonitorFile==false ? Icon(Jaliinstrument.add_circle_outline, color: themeappLightDark==1 ? Color(0xD9BC86D6) : invertCustom(Color(0xD9BC86D6)!)) : Icon(Jaliinstrument.refresh)) :  Icon(Jaliinstrument.loop_alt, color: Color(0xD9BC86D6)),
                                          //////////////////////////////////////
                                          label: Align(
                                            alignment: Alignment.centerRight,
                                          //child: Text(LoadCSVBtnTx, style: const TextStyle(fontSize: 18.0, color: Color(0xD9BC86D6)),),
                                            child: Text(LoadCSVBtnTx, style:  TextStyle(fontSize: (double.tryParse(size.width.toString()))! * 0.0039 + (double.tryParse(size.height.toString()))! * 0.0018 + 13, color: themeappLightDark==1 ? Color(0xD9BC86D6) : invertCustom(Color(0xD9BC86D6)!)),),
                                          ),
                                        ),
                                      ),
                                      ),
                                    ]
                                ),
//
//
                                ConstrainedBox(
                                  constraints:BoxConstraints(
                                    minHeight:55,		 // minHeight of the Box and TextButton
                                  ),
                                  child:
                                  TextButton.icon(       //toDo: change play button style
                                    style: TextButton.styleFrom(
                                      backgroundColor: themeappLightDark==1 ? Colors.orange[50] : invertCustom(Colors.orange[50]!),
                                      //backgroundColor: toggleIcnMsrBtn ? Colors.lightGreen[700] : Colors.grey[600],
                                      elevation: 2,
                                    ),
                                    autofocus: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? true : false,     // works fine, use Enter/Space button to Play
                                    onPressed: ()  async {      // ASYNC added, AWAiT playFromList()  added
                                      if (toggleIcnMsrBtn) {
                                        setState(() {toggleIcnMsrBtn = !toggleIcnMsrBtn;});
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                        ntTblNtfrsList[5]['msrTgl'] = 1;
                                        ntTblNotifier.value = ntTblNtfrsList;
                                        showVerticalBigLables = false; setState(() {});   // hide big labels, show buttons
                                        await playFromList (0);       // ASYNC added, AWAiT playFromList()  added
                                      } else {
                                        setState(() {toggleIcnMsrBtn = true;});
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                        ntTblNtfrsList[5]['msrTgl'] = 0;
                                        ntTblNotifier.value = ntTblNtfrsList;
                                      } // end if
                                      setState(() {
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                        isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
                                        mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
                                      });
                                    }, // end onPressed
                                    icon: toggleIcnMsrBtn ? Icon(Jaliinstrument.play_circle2, color: themeappLightDark==1 ? Color(0xD9BC86D6) : invertCustom(Color(0xD9BC86D6)!)) : Icon(Jaliinstrument.stop, color: themeappLightDark==1 ? Color(0xd6f9af1e) : invertCustom(Color(0xd6f9af1e)!)),
                                    label: Align(
                                      alignment: Alignment.centerRight,
                                      child: ValueListenableBuilder<List<Map<String, int>>> (     // Do not forget to write "return", otherwise you will get a red screen
                                          valueListenable: _JaliinstrumentState.ntTblNotifier,
                                          builder: (context, ntTblNtfrsList, __) {  // Fo example: "Measures 001-054"  (measures numbers with Leading Zeroes). On most smartphones the button text will become two-line
                                            measureBtnTx = 'Measures ${(ntTblNtfrsList[4]['tableChangeCount']!*2-1).toString().padLeft(3, '0')} - ${(maxNotEmptyPos / ntTblNtfrsList[21]['nTcolS']!).ceil().toString().padLeft(3, '0')}';
                                          //return Text(measureBtnTx, style: TextStyle(fontSize: 20.0, color: Color(0xD9BC86D6)),);
                                            return Text(measureBtnTx, style: TextStyle(fontSize: (double.tryParse(size.width.toString()))! * 0.0039 + (double.tryParse(size.height.toString()))! * 0.0018 + 15, color: themeappLightDark==1 ? Color(0xD9BC86D6) : invertCustom(Color(0xD9BC86D6)!)),);
                                          }
                                      ),
                                    ),
                                  ),
                                ),
                                if(showNavButtonsForThreeSeconds) ...[
                                  Row (
                                    children: [
                                      Container(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                child:
                                                CustomPaint(
                                                  size: Size(WIDTH_0,(WIDTH_0*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                                  painter: RPSCustomPainter5(themeappLightDark: themeappLightDark),
                                                ),
                                              ) ,
                                              TextButton(
                                                onPressed: () {decreaseMeasureByButton();},
                                                child: Text(''),
                                              ),
                                            ],
                                          )
                                      ),
                                      Container(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                child:
                                                CustomPaint(
                                                  size: Size(WIDTH_0,(WIDTH_0*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                                  painter: RPSCustomPainter6(themeappLightDark: themeappLightDark),
                                                ),
                                              ) ,
                                              TextButton(
                                                onPressed: () {increaseMeasureByButton();},
                                                child: Text(''),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ] else ...[
//
                                ],
//
//
                                SliderTheme(                                            // Tempo Slider
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: themeappLightDark==1 ? Colors.blueGrey[200] : invertCustom(Colors.blueGrey[200]!),
                                    inactiveTrackColor: themeappLightDark==1 ? Colors.blueGrey[100] : invertCustom(Colors.blueGrey[100]!),
                                    trackShape: RectangularSliderTrackShape(),
                                    trackHeight: 2.0,
                                    thumbColor: themeappLightDark==1 ? Colors.blueGrey[50] : invertCustom(Colors.blueGrey[50]!),
                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                    overlayColor: themeappLightDark==1 ? Colors.blue.withAlpha(32) : invertCustom(Colors.blue.withAlpha(32)!),
                                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                    //showValueIndicator: ShowValueIndicator.never,
                                    valueIndicatorColor: themeappLightDark==1 ? Colors.blueGrey[200] : invertCustom(Colors.blueGrey[200]!),
                                  ),
                                  child: Container(
                                    child: Slider(
                                      focusNode: FocusNode(),   // solved issue: "Highlighting remains visible after changes to Slider and DropdownButton widgets"
                                      autofocus: false,         // solved issue: "Slider overlay and value indicator interactive behavior on desktop"
                                      value: crntSldrValT,
                                      min: 0.1,
                                      max: 1.1,
                                      divisions: 10,
                                      label: crntSldrValT.toStringAsFixed(1), //toDo: add Log or Exp Label
                                      onChanged: isTempoSliderDisabled?null:(double valueS) {            // added slider-disable option, was   onChanged: (double valueS) {
                                            // if(    !Platform.isLinux    ) {playerInitWithEmptyNote();} else {}  // initialize player and wait 0.8 seconds
                                        setState(() {
                                          crntSldrValT = valueS;
                                        }); //end setState
                                      },  //end onChanged
                                    ),
                                  ),
                                ),
                              ] else ...[], // end if (hideControlsForScreenshotMode)
//
                              InkWell(
                                onTap: (){
                                  if (hideControlsForScreenshotMode) {
                                    if (toggleIcnMsrBtn) {
                                      setState(() {toggleIcnMsrBtn = !toggleIcnMsrBtn;});
                                      ntTblNtfrsList = [...ntTblNotifier.value];
                                      ntTblNtfrsList[5]['msrTgl'] = 1;
                                      ntTblNotifier.value = ntTblNtfrsList;
                                      playFromList (0);
                                    } else {
                                      setState(() {toggleIcnMsrBtn = true;});
                                      ntTblNtfrsList = [...ntTblNotifier.value];
                                      ntTblNtfrsList[5]['msrTgl'] = 0;
                                      ntTblNotifier.value = ntTblNtfrsList;
                                    } // end if
                                  } else {
                                    showNavButtonsForSomeSeconds();
                                    //
                                  } // end if (screenshot Mode entered)
                                  setState(() {
                                    ntTblNtfrsList = [...ntTblNotifier.value];
                                    isSwitched_32_64_128 = ntTblNtfrsList[15]['listener_32_64_128']!;
                                    mode_3264_or_64128 = ntTblNtfrsList[16]['listener_3264_64128']!;
                                  });
                                },
                                onLongPress: () {
                                  hideControlsForScreenshotModeByLongPress();
                                },
                                child:
                                Align (
                                  alignment: Alignment.topCenter,
                                  child:
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child:
                                    Text(
                                      tempperformrsInfo,
                                      style: TextStyle(fontFamily: 'Google_GHR', fontSize: 28.0, color: themeappLightDark==1 ? Colors.black87 : Colors.orange),
                                      overflow: TextOverflow.fade,    // fade if it does not fit in width   (fading the end of the text)
                                      //overflow: TextOverflow.clip,
                                      softWrap: true,
                                    ), //Google_GHR, see pubspec.yaml
                                  ),
                                  //Text(tempperformrsInfo, style: TextStyle(fontStyle: FontStyle.normal)),
                                ),
                              ),
                              if (hideControlsForScreenshotMode) ...[
                                Align (
                                  alignment: Alignment.topCenter,
                                  child:
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: ValueListenableBuilder<List<Map<String, int>>> (     // Do not forget to write "return", otherwise you will get a red screen
                                        valueListenable: _JaliinstrumentState.ntTblNotifier,
                                        builder: (context, ntTblNtfrsList, __) {
                                          return Text('${ntTblNtfrsList[4]['tableChangeCount']!*2-1}', style: TextStyle(fontSize: 58.0, color: themeappLightDark==1 ? Colors.black87 : invertCustom(Colors.black26)));
                                        }
                                    ),
                                  ),
                                  //Text(tempperformrsInfo, style: TextStyle(fontStyle: FontStyle.normal)),
                                ),
                              ] else ...[], //end if (hideControlsForScreenshotMode) second
                              // Container(
                              //   child:
                              //   CustomPaint(
                              //     size: Size(WIDTH_0,(WIDTH_0*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                              //     painter: RPSCustomPainter1(),
                              //   ),
                              // ) ,
                            ],
                          ) :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ pitch_detector (tuner) with audio_capture  4 of 4
                          Column(children: [
                            Center(
                                child: Text(
                                  currDetectedNote,
                                  style: TextStyle(
                                      color: themeappLightDark==1 ? Color.fromARGB(255, 236, 162, 9) : invertCustom(Color.fromARGB(255, 236, 162, 9)!),
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            const Spacer(),
                            Center(
                                child: Text(
                                  currTuneStatus,
                                  style: TextStyle(
                                    //color: Colors.black87,
                                      color: themeappLightDark==1 ? Color.fromARGB(255, 168, 116, 3) : invertCustom(Color.fromARGB(255, 168, 116, 3)!),
                                      fontSize: 18.0,                                   // was 18.0
                                      fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: FloatingActionButton(
                                                onPressed: _startCapture,
                                                child: const Text("Start")))),
                                    Expanded(
                                        child: Center(
                                            child: FloatingActionButton(
                                                onPressed: _stopCapture, child: const Text("Stop")))),
                                  ],
                                )),
                            const Spacer(),
                            Center(
                                child: Text(
                                  tunerNotSupportedTextPlatformDepending,
                                  style: TextStyle(
                                    //color: Colors.black87,
                                      color: themeappLightDark==1 ? Color.fromARGB(255, 168, 116, 3) : invertCustom(Color.fromARGB(255, 168, 116, 3)!),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                )),
                          ]),
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ end pitch_detector (tuner) with audio_capture  4 of 4
                        ),
                      ),
//
                      SizedBox(
                        width: width23a,
                        child: SizedBox.expand(
                          child: Stack(
                            alignment: Alignment.center,      // is Solution how to Align center, do not need to change base point of CustomPainter or it's width
                            children: <Widget>[
                              if (showVerticalBigLables == true) ...[
                                Container(
                                  child: CustomPaint(
                                    size: Size(WIDTH_8,(WIDTH_8*8.75).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: RPSCustomPainter9(themeappLightDark: themeappLightDark),
                                    //painter: (size.width <= pxlsWidth) ? RPSCustomPainter9() : RPSCustomPainter9a(),    // Left-Aligned or Variant1 (for wide media query)
                                  ),
                                ) ,
                              ] else ...[
                                //
                              ],
                              Column(                                       // Column is above the paintings !!! To buttons may work!
                                children: [
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,  // maybe "_" came up with to easy find a method
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(0, keysColorsList[0], fontSize, buttonsPS[0]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(1, keysColorsList[1], fontSize, buttonsPS[1]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(2, keysColorsList[2], fontSize, buttonsPS[2]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(3, keysColorsList[3], fontSize, buttonsPS[3]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(5, keysColorsList[5], fontSize, buttonsPS[5]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(7, keysColorsList[7], fontSize, buttonsPS[7]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(9, keysColorsList[9], fontSize, buttonsPS[9]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(11, keysColorsList[11], fontSize, buttonsPS[11]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(13, keysColorsList[13], fontSize, buttonsPS[13]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(15, keysColorsList[15], fontSize, buttonsPS[15]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        return buildKeyRight(17, keysColorsList[17], fontSize, buttonsPS[17]['prsd']!, buttonsPS[24]['fngr']!);
                                      }),
                                  ValueListenableBuilder<List<Map<String, bool>>>(
                                      valueListenable: _JaliinstrumentState.buttonsNotifier,
                                      builder: (_, buttonsPS, __) {
                                        if(stringsNum==21) return buildKeyRight(0, keysColorsList[0], fontSize, buttonsPS[0]['prsd']!, false);
                                        if(stringsNum==22) return buildKeyRight(21, keysColorsList[21], fontSize, buttonsPS[21]['prsd']!, false);
                                        throw '';
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
////////////////////////////////////////////////////////////////////////
            )
        ),
      ),
    );
//
  } //end Widget Build
//
//
///////////////////////////////// midi support part 3 of 3 (only for Web)/////
  void midiPlay(int midi) {
    if (playerMode==3) {                      // !!! was kIsWeb, replaced by !kIsWeb with "!"
// flutterMidi.playMidiNote(midi: midi);      // flutter_midi: commented 6 of 6
    } else {}
  } // end void midiPlay
////////////////////////////////// end midi support part 3 of 3///////////////
//
//
} // end class _JaliinstrumentState // toDo: end class _JaliinstrumentState
//
//
// --------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------------------------------------- //
// DART-Lang, Musical Tuition Project: African Harp Kora : Player, NotationReader, Tuner:  multi-Platform    //
// --------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------------------------------------- //