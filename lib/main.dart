//********************************************************************************************************//
//
//                     * * * * * JaliNativeInstrument * * * * *    *****Developer: misis2009@gmail.com *****
//
//********************************************************************************************************//
// DART-Lang, Musical Tuition Project: African Harp Kora : Player, NotationReader, Tuner:  multi-Platform //
//********************************************************************************************************//
/////////////////////////////////////////////////
import 'package:desktop_window/desktop_window.dart';              // setting Window Size for Desktop App (Win, Linux, MacOS)
import 'dart:math';
//
// to generate: you should give a command in terminal "flutter pub run flutter_launcher_icons"     // Uncomment this when you need to Generate app platform icons:
//-------------------------------------------------------------------------------------------
/*
import 'package:flutter_launcher_icons/abs/icon_generator.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/config/config.dart';
//import 'package:flutter_launcher_icons/config/config.g.dart';     // some error
import 'package:flutter_launcher_icons/config/macos_config.dart';
//import 'package:flutter_launcher_icons/config/macos_config.g.dart';     // some error
import 'package:flutter_launcher_icons/config/web_config.dart';
//import 'package:flutter_launcher_icons/config/web_config.g.dart';     // some error
import 'package:flutter_launcher_icons/config/windows_config.dart';
//import 'package:flutter_launcher_icons/config/windows_config.g.dart';     // some error
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
*/
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
import 'package:jalinativeinstrument/dropdown_tuningFromDropDown_box.dart';     // custom drop-down menu
import 'dart:async' show Future;
import 'package:async/async.dart';                        // for cancelable operation
import 'dart:ffi' hide Size;                              // Hide Size !!!   Needed !!!  It contains also in dart:io    !!!  Do not delete !!
import 'dart:io';
import 'dart:io' show File, Platform;
import 'package:csv/csv.dart';                            // converting csv
import 'package:csv/csv_settings_autodetection.dart';     // autodetection csv dilimeters
import 'package:flutter/foundation.dart' show ByteData, debugDefaultTargetPlatformOverride, kDebugMode, kIsWeb; // in release mode it should be so
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart'; // toDo: 2of5 try Web without audioplayers (look pubspec.yaml also! 1of5)
                                                 // toDo: 3of5   dart pub remove audioplayers  ,   dart pub get audioplayers
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
// Make these changes in file:     android/app/build.graddle
//    defaultConfig {
//         minSdkVersion 21            // need for flutter audio capture and pitchUp dart (chromatic tuner)
// //minSdkVersion flutter.minSdkVersion
//
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:permission_handler/permission_handler.dart';  // for tuner Mic permission request and Java error prevention
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ end pitch_detector (tuner) with audio_capture  2 of 4
import 'package:real_volume/real_volume.dart';                         // to suggest to reduce sound volume if it is too high (Android, iOS)
import 'package:keep_screen_on/keep_screen_on.dart';                   // so that the user has enough time to tune using the chromatic tuner
////////////////////////////  https://pub.dev/packages/fluttericon/install  /////////////////////////////
// (here was import from this Link)
// import removed, you can find it any time by this link
//
// toDo: Build Options, choose depending on Build Platform before starting build: after automatic switch added (see void main()) these options does not effect, except WEB !!!
// INTO VOID MAIN() ADDED AUTOMATICALLY CHOSE OF PLATFORM (WIN,ANDROID,MACOS,IOS,LINUX), SO SIMPLY USE "FLUTTER BUILD APK", "FLUTTER BUILD WINDOWS", ("FLUTTER BUILD APK --no-tree-shake-icons", "FLUTTER BUILD WINDOWS --no-tree-shake-icons")
// AUTOMATIC SWITCH SOLUTION FOUND: SEE VOID MAIN()  !!!                        USE DOUBLE SPACE or DOUBLE SLASH     for Comment/Uncomment
////////////////////////////////////////////   Build Options  //////////////////////////////////////////// Recommended variants: 1,2 and 5
//   int csvMode = 1; int playerMode = 2; int extension = 1;  double mS =  10; // Windows---WAV--***EXE   (some notes stop sounding on Android, so for Android - another build option)                                                (if plays Slow, it's Power Save Mode of Notebook)
     int csvMode = 1; int playerMode = 1; int extension = 1;  double mS =  10; // Android,MacOS---WAV--***APK, MacOS***APP,***DMG, yes you can create DMG (like installer) via Node.js "create-dmg"      (if plays Slow, it's hash table mode, comment Windows)
//   int csvMode = 2; int playerMode = 4; int extension = 3;  double mS = 22;  // Web-Synth-Tone.JS-***JS toDo: (add manually Script to index.html) Many setState() cause Noise! Sounds like web midi Synth without delay at all
//// int csvMode = 2; int playerMode = 1; int extension = 2;  double mS = 22;  // Web------m4a--------   (too slow! Do not use this at all, sound disappear)
//   int csvMode = 2; int playerMode = 5; int extension = 3;  double mS =  6;  // Web--m4a-via-Tone.JS***JS toDo: (1 of 4: add manually Script to index.html; 2 of 4: add manually Script to index.html) Works Great! To protect JS code from copying recommends (try to) transfer JavaScript to TypeScript
//  toDo: (3 of 4): if you use "Web--m4a-via-Tone.JS--JS" then in file "dropdown_tuningFromDropDown_box.dart" leave only "Ionian", "Lydian" (only those listed in JavaScript)
//  toDo: Minimum setState()'s !!! Slows Down!  // Tone.js make insignificant Noise // Commented: Midi 14Mb SF2 Asset was Commented "#" in pubspec.yaml to reduce APK
//  toDo: (4 of 4): if you build Web/Windows: un-/comment import "dart:js" and js.context.callMethod("playNoteSynth ... and js.context.callMethod("playNote ... methods  AND "import dart:js" // (Windows will not work with dart:js)
//   int csvMode = 2; int playerMode = 3; int extension = 3; const double mS = 19; // Android, iOS ----Midi SF2  // (int "extension" you may not specify)
//   also special const "!kIsWeb" from foundations may be used to check if compiled for web     // Midi functions commented, but they worked well
////////////
//
////  int csvMode = 1;                 //   =1 Android, Windows (Load File from Any place)   ?iOS?
////  int csvMode = 2;                 //   =2 Web: Only One File from assets                ?iOS?
//                                     //
////  int playerMode = 1;              //   =1 Android (simple Player, 350Mb, No Memory Leaks at all)         ?Web?
////  int playerMode = 2;              //   =2 Windows (Memory Leak more than 1Gb if not use this solution: hashTable of keys:AudioPlayers)
//                                                    Memory Leak Win successfully resolved!
// toDo: select with what kind of playing functions build project (playing wav,m4a,none,mp3)
//  int extension = 1; // using WAV     (62 Mb, perfect quality; Android, Windows,   ?iOS?) toDo: select build with: WAV, m4a or MP3
//  int extension = 2; // using m4a     (5,5 Mb poor quality, maybe Web)
//  int extension = 3; // silent, without calling players at all     (maybe for Web, audio imports can be removed)
//  int extension = 4; // using mp3     (10 Mb, middle quality, any application)
/////////////////////////////////////////////// End Build Options ////////////////////////////////////////
/////////////////////////////////////////////// Declare Global Variables: ////////////////////////////////////////////////////////////////
//var player = AudioPlayer(); // if declare here, sounds non-simultaneously
//final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);    // ReleaseMode you may not specify
//List<AudioPlayer> audioPlayersList = []; // List of audioplayers, to dispose each one personally
const int mSsW = 4; // minimum possible additional delay for every bit until stopwatch elapsedMilliseconds < 200
Map <String,AudioPlayer> audioPlayersMap = {}; // Map of many AudioPlayerS
String dropdownValue = "Lydian";       // default tuning for Drop Down Menu
double fontSize = 18.0;  // default font size, Left and Right buttons Text
double fontSizeCnt = 16.0;
int pxlsWidth = 600;     // it's Not a Pixels!!! default boundary width, for values less than or greater than Switches Text Alignment
double noteVolume = 0.9; // default personal volume of each note, or common volume (if value does not change while playing), =0.1,0.2...0.9,1.0; default =0.9
double noteVolumeBack = noteVolume; // to restore volume after stop, so that the sound of pressing individual buttons can be heard
double tempoCoeff = 1.0; // extends tempo diapason, default =1
// toDo: delay stall at a correction factor higher then 1.3
// const double mS = 19;   //ms 70/3=23    Windows, Android, Web, ?iOS?     // minimum possible duration, ms  (for measure tempo tuning) mS 70
// const mS = 5;        //ms 0          ?Web -No                         // 5mS is excessively small, and 19mS is optimal; do NOT try WEB  mS 5
// toDo: End Build Options
bool isReadOnce = false;  // for suggested variant of tuning read from csv
int maxNotEmptyPos = 1;   // for text on button measure
String measureBtnTx = 'Measures 1 - ...'; // for text on button measure
String LoadCSVBtnTx = 'Load csv/tsv File';
String tempperformrsInfo = '';          // performers info
int stringsNum = 21;                    // default number of strings, default =21
String file1 = 'assets/csv/sample01.csv';                   // Type String
File notationCsvFile = new File(file1);                     // Type File
double crntSldrValT = 1.0;                                    // Tempo Slider default value =1.0
bool toggleIcnMsrBtn = true;                                  // toggle (switch) Play|Stop Icon on TextButton
bool fromTheBegin = false;                                     // toggle (switch) Play|Stop from the begin of the file or from the begin of the current table view
int maxLength = 1;                                            // max Length of List to PlaySound
/////Change it here:///////// !!! strict EVEN, Not Odd /////////// Notation Table Columns Number:    //Widget Rebuild with thousands elements is very expensive!!!
int nTcolSHalf  = 8;    //default:8 is quarter of 64view (could be: 8,16,32,64...till slow down)     // notation Table Columns Number (number of bits)
//////////////////////////////////////////////////////////////////
int  isSwitched_32_64_128 = 64;  // 32   64   128                           // switching by short press and
int  mode_3264_or_64128 = 3264;  // 3264    64128                           // by a long press
int nTcolSN = 2*nTcolSHalf;       // 64
int nTcolS = nTcolSN;             // Normall of Default 64
int nTcolSDouble = 2*nTcolSN;     // 128
var rngEnd = 4*nTcolSN;           // for 64  is  128           // end range of the RangeSlider Depends on Cols Number (allways x2   32 is 64   64 is 128   128 is 256)
int playingBit = 1;                                            // currently playing bit (j) by playFromList() for cursor visualize
double centralColumnHeaderHeigth = 20;                        // central column above table block height
double nTtbLHeight = 126;   //toDo: put table into Container  // tailored height of the Notation Table (depends of edge insets=1 and font size=3)
//                  // cols1 is allways 22 (does not matter settings parameter number of strings)
const cols1 = 22;   // The Best Way to initialize filled List // Number of cells vertically in empty table (transpose!)
// it works also with 2*nTcolS, but when we changing view from 32 to 64 with empty data1, error occurs, so 4*nTcolS:
int rows1 = 4*nTcolS;   //default:64. To prevent index error  // Number of cells horizontally in empty table
final array1 = List.generate(rows1,(i) => List.generate(cols1 + 1, (j) => '', growable: true), growable: true); // fill up with '' ALL the list; the best way to fill up the List
List<dynamic> data1 = List.from(array1).transpose;
//List<List<dynamic>> data2 = [];                              // ? NotUsed List of Lists, every element as List of elements, contains nTcolS*2 Columns                                                   // if "---" then: default Lydian (4)
////////////////////////////////////////// Used in DropDown Menu Too, part 1 of 3//////////////////
Map<int,String> tuneMap = { 1 : "Aeolian", 2 : "Hardino", 3 : "Ionian", 4 : "Lydian", 5 : "Phrygian", 6 : "Sauta", 7 : "Silaba (extreme)", 8 : "Silaba or Tomora ba", 9 : "Tomora Mesengo", 11 : "Ionian (Malian kora)", 12: "Lydian (Malian kora)"};
Map<String,int> tuneMapRvrsd = { "Aeolian" : 1, "Hardino" : 2 , "Ionian" : 3 , "Lydian" : 4 , "Phrygian" : 5 , "Sauta" : 6 , "Silaba (extreme)" : 7 , "Silaba or Tomora ba" : 8 , "Tomora Mesengo" : 9, "---" : 4, "Ionian (Malian kora)" : 11, "Lydian (Malian kora)" : 12};
///////////////////////////////////////////////////////////////////////////////////////////////////
//////// non-default buttons labels and colours:      // List begins from 0 and ends at 23 (summary 24 elements) !!!  Null error in widget solution is 0:""
Map<int,String> stringsDiamMapVariant1 = {0:"",1:"0.55mm",2:"0.55mm",3:"0.55mm",4:"0.55mm",5:"0.6mm",6:"0.6mm",7:"0.7mm",8:"0.7mm",9:"0.7mm",10:"0.8mm",11:"0.8mm",12:"0.9mm",13:"1.0mm",14:"1.0mm",15:"1.2mm",16:"1.2mm",17:"1.3mm",18:"1.4mm",19:"1.5mm",20:"1.6mm",21:"1.7mm",22:"2.2mm",23:"-mm"};
Map<int,String> stringsDiamMapVariant2  = {0:"",1:"0.50mm",2:"0.50mm",3:"0.50mm",4:"0.65mm",5:"0.65mm",6:"0.65mm",7:"0.75mm",8:"0.75mm",9:"0.75mm",10:"0.85mm",11:"0.85mm",12:"1.0mm",13:"1.0mm",14:"1.0mm",15:"1.2mm",16:"1.2mm",17:"1.2mm",18:"1.4mm",19:"1.4mm",20:"1.6mm",21:"1.6mm",22:"1.8-2.0",23:"-mm"};
Map<int,String> stringsLbMapToVariant2   = {0:"",1:"30 lb",2:"30 lb",3:"30 lb",4:"40 lb",5:"40 lb",6:"40 lb",7:"60 lb",8:"60 lb",9:"60 lb",10:"70 lb",11:"70 lb",12:"100 lb",13:"100 lb",14:"100 lb",15:"120 lb",16:"120 lb",17:"120 lb",18:"160 lb",19:"160 lb",20:"180 lb",21:"180 lb",22:"200-300 lb",23:"- lb"};
void fillVariant1ColorsList() {
  keysColorsList[1]=keysColorsList[2]=keysColorsList[3]=keysColorsList[4]=Colors.blueGrey;
  keysColorsList[5]=keysColorsList[6]=Colors.deepPurpleAccent;
  keysColorsList[7]=keysColorsList[8]=keysColorsList[9]=Colors.red;
  keysColorsList[10]=keysColorsList[11]=Colors.brown;
  keysColorsList[12]=Colors.green;
  keysColorsList[13]=keysColorsList[14]=Colors.blue;
  keysColorsList[15]=keysColorsList[16]=Colors.pink;
  keysColorsList[17]=Colors.deepPurpleAccent;
  keysColorsList[18]=Colors.blue;
  keysColorsList[19]=Colors.red;
  keysColorsList[20]=Colors.green; keysColorsList[21]=Colors.black54; keysColorsList[22]=Colors.blueGrey; keysColorsList[23]=Colors.blueGrey;
}
void fillVariant2ColorsList() {
  keysColorsList[1]=keysColorsList[2]=keysColorsList[3]=Colors.blueGrey;
  keysColorsList[4]=keysColorsList[5]=keysColorsList[6]=Colors.deepPurpleAccent;
  keysColorsList[7]=keysColorsList[8]=keysColorsList[9]=Colors.red;
  keysColorsList[10]=keysColorsList[11]=Colors.cyan;
  keysColorsList[12]=keysColorsList[13]=keysColorsList[14]=Colors.blue;
  keysColorsList[15]=keysColorsList[16]=keysColorsList[17]=Colors.pink;
  keysColorsList[18]=keysColorsList[19]=Colors.blue;
  keysColorsList[20]=Colors.green; keysColorsList[21]=Colors.black54; keysColorsList[22]=Colors.blueGrey; keysColorsList[23]=Colors.blueGrey;
}
//////// end non-default buttons labels and colours
//// how to get key by value:
//// var key1 = tuneMap.keys.firstWhere((k) => tuneMap[k] == tuningName, orElse: () => 4); // not work inside async,  reverse Map
var reversedTuneMap = tuneMap.map((k, v) => MapEntry(v, k));  // reversed Map
List<Map<String, bool>> buttonsPS = []; // List of Maps !!! State of the both side columns of buttons
bool cancelDelay1 = false;
List<String>csvListOfFiles = [];
// List<Map<String, int>> bitStateList = []; // Not Used At All! // List of Maps !!! State of 1) notation table startBit, 2) animated cursor position
List<Map<String, int>> ntTblNtfrsList    = []; // List of Maps !!!
bool isSwitchedMonitorFile = false;
String tempSMonitor = '';
bool wasTSVextDetected = false;
bool oneTraversingInstanceLaunched = false;  // prevention of double- or even triple-start
String ntTableCaptionTxt_0 = '〇⬤〇  long press available  ';             // three circle symbols (16 32 64 indicator)
String ntTableCaptionTxt = '';                                                       // does not fit in size on smartphones if previous "ntTableCaptionTxt_0" is not equal ''
String tapMadeOnUpperOrLowerTable = 'None';  // temp, only for Debug printing output
bool hideControlsForScreenshotMode = false;
int buildKeysNotesOrFreqsMode = 0;           // 0 = display notes, 1 = display frequencies precisely (machine heads), 2 = display frequencies roughly (wooden pegs), 3 = strings diameter in mm
double WIDTH_0 = 70;                          // custom paint at the central column, bottom
double WIDTH_1 = 90;                          // wooden peg and measuring tool width for custom painter TWO (on upper right Button)
double WIDTH_2 = 80;                          // machine head width for custom painter ONE
// double WIDTH_3
double WIDTH_8 = 80;                         // vertical text label Jalinativeistriment, view from the Left
double WIDTH_9 = WIDTH_8;                     // vertical text label Jalinativeistriment, view from the Right
bool showVerticalBigLables = false;           // showing big vertical text labels Jalinativeistriment in Stack at the left ant at the right
double WIDTH_10 = 50;
double WIDTH_11 = 50;                         // Fingers: Index and Thumb
double WIDTH_12 = 50;
double WIDTH_13 = 50;
double WIDTH_14 = 50;
double WIDTH_15 = 240;                        // arrow with text "move left" for stack under the Range Slider (shown after Completion Naturally)
bool showArrowMoveToTheLeft=false;            // true = show arrow with text "move left"
bool showNavButtonsForThreeSeconds=false;     // true = show Navigate Buttons (to Change Up and Down Measure Number)
List<int> showFingeringOnButtons = [];        // show Index fingers = 1 and Thumb fingers = 0 on buttons in stack (right or left by context: buildKeyRight or buildKeyLeft)
List<Color> keysColorsList = [];              // text on keys and guestures press button effect background colors
String crc32trackPerfInfo = '';               // checksum of track_performer info string
List<double> sym_font = [12, 12, 12];         // only for Android: 〇⬤〇     ⬤ is smaller than 〇
List<String> ntTableCaptionTxt_0_sym = ['','',''];
String stringKeySharedPref = '';              // string key = crc32 checksum of track_performer info
String stringValSharedPref = '';              // string value, contains last seen mode (32/64/128), measure number, selected range
bool tapCollisionPrevention = false;          // so that the cursor doesn't run away, waiting for previous tapping ends
bool clearRangeSharePref = false;             // for delete shared pref for opening file (keeping ranges individual for each file by performer's info CRC32 checksum) by Right coincidence of a Range Slider and pressing multi-purpose button
bool clearRangeSharePrefA = false;
bool isTunerModeEnable = false;               // central column (Width 54%) is used to show: 1) main table and controls, 2) tuner pitch up functions (Android and maybe iOS)
String tunerNotSupportedTextPlatformDepending = "";
bool isCustomKeepScreenOn = false;            // for 3-minute timer to keep screen on while chromatic tuner in use
///////////////////////////////////////////////////////////////////////// custom materialColour: see "Background of Objects: custom materialColour" at MaterialApp returning
extension ToMaterialColor on Color {                                                      // not work ???  or Not Needed?
  MaterialColor get asMaterialColor {
    Map<int, Color> shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]            // because MaterialColor requires shades
        .asMap()
        .map((key, value) => MapEntry(value, withOpacity(1 - (1 - (key + 1) / 10))));
    return MaterialColor(value, shades);
  }
}                                                                                         // all block not work ???  or Not Needed?
/////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////// End Global Variables declaration and assignment ///////////////////////////////////////////
//
//
void main() {         // void main()
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;    // for build release
  //runApp(MaterialApp(home: Jaliinstrument(),),);                // app runs here, class exemplar creates here
  runApp(const MyApp());
  //-----------------------------------------------------------------------------------------------
  if (Platform.isWindows) {     // condtitional Build imitation (see also for "conditional Import"):
    csvMode = 1;  playerMode = 2;  extension = 1;  mS =  10; // Windows---WAV--***EXE   (some notes stop sounding on Android, so for Android - another build option)                                    (if plays Slow, it's Power Save Mode of Notebook)
  }
  else if (Platform.isAndroid || Platform.isMacOS  || Platform.isIOS || Platform.isLinux) {
    csvMode = 1;  playerMode = 1;  extension = 1;  mS =  10; // Android,MacOS---WAV--***APK, MacOS***APP,***DMG, yes you can create DMG (like installer) via Node.js "create-dmg"      (if plays Slow, it's hash table mode, comment Windows)
  }
  else {}
  //-----------------------------------------------------------------------------------------------
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
  //////////////////////////////////////////////////////  https://www.fluttericon.com/
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
// affects on tempo speed, now it is keeping tempo:
// 1) WidgetsBindingObserver (Android, macOS, iOS), toDo: still accelerates on its own on startUp, but does not slows down !!!
// 2) inkWell (Windows)                             toDo: does not freeze when part of widget rebuilds by valuelistenerBuilder
class _JaliinstrumentState extends State<Jaliinstrument> with WidgetsBindingObserver{   //observer variant: 1) to detect is app in foreground or background in Android, 2) for keep screen on while using chromatic tuning
/////////////////////////////////////////////// end foreground/ background observer for android 1 of 3 ///////////////////////
//
///////////// real volume 1 of 2 ///////////////                      // to suggest to reduce sound volume if it is too high (Android, iOS)
  StreamType? selectedStreamType = StreamType.MUSIC;                  // alarm/ music/ notifications/ ring/ system/ voice_call
  double currentVolume = 0;
//////////////end real volume 1 of 2 ///////////
//
Future getAndSetWindowSize() async {
  Size fullScreenSize = await DesktopWindow.getFullScreen();
  ntTableCaptionTxt = await fullScreenSize.toString(); setState(() {});
  if(fullScreenSize.height > 1600) {
    await DesktopWindow.setWindowSize(Size(1300,1600));  // Setting Desktop Window Size // SEE: "windows/runner/main.cpp" to setUp OriginPoint
  } else {} //end if
} // end getAndSetWindowSize via
///////////////// Replacing setState()s with Value NotifierAndBuilder Listener  (1 of 4) //////////// Increase performance without reloading the widget
// When the value is replaced with something that is not equal to the old value as evaluated by the equality operator ==, this class notifies its listeners
static final ValueNotifier<List<Map<String, bool>>> buttonsNotifier = ValueNotifier([]); // Creates a ChangeNotifier that wraps this value
void addButtonsStates(int btnNum, bool locFing) {                        // See also SplayTreeMap (Sorted! HashMap), "Splay"!
  // final List<Map<int, bool>> buttonsPS = [...buttonsNotifier.value]; // "..." !!! If you want to get previous values!
  if (btnNum==0)  {
    buttonsPS.clear();
    for (int i = 0; i < 24; i++) {        // to prevent Range error: max index is 23
      buttonsPS.add({'prsd' : false});    // List of unsorted HashMapS (no need to Sort, it's primitive!)
    } //end for
      buttonsPS.add({'fngr' : false});    // for Local showFingering              24th element
    buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
  } else {
    buttonsPS = [...buttonsNotifier.value]; // "..." !!! it is called "Spread operator"
    buttonsPS[btnNum]['prsd'] = true;
    if (locFing==true) {buttonsPS[24]['fngr'] = true;} else {};
    buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
  } // end if()
} // end addButtonsStates()
void releaseButtonsStates(int btnNum) {
  buttonsPS = [...buttonsNotifier.value]; // "..." !!! it is called "Spread operator"
  if (btnNum==0)  {
    for (int i = 0; i < 24; i++) {
      buttonsPS[i]['prsd'] = false;
    } //end for
    buttonsPS[24]['fngr'] = false;
    buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
  } else {
    buttonsPS[btnNum]['prsd'] = false;
    buttonsPS[24]['fngr'] = false;
    buttonsNotifier.value = buttonsPS;  // here List attached to Notifier
  } // end if()
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
  /*    @override
          void initState() {        // after ANY .dispose() !!!
            super.initState();
          }       */
  void fillDefaultColorsList() {
    ///////////////////////////////////////////// keys Colors: /////////////////////////////////////////////
    Color key0Color = Colors.blueGrey;
    Color key1Color = Colors.red;
    Color key2Color = Colors.green;
    Color key3Color = Colors.blue;
    Color key4Color = Colors.red; // Left
    Color key5Color = Colors.deepPurpleAccent;
    Color key6Color = Colors.green; // Left
    Color key7Color = Colors.redAccent;
    Color key8Color = Colors.blue; // Left
    Color key9Color = Colors.black54;
    Color key10Color = Colors.deepPurpleAccent; // Left
    Color key11Color = Colors.pink;
    Color key12Color = Colors.redAccent; // Left
    Color key13Color = Colors.red;
    Color key14Color = Colors.black54; // Left
    Color key15Color = Colors.green;
    Color key16Color = Colors.pink; // Left
    Color key17Color = Colors.blue;
    Color key18Color = Colors.red; // Left
    Color key19Color = Colors.green; // Left
    Color key20Color = Colors.blue; // Left
    Color key21Color = Colors.deepPurpleAccent;
    Color key22Color = Colors.deepPurpleAccent; // Left
    Color key23Color = Colors.blueGrey; // Left
////// keyColors List for filling: //////
    keysColorsList.clear();    // List begins from 0 and ends at 23 (summary 24 elements) !!!
    keysColorsList.add(key0Color );keysColorsList.add(key1Color );keysColorsList.add(key2Color );keysColorsList.add(key3Color );
    keysColorsList.add(key4Color );keysColorsList.add(key5Color );keysColorsList.add(key6Color );keysColorsList.add(key7Color );
    keysColorsList.add(key8Color );keysColorsList.add(key9Color );keysColorsList.add(key10Color);keysColorsList.add(key11Color);
    keysColorsList.add(key12Color);keysColorsList.add(key13Color);keysColorsList.add(key14Color);keysColorsList.add(key15Color);
    keysColorsList.add(key16Color);keysColorsList.add(key17Color);keysColorsList.add(key18Color);keysColorsList.add(key19Color);
    keysColorsList.add(key20Color);keysColorsList.add(key21Color);keysColorsList.add(key22Color);keysColorsList.add(key23Color);
    /////////////////////////////////////////// End keys Colors ///////////////////////////////////////////
  }
  void fillDefaultFingeringList() { // zero element and 24-th element are ignored (they are not music keys)
    showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);
    showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);
    showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);showFingeringOnButtons.add(1);showFingeringOnButtons.add(0);
    showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);
    showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);
    showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);showFingeringOnButtons.add(0);showFingeringOnButtons.add(1);
  }
  @override
  void initState() {
    fillDefaultColorsList();  //CALL
    fillDefaultFingeringList(); //CALL
    addButtonsStates(0,false); // filling buttons states List for Value NotifierAndBuilder Listener (2 of 4)
    addNtTblNotifierStates();
///////////////////////////////// midi support part 1 of 3 (only for Web)/////    // Special constant kIsWeb
//   if (playerMode==3) {loadSF2(midiValue);} else {flutterMidi.prepare(sf2: null);}  // flutter_midi: commented 3 of 6
//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////  foreground/ background observer for android 2 of 3  ///////////////////////
    WidgetsBinding.instance.addObserver(this);
/////////////////////////////////////////////// end foreground/ background observer for android 2 of 3  ///////////////////////
  //getdataSharedPref();    //CALL  //no needed
//////////
    super.initState();
    //getAndSetWindowSize();  // setting Window Size for Desktop App (Win, Linux, MacOS) toDo: NotWork! // SEE: "windows/runner/main.cpp" to setUp OriginPoint
    if(tempSMonitor == '') {DesktopWindow.setWindowSize(Size(1600,1600));} else {} //end if  // Setting Desktop Window Size // SEE: "windows/runner/main.cpp" to setUp OriginPoint
    showBigLabelsShortly();
    showVerticalBigLables = false; // hide big labels at both side if they were shown
  } //end initState ()
//
  Future<void> showBigLabelsShortly() async {
    // //// show big labels shortly
    showVerticalBigLables = true; setState(() {});    // show
    await Future.delayed(const Duration(seconds: 2)); // pause 2 seconds
    showVerticalBigLables = false; setState(() {});   // hide
    // //// end show big labels shortly
  }
//
///////////////////////////////////////////////  foreground/ background observer for android 3 of 3  ///////////////////////
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {        // after SDK upgrade it stops in background in Windows Too, earlier it was only in Android
//    if(csvMode == 1 && playerMode == 1) {                           // stop playback if in background on Android, MacOS. And do not stop if Windows
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
//  String midiValue = 'assets/Piano.sf2';                                           // flutter_midi: commented 5a of 6
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
  List<List<dynamic>> dataF = [];                       // for playSound, not for visual, base for data1 (visual)
  List<List<dynamic>> dataFbak = [];                    // backup dataF if read CSV error
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
              fieldDLMTr = '\t';                                                                    // TAB
            } else {
              fieldDLMTr = ';';                                                                     // Semicolon
            } //end if TSV or CSV was detected
    List <List> csvToList1 (File notationCsvFile) {
      //csv.CsvToListConverter tempC = new csv.CsvToListConverter(eol: "\r\n", fieldDelimiter: ";");
      csv.CsvToListConverter tempC = new csv.CsvToListConverter(eol: "\r\n", fieldDelimiter: "$fieldDLMTr");
      List<List<dynamic>> listCreated = tempC.convert(notationCsvFile.readAsStringSync());
      return listCreated;
    }
    dataF.clear();
    dataF = await csvToList1(notationCsvFile);
    setState(() {       // use matrix2d package to transpose Rows to Cols //the last non-empty element could be defined by Excel itself when exporting (but we have not undiscovered cell range)
      dataF = List.from(dataF.transpose);
    });
    await loadTagsFirst();
    //setState(() {isLoadingCSV = false;}); // moved to the end of the loadTagsFirst()
  } // end readCsvFeautr() async
//
//
//toDo: FILE PICKER       (Open File Dialog)                  !!! WORKS WEB (* -[path]), WIN, ANDROID, MacOS !!!
  String? fileNameCSV;  List<PlatformFile>? pathsLst; String? directoryPath; bool isLoadingCSV = false;  bool userAbortedLoadCSV = false;
//
  pickUpCSV() async {     //print('$isLoadingCSV---$userAbortedLoadCSV');
    if(csvMode == 1 && playerMode == 1) {         // these two modes (see at the begin: build variants) means "Android, MacOS"
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
              //loadCSV('assets/csv/$fileL');                        // toDo: only from assets
        String tempS = csvFile.files.single.path.toString();  // toDo: [path] Not support Web, only [name] supports Web
        if(getFileExtension(tempS)=='tsv' || getFileExtension(tempS)=='TSV') {setState(() {wasTSVextDetected = true;});}
        else {setState(() {wasTSVextDetected = false;});} //end if
        File fileL = File('$tempS');                          // toDo: !!! !!! !!! !!!!!! !!! Only such: " '$Str' ", not unnecessary ?! // this string interpolation NEEDED in current version SDK or due Android peculiarities
        // await readCsvFeautr (fileL);                          // works fine, try to check if file csv is correct or not
/////////////// Prevention: if file is Not a CSV/TSV-file ////////////////
        dataFbak.clear(); dataFbak = List.from(dataF); // make backup
        try {   // thanks to this function, it will be possible to re-open file
          await readCsvFeautr (fileL);                          // toDo: from any place
        } catch (e) {
          //print(e);   // exclude the error "...StateLifecycle.created...", showing the alert message or dialog:
          if(!e.toString().contains('_StateLifecycle.created')) {
            showAlertDialog(context);  // handle the error here
            dataF.clear(); dataF = List.from(dataFbak); // apply backup
          } else {} //end if
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
/////////////////////////////////// Cyclical file monitoring functions: //////////////////// Not yet cyclically automatic! Only manual!
  MonitorFile() async{              // So far, manually cyclical monitoring
    ///////////////////////////////  only on Android, MacOS platform file should be Re-Picked if it was changed externally
    if(csvMode == 1 && playerMode == 1) {     // these two modes (see at the begin: build variants) means "Android, MacOS"
      if(isSwitchedMonitorFile==true) {
        try { // sometimes freeze if press monitor second time (only Android), cause was incorrect table view 128/64/32 switching and not a folder deletion
          FilePicker.platform.clearTemporaryFiles(); // FIRST: Trying to clear cached file or entirely folder, because changes in file not applied; reload old version (on Android, MacOS)
        } catch(e) {} //no need to catch
        pickUpCSV();                               // in the Android build Monitor works only as Re-Pick
      } else {
        if (tempSMonitor!='') await readCsvFeautr (File('$tempSMonitor'));       // Re-Read existing
      }
    } else {                                                 // Windows          // in all cases (except Android, MacOS) using monitor
        if (tempSMonitor!='') await readCsvFeautr (File('$tempSMonitor'));       // in all other cases (Windows), Monitor works just like a monitor
      if (ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) != 0 || ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0) { //if Range Slider (Start or End) is not at the default position
        // editor autoplay:
        setState(() {toggleIcnMsrBtn = !toggleIcnMsrBtn;});
        ntTblNtfrsList = [...ntTblNotifier.value];
        ntTblNtfrsList[5]['msrTgl'] = 1;
        ntTblNotifier.value = ntTblNtfrsList;
        playFromList ();  // playing selected fragment immediately after contents loaded without pressing the Measures Button
        // end editor autoplay
      } else {
        // do nothing
      }; // end if Range Slider (Start or End) is not at the default position
    }
    ///////////////////////////////
  } // end MonitorFile
////////////////////////////////// End cyclical file monitoring functions. /////////////////
//
//
  Future <void> playerInitWithEmptyNote() async {
    if (csvMode != 2) { // not for Web
      final player = AudioPlayer(); // only one final audioPlayer
      player.setVolume(0.9);
      player.play(AssetSource('m4a/000L.m4a'), mode: PlayerMode.lowLatency);  // try to initialize player, 000L is silent sample
    } else {} //end if
  }
//
  fromTheBeginBySliderCoincidence() {             // Suggest to Start Over (begin) by Slider Values Coincidence
    ntTblNtfrsList = [...ntTblNotifier.value];
    if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) == 0){
      fromTheBegin = false;
      if(isSwitchedMonitorFile==true) {LoadCSVBtnTx='Changes monitor';} else {LoadCSVBtnTx='Load csv/tsv File';} //end if
    } else {
      fromTheBegin = false;
      if(isSwitchedMonitorFile==true) {LoadCSVBtnTx='Changes monitor';} else {LoadCSVBtnTx='Load csv/tsv File';} //end if
    }
    if(ntTblNtfrsList[0]['rangeStart']?.round() == ntTblNtfrsList[1]['rangeEnd']?.round() && ntTblNtfrsList[1]['rangeEnd']?.round() != nTcolS*2 && ntTblNtfrsList[4]['tableChangeCount'] != 1){
      fromTheBegin = true;
      LoadCSVBtnTx = 'Start Over (begin)';
      showArrowMoveToTheLeft=false;
    } else {
      fromTheBegin = false;
      if(isSwitchedMonitorFile==true) {LoadCSVBtnTx='Changes monitor';} else {LoadCSVBtnTx='Load csv/tsv File';} //end if
    } //end if
    if(ntTblNtfrsList[0]['rangeStart']?.round() == ntTblNtfrsList[1]['rangeEnd']?.round() && ntTblNtfrsList[1]['rangeEnd']?.round() == nTcolS*4){
      clearRangeSharePref = true;
      LoadCSVBtnTx = 'Clear Range Pref. (for the file being opn.)'; // if both slider handles are at all the way to the right position
      showArrowMoveToTheLeft=false;
    } else {
      clearRangeSharePref = false;
    } //end if
    ntTblNotifier.value = ntTblNtfrsList;
    setState(() { }); // setting states of All Upper values, because you do not have to write they inside the "setState"
  }
//
/////////////////////////////////////////////////////~~~~~ loadTagsFirst() Future ~~~~~//////////////////////////////////////////////////
  Future <void> loadTagsFirst() async {
    playerInitWithEmptyNote();
    // keeping only 0...22 rows because the file exported from other Office packages may contain 24 and 25 txt strings (list row 23,24):
////////////////
    dataF = List.from(dataF.transpose);  // additional, 2nd
////////////////                                       // !!! !!! !!! Another warning about "List.From" method !!! !!! !!! You can also try methods:   "List.Of"   "List.Copy"
    try {dataF = dataF.sublist(0,23);} catch(e) {};    // keeping only 24 rows (0, 1 .. 23)  // [0] is a row of A1 and extra marks or bookmarks, [1...22] is rows corresponding to strings
//  try {dataF = dataF.sublist(0,22);} catch(e) {};    // with <= notesByBit+1 you will give an error in readCSV Future because of "List.From". This "Strange" method changes parameters of the Parent List, from which the Child List is taken !!!
////////////////
    dataF = List.from(dataF.transpose);  // back, 3rd
////////////////
    List <String> cellA1 = dataF[0][0].toString().split('~');                             // splitting Excel's A1 cell contents by dilimiter "~"       excel[row][column]
    int tempStringsNum      =   int.parse(cellA1[0]);
    int tempselectedtuningNum = int.parse(cellA1[1]);
    if (cellA1[2] != null) {                                                              // "!" is a Null Check  //  .clamp(0.1,2.0)
    tempoCoeff =  double.tryParse(cellA1[2])!.clamp(0.1,2.0); } else {tempoCoeff = 1.0;}  // clamp(0.1,2.0) is Fit in Range 0.1 ... 2.0, if less or more, then equal 0.1 and 2.0 accordingly
    //////////////////////////////////                                                    // extra tempo correction depends on widget rebuild time:
    // if(isSwitched_32_64_128 == 128) {tempoCoeff = tempoCoeff + 0.1;tempoCoeff = tempoCoeff.clamp(0.1,2.0);} else {} //end if    // if more columns, then should rebuild faster
    // if(isSwitched_32_64_128 == 32)  {tempoCoeff = tempoCoeff - 0.1;tempoCoeff = tempoCoeff.clamp(0.1,2.0);} else {} //end if    // if less columns, then should rebuild slower
    //////////////////////////////////
    tempperformrsInfo = cellA1[3];
    if (tempStringsNum.clamp(21,22) == tempStringsNum) {stringsNum = tempStringsNum;} else {}  // Clamp - is checking if it is within the range // if out of range, used nearest boundary value
    if (tempselectedtuningNum.clamp(1,12) == tempselectedtuningNum) {setState(() {selectedtuningNum = tempselectedtuningNum;});} else {} // end if clamp
              // ~~~~~~~~~~~~~~finding Max Non-empty Position (if csv contains many ";;;;;" without notes at the end)~~~~~~~~~~~~:
              List csvLst = List.from(dataF);                             // it's local !!!
                int notesByBit = 22;                                        // allways 22        if 21 string: 22         if 22 string: 22         For F2 Button To Work!
//              int notesByBit = stringsNum;                                // !!!!!!!!!!!!!!!!!!! Not ReDefine Variables !!!!!!!!!!!!!!! Not to Mix With Global Variables !!!
              int maxLength_1 = csvLst.length;                            // !!! do not re-define variable (int maxLength) here!!! Will not be errors, and not result
              maxNotEmptyPos = 1;     bool isFound = false;               // !!! do not re-define variable (maxNotEmptyPos) !!!
              for (int i = 1; i < maxLength_1; i++) {
                for (int j = 0; j <= notesByBit; j++) {                   //  <=    <=    <=    less or equal
                  if (csvLst[i][j] != "") {isFound = true;} else {}
                } // end for (j)
                if (isFound == true) {maxNotEmptyPos = i + 1 + 1;  isFound = false;} else {}  // (i + 1) because of last bit; (i + 1 + 1) because when stops, last bit should not sounds
              } // end for (i)
//print(csvLst); print(maxLength_1);                                        // !!! in playFromList() func. csvLst generates again !!!
///////////////////////////////////////////////////////////////////////////////////////////////////////    TSV adding elements at the end   1 of 5
              if(wasTSVextDetected==true) {                                 // TSV needs one additional element at the end (this is the difference from CSV):
              final List<dynamic>emptyFillingList_00a = List.generate(1,(i) => List.generate((cols1 + 1),(j) => '', growable: true), growable: true);
              csvLst = csvLst + emptyFillingList_00a + emptyFillingList_00a; // prevention of freeze at the end of TSV List playing // if you will use "add" instead of "+" you will give not element add but list of elements add
              //maxNotEmptyPos = maxNotEmptyPos - 1;
//print(csvLst); print(csvLst.length);
              } else {} //end if TSV was detected
///////////////////////////////////////////////////////////////////////////////////////////////////////    end TSV adding elements at the end   1 of 5
                 setState(() {                                              // you dont have to write all assignments inside the setState(...)
                   maxNotEmptyPos = maxNotEmptyPos;
                   maxLength = maxNotEmptyPos;                              // this will be the end point where player stops
                   measureBtnTx = 'measures 1 - ' + (maxNotEmptyPos / nTcolS).ceil().toString();            // nTcolS=32 is a cell layout in excel template
                 });
// print('maxLength:'); print(maxLength);
               // ~~~~~~~~~~~~~Splitting Notation List by Two Tables (by every constant number of Columns)~~~~~~~~~~~~~~~~~~~~~~~:
                data1.clear();                                          // "List.from" is a very strange method, see further:
                data1 = List.from(dataF);                               //  Filling List for NotationTable
              //data1 = data1.sublist(1);              //see later      //  Submatrix called Sublist, except for zero (tags), start from the first
//                for (int i = 1; i < data1.length; i++) {
//                  for (int j = 1; j < stringsNum; j++) {
// // IT STRANGE, BUT ... ALL ELEMENTS IN PARENTAL CSVLST ALSO REPLACED BY '⬤' OF CHILD LIST WHEN CHILD LIST CHANGED !!! !!!
//                     // if(data1[i][j] != '') {data1[i][j] = '1';} else {}  // replacing all notes with '1'
// // if(data1[i][j] != '') {data1[i][j] = '⬤';} else {}  // replacing all notes with '⬤', filled circle symbol  //SHORT NOTES NOT WORKED BY THIS REASON !!!
//                   } // end for (j)
//                 } // end for (i)
////////////////////////// ------------------ Grey Screen Prevention at the End: -----------------////////////////////
////// Prevention Widget Crash (grey screen, when ends naturally) when list ends earlier than expected table width, ///////
////// this generated list will fill in the missing columns at the end before length dividing without a remainder: ////////
    //final  List<dynamic>emptyFillingList = List.generate(cols1 + 1,(i) => '', growable: true);      // [ ,  ,  ,  ,  ,  , ..23..  ,  ,  ,  ,  ,  ]
    final List <dynamic> emptyFillingList = List.generate(data1[0].length,(i) => '', growable: true); // [ ,  ,  ,  ,  ,  , ..23..  ,  ,  ,  ,  ,  ]
//  print('nTcolS*2='+(nTcolS*2).toString());print('nTcolS*4='+(nTcolS*4).toString());print('nTcolS*6='+(nTcolS*6).toString());
//
    while ((data1.length).remainder(nTcolS*2) != 0) { // adding an empty column until the total width of the two tables is a multiple of 64th
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
        data1.add(emptyFillingList_1);         //keeping the shape of the table in width
    } // end while()
////////////////
    data1 = data1.transpose;   // additional, 2nd
////////////////
    data1 = listFillingWith_1 + data1;      //keeping the shape of the table in height
    data1 = data1.sublist(2);               //minus 2 columns at the begin
///////////////////////////////////////////////////////////////////////////////////////////////////////    TSV adding elements at the end   2 of 5
    if(wasTSVextDetected==true) {           // TSV needs one additional element at the end (this is the difference from CSV)
      data1 = data1 + emptyFillingList_0a + emptyFillingList_0a + emptyFillingList_0a + listFillingWith_1;  //plus 3 filled-up with "" columns and 1 column filled-up with "1" at the end
    } else {                                // CSV - NO needs additional elements:
      data1 = data1 + emptyFillingList_0a + listFillingWith_1;                                              //plus 1 filled-up with "" column and 1 column filled-up with "1" at the end
    } //end if
///////////////////////////////////////////////////////////////////////////////////////////////////////    end TSV adding elements at the end   2 of 5
////////////////
    data1 = data1.transpose; // additional, 3rd
////////////////
    dataF = dataF.sublist(1);               //minus 1 column at the begin
///////////////  ------------------ End Grey Screen Prevention when Opening the CSV file with unsufficient number of strings ---------///
     //print(data1.transpose);print(data1.transpose.length);
     //print(dataF);print(dataF.length);
    crc32trackPerfInfo = Crc32.calculate(tempperformrsInfo).toString();
    clearOneFileSharedPrefByCondition(crc32trackPerfInfo); // call BEFORE settingState !! // CLEAR individual shared pref. for one file !!!
    setState(() {
      dropdownValue = tuneMap[tempselectedtuningNum].toString();  // Type String for Drop Down Menu
      tempperformrsInfo = tempperformrsInfo;
      crc32trackPerfInfo = crc32trackPerfInfo;
      data1 = data1; dataF = dataF;                               // assignment inside of setState() - is also because of that "strange" method "List.From"
    }); //end setState()
    if(fromTheBegin == false) {
      getDataSharedPref();         // try-catch to get data from shared preferences by crc32 of track_performer info string and setting State
      loading__3264_or_64128();    // CALL
    } else {}
    playerInitWithEmptyNote();
    if (isSwitchedMonitorFile==true) {
      addButtonsStates(0,false);   // only left and right key buttons setting to init state, notation table do not touch
    } else {
      initState();                 // buttons and notifiers brought to the initial state!!!
    } // end if
    setState(() {
      isLoadingCSV = false; // completely loading process finished // regardless of the result, the main thing is that the process is completed
      fromTheBegin = false; // for Load CSV Button text ("start over (begin)" will change to "Load csv/tsv File")
      //if(isSwitchedMonitorFile==true) {LoadCSVBtnTx = 'Changes monitor';} else {LoadCSVBtnTx = 'Load csv/tsv File';} //end if
    });
//
    //// Suggestion to Start Over (begin) if slider values Match:
    fromTheBeginBySliderCoincidence();
    //// End Suggestion to Start Over (begin) if slider values Match:
//
//
  } //end loadTagsFirst() Future
///////////////////////////////////////////////////~~~~~ End loadTagsFirst() Future ~~~~~/////////////////////////////////////////////////
//
  // creating exemplar of sharedPreferences:
  // getdataSharedPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  // }
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
        .toString()}~${ENB032.toString()}~${isSwitched_32_64_128.toString()}~${mode_3264_or_64128.toString()}';
    preferences.setString(crc32trackPerfInfo, stringValSharedPref);
  }
// end Future setDataSharedPref()
//
  Future<void> clearOneFileSharedPrefByCondition(String crc32TPI) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();  //  preferences.clear(); // if Uncommented:  CLEARING ALL SHARED PREFERENCES !!!
    if(clearRangeSharePrefA == true) {
      await preferences.remove(crc32TPI);                                                            // remove Range Shared Preferences for ONE now Opening File
      clearRangeSharePref = false; clearRangeSharePrefA = false;
      ntTblNtfrsList = [...ntTblNotifier.value];
      ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = nTcolS*4; ntTblNotifier.value = ntTblNtfrsList;    // resetting Range Slider
      setState(() {});} else {}
  }
  Future<void> getDataSharedPref() async{
    stringValSharedPref = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
//await preferences.clear();                                                                                                   // CLEAR SHARED PREFERENCES ALL !!!
    stringValSharedPref = preferences.getString(crc32trackPerfInfo)!;
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
        isSwitched_32_64_128 = int.parse(stLSP[14]);
        mode_3264_or_64128 = int.parse(stLSP[15]);
        ntTblNotifier.value = ntTblNtfrsList;
        setState(() {});
        //**********************************************************************//
      } catch(e){
      //
      }
    } else {}
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
      AlertDialog alert = AlertDialog(title: Text("Jalinativeinstrument for African Harp Kora notation: brief information"),content: Text("Music notations contains in CSV/TSV files. You can create them using JNI Excel Macro (Windows Excel 2016 64-bit xlsm file, it contains in CSV folder in Assets of APK and in Windows release folder) or using Google Spreadsheets TSV format..." +"\n"+"\n"+ "In the Application screen three objects have not only shortly press function but a long press function too (table, performers name and key-button)" +"\n"+"\n"+ "The simplest notation file in Excel is a blank sheet with cell A1, the basis of the text: 21~1~1~Template" +"\n"+"\n"+ "Cells A2:A23 should be filled with any data. Non-empty cells starting from column B sound like notes. When Excel exporting to CSV, the delimiter is semicolon"),
        actions: [okButton,],);
      // show the dialog:
      showDialog(context: context,builder: (BuildContext context) {return alert;},);
    }
    showAlertDialog(context);
  } //end openInfoPage()
//
// Tuning (musical Scale/Mode) variant selection (one of 9): // Open visualMarks in Visual Studio CODE editor or other with syntax highlighting
//shortOrLong variant of the playing note selection, (most commonly used ~90% long notes and only ~10% of the short):
//int shortOrLong = 1;//Long WAV (by default) //int shortOrLong = 2;//Short WAV           //You can made notes shorter by using Audacity and it's tempo correction without pitch change
  int stringsNum = 21; int selectedtuningNum = 4; int shortOrLongNum = 1; // stringsNum = 21 or 22, shortOrLongNum = 1 or 2 (Long|Short)
//tuning has been selected
//
//notation visual marks for visual display on buttons and in notation table
//this is the First Place of Two, where (notes/frequencies/paths/colours) Data written direct in Source code
//toDo: Lets complete keyTuning 8 and 9
//  https://pages.mtu.edu/~suits/notefreqs.html
  dynamic visualMarks (int tuningNum){          //its O'Kay to define function inside "Class", returning Type is "Dynamic"
    switch (tuningNum) {                        //its O'Kay to use switch operator inside "function" that locates inside "Class"
      case 1:                                   //Use (Alt + Shift + Selection) in Visual Studio CODE Editor to edit the table
        final List<Map> keyTuning = [           //Samples could by made in "Audacity", "Melodyne" and "Foobar2000 encoders"
          {'noteNum': 0,  'ntNote': '',          'ntCent': '',       'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A♭5',       'ntCent': '',       'ntFreq': '830.59', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',        'ntCent': '',       'ntFreq': '783.97', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',        'ntCent': '',       'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E♭5',       'ntCent': '',       'ntFreq': '622.24', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'C♯5',       'ntCent': '',       'ntFreq': '554.35', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A♭4',       'ntCent': '',       'ntFreq': '415.29', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',        'ntCent': '',       'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B♭4',       'ntCent': '',       'ntFreq': '466.15', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',        'ntCent': '',       'ntFreq': '391.99', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',        'ntCent': '',       'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E♭4',       'ntCent': '',       'ntFreq': '311.12', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'C♯4',       'ntCent': '',       'ntFreq': '277.18', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',        'ntCent': '',       'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B♭3',       'ntCent': '',       'ntFreq': '233.08', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A♭3',       'ntCent': '',       'ntFreq': '207.65', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',        'ntCent': '',       'ntFreq': '195.99', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',        'ntCent': '',       'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E♭3',       'ntCent': '',       'ntFreq': '155.56', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'C♯3',       'ntCent': '',       'ntFreq': '138.59', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',        'ntCent': '',       'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B♭2',       'ntCent': '',       'ntFreq': '116.54', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',        'ntCent': '',       'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',          'ntCent': '',       'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA♭ SOL FA MI♭ DO♯ LA♭ DO SI♭ SOL FA MI♭ DO♯ DO SI♭ LA♭ SOL FA MI♭ DO♯ DO SI♭ FA
        // 21   B2_123 (123.47) Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 2:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',       'ntCent': '',        'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',     'ntCent': ' +5c',    'ntFreq': '882.52', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',     'ntCent': ' -15c',   'ntFreq': '777.21', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',     'ntCent': '',        'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',     'ntCent': '+5c ',    'ntFreq': '661.15', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',     'ntCent': ' -15c',   'ntFreq': '582.25', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',     'ntCent': '',        'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B♭4',    'ntCent': '',        'ntFreq': '466.15', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',     'ntCent': '+5c ',    'ntFreq': '441.26', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',     'ntCent': ' -15c',   'ntFreq': '388.60', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',     'ntCent': '',        'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',     'ntCent': ' +5c',    'ntFreq': '330.57', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',     'ntCent': '-15c ',   'ntFreq': '291.12', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',     'ntCent': '',        'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B♭3',    'ntCent': '',        'ntFreq': '233.08', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',     'ntCent': ' +5c',    'ntFreq': '220.63', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',     'ntCent': '-15c ',   'ntFreq': '194.30', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',     'ntCent': '',        'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',     'ntCent': '+5c ',    'ntFreq': '165.29', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',     'ntCent': '-15c ',   'ntFreq': '145.56', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',     'ntCent': '',        'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B♭2',    'ntCent': '',        'ntFreq': '116.54', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',     'ntCent': '',        'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',       'ntCent': '',        'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 3:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',     'ntCent': '',     'ntFreq': '879.98', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',     'ntCent': '',     'ntFreq': '783.97', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',     'ntCent': '',     'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',     'ntCent': '',     'ntFreq': '659.24', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',     'ntCent': '',     'ntFreq': '587.32', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',     'ntCent': '',     'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B♭4',    'ntCent': '',     'ntFreq': '466.15', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',     'ntCent': '',     'ntFreq': '439.99', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',     'ntCent': '',     'ntFreq': '391.99', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',     'ntCent': '',     'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',     'ntCent': '',     'ntFreq': '329.62', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',     'ntCent': '',     'ntFreq': '293.66', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',     'ntCent': '',     'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B♭3',    'ntCent': '',     'ntFreq': '233.08', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',     'ntCent': '',     'ntFreq': '219.99', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',     'ntCent': '',     'ntFreq': '195.99', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',     'ntCent': '',     'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',     'ntCent': '',     'ntFreq': '164.81', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',     'ntCent': '',     'ntFreq': '146.83', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',     'ntCent': '',     'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B♭2',    'ntCent': '',     'ntFreq': '116.54', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',     'ntCent': '',     'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 4:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',     'ntCent': '',     'ntFreq': '879.98', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',     'ntCent': '',     'ntFreq': '783.97', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',     'ntCent': '',     'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',     'ntCent': '',     'ntFreq': '659.24', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',     'ntCent': '',     'ntFreq': '587.32', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',     'ntCent': '',     'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B4',     'ntCent': '',     'ntFreq': '493.87', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',     'ntCent': '',     'ntFreq': '439.99', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',     'ntCent': '',     'ntFreq': '391.99', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',     'ntCent': '',     'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',     'ntCent': '',     'ntFreq': '329.62', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',     'ntCent': '',     'ntFreq': '293.66', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',     'ntCent': '',     'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B3',     'ntCent': '',     'ntFreq': '246.94', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',     'ntCent': '',     'ntFreq': '219.99', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',     'ntCent': '',     'ntFreq': '195.99', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',     'ntCent': '',     'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',     'ntCent': '',     'ntFreq': '164.81', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',     'ntCent': '',     'ntFreq': '146.83', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',     'ntCent': '',     'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B2',     'ntCent': '',     'ntFreq': '123.47', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',     'ntCent': '',     'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA MI RE DO SI LA SOL FA MI RE DO SI LA SOL FA MI RE DO SI FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 5:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',     'ntCent': '',     'ntFreq': '879.98', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',     'ntCent': '',     'ntFreq': '783.97', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F♯5',    'ntCent': '',     'ntFreq': '739.97', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',     'ntCent': '',     'ntFreq': '659.24', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',     'ntCent': '',     'ntFreq': '587.32', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C♯5',    'ntCent': '',     'ntFreq': '554.35', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B4',     'ntCent': '',     'ntFreq': '493.87', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',     'ntCent': '',     'ntFreq': '439.99', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',     'ntCent': '',     'ntFreq': '391.99', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F♯4',    'ntCent': '',     'ntFreq': '369.99', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',     'ntCent': '',     'ntFreq': '329.62', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',     'ntCent': '',     'ntFreq': '293.66', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C♯4',    'ntCent': '',     'ntFreq': '277.18', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B3',     'ntCent': '',     'ntFreq': '246.94', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',     'ntCent': '',     'ntFreq': '219.99', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',     'ntCent': '',     'ntFreq': '195.99', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F♯3',    'ntCent': '',     'ntFreq': '184.99', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',     'ntCent': '',     'ntFreq': '164.81', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',     'ntCent': '',     'ntFreq': '146.83', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C♯3',    'ntCent': '',     'ntFreq': '138.59', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B2',     'ntCent': '',     'ntFreq': '123.47', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F♯2',    'ntCent': '',     'ntFreq': '92.50',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA♯ MI RE DO♯ SI LA SOL FA♯ MI RE DO♯ SI LA SOL FA♯ MI RE DO♯ SI FA♯
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 6:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',     'ntCent': '',       'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',   'ntCent': ' +5c',   'ntFreq': '882.52', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',   'ntCent': ' -15c',  'ntFreq': '777.21', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',   'ntCent': '',       'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',   'ntCent': '+5c ',   'ntFreq': '661.15', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',   'ntCent': ' -15c',  'ntFreq': '582.25', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',   'ntCent': '',       'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B4',   'ntCent': ' +5c',   'ntFreq': '495.30', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',   'ntCent': '+5c ',   'ntFreq': '441.26', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',   'ntCent': ' -15c',  'ntFreq': '388.60', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',   'ntCent': '',       'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',   'ntCent': ' +5c',   'ntFreq': '330.57', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',   'ntCent': '-15c ',  'ntFreq': '291.12', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',   'ntCent': '',       'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B3',   'ntCent': '+5c ',   'ntFreq': '247.65', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',   'ntCent': ' +5c',   'ntFreq': '220.63', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',   'ntCent': '-15c ',  'ntFreq': '194.30', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',   'ntCent': '',       'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',   'ntCent': '+5c ',   'ntFreq': '165.29', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',   'ntCent': '-15c ',  'ntFreq': '145.56', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',   'ntCent': '',       'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B2',   'ntCent': '',       'ntFreq': '123.47', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',   'ntCent': '',       'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',     'ntCent': '',       'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA MI RE DO SI LA SOL FA MI RE DO SI LA SOL FA MI RE DO SI FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 7:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',       'ntCent': '',      'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',     'ntCent': '',      'ntFreq': '879.98', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'A♭5',    'ntCent': '',      'ntFreq': '806.94', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',     'ntCent': '',      'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',     'ntCent': '-20c ', 'ntFreq': '651.67', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'E♭5',    'ntCent': ' -40c', 'ntFreq': '608.03', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',     'ntCent': '',      'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B♭4',    'ntCent': '',      'ntFreq': '466.15', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',     'ntCent': '',      'ntFreq': '439.99', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'A♭4',    'ntCent': ' -50c', 'ntFreq': '403.47', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',     'ntCent': '',      'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',     'ntCent': ' -20c', 'ntFreq': '325.83', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'E♭4',    'ntCent': '-40c ', 'ntFreq': '304.01', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',     'ntCent': '',      'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B♭3',    'ntCent': '',      'ntFreq': '233.08', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',     'ntCent': '',      'ntFreq': '219.99', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'A♭3',    'ntCent': '-50c ', 'ntFreq': '201.74', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',     'ntCent': '',      'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',     'ntCent': '-20c ', 'ntFreq': '162.92', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'E♭3',    'ntCent': '-40c ', 'ntFreq': '152.01', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',     'ntCent': '',      'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B♭2',    'ntCent': '',      'ntFreq': '116.54', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',     'ntCent': '',      'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',       'ntCent': '',      'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA LA♭ FA MI MI♭ DO SI♭ LA LA♭ FA MI MI♭ DO SI♭ LA LA♭ FA MI MI♭ DO SI♭ FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 8:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',     'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',   'ntCent': ' -15c','ntFreq': '872.39', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',   'ntCent': '',     'ntFreq': '783.97', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',   'ntCent': '',     'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',   'ntCent': '-15c ','ntFreq': '653.55', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',   'ntCent': '',     'ntFreq': '587.32', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',   'ntCent': '',     'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B♭4',  'ntCent': '',     'ntFreq': '466.15', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',   'ntCent': '-15c ','ntFreq': '436.19', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',   'ntCent': '',     'ntFreq': '391.99', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',   'ntCent': '',     'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',   'ntCent': ' -15c','ntFreq': '326.78', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',   'ntCent': '',     'ntFreq': '293.66', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',   'ntCent': '',     'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B♭3',  'ntCent': '',     'ntFreq': '233.08', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',   'ntCent': ' -15c','ntFreq': '218.10', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',   'ntCent': '',     'ntFreq': '195.99', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',   'ntCent': '',     'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',   'ntCent': '-15c ','ntFreq': '163.39', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',   'ntCent': '',     'ntFreq': '146.83', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',   'ntCent': '',     'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B♭2',  'ntCent': '',     'ntFreq': '116.54', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',   'ntCent': '',     'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',     'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 9:
        final List<Map> keyTuning = [
          {'noteNum': 0,  'ntNote': '',     'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A♭5',  'ntCent': ' +25c','ntFreq': '842.67', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',   'ntCent': ' +30c','ntFreq': '797.68', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',   'ntCent': '',     'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E♭5',  'ntCent': '+25c ','ntFreq': '631.29', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',   'ntCent': ' +30c','ntFreq': '597.58', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',   'ntCent': '',     'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B♭4',  'ntCent': '',     'ntFreq': '466.15', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A♭4',  'ntCent': '+25c ','ntFreq': '421.34', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',   'ntCent': ' +30c','ntFreq': '398.84', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',   'ntCent': '',     'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E♭4',  'ntCent': ' +25c','ntFreq': '315.64', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',   'ntCent': '+30c ','ntFreq': '298.79', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',   'ntCent': '',     'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B♭3',  'ntCent': '',     'ntFreq': '233.08', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A♭3',  'ntCent': ' +25c','ntFreq': '210.67', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',   'ntCent': '+30c ','ntFreq': '199.42', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',   'ntCent': '',     'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E♭3',  'ntCent': '+25c ','ntFreq': '157.82', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',   'ntCent': '+30c ','ntFreq': '149.40', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',   'ntCent': '',     'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B♭2',  'ntCent': '',     'ntFreq': '116.54', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',   'ntCent': '',     'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',     'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA♭ SOL FA MI♭ RE DO SI♭ LA♭ SOL FA MI♭ RE DO SI♭ LA♭ SOL FA MI♭ RE DO SI♭ FA
        //  21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 11:
        final List<Map> keyTuning = [     // copy of   case 3:
          {'noteNum': 0,  'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',     'ntCent': '',     'ntFreq': '879.98', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',     'ntCent': '',     'ntFreq': '783.97', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',     'ntCent': '',     'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',     'ntCent': '',     'ntFreq': '659.24', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',     'ntCent': '',     'ntFreq': '587.32', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',     'ntCent': '',     'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B♭4',    'ntCent': '',     'ntFreq': '466.15', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',     'ntCent': '',     'ntFreq': '439.99', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',     'ntCent': '',     'ntFreq': '391.99', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',     'ntCent': '',     'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',     'ntCent': '',     'ntFreq': '329.62', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',     'ntCent': '',     'ntFreq': '293.66', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',     'ntCent': '',     'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B♭3',    'ntCent': '',     'ntFreq': '233.08', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',     'ntCent': '',     'ntFreq': '219.99', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',     'ntCent': '',     'ntFreq': '195.99', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',     'ntCent': '',     'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',     'ntCent': '',     'ntFreq': '164.81', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',     'ntCent': '',     'ntFreq': '146.83', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',     'ntCent': '',     'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B♭2',    'ntCent': '',     'ntFreq': '116.54', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',     'ntCent': '',     'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ LA SOL FA MI RE DO SI♭ FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
      case 12:
        final List<Map> keyTuning = [     // copy of   case 4:
          {'noteNum': 0,  'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
          {'noteNum': 1,  'ntNote': 'A5',     'ntCent': '',     'ntFreq': '879.98', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 2,  'ntNote': 'G5',     'ntCent': '',     'ntFreq': '783.97', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 3,  'ntNote': 'F5',     'ntCent': '',     'ntFreq': '698.44', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 4,  'ntNote': 'E5',     'ntCent': '',     'ntFreq': '659.24', 'ntMark': 'e', 'ntColor': ''},
          {'noteNum': 5,  'ntNote': 'D5',     'ntCent': '',     'ntFreq': '587.32', 'ntMark': 'd', 'ntColor': ''},
          {'noteNum': 6,  'ntNote': 'C5',     'ntCent': '',     'ntFreq': '523.24', 'ntMark': 'c', 'ntColor': ''},
          {'noteNum': 7,  'ntNote': 'B4',     'ntCent': '',     'ntFreq': '493.87', 'ntMark': 'b', 'ntColor': ''},
          {'noteNum': 8,  'ntNote': 'A4',     'ntCent': '',     'ntFreq': '439.99', 'ntMark': 'a', 'ntColor': ''},
          {'noteNum': 9,  'ntNote': 'G4',     'ntCent': '',     'ntFreq': '391.99', 'ntMark': 'g', 'ntColor': ''},
          {'noteNum': 10, 'ntNote': 'F4',     'ntCent': '',     'ntFreq': '349.22', 'ntMark': 'f', 'ntColor': ''},
          {'noteNum': 11, 'ntNote': 'E4',     'ntCent': '',     'ntFreq': '329.62', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 12, 'ntNote': 'D4',     'ntCent': '',     'ntFreq': '293.66', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 13, 'ntNote': 'C4',     'ntCent': '',     'ntFreq': '261.62', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 14, 'ntNote': 'B3',     'ntCent': '',     'ntFreq': '246.94', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 15, 'ntNote': 'A3',     'ntCent': '',     'ntFreq': '219.99', 'ntMark': 'A', 'ntColor': ''},
          {'noteNum': 16, 'ntNote': 'G3',     'ntCent': '',     'ntFreq': '195.99', 'ntMark': 'G', 'ntColor': ''},
          {'noteNum': 17, 'ntNote': 'F3',     'ntCent': '',     'ntFreq': '174.61', 'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 18, 'ntNote': 'E3',     'ntCent': '',     'ntFreq': '164.81', 'ntMark': 'E', 'ntColor': ''},
          {'noteNum': 19, 'ntNote': 'D3',     'ntCent': '',     'ntFreq': '146.83', 'ntMark': 'D', 'ntColor': ''},
          {'noteNum': 20, 'ntNote': 'C3',     'ntCent': '',     'ntFreq': '130.81', 'ntMark': 'C', 'ntColor': ''},
          {'noteNum': 21, 'ntNote': 'B2',     'ntCent': '',     'ntFreq': '123.47', 'ntMark': 'B', 'ntColor': ''},
          {'noteNum': 22, 'ntNote': 'F2',     'ntCent': '',     'ntFreq': '87.30',  'ntMark': 'F', 'ntColor': ''},
          {'noteNum': 23, 'ntNote': '',       'ntCent': '',     'ntFreq': '',       'ntMark': '',  'ntColor': ''},
        ];
        // LA SOL FA MI RE DO SI LA SOL FA MI RE DO SI LA SOL FA MI RE DO SI FA
        // 21   B2_123 Note present Only in Lydian     Scale;    22   F2__92 Note present Only in Phrygian Scale
        //  Hide noteButton B2 (freq 123.47Hz) for 21-string instrument
        //  In CSV file Editor: hide Label for rowNumber 22 range("A22") for string number 21 for 21-string instrument
        return keyTuning;
    }//switch
  }  //end visualMarks
//
//toDo: Play Sounds simultaneously via audioplayers
  // Samples/ sound fonts/ sound bank     koraSound
  List<List> krSnd = [                              // List krSnd (koraSound 3d-List)
    [
      ['01al830' , '01as830'] , ['02gl' , '02gs'] , ['03fl' , '03fs'] , ['04el622' , '04es622'] , ['05dl554' , '05ds554'] , ['06cl' , '06cs'] , ['07bl' , '07bs'] , ['08al415' , '08as415'] , ['09gl' , '09gs'] , ['10fl' , '10fs'] , ['11el311' , '11es311'] , ['12dl277' , '12ds277'] , ['13cl' , '13cs'] , ['14bl' , '14bs'] , ['15al207' , '15as207'] , ['16gl' , '16gs'] , ['17fl' , '17fs'] , ['18el155' , '18es155'] , ['19dl138' , '19ds138'] , ['20cl' , '20cs'] , ['21bl' , '21bs'] , ['22fl' , '22fs']
    ] , [
      ['01al882' , '01as882'] , ['02gl777' , '02gs777'] , ['03fl' , '03fs'] , ['04el661' , '04es661'] , ['05dl582' , '05ds582'] , ['06cl' , '06cs'] , ['07bl' , '07bs'] , ['08al441' , '08as441'] , ['09gl388' , '09gs388'] , ['10fl' , '10fs'] , ['11el330' , '11es330'] , ['12dl291' , '12ds291'] , ['13cl' , '13cs'] , ['14bl' , '14bs'] , ['15al220' , '15as220'] , ['16gl194' , '16gs194'] , ['17fl' , '17fs'] , ['18el165' , '18es165'] , ['19dl145' , '19ds145'] , ['20cl' , '20cs'] , ['21bl' , '21bs'] , ['22fl' , '22fs']
    ] , [
      ['01al' , '01as'] , ['02gl' , '02gs'] , ['03fl' , '03fs'] , ['04el' , '04es'] , ['05dl' , '05ds'] , ['06cl' , '06cs'] , ['07bl' , '07bs'] , ['08al' , '08as'] , ['09gl' , '09gs'] , ['10fl' , '10fs'] , ['11el' , '11es'] , ['12dl' , '12ds'] , ['13cl' , '13cs'] , ['14bl' , '14bs'] , ['15al' , '15as'] , ['16gl' , '16gs'] , ['17fl' , '17fs'] , ['18el' , '18es'] , ['19dl' , '19ds'] , ['20cl' , '20cs'] , ['21bl' , '21bs'] , ['22fl' , '22fs']
    ] , [
      ['01al' , '01as'] , ['02gl' , '02gs'] , ['03fl' , '03fs'] , ['04el' , '04es'] , ['05dl' , '05ds'] , ['06cl' , '06cs'] , ['07bl493' , '07bs493'] , ['08al' , '08as'] , ['09gl' , '09gs'] , ['10fl' , '10fs'] , ['11el' , '11es'] , ['12dl' , '12ds'] , ['13cl' , '13cs'] , ['14bl246' , '14bs246'] , ['15al' , '15as'] , ['16gl' , '16gs'] , ['17fl' , '17fs'] , ['18el' , '18es'] , ['19dl' , '19ds'] , ['20cl' , '20cs'] , ['21bl123' , '21bs123'] , ['22fl' , '22fs']
    ] , [
      ['01al' , '01as'] , ['02gl' , '02gs'] , ['03fl739' , '03fs739'] , ['04el' , '04es'] , ['05dl' , '05ds'] , ['06cl554' , '06cs554'] , ['07bl493' , '07bs493'] , ['08al' , '08as'] , ['09gl' , '09gs'] , ['10fl369' , '10fs369'] , ['11el' , '11es'] , ['12dl' , '12ds'] , ['13cl277' , '13cs277'] , ['14bl246' , '14bs246'] , ['15al' , '15as'] , ['16gl' , '16gs'] , ['17fl184' , '17fs184'] , ['18el' , '18es'] , ['19dl' , '19ds'] , ['20cl138' , '20cs138'] , ['21bl123' , '21bs123'] , ['22fl92' , '22fs92']
    ] , [
      ['01al' , '01as'] , ['02gl' , '02gs'] , ['03fl' , '03fs'] , ['04el661' , '04es661'] , ['05dl582' , '05ds582'] , ['06cl' , '06cs'] , ['07bl495' , '07bs495'] , ['08al441' , '08as441'] , ['09gl388' , '09gs388'] , ['10fl' , '10fs'] , ['11el330' , '11es330'] , ['12dl291' , '12ds291'] , ['13cl' , '13cs'] , ['14bl247' , '14bs247'] , ['15al220' , '15as220'] , ['16gl194' , '16gs194'] , ['17fl' , '17fs'] , ['18el165' , '18es165'] , ['19dl145' , '19ds145'] , ['20cl' , '20cs'] , ['21bl123' , '21bs123'] , ['22fl' , '22fs']
    ] , [
      ['01al' , '01as'] , ['02gl806' , '02gs806'] , ['03fl' , '03fs'] , ['04el651' , '04es651'] , ['05dl608' , '05ds608'] , ['06cl' , '06cs'] , ['07bl' , '07bs'] , ['08al' , '08as'] , ['09gl403' , '09gs403'] , ['10fl' , '10fs'] , ['11el325' , '11es325'] , ['12dl304' , '12ds304'] , ['13cl' , '13cs'] , ['14bl' , '14bs'] , ['15al' , '15as'] , ['16gl201' , '16gs201'] , ['17fl' , '17fs'] , ['18el162' , '18es162'] , ['19dl152' , '19ds152'] , ['20cl' , '20cs'] , ['21bl' , '21bs'] , ['22fl' , '22fs']
    ] , [
      ['01al872' , '01as872'] , ['02gl' , '02gs'] , ['03fl' , '03fs'] , ['04el653' , '04es653'] , ['05dl' , '05ds'] , ['06cl' , '06cs'] , ['07bl' , '07bs'] , ['08al436' , '08as436'] , ['09gl' , '09gs'] , ['10fl' , '10fs'] , ['11el325' , '11es325'] , ['12dl' , '12ds'] , ['13cl' , '13cs'] , ['14bl' , '14bs'] , ['15al218' , '15as218'] , ['16gl' , '16gs'] , ['17fl' , '17fs'] , ['18el163' , '18es163'] , ['19dl' , '19ds'] , ['20cl' , '20cs'] , ['21bl' , '21bs'] , ['22fl' , '22fs']
    ] , [
      ['01al842' , '01as842'] , ['02gl797' , '02gs797'] , ['03fl' , '03fs'] , ['04el631' , '04es631'] , ['05dl597' , '05ds597'] , ['06cl' , '06cs'] , ['07bl' , '07bs'] , ['08al421' , '08as421'] , ['09gl398' , '09gs398'] , ['10fl' , '10fs'] , ['11el315' , '11es315'] , ['12dl298' , '12ds298'] , ['13cl' , '13cs'] , ['14bl' , '14bs'] , ['15al210' , '15as210'] , ['16gl199' , '16gs199'] , ['17fl' , '17fs'] , ['18el157' , '18es157'] , ['19dl149' , '19ds149'] , ['20cl' , '20cs'] , ['21bl' , '21bs'] , ['22fl' , '22fs']
    ]
  ]; // end krSnd (end koraSound 3d-List)
//
  void playSound(int tuning, int number, int shortOrLong, double nVol, int ext) async {
    final player = AudioPlayer(); // only one final audioPlayer
    player.setVolume(nVol);
    String xtsn_ = '';  String nT_ = '';  String aP_ = '';  // string extension //string Note    //assetsPath
    int tI_ = tuning - 1; int nI_ = number - 1; int sOl_ = shortOrLong - 1;     //tune index     //number of the note index    //shortOrLong note index
    switch (ext) {
      case 1: xtsn_ = 'WAV'; aP_ = 'wav/';  break;      case 2: xtsn_ = 'm4a'; aP_ = 'm4a/';  break;
      case 3: xtsn_ = '';    aP_ = '';      break;      case 4: xtsn_ = 'mp3'; aP_ = 'mp3/';  break;
      default: {  xtsn_ = 'WAV'; aP_ = 'wav/';  } break;
    } //end switch
///////////
if (tuning == 11) {tI_ = 3-1; aP_ = 'wavn/';} else {}   // two new sets of samples for Ionian and Lydian tunings
if (tuning == 12) {tI_ = 4-1; aP_ = 'wavn/';} else {}
//////////
    String kM_; // String as index (key) in hash table
    kM_ = krSnd[tI_][nI_][sOl_].toString();
    nT_ = aP_ + krSnd[tI_][nI_][sOl_] + '.' + xtsn_; // = ready path to the sound file
    switch (playerMode) {
      case 1:                                                 // build mode: android
        await player.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);  // Sounds From Here, Mode for each note: lowLatency ! But Memory Leak Windows!
        break;
      case 2:                                                 // build mode: Windows
      ///////////////////////////////// Prevent Memory Leak Win ////////////////////////////////
        if(audioPlayersMap.containsKey(kM_)) {} else {                // do nothing
          audioPlayersMap.addEntries({kM_ : AudioPlayer()}.entries);  // adding AudioPlayer for absolutely new note, .stop() method !!!
        } //end if
        audioPlayersMap[kM_]?.setVolume(nVol); await audioPlayersMap[kM_]?.stop(); await audioPlayersMap[kM_]?.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);
      ///////////////////////////////// End Prevent Memory Leak Win ////////////////////////////
        break;
      case 3:                                   // dart midi, only Android and iOS, functions and package commented
        // midiPlay(60); // print('Playing ~ 60'); // toDo: correspondence table of midi notes (0...256) only Android, iOS
        break;
      case 4:                                // Web JavaScript via Tone.js, Sounds like web midi Synth without delay at all
        //playJS(60); // needed correspondence table // works fine  // DO Not Use setState()s !!!
        //await Future.delayed(Duration(milliseconds: ((mS + mS*(1.0-crntSldrValT))/tempoCoeff).round()));
        //playNoteJS('E4'); // native Web tonic JS, works perfect!
        dynamic keyTuning = visualMarks (tuning);
        var noteJS = keyTuning[number].values.elementAt(1).toString(); // toDo: split string (remove -15c, +5c etc.)
        playNoteJS(noteJS); // native Web tonic JS, works perfect!
        await Future.delayed(Duration(milliseconds: ((mS + mS*(1.0-crntSldrValT))/tempoCoeff).round()));
        // plaYm4a();
        break;
      case 5:                                // Web JavaScript via Tone.js, trying to play m4a via Tone.js
        dynamic keyTuning = visualMarks (tuning);
        var noteJS = keyTuning[number].values.elementAt(1).toString();
        plaYm4a(noteJS);
        await Future.delayed(Duration(milliseconds: ((mS + mS*(1.0-crntSldrValT))/tempoCoeff).round()));
        break;
      default:
        await player.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);  // Sounds From Here, Mode for each note: lowLatency ! But Memory Leak Windows!
        break;
    } //end switch (playerMode)
//
  } // end PlaySound ()
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
/////////////////////////// Value Notifiers (instead of setState()'s) /////////////////////////////
//
  static final ValueNotifier<bool> cnslDelay1Ntfr = ValueNotifier<bool>(false);         // CancelDelay Notifier // "false" is it's default value
//
  static final ValueNotifier<List<Map<String, int>>> ntTblNotifier = ValueNotifier([]); // "empty List[]" is the default notifier's Value
//
  switchRangeEndDependsColsNumb() {
    if(isSwitched_32_64_128==32) {nTcolS=nTcolSHalf;} else if(isSwitched_32_64_128==64) {nTcolS=nTcolSN;}  else if(isSwitched_32_64_128==128) {nTcolS=nTcolSDouble;} //end if
    rngEnd=4*nTcolS;
    setState(() {});
  } //end switchRangeEndDependsColsNumb()
//
  void addNtTblNotifierStates() {
    switchRangeEndDependsColsNumb();
    ntTblNtfrsList.clear();
    ntTblNtfrsList = [...ntTblNotifier.value];        // !!! To prevent "Null Check Operator on Null Value", numbers of Elements very important !
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
    ntTblNotifier.value = ntTblNtfrsList;
  }
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
  Future<void> showNavButtonsForSomeSeconds() async {      // navigate buttons (Left and Right to change Measure Number) are shown temporary
    showNavButtonsForThreeSeconds=true; setState(() {});
    await Future.delayed(const Duration(seconds: 5)); // pause 3 seconds
    // here will be second await with listening new duration when Arrow button pressed:
    // toDo:
    //
    showNavButtonsForThreeSeconds=false; setState(() {});
  } // end showNavButtonsForSomeSeconds() async
//
  Future<void> increaseMeasureByButton() async { //  Measure Up by User
    //showNavButtonsIncreaseTime(); // add more Time to show Nav Buttons, then hide them
    ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = nTcolS*4;  // resetting Range Slider
    ntTblNotifier.value = ntTblNtfrsList;
    int requiredMeasToStop;
    ntTblNtfrsList = [...ntTblNotifier.value];
    requiredMeasToStop = (ntTblNtfrsList[4]['tableChangeCount']!*2-1) + 0;
    if((ntTblNtfrsList[4]['tableChangeCount']!*2-1) < (maxNotEmptyPos / nTcolS).ceil() - 1) {requiredMeasToStop = (ntTblNtfrsList[4]['tableChangeCount']!*2-1) + 2;} else {}
    List csvLst = List.from(dataF);         // again !!! creating csvLst, like in loadTagsFirst() func.
///////////////////////////////////////////////////////////////////////////////////////////////////////    TSV adding elements at the end   3 of 5
    if(wasTSVextDetected==true) {           // TSV needs one additional element at the end (this is the difference from CSV):
      final List<dynamic>emptyFillingList_00a = List.generate(1,(i) => List.generate((cols1 + 1),(j) => '', growable: true), growable: true);
      csvLst = csvLst + emptyFillingList_00a + emptyFillingList_00a + emptyFillingList_00a; // prevention of freeze at the end of TSV List playing // if you will use "add" instead of "+" you will give not element add but list of elements add
    } else {} //end if TSV was detected.
///////////////////////////////////////////////////////////////////////////////////////////////////////  end TSV adding elements at the end   3 of 5
    traversingForNavigate(csvLst, requiredMeasToStop); //CALL
      setState(() {});
    } // end future increase measure
//
  Future<void> decreaseMeasureByButton() async { //  Measure Down by User
    //showNavButtonsIncreaseTime(); // add more Time to show Nav Buttons, then hide them
    ntTblNtfrsList = [...ntTblNotifier.value];
    ntTblNtfrsList[0]['rangeStart'] = 0; ntTblNtfrsList[1]['rangeEnd'] = nTcolS*4;  // resetting Range Slider
    ntTblNotifier.value = ntTblNtfrsList;
    int requiredMeasToStop;
    int requiredView;
    requiredMeasToStop = (ntTblNtfrsList[4]['tableChangeCount']!*2-1) + 0;        // TABLE CHANGE COUNT CHECK IT !!!
    requiredView = isSwitched_32_64_128;
    initState();                                                                  // resetting all TCC's to "1"
    isSwitched_32_64_128 = requiredView;
    if(requiredMeasToStop>=3) {
     requiredMeasToStop = requiredMeasToStop - 2;
    } else {}
    List csvLst = List.from(dataF);         // again !!! creating csvLst, like in loadTagsFirst() func.
///////////////////////////////////////////////////////////////////////////////////////////////////////    TSV adding elements at the end   4 of 5
    if(wasTSVextDetected==true) {           // TSV needs one additional element at the end (this is the difference from CSV):
      final List<dynamic>emptyFillingList_00a = List.generate(1,(i) => List.generate((cols1 + 1),(j) => '', growable: true), growable: true);
      csvLst = csvLst + emptyFillingList_00a + emptyFillingList_00a + emptyFillingList_00a; // prevention of freeze at the end of TSV List playing // if you will use "add" instead of "+" you will give not element add but list of elements add
    } else {} //end if TSV was detected.
///////////////////////////////////////////////////////////////////////////////////////////////////////  end TSV adding elements at the end   4 of 5
    traversingForNavigate(csvLst, requiredMeasToStop); //CALL
    showArrowMoveToTheLeft=false;                      // hide Arrow "Move Left"
    setState(() {});
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
//**********************************************************************//  "Assembler-style" variables names:
    ntTblNtfrsList = [...ntTblNotifier.value];
    var TCC128 = ntTblNtfrsList[8]['tableChangeCount128']!;
    var TCC064 = ntTblNtfrsList[7]['tableChangeCount64']!;
    var TCC032 = ntTblNtfrsList[6]['tableChangeCount32']!;
    var PBIT   = ntTblNtfrsList[3]['playingBit']!;
    var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
    var SBIT   = ntTblNtfrsList[2]['startBit']!;
    var OisLEFT =  ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2);  // Range slider left Handle at the Left position
    var OisRIGHT = ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4);    // Range slider right Handle at the Right position
    var rSTART = ntTblNtfrsList[0]['rangeStart']!;
    var rEND = ntTblNtfrsList[1]['rangeEnd']!;
    var STB128 = ntTblNtfrsList[13]['rangeStart128bak']!;
    var ENB128 = ntTblNtfrsList[14]['rangeEnd128bak']!;
    var STB064 = ntTblNtfrsList[11]['rangeStart64bak']!;
    var ENB064 = ntTblNtfrsList[12]['rangeEnd64bak']!;
    var STB032 =  ntTblNtfrsList[9]['rangeStart32bak']!;
    var ENB032 = ntTblNtfrsList[10]['rangeEnd32bak']!;
    var ALLCOL = nTcolS*2;
    var STARTr = rSTART?.round();
//**********************************************************************//
    if(isSwitched_32_64_128==128) {
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
    } else if(isSwitched_32_64_128==64) {
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
    } else if (isSwitched_32_64_128 == 32) {
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
//debug:    // for PBIT adding Leading Zeroes at the beginning of the string (padLeft):                         // setState() !!! use it Only for debugging
// SET STATE - COMMENT IT 1 of 4 !!!  mode_3264_or_64128
//  ntTableCaptionTxt = 'TCC:${TCC} 32:${TCC032} 64:${TCC064} 128:${TCC128} is:$isSwitched_32_64_128 fr:$tapMadeOnUpperOrLowerTable PBIT:${PBIT.toString().padLeft(4, '0')} SBIT:${SBIT} '; setState(() {}); // for debug
//    ntTableCaptionTxt = 'TCC:${TCC} 32:${TCC032} 64:${TCC064} 128:${TCC128} is:$isSwitched_32_64_128'; setState(() {}); // for debug
//  ntTableCaptionTxt = ' sbit:${SBIT} '; setState(() {}); // for debug
//  ntTableCaptionTxt = 'TCC:${TCC} 32:${TCC032} 64:${TCC064} 128:${TCC128} is:$isSwitched_32_64_128 fr:$tapMadeOnUpperOrLowerTable mode:${mode_3264_or_64128} '; setState(() {}); // for debug
// for debug
//
//**********************************************************************//
    ntTblNtfrsList[8]['tableChangeCount128'] = TCC128;
    ntTblNtfrsList[7]['tableChangeCount64'] = TCC064;
    ntTblNtfrsList[6]['tableChangeCount32'] = TCC032;
    ntTblNtfrsList[3]['playingBit'] = PBIT;
    ntTblNtfrsList[4]['tableChangeCount'] = TCC;
    ntTblNtfrsList[2]['startBit'] = SBIT;
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
  } // end changeTableView()
Future listTraversal (int iStarts, int iEnds, List jBtnRelease, List csvLst, int notesByBit, bool rngExtend) async {
//**********************************************************************//
  var PBIT   = ntTblNtfrsList[3]['playingBit']!;
  var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
  var SBIT   = ntTblNtfrsList[2]['startBit']!;                                  // (it says unused, because it temporary commented)
  var OisLEFT =  ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2);  // Range slider left Handle at the Left position
  var OisRIGHT = ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4);    // Range slider right Handle at the Right position
  var rSTART = ntTblNtfrsList[0]['rangeStart']!;
  var rEND = ntTblNtfrsList[1]['rangeEnd']!;
        // for debug (it says unused, because it temporary commented):
            var STB064 = ntTblNtfrsList[11]['rangeStart64bak']!;
            var ENB064 = ntTblNtfrsList[12]['rangeEnd64bak']!;
            var STB032 =  ntTblNtfrsList[9]['rangeStart32bak']!;
            var ENB032 = ntTblNtfrsList[10]['rangeEnd32bak']!;
            var TCC128 = ntTblNtfrsList[8]['tableChangeCount128']!;
            var TCC064 = ntTblNtfrsList[7]['tableChangeCount64']!;
            var TCC032 = ntTblNtfrsList[6]['tableChangeCount32']!;
        // end for debug only
//**********************************************************************//
  oneTraversingInstanceLaunched = true; setState(() {}); // prevention of double- or multi- starts
  showArrowMoveToTheLeft=false;                     // hide Arrow "Move Left"
  showVerticalBigLables = false; setState(() {});   // hide
  bool showLocalFinger = false;
  int iEndsTmp;                                             // for dynamical shortening or extending range by slider
  if(TCC == 1) {iEndsTmp = ((rEND)/2).round() + 0;} else {iEndsTmp = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);}
//////////////////////////// Playback speed Slowdown correction using Stopwatch (part 1 of 3): /////////////////
// Android: first ~3 measures after first file load - playback accelerates, then slows down,
// Windows: in background - playback accelerates (when result of widget rebuild is not visible)
// Conclusion: needs speed correction, SLOWDOWN (!), so used stopwatch steps 1-3:
    Stopwatch stopwatch;  // measure execution duration in between lines of code 1 of 2
//      print('Elapse Start: ${stopwatch.elapsed}'); // works fine
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
                // if TSV, prevention of iEnds range error at the end of playback (1 of 2):
                if(wasTSVextDetected==true) { // TSV needs minus one element at the end (this is the difference from CSV):
                                           iEnds = csvLst.length - 1;
                } else {
                } //end if TSV was detected
//print(iEnds);print(wasTSVextDetected);
//--------------------------------------- Main Cycle Loops Begin ---------------------------------------//
  for (int i = iStarts; i < iEnds; i++) { // traversing a list from start to finish //"mS" could be changed at any time by Slider
    if(TCC == 1) {iEndsTmp = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0;} else {iEndsTmp = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0 + (TCC - 1) * (nTcolS*2);}  // use listenable value ntTblNtfrsList[1]['rangeEnd']!
    if((i==iEnds-1) && OisLEFT == 0 && OisRIGHT == 0 && TCC > 1) {showArrowMoveToTheLeft=true;setState(() {});} else {};      // show suggest to move to the left handle of the range slider to start from the beginning
////////// Stopwatch (part 2 of 3)///////////
      stopwatch = Stopwatch()..start();
      stopwatch.reset();
        //print('Elapse Start: ${stopwatch.elapsed}');
/////////// End Stopwatch (part 2 of 3)//////
    ntTblNtfrsList = [...ntTblNotifier.value];  // here value attached to the Notifier
//
    /////////////// Animation of Cursor Move
    PBIT       = i;  // animation of cursor move
    ntTblNtfrsList[3]['playingBit'] = PBIT;
    ntTblNotifier.value = ntTblNtfrsList;
    /////////////// End Animation of Cursor Move
//
//
    // if range slider became All the way to the left and All the way to the right, then:
    if (OisLEFT == 0 && OisRIGHT == 0 && fromTheBegin == true) { // restore cursor position when range released by user
       setState(() {fromTheBegin = false;}); // will not start from the begin of the List   toDo: !!! setState Remove It !!!
    } else {} // end if
//
//////////////////////////////////////////////////////////////////// // range WAS all the way to the left and right (not set), and NOW it changed by user, then Stop:
    if((OisLEFT==0 && ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) != 0) || (OisRIGHT==0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0)) {
      setState(() {toggleIcnMsrBtn = true;});
      ntTblNtfrsList = [...ntTblNotifier.value];
      ntTblNtfrsList[5]['msrTgl'] = 0;
      ntTblNotifier.value = ntTblNtfrsList;
    }
    else {}
////////////////////////////////////////////////////////////////////
//
/////////////////////////////////  Automatically shift left Range to first found note if right interval was changed by user: (not a very important function, but convenient)
//     if(OisLEFT==0 && OisRIGHT == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0) {
//       for (int u = SBIT; u < iEndsTmp; u++) {
//         for (int v = 1; v < notesByBit; v++) {
//           if(csvLst[u][v] != "") {ntTblNtfrsList[0]['rangeStart'] = u; v=notesByBit; u=iEndsTmp; setState(() {});} else {}  // ?????
//         }
//       }
//     } else {}
/////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////
    if (toggleIcnMsrBtn) {  // if measure button pressed by user
      if (fromTheBegin) {
        i = iEnds - 1; // exit from cycle = release, stop
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
        //                           // So that there is no empty space at the cursor position after stopping:
        ntTblNtfrsList[3]['playingBit']       = maxLength;
        ntTblNotifier.value = ntTblNtfrsList;
        //
        setState(() {toggleIcnMsrBtn = true;oneTraversingInstanceLaunched = false;});
      } // end if (start from the begin)
    } else {} // end exiting cycle (stop play), measure button pressed by user
/////////////////////////////////////////////////////////////////////////////////////////
    // SET STATE - COMMENT IT 3 of 4
    // for debug:
    // ntTableCaptionTxt = 'rSTART:${rSTART} rEND:${rEND} iETmp:${iEndsTmp} PBIT:${PBIT} i:${i} TCC:$TCC'; setState(() {}); // for debug
    // end debug
    ///////////////////////////////////////////////////////////////////////////////
    // if range dynamically changed by user (rangeEnd became less than playingBit):
    if ((iEndsTmp <= PBIT && (OisLEFT != 0 || OisRIGHT != 0))) {  // if range dynamically changed by user
      {setState(() {i = iEnds - 1;});}
    } else {} // end if
    //////////////////////////////////////////////////////////////////////////////
//////////////////////////// Current Bit Traversal by "j", PlayingNotes ////////////////////////////////
    for (int j = 1; j <= notesByBit; j++) {      // (j) is number of playing string at the moment, and  shortOrLong - is variant of note's length // <=   <=   <=  less or equal
      //print('$i   $iEnds   ${csvLst.length}'); print('i  iEnds  csvLst.length');
      //print(csvLst.length);
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
                                                                    //ntTableCaptionTxt = showFingeringOnButtons[j].toString(); setState(() {}); // for debug             contains(RegExp('i'), 0)
                                                                    //ntTableCaptionTxt = showLocalFinger.toString(); setState(() {}); // for debug
                                                                    //ntTableCaptionTxt = csvLst[i][j].toString(); setState(() {}); // for debug
                                                                    //ntTableCaptionTxt = '==${csvLst[i][j].toString()}==${showFingeringOnButtons[j]}==${showLocalFinger}=='          ; setState(() {}); // for debug
        addButtonsStates(j, showLocalFinger);        // pressing the button
      }  // will be hear async parallel simultaneously sounds notes by one bit and aftertones of previous bits notes
    } // ind for (j)
//////////////////////////// End Current Bit Traversal by "j", PlayingNotes ////////////////////////////
    ///////////////////////////////// Uncomment this:
    //ntTableCaptionTxt = 'TCC:${TCC} PBIT:${PBIT} SBIT:${SBIT}'; setState(() {}); // for debug
    //ntTableCaptionTxt = '-rSTART-${rSTART}-rEND-${rEND}-STB032-${STB032}-ENB032-${ENB032}-STB064-${STB064}-ENB064-${ENB064}-'; setState(() {}); // for debug
          //ntTableCaptionTxt = '-----i------'+i.toString()'; setState(() {}); // for debug
          //ntTableCaptionTxt = '-playingBit-'+PBIT.toString()'; setState(() {}); // for debug
          //ntTableCaptionTxt = '-startBit-'+SBIT.toString()'; setState(() {}); // for debug
          //ntTableCaptionTxt = '--iStarts---'+iStarts.toString()'; setState(() {}); // for debug
          //ntTableCaptionTxt = '--iEnds---'+iEnds.toString()'; setState(() {}); // for debug
    ////////////////////////////////
//
//////////////////////////// Playback speed Slowdown correction using Stopwatch (part 2a of 3): /////////////////
//stopwatch.stop(); // measure execution duration in between lines of code
//  if(i.remainder(5)==0) {ntTableCaptionTxt=stopwatch.elapsedMicroseconds.toString();setState(() {});} else {} //end if
//print('Elapse End w/o pauses, mks: ${stopwatch.elapsedMicroseconds}');
//print('                   mD, mks: '+reCalculateMD().inMicroseconds.toString());
//////////////////////////// End Stopwatch (part 2a of 3): //////////////////////////////////////////////////////
//
///////////////////////--------Change table View---------///////////////////////
    //////////////////// Try Change Table View with await (try to prevent sound Freeze in non-fullsize Win build; NOT EFFECT!)/////// Cause was: 1) tables, wrapped into Inkwell, should be used and 2) new SDK version (elevated text buttons without shades effect)
    await changeTableView(i,iStarts,dontChangeView);        // when part of widget rebuilds occurs some sound freeze, only if Not full-size window
    if(OisLEFT == 0 && OisRIGHT == 0 && rSTART?.round() != 2*nTcolS) {
      iEnds = maxLength;
      // if TSV, prevention of iEnds range error at the end of playback (2 of 2):
      if(wasTSVextDetected==true) { // TSV needs minus one element at the end (this is the difference from CSV):
        iEnds = csvLst.length - 1;
      } else {
      } //end if TSV was detected
    } else {}; //end if
    if((i+1).remainder(nTcolS*2) == 0) {dontChangeView = false;} else {} //end if // don't change table view after manually toggle button play
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////------End Change table View------////////////////////////
//
//ntTableCaptionTxt = 'TCC:${TCC} PBIT:${PBIT} SBIT:${SBIT} TCC032:${TCC032} TCC064:${TCC064} 32or64: $isSwitched32or64 UorL: $tapMadeOnUpperOrLowerTable'; setState(() {}); // for debug
//ntTableCaptionTxt = 'TCC:${TCC} PBIT:${PBIT} SBIT:${SBIT}'; setState(() {}); // for debug
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
    } // end if(): setting Icon on Measure Button to "Play" (default)
/////////////////// End Completion naturally /////////////////////
//
//////////////////////////// Playback speed Slowdown correction using Stopwatch (part 3 of 3): /////////////////
// stopwatch.stop(); // measure execution duration in between lines of code
//if(i.remainder(5)==0) {ntTableCaptionTxt='stopwatch: ${stopwatch.elapsedMicroseconds.toString()} md2: ${reCalculateMD2().toString()}';setState(() {});} else {} //end if
   //print('Elapse End: ${stopwatch.elapsed}');
   //print('Elapse End, ms: ${stopwatch.elapsedMilliseconds}');
   //print('        mD, ms: '+reCalculateMD().inMilliseconds.toString());
//print('Elapse End, mks: ${stopwatch.elapsedMicroseconds}');
//print('        mD, mks: '+reCalculateMD().inMicroseconds.toString());
//
//// Extra Delay (especially relevant: to Android - ONLY at App launch and first file load - it is accelerating, so, it needs to some slowDown):
//// toDo: There was a very significant smoothness, it's very good:
    if(stopwatch.elapsedMilliseconds < 100) {   // < 100 mS clean code execution time
      for (int u = 0; u < 6; u++) {await Future.delayed(reCalculateMD());} // end for(u)
    } else {} //end if
//
/*
    if(stopwatch.elapsedMilliseconds < 120) {   // if too fast: then make an extra delay
      for (int u = 0; u < 14; u++) {await Future.delayed(reCalculateMD());} // end for(u)
    } else if(stopwatch.elapsedMilliseconds < 140) {
      for (int u = 0; u < 12; u++) {await Future.delayed(reCalculateMD());} // end for(u)
    } else if(stopwatch.elapsedMilliseconds < 160) {
      for (int u = 0; u < 10; u++) {await Future.delayed(reCalculateMD());} // end for(u)
    } else if(stopwatch.elapsedMilliseconds < 180) {
      for (int u = 0; u < 8; u++) {await Future.delayed(reCalculateMD());} // end for(u)
    } else if(stopwatch.elapsedMilliseconds < 190) {
      for (int u = 0; u < 6; u++) {await Future.delayed(reCalculateMD());} // end for(u)
    } else {
  //print('Duration normalized');
    } //end if too fast // if >= 190 then No additional Delay
*/
//
///////////////////////////////////////////// End Stopwatch 3 of 3 ////////////////////////////////////////////////
  } // end for (i)                                        // "oneTraversingInstanceLaunched" is a Double-start prevention
  oneTraversingInstanceLaunched = false; setState(() {}); // after additional list traversal it could be "true", so setting it to "false" at the end
} // end listTraversal()
//
  Future<void> playFromList () async {      // ASYNC because we use "await", resolves a problem with disappeared buttons with status 'pressed'
    int iStarts = 1;
    int iEnds = maxLength;
    ntTblNtfrsList = [...ntTblNotifier.value];
    ntTblNtfrsList[5]['msrTgl'] = 1;
    cnslDelay1Ntfr.value = false;
    noteVolume = 0.9;
    playerInitWithEmptyNote();  // initialize player and wait 0.8 seconds
    await Future.delayed(Duration(milliseconds: 800)); // give time to initialize the player. // Map: See also SplayTreeMap (Sorted! HashMap), "Splay"!
if (playerMode==2) {audioPlayersMap = Map.fromEntries(audioPlayersMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));} else {} // sorting HashMap (optional part of Win Memory Leak Resolve)
    List jBtnRelease = [];                  // release the buttons of short-sounding notes a little earlier, List of numbers of short notes by one beat
    List csvLst = List.from(dataF);         // again !!! creating csvLst, like in loadTagsFirst() func.
///////////////////////////////////////////////////////////////////////////////////////////////////////  end TSV adding elements at the end   5 of 5
if(wasTSVextDetected==true) { // TSV needs one additional element at the end (this is the difference from CSV):
  final List<dynamic>emptyFillingList_00a = List.generate(1,(i) => List.generate((cols1 + 1),(j) => '', growable: true), growable: true);
  csvLst = csvLst + emptyFillingList_00a + emptyFillingList_00a + emptyFillingList_00a; // prevention of freeze at the end of TSV List playing // if you will use "add" instead of "+" you will give not element add but list of elements add
  //maxNotEmptyPos = maxNotEmptyPos - 1;
  //print(csvLst); print(csvLst.length);
} else {} //end if TSV was detected.
///////////////////////////////////////////////////////////////////////////////////////////////////////  end TSV adding elements at the end   5 of 5
      int notesByBit = 22;                                        // allways 22        if 21 string: 22         if 22 string: 22         For F2 Button To Work!
//    int notesByBit = stringsNum;
//
//**********************************************************************//
    var OisLEFT =  ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2);  // Range slider left Handle at the Left position
    var OisRIGHT = ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4);    // Range slider right Handle at the Right position
    var rSTART  = ntTblNtfrsList[0]['rangeStart']!;
    var rEND    = ntTblNtfrsList[1]['rangeEnd']!;
    var PBIT   = ntTblNtfrsList[3]['playingBit']!;
    var TCC     = ntTblNtfrsList[4]['tableChangeCount']!;
    var SBIT    = ntTblNtfrsList[2]['startBit']!;
//**********************************************************************//
/////////////////////////////////// iStarts, iEnds = depends on selected Range: //////////////////////////////////////////////////////////////////
if (OisLEFT == 0 && OisRIGHT == 0 && rSTART?.round() != 2*nTcolS)  {
                iStarts = SBIT + 0;
                iEnds = maxLength;
      // if TSV, prevention of iEnds range error at the end of playback (2 of 2):
      if(wasTSVextDetected==true) { // TSV needs minus one element at the end (this is the difference from CSV):
        iEnds = csvLst.length - 1;
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
            iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
            PBIT = iStarts - 0;
            iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
          } else { // left range is NOT all the way to the left
            iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
            PBIT = iStarts - 0;
            iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
          } //end if
          if(OisRIGHT == 0) { //rangeEnd is all the way to the right
            iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
          } else {
          } //end if(range End is all the way to the right)
  } else if(TCC == 3) { //second and subsequent views (tableChangeCount==3)
            if(OisLEFT == 0) { // rangeStart is all the way to the left
              iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
              PBIT = iStarts - 0;
              iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
            } else { // left range is NOT all the way to the left
              iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
              PBIT = iStarts - 0;
              iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
            } //end if
            if(OisRIGHT == 0) { //rangeEnd is all the way to the right
              iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
            } else {
            } //end if(range End is all the way to the right)
  } else if(TCC > 3) {
              if(OisLEFT == 0) { // rangeStart is all the way to the left
                iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
                PBIT = iStarts - 0;
                iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
              } else { // left range is NOT all the way to the left
                iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
                PBIT = iStarts - 0;
                iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
              } //end if
              if(OisRIGHT == 0) { //rangeEnd is all the way to the right
                iEnds = ((rEND)/2).round() + 0 + (TCC - 1) * (nTcolS*2);
              } else {
              } //end if(range End is all the way to the right)
  } else {} //end if(tableChangeCount)
} // end if(range is all the way to the left and to the right)
    // Range Slider Left pos is 64:
  if(rSTART?.round() == 2*nTcolS) {iStarts = SBIT + nTcolS + 0;} else {}//end if Start: 64
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
    if(TCC == 1) {iEndsTmp1 = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0;} else {iEndsTmp1 = ((ntTblNtfrsList[1]['rangeEnd']!)/2).round() + 0 + (TCC - 1) * (nTcolS*2);}
    if (iEndsTmp1 > iEnds) { // addtitional list traversal if the range is dynamically extended further by the user
      if (OisLEFT != 0 || OisRIGHT != 0) { // only if range was set
        iStarts = iEnds + 0; iEnds = iEndsTmp1; // use only listenable value !!! ntTblNtfrsList[1]['rangeEnd']!
        // SET STATE - COMMENT IT 4 of 4
        // for debug:
        // ntTableCaptionTxt = 'rSTART:${rSTART} rEND:${rEND} iETmp1:${iEndsTmp1} PBIT:${PBIT} TCC:$TCC'; setState(() {}); // for debug
        // end debug
/////////////////////////////////////////// see rngExtend=true:
        await listTraversal (iStarts, iEnds, jBtnRelease, csvLst, notesByBit, true); // additional second list traversal, after main traversal ends
///////////////////////////////////////////
      } else {} //end if
    } else {} //end if
    setDataSharedPref(); // CALL
  } //end future playFromList() async
//
//
Future traversingForNavigate(List csvLst, int requiredMeasToStop) async{
//**********************************************************************//
  var PBIT   = ntTblNtfrsList[3]['playingBit']!;
//**********************************************************************//
  oneTraversingInstanceLaunched = true; setState(() {}); // prevention of double- or multi- starts
  bool dontChangeView = true;     // don't change Current Page View with Current Numbers of Measures
  ntTblNtfrsList = [...ntTblNotifier.value];
  int iStarts; iStarts = 0;
  int iEnds;   iEnds = csvLst.length - 0;
  if(wasTSVextDetected==true) {iEnds = csvLst.length - 1;} else {} //end if TSV was detected  // if TSV, prevention of iEnds range error at the end of playback (1 of 2) // TSV needs minus one element at the end (this is the difference from CSV)
//--------------------------------------- Main Cycle Loops Begin ---------------------------------------//
  for (int i = iStarts; i < iEnds; i++) { // traversing a list from start to finish
      ntTblNtfrsList = [...ntTblNotifier.value];
                /////////////// Animation of Cursor Move
                PBIT       = i;  // animation of cursor move
                ntTblNtfrsList[3]['playingBit'] = PBIT;
                ntTblNotifier.value = ntTblNtfrsList;
                /////////////// End Animation of Cursor Move
///////////////////////--------Change table View---------///////////////////////
    await changeTableView(i,iStarts,dontChangeView);
    if((i+1).remainder(nTcolS*2) == 0) {dontChangeView = false;} else {} //end if // don't change table view after manually toggle button play
///////////////////////------End Change table View------////////////////////////
//
////////////////////// Completion naturally //////////////////////
    if(ntTblNtfrsList[4]['tableChangeCount']!*2-1 == requiredMeasToStop) {i = iEnds - 1;} else {}
    if (i == iEnds - 1) {      // completion naturally upon reaching iEnds OR at the end of the List
      ntTblNtfrsList = [...ntTblNotifier.value];
        ntTblNtfrsList[5]['msrTgl'] = 0;
        ntTblNtfrsList[3]['playingBit']       = maxLength;
        ntTblNotifier.value = ntTblNtfrsList;
        setState(() {toggleIcnMsrBtn = true;oneTraversingInstanceLaunched = false;});
    } else {}
/////////////////// End Completion naturally /////////////////////
//
  } // end for (i)                                        // "oneTraversingInstanceLaunched" is a Double-start prevention
  oneTraversingInstanceLaunched = false; setState(() {}); // after additional list traversal it could be "true", so setting it to "false" at the end
} // end traversingForNavigate()
//
  tablesBothOnTap(bool isLongSwitching) {
  tapCollisionPrevention = true; setState(() {});
      ntTblNtfrsList = [...ntTblNotifier.value];
    // 32/64/128 Mode: switching by User tapping at Any of Two Tables
    // ensure that data1.length is at least (2*(2*nTcols)) before switching; also check TSV (it is different from CSV)
    // swith to (32) or (32-previous), if Second row of wide 64-cols table, or switch back:
//**********************************************************************//
    var TCC128 = ntTblNtfrsList[8]['tableChangeCount128']!;
    var TCC064 = ntTblNtfrsList[7]['tableChangeCount64']!;
    var TCC032 = ntTblNtfrsList[6]['tableChangeCount32']!;
    var PBIT   = ntTblNtfrsList[3]['playingBit']!;
    var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
    var SBIT   = ntTblNtfrsList[2]['startBit']!;
    var OisLEFT =  ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2);  // Range slider left Handle at the Left position
    var OisRIGHT = ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4);    // Range slider right Handle at the Right position
    var rSTART = ntTblNtfrsList[0]['rangeStart']!;
    var rEND = ntTblNtfrsList[1]['rangeEnd']!;
    var STB128 = ntTblNtfrsList[13]['rangeStart128bak']!;
    var ENB128 = ntTblNtfrsList[14]['rangeEnd128bak']!;
    var STB064 = ntTblNtfrsList[11]['rangeStart64bak']!;
    var ENB064 = ntTblNtfrsList[12]['rangeEnd64bak']!;
    var STB032 =  ntTblNtfrsList[9]['rangeStart32bak']!;
    var ENB032 = ntTblNtfrsList[10]['rangeEnd32bak']!;
    var ALLCOL = nTcolS*2;
    // by Default:   nTcolSHalf=8     nTcolSN=16     nTcolSDouble=32
//**********************************************************************//
    ////////////////  tapMadeOnUpperOrLowerTable - at the moment when cursor ON IT        64=>128       128=>64  128=>64       64=>32  64=>32        32=>64
if(isSwitched_32_64_128 ==64 && mode_3264_or_64128 == 64128){
      tapMadeOnUpperOrLowerTable = '064=>128';
      TCC  = TCC128;
      STB064 =  rSTART;
      ENB064   =  rEND;
      rSTART = STB128;
      rEND = ENB128;
      nTcolS=nTcolSDouble;
      if(TCC==1) {SBIT = (TCC128 - 1) * (nTcolS * 2) + 1;} else {SBIT = (TCC128 - 1) * (nTcolS * 2) + 0;}
      ntTableCaptionTxt_0 = '〇〇⬤';   ntTableCaptionTxt_0_sym = ['〇','〇','⬤'];   sym_font = [8,8,12];
      isSwitched_32_64_128 = 128;  // 32  64  128
      rngEnd=4*nTcolS;
    }
else if((((TCC128 - 1) * (nTcolS*2) + (nTcolS*1) <= PBIT && PBIT <= (TCC128 - 1) * (nTcolS*2) + (nTcolS*2)) || rSTART >= nTcolSDouble) && isSwitched_32_64_128 ==128 && isLongSwitching ==false){
           tapMadeOnUpperOrLowerTable = '128LOW=>064';
           if(TCC064 < TCC128*2) {TCC064 = TCC064 + 1;TCC032 = TCC032 + 2;} else {};
           TCC = TCC064;
           STB128 = rSTART;
           ENB128 = rEND;
           rSTART = STB064;
           rEND = ENB064;
           nTcolS=nTcolSN;
           SBIT = (TCC064 - 1) * (nTcolS*2);
           ntTableCaptionTxt_0 = '〇⬤〇';      ntTableCaptionTxt_0_sym = ['〇','⬤','〇'];   sym_font = [8,12,8];
           isSwitched_32_64_128 = 64;  // 32  64  128
           rngEnd=4*nTcolS;
    }
else if((((TCC128 - 1) * (nTcolS*2) + (nTcolS*0) <= PBIT && PBIT < (TCC128 - 1) * (nTcolS*2) + (nTcolS*1)) || rSTART < nTcolSDouble) && isSwitched_32_64_128 ==128 && isLongSwitching ==false){
     tapMadeOnUpperOrLowerTable = '128UP=>064';
     TCC = TCC064;
     STB128 = rSTART;
     ENB128 = rEND;
     rSTART = STB064;
     rEND = ENB064;
     nTcolS=nTcolSN;
     ntTableCaptionTxt_0 = '〇⬤〇';       ntTableCaptionTxt_0_sym = ['〇','⬤','〇'];   sym_font = [8,12,8];
     isSwitched_32_64_128 = 64;  // 32  64  128
     rngEnd=4*nTcolS;
    }
else if((((TCC064 - 1) * (nTcolS*2) + (nTcolS*1) <= PBIT && PBIT <= (TCC064 - 1) * (nTcolS*2) + (nTcolS*2)) || rSTART >= nTcolSN) && isSwitched_32_64_128 ==64 && mode_3264_or_64128 == 3264){
      tapMadeOnUpperOrLowerTable = '064LOW=>032';     //// PlayingBit is at Second (Lower) Row of 64 view
      if(TCC032 < TCC064*2) {TCC032 = TCC032 + 1;} else {};
      TCC  = TCC032;
      STB064 =  rSTART;
      ENB064 =  rEND;
      rSTART = STB032;
      rEND = ENB032;
      nTcolS=nTcolSHalf;
      SBIT = (TCC032 - 1) * (nTcolS*2);
      if(TCC==1) {SBIT = (TCC032 - 1) * (nTcolS*2) + 1;} else {SBIT = (TCC032 - 1) * (nTcolS*2) + 0;}
      ntTableCaptionTxt_0 = '⬤〇〇';     ntTableCaptionTxt_0_sym = ['⬤','〇','〇'];   sym_font = [12,8,8];
      isSwitched_32_64_128 = 32;  // 32  64  128
      rngEnd=4*nTcolS;
    }
else if((((TCC064 - 1) * (nTcolS*2) + (nTcolS*0) <= PBIT && PBIT < (TCC064 - 1) * (nTcolS*2) + (nTcolS*1)) || rSTART < nTcolSN) && isSwitched_32_64_128 ==64 && mode_3264_or_64128 == 3264) {
      tapMadeOnUpperOrLowerTable = '064UP=>032';
      TCC  = TCC032;
      STB064 =  rSTART;
      ENB064 =  rEND;
      rSTART = STB032;
      rEND = ENB032;
      nTcolS=nTcolSHalf;
      ntTableCaptionTxt_0 = '⬤〇〇';      ntTableCaptionTxt_0_sym = ['⬤','〇','〇'];   sym_font = [12,8,8];
      isSwitched_32_64_128 = 32;  // 32  64  128
      rngEnd=4*nTcolS;
    }
else if (isSwitched_32_64_128 ==32 && mode_3264_or_64128 == 3264) {                                         //// Current View is "32"
      tapMadeOnUpperOrLowerTable = '032=>064';
      TCC = TCC064;
      STB032 = rSTART;
      ENB032 = rEND;
      rSTART = STB064;
      rEND = ENB064;
      nTcolS=nTcolSN;
      if(TCC==1) {SBIT = (TCC064 - 1) * (nTcolS * 2) + 1;} else {SBIT = (TCC064 - 1) * (nTcolS * 2) + 0;}
      ntTableCaptionTxt_0 = '〇⬤〇';      ntTableCaptionTxt_0_sym = ['〇','⬤','〇'];   sym_font = [8,12,8];
      isSwitched_32_64_128 = 64;  // 32  64  128
      rngEnd=4*nTcolS;
    }
//else if()
    else {} //end if
//
//
//debug:    // for PBIT adding Leading Zeroes at the beginning of the string (padLeft):                         // setState() !!! use it Only for debugging
// SET STATE - COMMENT IT 2 of 4 !!!  mode_3264_or_64128
// ntTableCaptionTxt = 'TCC:${TCC} 32:${TCC032} 64:${TCC064} 128:${TCC128} is:$isSwitched_32_64_128 fr:$tapMadeOnUpperOrLowerTable PBIT:${PBIT.toString().padLeft(4, '0')} SBIT:${SBIT} '; setState(() {}); // for debug
//    ntTableCaptionTxt = 'TCC:${TCC} 32:${TCC032} 64:${TCC064} 128:${TCC128} is:$isSwitched_32_64_128'; setState(() {}); // for debug
// ntTableCaptionTxt = ' sbit:${SBIT} nTcolS*2:${nTcolS*2} rSTART:${rSTART} rEND:${rEND}'; setState(() {}); // for debug
// ntTableCaptionTxt = '  rEND:${rEND}'; setState(() {}); // for debug
//  ntTableCaptionTxt = 'TCC:${TCC} 32:${TCC032} 64:${TCC064} 128:${TCC128} is:$isSwitched_32_64_128 fr:$tapMadeOnUpperOrLowerTable mode:${mode_3264_or_64128} '; setState(() {}); // for debug
// for debug
//
//**********************************************************************//
      ntTblNtfrsList[8]['tableChangeCount128'] = TCC128;
      ntTblNtfrsList[7]['tableChangeCount64'] = TCC064;
      ntTblNtfrsList[6]['tableChangeCount32'] = TCC032;
      ntTblNtfrsList[3]['playingBit'] = PBIT;
      ntTblNtfrsList[4]['tableChangeCount'] = TCC;
      ntTblNtfrsList[2]['startBit'] = SBIT;
      ntTblNtfrsList[0]['rangeStart'] = rSTART;
      ntTblNtfrsList[1]['rangeEnd'] = rEND;
      ntTblNtfrsList[13]['rangeStart128bak'] = STB128;
      ntTblNtfrsList[14]['rangeEnd128bak'] = ENB128;
      ntTblNtfrsList[11]['rangeStart64bak'] = STB064;
      ntTblNtfrsList[12]['rangeEnd64bak'] = ENB064;
      ntTblNtfrsList[9]['rangeStart32bak'] = STB032;
      ntTblNtfrsList[10]['rangeEnd32bak'] = ENB032;
    setState(() {ntTblNotifier.value = ntTblNtfrsList;});                    // !!! Unfortunately  USING SETTING STATE !!! Only when OnTap !!!
//**********************************************************************//
    ////////////////////////////////////
    //
    ////////////////////////////////////
    //
    setDataSharedPref(); // CALL    // Setting 16 parameters, including slider's Range into Shared Preferences
    //
    tapCollisionPrevention = false; setState(() {});
  } // End tablesBothOnTap()
//
//
  loading__3264_or_64128() {
//**********************************************************************//
    var TCC032 = ntTblNtfrsList[6]['tableChangeCount32']!;
    var TCC064 = ntTblNtfrsList[7]['tableChangeCount64']!;
    var TCC128 = ntTblNtfrsList[8]['tableChangeCount128']!;
    var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
    var rSTART = ntTblNtfrsList[0]['rangeStart']!;
    var rEND = ntTblNtfrsList[1]['rangeEnd']!;
    var STB032 =  ntTblNtfrsList[9]['rangeStart32bak']!;
    var ENB032 = ntTblNtfrsList[10]['rangeEnd32bak']!;
    var STB064 = ntTblNtfrsList[11]['rangeStart64bak']!;
    var ENB064 = ntTblNtfrsList[12]['rangeEnd64bak']!;
    var STB128 = ntTblNtfrsList[13]['rangeStart128bak']!;
    var ENB128 = ntTblNtfrsList[14]['rangeEnd128bak']!;
//**********************************************************************//
    if(isSwitched_32_64_128==128){
      TCC = TCC128;
      rSTART = STB128;
      rEND = ENB128;
      nTcolS=nTcolSDouble;
    }
    else if(isSwitched_32_64_128==64) {
      TCC = TCC064;
      rSTART = STB064;
      rEND = ENB064;
      nTcolS=nTcolSN;
    }
    else if(isSwitched_32_64_128==32) {
      TCC = TCC032;
      rSTART = STB032;
      rEND = ENB032;
      nTcolS=nTcolSHalf;
    }
    else {}
//**********************************************************************//
    ntTblNtfrsList[0]['rangeStart'] = rSTART;
    ntTblNtfrsList[1]['rangeEnd'] = rEND;
    ntTblNtfrsList[4]['tableChangeCount'] = TCC;
    ntTblNotifier.value = ntTblNtfrsList;
//**********************************************************************//
    setState(() {});
    //
  }
//
  switchingTableViewByLongPress()  {
//**********************************************************************//
    var TCC032 = ntTblNtfrsList[6]['tableChangeCount32']!;
    var TCC064 = ntTblNtfrsList[7]['tableChangeCount64']!;  // not used
    var TCC128 = ntTblNtfrsList[8]['tableChangeCount128']!;
    var TCC    = ntTblNtfrsList[4]['tableChangeCount']!;
    var rSTART = ntTblNtfrsList[0]['rangeStart']!;
    var rEND = ntTblNtfrsList[1]['rangeEnd']!;
    var STB032 =  ntTblNtfrsList[9]['rangeStart32bak']!;
    var ENB032 = ntTblNtfrsList[10]['rangeEnd32bak']!;
    var STB064 = ntTblNtfrsList[11]['rangeStart64bak']!;   // not used
    var ENB064 = ntTblNtfrsList[12]['rangeEnd64bak']!;     // not used
    var STB128 = ntTblNtfrsList[13]['rangeStart128bak']!;
    var ENB128 = ntTblNtfrsList[14]['rangeEnd128bak']!;
//**********************************************************************//
    if(isSwitched_32_64_128==64 && mode_3264_or_64128 == 3264){
              // // /////////////////// restarting playback 1 of 3:
              // setState(() {toggleIcnMsrBtn = true;});
              // ntTblNtfrsList = [...ntTblNotifier.value];
              // ntTblNtfrsList[5]['msrTgl'] = 0;
              // ntTblNotifier.value = ntTblNtfrsList;
              // // ///////////////////
      TCC = TCC128;
      STB064 = rSTART;
      ENB064 = rEND;
      rSTART = STB128;
      rEND = ENB128;
      mode_3264_or_64128 = 64128;
    }
    else if(isSwitched_32_64_128==64 && mode_3264_or_64128 == 64128) {
              // // /////////////////// restarting playback 2 of 3:
              // setState(() {toggleIcnMsrBtn = true;});
              // ntTblNtfrsList = [...ntTblNotifier.value];
              // ntTblNtfrsList[5]['msrTgl'] = 0;
              // ntTblNotifier.value = ntTblNtfrsList;
              // // ///////////////////
      TCC = TCC032;
      STB064 = rSTART;
      ENB064 = rEND;
      rSTART = STB032;
      rEND = ENB032;
      mode_3264_or_64128 = 3264;
    }
    else {}
//**********************************************************************//    isSwitched_32_64_128 = 64     TILL THE END OF FUNCTION !!!
    ntTblNtfrsList[0]['rangeStart'] = rSTART;
    ntTblNtfrsList[1]['rangeEnd'] = rEND;
    ntTblNtfrsList[4]['tableChangeCount'] = TCC;
    ntTblNtfrsList[11]['rangeStart64bak'] = STB064;
    ntTblNtfrsList[12]['rangeEnd64bak'] = ENB064;
    ntTblNotifier.value = ntTblNtfrsList;
//**********************************************************************//
    setState(() {});
    tablesBothOnTap(true); // CALL
    // // /////////////////// restarting playback 3 of 3:
    // setState(() {toggleIcnMsrBtn = false;});
    // ntTblNtfrsList[5]['msrTgl'] = 1;
    // ntTblNotifier.value = ntTblNtfrsList;
    // showVerticalBigLables = false; setState(() {});
    // playFromList ();
    // // ///////////////////
    //
    //setState(() {});  // second setState()
  } // end switchingTableViewByLongPress()
//
//
  hideControlsForScreenshotModeByLongPress() {
    hideControlsForScreenshotMode = !hideControlsForScreenshotMode;
    if(hideControlsForScreenshotMode) DesktopWindow.setWindowSize(Size(860,1600));
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
      tunerNotSupportedTextPlatformDepending = "The Tuner can only be implemented in Jalinativeinstrument assemblies for Android and iOS! Not in Windows, MacOS, Linux";
    } else {tunerNotSupportedTextPlatformDepending = "";}
////////////////////////////////////////////////////
    if(isTunerModeEnable==true) {_stopCapture();} else {}    // Turn OFF capturing stream from Mic with turning OFF Green Mic Privacy Indicator, also see Binding Observer (when App is Inactive)
    isTunerModeEnable = !isTunerModeEnable;
    setState(() {});
    ////////////////////////////////////////////////////////////////////// keep_screen_on 4 of 4
    KeepScreenOn.turnOff(withAllowLockWhileScreenOn: true); // immediately stop
    //////////////////////////////////////////////////////////////////////
  } // end tunerModeEnableByKeyLongPress()
  ////////////////////////////////////////////////////////  keep_screen_on 1 of 4
  Future<void> customKeepScreenOnFuture() async {
  //KeepScreenOn.turnOn(withAllowLockWhileScreenOn: true);
    KeepScreenOn.turnOn(withAllowLockWhileScreenOn: false);
    await Future.delayed(Duration(minutes: 3));               // waiting for 3 minutes
    //if isCustomKeepScreenOn==true                                                           //toDo toDo toDo toDo toDo toDo toDo toDo toDo toDo
    KeepScreenOn.turnOff(withAllowLockWhileScreenOn: true);
  }
  //////////////////////////////////////////////////////// end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ pitch_detector (tuner) with audio_capture  3 of 4
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);  //don't pay attention to the name of the musical instrument
  var currDetectedNote = "";
  var currTuneStatus = "Click on start";
//
  Future<void> _startCapture() async {
    var prmssStatus = await Permission.microphone.status;
    if (prmssStatus.isGranted) {
//////////////////////////////////////
      await _audioRecorder.start(listenerT, onErrorT, sampleRate: 44100, bufferSize: 3000);
      setState(() {currDetectedNote = ""; currTuneStatus = "Play something";});
//////////////////////////////////////
    } else if (prmssStatus.isDenied) {
      Permission.microphone.request();
    } // Granted Or Refused
  }   // end _startCapture()
//
  Future<void> _stopCapture() async {
    await _audioRecorder.stop();
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
        //
      }); // end setState()
    } else {}
  } // end void listenerT()
//
  void onErrorT(Object e) {print(e);}  // see _audioRecorder
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ end pitch_detector (tuner) with audio_capture  3 of 4
//
  @override
  Widget build(BuildContext context) {            // Widget Creating
//
    var size = MediaQuery.of(context).size;       // Getting parameters of context Widget (Height, Width, etc)
//
  // toDo: // if(size.width < pxlsWidth) {isSwitched32or64 = true;} else if(size.width >= pxlsWidth && isAppFirstLoad == true) {isSwitched32or64 = false;} else {isSwitched32or64 = true;} // two variants of Table Cols numbers depends on Window Width
//
    if (selectedtuningNum == 3 || selectedtuningNum == 4) {double fontSize = 20.0;} else {double fontSize = 18.0;}
    double fontSize_i = 16.0;         // font-size of text "Info"
    // double fontSize = 18.0;
    double heightSupportingSize = 5;  // default value is (4), supports Height of each cell of the both tables
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
                    backgroundColor: prsdBool ?  Colors.orange[100] : Colors.orange[50],
                    elevation: 3,  //visual effect for button
                  ),
                  onPressed: (){
                    playSound(selectedtuningNum,soundNum,shortOrLongNum,noteVolume,extension);
                    //harmonicFunctions (soundNum); //Complexity calculates well
                  },
                  child:
                  InkWell(
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
                                painter: RPSCustomPainter10(),
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
                                painter: RPSCustomPainter13(),
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
                                  painter: RPSCustomPainter13(),
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
                                  painter: RPSCustomPainter10(),
                                )
                            ) ,
                          ),
                          ] else ...[],
                        /////////////// end Fingering
                      ],
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
              backgroundColor: prsdBool ?  Colors.orange[100] : Colors.orange[50],   //foregroundColor: color,
              elevation: 2,  //visual effect for button
            ),
            onPressed: () {
              //////////////////////////
              openInfoPage();
              //////////////////////////
              // Open Help Page
            },
            icon: const Icon(Jaliinstrument.info, color: Colors.orange),
            label:
            Column (
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('info', style: TextStyle(fontSize: fontSize_i, color: Colors.black38)),
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
                     backgroundColor: prsdBool ?  Colors.orange[100] : Colors.orange[50],
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
                       if (buildKeysNotesOrFreqsMode==5) {fillDefaultColorsList();} else {}  //CALL                                              // Fingering Default
                       if (buildKeysNotesOrFreqsMode==6) {showVerticalBigLables = true;} else {}                                                 // big Labels (vertical text)
                       if (buildKeysNotesOrFreqsMode==7) {} else {}                                                                   //not used, upper is limit ">6"
                       if (buildKeysNotesOrFreqsMode==0) {fillDefaultColorsList(); showVerticalBigLables = false;} else {} //CALL               // F G A B C
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
                     child: Stack(     // stack is only to show Fingering under the button Layer   // Stack is like Z-Layers in CSS or transparent Layers in Photoshop. It's a Stack
                       alignment: Alignment.center,      // is Solution how to Align center, do not need to change base point of CustomPainter or it's width
                       children: <Widget>[
                         Column (
                           children: [
                             if(((soundNum==0 && stringsNum==22) || ((soundNum==0 || soundNum==21) && stringsNum==21)) && (buildKeysNotesOrFreqsMode==0 || buildKeysNotesOrFreqsMode==1 || buildKeysNotesOrFreqsMode==5 || buildKeysNotesOrFreqsMode==6)) ...[
                               Container(
                                 child:
                                 CustomPaint(
                                   size: Size(WIDTH_2,(WIDTH_2*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                   painter: RPSCustomPainter2(),    // machine head
                                 ),
                               ) ,
                             ] else if(((soundNum==0 && stringsNum==22) || ((soundNum==0 || soundNum==21) && stringsNum==21)) && buildKeysNotesOrFreqsMode==2) ...[
                               Container(
                                 child:
                                 CustomPaint(
                                   size: Size(WIDTH_1,(WIDTH_1*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                   painter: RPSCustomPainter1(),    // wooden peg
                                 ),
                               ) ,
                             ] else if(((soundNum==0 && stringsNum==22) || ((soundNum==0 || soundNum==21) && stringsNum==21)) && (buildKeysNotesOrFreqsMode==3 || buildKeysNotesOrFreqsMode==4)) ...[
                               Container(
                                 child:
                                 CustomPaint(
                                   size: Size(WIDTH_1,(WIDTH_1*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                   painter: RPSCustomPainter7(),    // diam. measuring tool
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
                                 painter: RPSCustomPainter11(),
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
                                 painter: RPSCustomPainter14(),
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
                                   painter: RPSCustomPainter14(),
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
                                   painter: RPSCustomPainter11(),
                                 )
                             ) ,
                           ),
                         ] else ...[],
                         /////////////// end Fingering
                       ],
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
        child: Scaffold(
            backgroundColor: Colors.white, // background color of App
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
                                      painter: RPSCustomPainter8(),
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
                              Row (          // mode indicator (three circles utf-8 symbols)        // table caption text   (csvMode == 1 && playerMode == 1) ?
                                children: [  //  if Android, MacOS:
                                  (csvMode == 1 && playerMode == 1) ?   Container(height: centralColumnHeaderHeigth, child: Text(ntTableCaptionTxt_0_sym[0], style: TextStyle(fontFamily: 'Lucida',fontStyle: FontStyle.normal, fontSize: sym_font[0], color: Colors.amber) ),): Container(),
                                  (csvMode == 1 && playerMode == 1) ?   Container(height: centralColumnHeaderHeigth, child: Text(ntTableCaptionTxt_0_sym[1], style: TextStyle(fontFamily: 'Lucida',fontStyle: FontStyle.normal, fontSize: sym_font[1], color: Colors.amber) ),): Container(),
                                  (csvMode == 1 && playerMode == 1) ?   Container(height: centralColumnHeaderHeigth, child: Text(ntTableCaptionTxt_0_sym[2], style: TextStyle(fontFamily: 'Lucida',fontStyle: FontStyle.normal, fontSize: sym_font[2], color: Colors.amber) ),): Container(),
                                  Container(height: centralColumnHeaderHeigth, child: Text('   ', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: Colors.amber) ),),
                                  (csvMode == 1 && playerMode == 1) ?   Container() : Container(height: centralColumnHeaderHeigth, child: Text(ntTableCaptionTxt_0 + '  ', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: Colors.amber) ),)
                                  ,
                                  Container(height: centralColumnHeaderHeigth, child: Text(ntTableCaptionTxt, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: Colors.amber) ),),
                                ],
                              ),
                            ),
                                ),
//
                                InkWell(    // with InkWell NO FREEZE When Table View Changes !!!
                                  onTap: (){
                                    if(tapCollisionPrevention == false) {   // so that the cursor doesn't run away, waiting for previous tapping ends
                                      tablesBothOnTap(false);
                                    } else {}
                                  },
                                  onLongPress: () {
                                    switchingTableViewByLongPress();
                                  },
                                  child:
//////// FIRST: ///////////////////// toDo: variable doesn't have to be inside setState(), widget rebuilds with new value of variable after each setState WITHOUT ValueListenableBuilder!!!, even if variable is not inside the setState() !!!
                                  ValueListenableBuilder<List<Map<String, int>>> (     // works very well!
                                      valueListenable: _JaliinstrumentState.ntTblNotifier,
                                      builder: (context, ntTblNtfrsList, __) {  //As few assignments of new variables as possible! It slows down!
                                        return Table(
                                            border: TableBorder.all(width: 0, color: const Color(
                                                0xFFF6EAB4)),  //toDo: uncomment it!
                                            // border: TableBorder.all(width: 0, color: Colors.black12),  // visible grid, but too thick in Win
                                            children:
                                            [
                                              for(int i = 0; i < stringsNum; i++)  TableRow(children: [
                                                for(int j = ntTblNtfrsList[2]['startBit']!.round(); j! < ntTblNtfrsList[2]['startBit']!.round() + nTcolS; j++)
// if(data1[i][j] != '') {data1[i][j] = '⬤';} else {}  // replacing all notes with '⬤', filled circle symbol
                                                  if (data1[i][j] != '' && j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                    Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                      //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      decoration: BoxDecoration(color: Colors.yellow[700],borderRadius: BorderRadius.circular(heightSupportingSize+1)),  width: heightSupportingSize+1,  height: heightSupportingSize+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                      child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                    ),
                                                  ] else if (data1[i][j] != '') ...[
                                                    Container(                      // if not empty, then decorate (contains some Note)
                                                      //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(heightSupportingSize+1)),  width: heightSupportingSize+1,  height: heightSupportingSize+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                      child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) == 0 && j!=ntTblNtfrsList[3]['playingBit']) ...[
                                                    Container(
                                                      color:   Colors.amber[50],    // Start: divides by 64, End: divides by 128 && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)) || ((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                    Container(                  // Border-L Green Range 1st table
                                                      decoration: BoxDecoration(
                                                        color:   Colors.lime[100],
                                                        border: Border(
                                                          left: BorderSide(color: const Color(
                                                              0xffffce4c),width: isSwitched_32_64_128==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                        ),
                                                      ),                      // Border-L Green Range 1st table (now it's thin Orange)
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)) || ((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                    Container(            // Border-R Green Range 1st table
                                                      decoration: BoxDecoration(
                                                        color:   Colors.lime[100],
                                                        border: Border(
                                                          right: BorderSide(color: const Color(
                                                              0xffffce4c),width: isSwitched_32_64_128==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                        ),
                                                      ),                  // Border-R Green Range 1st table (now it's thin Orange)
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 1) ...[
                                                    Container(                      // Green Range 1st table (see also: second cond.)
                                                      color:   Colors.lime[100],    // S + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != nTcolS*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 1) ...[
                                                    Container(                      // Green Range 1st table (second condition)
                                                      color:   Colors.lime[100],    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 2) ...[
                                                    Container(                      // Green Range 1st table (see also: second cond.)
                                                      color:   Colors.lime[100],    // S + 1 + (C-1)*(32*2) < = j < = E + 0 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != nTcolS*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 2) ...[
                                                    Container(                      // Green Range 1st table (second condition)
                                                      color:   Colors.lime[100],    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 3) ...[
                                                    Container(                      // Green Range 1st table (see also: second cond.)
                                                      color:   Colors.lime[100],    // S + 1 + (C-1)*(32*2) < = j < = E + 0 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != nTcolS*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 3) ...[
                                                    Container(                      // Green Range 1st table (second condition)
                                                      color:   Colors.lime[100],    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)   <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! > 3) ...[
                                                    Container(                      // Green Range 1st table (see also: second cond.)
                                                      color:   Colors.lime[100],    // S + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != nTcolS*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) != 0 && j < (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2)  && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! > 3) ...[
                                                    Container(                      // Green Range 1st table (second condition)
                                                      color:   Colors.lime[100],    // S: divides by 64 && S != 64 + (C-1)*(32*4) (Not at the Middle Position) && E: Not divides by 128 && j < E + (C-1)*(32*2)
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1 && ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) == 0) ...[
                                                    Container(
                                                      color:   Colors.lime[200],    // j: is PlayingBit && msrTgl==1 && S: all the way to the left (divides by 64) && E: all the way to the right (divides by 128)
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                    Container(                      // Light Cursor 1st table
                                                      color:   Colors.lime[50],     // j: is PlayingBit && msrTgl==1
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else ...[
                                                    Container(
                                                      color:   Colors.amber[50],    // in all other cases
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] // end if[]
                                              ]),
                                            ]
                                        );
                                      }),
                                ),
                                InkWell(    // with InkWell NO FREEZE When Table View Changes !!!
                                  onTap: (){
                                    tablesBothOnTap(false);
                                  },
                                  onLongPress: () {
                                    switchingTableViewByLongPress();
                                  },
                                  child:
/////// SECOND: // Lower Level of the Table://///////////////
                                  ValueListenableBuilder<List<Map<String, int>>> (
                                      valueListenable: _JaliinstrumentState.ntTblNotifier,
                                      builder: (context, ntTblNtfrsList, __) {  //As few assignments of new variables as possible! It slows down!
                                        return Table(
                                            border: TableBorder.all(width: 0, color: const Color(
                                                0xFFEFEEE1)),  //toDo: uncomment it!
                                            children:
                                            [
                                              for(int i = 0; i < stringsNum; i++)  TableRow(children: [
                                                for(int j = ntTblNtfrsList[2]['startBit']!.round() + nTcolS; j! < ntTblNtfrsList[2]['startBit']!.round() + nTcolS*2; j++)
// if(data1[i][j] != '') {data1[i][j] = '⬤';} else {}  // replacing all notes with '⬤', filled circle symbol
                                                  if (data1[i][j] != '' && j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                    Container(                      // if not empty and is playingBit, then decorate with another color (contains some Note)
                                                      //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      decoration: BoxDecoration(color: Colors.yellow[700],borderRadius: BorderRadius.circular(heightSupportingSize+1)),  width: heightSupportingSize+1,  height: heightSupportingSize+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                      child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                    ),
                                                  ] else if (data1[i][j] != '') ...[
                                                    Container(                      // if not empty, then decorate (contains some Note)
                                                      //decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(5)),  width: 5,  height: 5, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      decoration: BoxDecoration(color: Colors.orange[700],borderRadius: BorderRadius.circular(heightSupportingSize+1)),  width: heightSupportingSize+1,  height: heightSupportingSize+1, // if not empty, then decorate (contains some Note) // form: circle (the closer the shape of the cell to the square)
                                                      //child: Text(data1[i][j].toString(), style: TextStyle(fontSize: heightSupportingSize, color: Colors.orange[400])),   // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                      child: Text('⬤', style: TextStyle(fontSize: heightSupportingSize, color: keysColorsList[i])),    // in loadTagsFirst() function all notes were replaced with '⬤', filled circle symbol
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[0]['rangeStart']?.round() != nTcolS*2 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) == 0 && j!=ntTblNtfrsList[3]['playingBit']) ...[
                                                    Container(
                                                      color:   Colors.amber[50],    // Start: divides by 64 && Start: Not at the Middle Position && End: divides by 128 && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)) || ((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                    Container(                      // Border-L Green Range 2nd table
                                                      decoration: BoxDecoration(
                                                        color:   Colors.lime[100],
                                                        border: Border(
                                                          left: BorderSide(color: const Color(
                                                              0xffffce4c),width: isSwitched_32_64_128==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                        ),
                                                      ),                      // Border-L Green Range 2nd table
                                                      child: Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                    ),
                                                  ] else if(ntTblNtfrsList[0]['rangeStart']?.round() != ntTblNtfrsList[1]['rangeEnd']?.round() && (((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 2 || ntTblNtfrsList[4]['tableChangeCount']! == 3)) || ((ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) == j && (ntTblNtfrsList[4]['tableChangeCount']! == 1 || ntTblNtfrsList[4]['tableChangeCount']! > 3)))  && j!=ntTblNtfrsList[3]['playingBit']!) ...[
                                                    Container(                      // Border-R Green Range 2nd table
                                                      decoration: BoxDecoration(
                                                        color:   Colors.lime[100],
                                                        border: Border(
                                                          right: BorderSide(color: const Color(
                                                              0xffffce4c),width: isSwitched_32_64_128==32 ? 2 : 1,),    // width (3) OR width (1) Depends On Columns Number (True 32 /False 64)
                                                        ),
                                                      ),                      // Border-R Green Range 2nd table
                                                      child: Text(' ', style: TextStyle(fontSize: heightSupportingSize)),
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 1) ...[
                                                    Container(                      // Green Range 2nd table
                                                      color:   Colors.lime[100],    // S + 0 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 2) ...[
                                                    Container(                      // Green Range 2nd table
                                                      color:   Colors.lime[100],    // S + 1 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! == 3) ...[
                                                    Container(                      // Green Range 2nd table
                                                      color:   Colors.lime[100],    // S + 1 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if((ntTblNtfrsList[0]['rangeStart']?.round())!/2 + 0 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) <= j && j <= (ntTblNtfrsList[1]['rangeEnd']?.round())!/2 - 1 + (ntTblNtfrsList[4]['tableChangeCount']! - 1) * (nTcolS*2) && j!=ntTblNtfrsList[3]['playingBit'] && ntTblNtfrsList[4]['tableChangeCount']! > 3) ...[
                                                    Container(                      // Green Range 2nd table
                                                      color:   Colors.lime[100],    // S + 0 + (C-1)*(32*2) < = j < = E - 1 + (C-1)*(32*2) && j: is Not PlayingBit
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1 && ntTblNtfrsList[0]['rangeStart']?.round().remainder(nTcolS*2) == 0 && ntTblNtfrsList[1]['rangeEnd']?.round().remainder(nTcolS*4) == 0) ...[
                                                    Container(
                                                      color:   Colors.lime[200],    // j: is PlayingBit && msrTgl==1 && S: all the way to the left && E: all the way to the right
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else if(j==ntTblNtfrsList[3]['playingBit']! && ntTblNtfrsList[5]['msrTgl'] == 1) ...[
                                                    Container(                      // Light Cursor 2nd table
                                                      color:   Colors.lime[50],     // j: is PlayingBit && msrTgl==1
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] else ...[
                                                    Container(
                                                      color:   Colors.amber[50],    // in all other cases
                                                      child:   Text(' ', style: TextStyle(fontSize: heightSupportingSize)),  // small text color is the same as the cell colour, text will not be visible
                                                    ),
                                                  ] // end if[]
                                              ]),
                                            ]
                                        );
                                      }),
                                ),
/////// End Both Tables ////////////////////////////////////////////////////////////////////////////
//
                                if (!hideControlsForScreenshotMode) ...[
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.brown[200],
                                      inactiveTrackColor: Colors.brown[50],
                                      //inactiveTrackColor: Colors.white,
                                      trackShape: RectangularSliderTrackShape(),
                                      trackHeight: 1.0,
                                      disabledInactiveTrackColor: Colors.brown[50],
                                      thumbColor: Colors.brown[50],
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                      overlayColor: Colors.red.withAlpha(32),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                      //showValueIndicator: ShowValueIndicator.never,
                                      valueIndicatorColor: Colors.brown[200],
                                    ),
                                    child:
                                    Stack(
                                      children: <Widget>[                 // Container is OVER the painting, because it is LAST in the List
                                        if (showArrowMoveToTheLeft==true) ...[
                                          Container(
                                            child:
                                            CustomPaint(
                                              size: Size(WIDTH_15,(WIDTH_15*0.3833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                              painter: RPSCustomPainter15(),
                                            ),
                                          ) ,
                                        ] else ...[],
                                        Container( child:
                                        ValueListenableBuilder<List<Map<String, int>>> (
                                            valueListenable: _JaliinstrumentState.ntTblNotifier,
                                            builder: (context, ntTblNtfrsList, __) {
                                              double? doubleVar1 = (ntTblNtfrsList[0]['rangeStart'])?.toDouble();
                                              double? doubleVar2 = (ntTblNtfrsList[1]['rangeEnd'])?.toDouble();
                                              return RangeSlider(
                                                values: RangeValues(doubleVar1!, doubleVar2!),
                                                // max: (4*nTcolS).toDouble(),   // 128
                                                max: (rngEnd).toDouble(),
                                                // divisions: 2*nTcolS,          // 64
                                                divisions: (rngEnd/2).round(),
                                                // was working without "min" parameter at all, then added min (when switched from range 32...64 occured Start error). Min is unnecessary instance.
                                                min: isSwitched_32_64_128==64 ? 0 : 0, // allways zero
                                                labels: RangeLabels(
                                                  (ntTblNtfrsList[0]['rangeStart']!).toString(),
                                                  (ntTblNtfrsList[1]['rangeEnd']!).toString(),
                                                ),
                                                onChanged: (RangeValues values1) {
                                                  cnslDelay1Ntfr.value = true;
                                                  ntTblNtfrsList[0]['rangeStart'] = values1.start.round();
                                                  ntTblNtfrsList[1]['rangeEnd'] = values1.end.round();
                                                  setDataSharedPref(); // CALL    // Setting 16 parameters, including slider's Range into Shared Preferences
                                                  fromTheBeginBySliderCoincidence();
                                                  //ntTableCaptionTxt = '${ntTblNtfrsList[2]['startBit']}    $rngEnd    $nTcolSFull  $nTcolS   [${ntTblNtfrsList[0]['rangeStart']}   ${ntTblNtfrsList[1]['rangeEnd']}]   $tapMadeOnUpperOrLowerTable   $isSwitched128or64';
                                                  //ntTableCaptionTxt = '${ntTblNtfrsList[2]['startBit']}      [${ntTblNtfrsList[0]['rangeStart']}   ${ntTblNtfrsList[1]['rangeEnd']}]   $tapMadeOnUpperOrLowerTable   $isSwitched128or64';
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
                                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),   // general margins from all edges sets here
                                    child: Row(         // toDo: "DropdownTuningBox" is a Class from "dropdown...dart" file, adjacent to our file
                                      children: [
                                        const Text("Mode: ", style: TextStyle(fontSize: 14, color: Colors.amber)),     // "Scale" replaced with "Mode"
                                        const SizedBox(width: 12),
                                        Expanded(child: DropdownTuningBox(dropdownValue, callBack: (valueFromDropDown) =>{
                                          setState(() {
                                            dropdownValue = valueFromDropDown;
                                            //MapEntry tuneMapEntry = tuneMap.entries.firstWhere((element) => element.value==valueFromDropDown);
                                            selectedtuningNum = tuneMapRvrsd[dropdownValue]!.round();
                                          })
                                        })),
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
                                              if(isSwitchedMonitorFile==true) {LoadCSVBtnTx='Changes monitor';MonitorFile();} else {LoadCSVBtnTx='Load csv/tsv File';} //end if
                                            });
                                          },
                                          activeTrackColor: Colors.lightGreen[100],
                                          activeColor: Colors.lightGreen[300],
                                          inactiveTrackColor:  Colors.lightGreen[50],
                                          inactiveThumbColor:  Colors.lightGreen[200],
                                          // trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {    // not work ???
                                          //   if (states.contains(MaterialState.disabled)) {
                                          //     return Colors.lightGreen[200];
                                          //   }
                                          //   return null; // Use the default color.
                                          // }),
                                        ),
                                        Expanded(child:
                                        TextButton.icon(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.orange[50], elevation: 2, //foregroundColor: color,
                                          ),
                                          onPressed: (){
                                            //print('isSwitchedMonitorFile $isSwitchedMonitorFile ; fromTheBegin $fromTheBegin');
                                            showArrowMoveToTheLeft=false;                     // hide Arrow "Move Left"
                                            setState(() { userAbortedLoadCSV = false;  });
                                            if(isSwitchedMonitorFile==true && fromTheBegin==false) {
                                              MonitorFile();
                                            } else if (fromTheBegin==true) {
                                              ntTblNtfrsList = [...ntTblNotifier.value];
                                              ntTblNtfrsList[2]['startBit']         = 0;
                                              ntTblNtfrsList[3]['playingBit']       = 0;
                                              ntTblNtfrsList[4]['tableChangeCount'] = 1;
                                              ntTblNtfrsList[5]['msrTgl'] = 0;
                                              ntTblNtfrsList[6]['tableChangeCount32']  = 1;
                                              ntTblNtfrsList[7]['tableChangeCount64']  = 1;
                                              ntTblNtfrsList[8]['tableChangeCount128'] = 1;
                                              ntTblNotifier.value = ntTblNtfrsList;
                                              if (csvMode==1) {MonitorFile();} else if (csvMode==2) {loadCSV(file1);} else {pickUpCSV();}  //(1: for Android, Win; 2: for Web variant)
                                            } else {
                                              if (csvMode==1) {pickUpCSV();} else if (csvMode==2) {loadCSV(file1);} else {pickUpCSV();}  //(1: for Android, Win; 2: for Web variant)
                                            } //end if
                                          },
                                          //child: Text('----'),
                                          //////////////////////////////////////  nested ternary operator:
                                          icon: fromTheBegin==false?   (isSwitchedMonitorFile==false ? Icon(Jaliinstrument.add_circle_outline, color: Color(0xD9BC86D6)) : Icon(Jaliinstrument.refresh)) :  Icon(Jaliinstrument.loop_alt, color: Color(0xD9BC86D6)),
                                          //////////////////////////////////////
                                          label: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(LoadCSVBtnTx, style: const TextStyle(fontSize: 18.0, color: Color(0xD9BC86D6)),),
                                          ),
                                        ),
                                        ),
                                      ]
                                  ),
//
//
                                  TextButton.icon(       //toDo: change play button style
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.orange[50],
                                      //backgroundColor: toggleIcnMsrBtn ? Colors.lightGreen[700] : Colors.grey[600],
                                      elevation: 2,
                                    ),
                                    onPressed: ()  {
                                      if (toggleIcnMsrBtn) {
                                        setState(() {toggleIcnMsrBtn = !toggleIcnMsrBtn;});
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                        ntTblNtfrsList[5]['msrTgl'] = 1;
                                        ntTblNotifier.value = ntTblNtfrsList;
                                        showVerticalBigLables = false; setState(() {});   // hide big labels, show buttons
                                        playFromList ();
                                      } else {
                                        setState(() {toggleIcnMsrBtn = true;});
                                        ntTblNtfrsList = [...ntTblNotifier.value];
                                        ntTblNtfrsList[5]['msrTgl'] = 0;
                                        ntTblNotifier.value = ntTblNtfrsList;
                                      } // end if
                                    }, // end onPressed
                                    icon: toggleIcnMsrBtn ? Icon(Jaliinstrument.play_circle2, color: Color(0xD9BC86D6)) : Icon(Jaliinstrument.stop, color: Color(0xd6f9af1e)),
                                    label: Align(
                                      alignment: Alignment.centerRight,
                                      child: ValueListenableBuilder<List<Map<String, int>>> (     // Do not forget to write "return", otherwise you will get a red screen
                                          valueListenable: _JaliinstrumentState.ntTblNotifier,
                                          builder: (context, ntTblNtfrsList, __) {  // Fo example: "Measures 001-054"  (measures numbers with Leading Zeroes). On most smartphones the button text will become two-line
                                            measureBtnTx = 'Measures ${(ntTblNtfrsList[4]['tableChangeCount']!*2-1).toString().padLeft(3, '0')} - ${(maxNotEmptyPos / nTcolS).ceil().toString().padLeft(3, '0')}';
                                            return Text(measureBtnTx, style: TextStyle(fontSize: 20.0, color: Color(0xD9BC86D6)),);
                                          }
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
                                                    painter: RPSCustomPainter5(),
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
                                                    painter: RPSCustomPainter6(),
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
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.blueGrey[200],
                                      inactiveTrackColor: Colors.blueGrey[100],
                                      trackShape: RectangularSliderTrackShape(),
                                      trackHeight: 2.0,
                                      thumbColor: Colors.blueGrey[50],
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                      overlayColor: Colors.blue.withAlpha(32),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                      //showValueIndicator: ShowValueIndicator.never,
                                      valueIndicatorColor: Colors.blueGrey[200],
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
                                        onChanged: (double valueS) {
                                          playerInitWithEmptyNote();
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
                                        playFromList ();
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
                                        style: TextStyle(fontFamily: 'Google_GHR', fontSize: 28.0),
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
                                            return Text('${ntTblNtfrsList[4]['tableChangeCount']!*2-1}', style: TextStyle(fontSize: 58.0));
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
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 236, 162, 9),
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const Spacer(),
                              Center(
                                  child: Text(
                                    currTuneStatus,
                                    style: const TextStyle(
                                        //color: Colors.black87,
                                        color: Color.fromARGB(255, 168, 116, 3),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child: FloatingActionButton(
                                                  onPressed:
                                                //_startCapture,       // here you can use without ()
                                                   () {
                                                    _startCapture();   // here you should use with ()  {function()}
                                                    ////////////////////////////////////////////////////////////////////// keep_screen_on 2 of 4
                                                    customKeepScreenOnFuture(); // call
                                                    //////////////////////////////////////////////////////////////////////
                                                      },
                                                  child: const Text("Start")))),
                                      Expanded(
                                          child: Center(
                                              child: FloatingActionButton(
                                                  onPressed:
                                                //_stopCapture,
                                                   () {
                                                    _stopCapture();
                                                    ////////////////////////////////////////////////////////////////////// keep_screen_on 3 of 4
                                                    KeepScreenOn.turnOff(withAllowLockWhileScreenOn: true); // immediately stop
                                                    //////////////////////////////////////////////////////////////////////
                                                      },
                                                  child: const Text("Stop")))),
                                    ],
                                  )),
                              const Spacer(),
                              Center(
                                  child: Text(
                                    tunerNotSupportedTextPlatformDepending,
                                    style: const TextStyle(
                                      //color: Colors.black87,
                                        color: Color.fromARGB(255, 168, 116, 3),
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
                                      painter: RPSCustomPainter9(),
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
//
///////////////////////////////// Custom Paint class for Wooden Peg (flutter shape maker),  custom paint wooden peg 1 of 2  //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter1 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 241, 201)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.0066667,size.height*0.3800000);
    path_0.lineTo(size.width*0.0066667,size.height*0.5657143);
    path_0.lineTo(size.width*0.4000000,size.height*0.6014286);
    path_0.lineTo(size.width*0.6508333,size.height*0.7328571);
    path_0.lineTo(size.width*0.6625000,size.height*0.8328571);
    path_0.lineTo(size.width*0.9183333,size.height*0.8971429);
    path_0.lineTo(size.width*0.9533333,size.height*0.7557143);
    path_0.lineTo(size.width*0.9658333,size.height*0.6200000);
    path_0.lineTo(size.width*0.9716667,size.height*0.5014286);
    path_0.lineTo(size.width*0.9691667,size.height*0.3614286);
    path_0.lineTo(size.width*0.9466667,size.height*0.1600000);
    path_0.lineTo(size.width*0.9358333,size.height*0.1357143);
    path_0.lineTo(size.width*0.6591667,size.height*0.1757143);
    path_0.lineTo(size.width*0.6408333,size.height*0.2914286);
    path_0.lineTo(size.width*0.4025000,size.height*0.3657143);
    path_0.lineTo(size.width*0.0066667,size.height*0.3800000);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 236, 162, 9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for Wooden Peg//////////////////////////////////////////
///////////////////////////////// Custom Paint class for Machine Head (flutter shape maker),  custom paint Machine Head  1 of 2 //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter2 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 229, 178)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.0930250,size.height*0.7660714);
    path_0.lineTo(size.width*0.1703000,size.height*0.9641000);
    path_0.lineTo(size.width*0.1863667,size.height*0.9759000);
    path_0.lineTo(size.width*0.2077833,size.height*0.9785286);
    path_0.lineTo(size.width*0.2315000,size.height*0.9785286);
    path_0.lineTo(size.width*0.2452750,size.height*0.9706571);
    path_0.lineTo(size.width*0.3335083,size.height*0.7634286);
    path_0.lineTo(size.width*0.3546917,size.height*0.5666571);
    path_0.lineTo(size.width*0.4464750,size.height*0.5641000);
    path_0.lineTo(size.width*0.5246000,size.height*0.5541143);
    path_0.lineTo(size.width*0.5791750,size.height*0.5430429);
    path_0.lineTo(size.width*0.6270250,size.height*0.5286857);
    path_0.lineTo(size.width*0.6515083,size.height*0.5234429);
    path_0.lineTo(size.width*0.6668083,size.height*0.5313143);
    path_0.lineTo(size.width*0.6729250,size.height*0.5444286);
    path_0.lineTo(size.width*0.6775167,size.height*0.5641000);
    path_0.lineTo(size.width*0.6775167,size.height*0.6263857);
    path_0.lineTo(size.width*0.6780833,size.height*0.6900000);
    path_0.lineTo(size.width*0.6804500,size.height*0.7347571);
    path_0.lineTo(size.width*0.6861500,size.height*0.7749286);
    path_0.lineTo(size.width*0.7003333,size.height*0.8081714);
    path_0.lineTo(size.width*0.7149333,size.height*0.8254429);
    path_0.lineTo(size.width*0.7310000,size.height*0.8339143);
    path_0.lineTo(size.width*0.7522000,size.height*0.8393857);
    path_0.lineTo(size.width*0.7798750,size.height*0.8360571);
    path_0.lineTo(size.width*0.8109750,size.height*0.8205571);
    path_0.lineTo(size.width*0.8504833,size.height*0.7850286);
    path_0.lineTo(size.width*0.8856083,size.height*0.7306571);
    path_0.lineTo(size.width*0.9116250,size.height*0.6585286);
    path_0.lineTo(size.width*0.9243500,size.height*0.5745857);
    path_0.lineTo(size.width*0.9291417,size.height*0.4748000);
    path_0.lineTo(size.width*0.9271250,size.height*0.3798857);
    path_0.lineTo(size.width*0.9213583,size.height*0.2874857);
    path_0.lineTo(size.width*0.9063417,size.height*0.1992571);
    path_0.lineTo(size.width*0.8847167,size.height*0.1366571);
    path_0.lineTo(size.width*0.8584417,size.height*0.0892429);
    path_0.lineTo(size.width*0.8159417,size.height*0.0485286);
    path_0.lineTo(size.width*0.7784417,size.height*0.0399571);
    path_0.lineTo(size.width*0.7496917,size.height*0.0421000);
    path_0.lineTo(size.width*0.7288583,size.height*0.0521000);
    path_0.lineTo(size.width*0.7121917,size.height*0.0656714);
    path_0.lineTo(size.width*0.6971917,size.height*0.0828143);
    path_0.lineTo(size.width*0.6855250,size.height*0.1056714);
    path_0.lineTo(size.width*0.6805250,size.height*0.1228143);
    path_0.lineTo(size.width*0.6746917,size.height*0.1485286);
    path_0.lineTo(size.width*0.6705250,size.height*0.1913857);
    path_0.lineTo(size.width*0.6713583,size.height*0.2399571);
    path_0.lineTo(size.width*0.6721917,size.height*0.2828143);
    path_0.lineTo(size.width*0.6721917,size.height*0.3128143);
    path_0.lineTo(size.width*0.6634417,size.height*0.3342429);
    path_0.lineTo(size.width*0.6463583,size.height*0.3385286);
    path_0.lineTo(size.width*0.6205250,size.height*0.3363857);
    path_0.lineTo(size.width*0.5821917,size.height*0.3263857);
    path_0.lineTo(size.width*0.5346917,size.height*0.3142429);
    path_0.lineTo(size.width*0.4599583,size.height*0.3018714);
    path_0.lineTo(size.width*0.3926083,size.height*0.2913857);
    path_0.lineTo(size.width*0.3267750,size.height*0.2849571);
    path_0.lineTo(size.width*0.2516667,size.height*0.2785714);
    path_0.lineTo(size.width*0.1666667,size.height*0.2771429);
    path_0.lineTo(size.width*0.1023333,size.height*0.2800000);
    path_0.lineTo(size.width*0.0641667,size.height*0.2828571);
    path_0.lineTo(size.width*0.0291667,size.height*0.2857143);
    path_0.lineTo(size.width*0.0258333,size.height*0.3518429);
    path_0.lineTo(size.width*0.0193000,size.height*0.4071429);
    path_0.lineTo(size.width*0.0194000,size.height*0.4538714);
    path_0.lineTo(size.width*0.0250000,size.height*0.5073571);
    path_0.lineTo(size.width*0.0291667,size.height*0.5642857);
    path_0.lineTo(size.width*0.0550000,size.height*0.5628571);
    path_0.lineTo(size.width*0.0930250,size.height*0.7660714);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 196, 66)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
    // Circle
    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 246, 227, 152)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_1 = Path();
    path_1.moveTo(size.width*0.2124000,size.height*0.3142857);
    path_1.cubicTo(size.width*0.2760250,size.height*0.3142857,size.width*0.3714667,size.height*0.3906429,size.width*0.3714667,size.height*0.5869714);
    path_1.cubicTo(size.width*0.3714667,size.height*0.6960429,size.width*0.3237417,size.height*0.8596571,size.width*0.2124000,size.height*0.8596571);
    path_1.cubicTo(size.width*0.1487667,size.height*0.8596571,size.width*0.0533333,size.height*0.7778429,size.width*0.0533333,size.height*0.5869714);
    path_1.cubicTo(size.width*0.0533333,size.height*0.4778857,size.width*0.1010583,size.height*0.3142857,size.width*0.2124000,size.height*0.3142857);
    path_1.close();
    canvas.drawPath(path_1, paint_fill_1);
    // Circle
    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(255, 249, 190, 32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_1, paint_stroke_1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for Machine Head //////////////////////////////////////////
///////////////////////////////// Custom Paint class for ArrowLeft Variant (flutter shape maker),  custom paint ArrowLeft Variant  1 of 2 //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter5 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 249, 227, 144)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.7150000,size.height*0.2828571);
    path_0.lineTo(size.width*0.1316667,size.height*0.4985714);
    path_0.lineTo(size.width*0.7133333,size.height*0.7171429);
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 229, 255, 151)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
/////////////////////////////////end Custom Paint class for ArrowLeft Variant (flutter shape maker),  custom paint ArrowLeft Variant  1 of 2
///////////////////////////////// Custom Paint class for ArrowRight Variant (flutter shape maker),  custom paint ArrowRight Variant  1 of 2 //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter6 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 249, 227, 144)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.2941667,size.height*0.2842857);
    path_0.lineTo(size.width*0.8758333,size.height*0.4985714);
    path_0.lineTo(size.width*0.2950000,size.height*0.7171429);
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 229, 255, 151)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
/////////////////////////////////end Custom Paint class for ArrowRight Variant (flutter shape maker),  custom paint ArrowRight Variant  1 of 2
///////////////////////////////// Custom Paint class for Diam Measuring Tool (flutter shape maker),  custom paint Diam Measuring Tool   1 of 2 //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter7 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(211, 233, 250, 169)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.1916667,size.height*0.8997143);
    path_0.lineTo(size.width*0.1925000,size.height*0.7471429);
    path_0.lineTo(size.width*0.1785000,size.height*0.7471429);
    path_0.lineTo(size.width*0.1775000,size.height*0.5385714);
    path_0.lineTo(size.width*0.2541667,size.height*0.5400000);
    path_0.lineTo(size.width*0.2558333,size.height*0.7457143);
    path_0.lineTo(size.width*0.2433333,size.height*0.7462143);
    path_0.lineTo(size.width*0.2422167,size.height*0.9019000);
    path_0.lineTo(size.width*0.2566667,size.height*0.9028571);
    path_0.lineTo(size.width*0.2575000,size.height*0.8614286);
    path_0.lineTo(size.width*0.3022167,size.height*0.5357000);
    path_0.lineTo(size.width*0.3016667,size.height*0.5142857);
    path_0.lineTo(size.width*0.9158333,size.height*0.5185714);
    path_0.lineTo(size.width*0.9175000,size.height*0.4242857);
    path_0.lineTo(size.width*0.3016667,size.height*0.4200000);
    path_0.lineTo(size.width*0.3016667,size.height*0.3857143);
    path_0.lineTo(size.width*0.2337500,size.height*0.3871429);
    path_0.lineTo(size.width*0.2341667,size.height*0.3657143);
    path_0.lineTo(size.width*0.2500000,size.height*0.3628571);
    path_0.lineTo(size.width*0.2508333,size.height*0.3357143);
    path_0.lineTo(size.width*0.2130917,size.height*0.3267286);
    path_0.lineTo(size.width*0.1741667,size.height*0.3357143);
    path_0.lineTo(size.width*0.1743917,size.height*0.3583714);
    path_0.lineTo(size.width*0.1941667,size.height*0.3671429);
    path_0.lineTo(size.width*0.1950000,size.height*0.3871429);
    path_0.lineTo(size.width*0.1300000,size.height*0.3885714);
    path_0.lineTo(size.width*0.1300000,size.height*0.4185714);
    path_0.lineTo(size.width*0.0908333,size.height*0.4185714);
    path_0.lineTo(size.width*0.0916667,size.height*0.5185714);
    path_0.lineTo(size.width*0.1298750,size.height*0.5177571);
    path_0.lineTo(size.width*0.1301083,size.height*0.5424286);
    path_0.lineTo(size.width*0.1775000,size.height*0.8585714);
    path_0.lineTo(size.width*0.1766667,size.height*0.8985714);
    path_0.lineTo(size.width*0.1916667,size.height*0.8997143);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 243, 183, 33)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
    // Circle
    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(255, 245, 202, 21)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_1 = Path();
    path_1.moveTo(size.width*0.2167250,size.height*0.8335421);
    path_1.cubicTo(size.width*0.2249167,size.height*0.8335421,size.width*0.2372000,size.height*0.8435180,size.width*0.2372000,size.height*0.8691857);
    path_1.cubicTo(size.width*0.2372000,size.height*0.8834485,size.width*0.2310583,size.height*0.9048428,size.width*0.2167250,size.height*0.9048428);
    path_1.cubicTo(size.width*0.2085333,size.height*0.9048428,size.width*0.1962500,size.height*0.8941457,size.width*0.1962500,size.height*0.8691857);
    path_1.cubicTo(size.width*0.1962500,size.height*0.8549364,size.width*0.2023917,size.height*0.8335421,size.width*0.2167250,size.height*0.8335421);
    path_1.close();
    canvas.drawPath(path_1, paint_stroke_1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for Diam Measuring Tool //////////////////////////////////////////
//////////////////////////////////Custom Paint class for My Jalinativeinstrument Label View from the Left ////////////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter8 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {                // CHANGE CANVAS PARAMETERS AT YOUR DRAWING SOFTWARE FIRST!
    // Text Layer 1
    canvas.save();
    final pivot_6214928380299 = Offset(size.width*0.97,size.height*0.06);
    canvas.translate(pivot_6214928380299.dx,pivot_6214928380299.dy);
    canvas.rotate(1.5705648988888223);
    canvas.translate(-pivot_6214928380299.dx,-pivot_6214928380299.dy);
    TextPainter tp_6214928380299 = TextPainter(
      text:  TextSpan(text: """Jalinativeinstrument""", style: TextStyle(
        fontSize: size.width*0.81,
        fontWeight: FontWeight.normal,
        color: Color(0xffffeebe),
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.overline,
      )),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.width*7.75, minWidth: size.width*7.75);
    tp_6214928380299.paint(canvas,pivot_6214928380299);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Jalinativeinstrument Label View from the Left ///////////////////////////////////////
//////////////////////////////////Custom Paint class for My Jalinativeinstrument Label View from the Right /////////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter9 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {                // CHANGE CANVAS PARAMETERS AT YOUR DRAWING SOFTWARE FIRST!
    // Text Layer 1
    canvas.save();
    final pivot_6214928380299 = Offset(size.width*0.02,size.height*0.94);
    canvas.translate(pivot_6214928380299.dx,pivot_6214928380299.dy);
    canvas.rotate(-1.5701553509690762);
    canvas.translate(-pivot_6214928380299.dx,-pivot_6214928380299.dy);
    TextPainter tp_6214928380299 = TextPainter(
      text:  TextSpan(text: """Jalinativeinstrument""", style: TextStyle(
        fontSize: size.width*0.81,
        fontWeight: FontWeight.normal,
        color: Color(0xffffeebe),
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.overline,
      )),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.width*7.75, minWidth: size.width*7.75);
    tp_6214928380299.paint(canvas,pivot_6214928380299);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Jalinativeinstrument Label View from the Right ///////////////////////////////////
//////////////////////////////////Custom Paint class for My Jalinativeinstrument Label View from the Right - Variant1 /////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter9a extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Text Layer 1
    canvas.save();
    final pivot_4562234004201 = Offset(size.width*0.69,size.height*0.98);
    canvas.translate(pivot_4562234004201.dx,pivot_4562234004201.dy);
    canvas.rotate(-1.5708698724298276);
    canvas.translate(-pivot_4562234004201.dx,-pivot_4562234004201.dy);
    TextPainter tp_4562234004201 = TextPainter(
      text:  TextSpan(text: """Jalinativeinstrument""", style: TextStyle(
        fontSize: size.width*0.81,
        fontWeight: FontWeight.normal,
        color: Color(0xFFF1B77B),
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.overline,
      )),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.width*7.75, minWidth: size.width*7.75);
    tp_4562234004201.paint(canvas,pivot_4562234004201);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Jalinativeinstrument Label View from the Right - Variant1 ////////////////////////////////
////////////////////////////////// Custom Paint class for My Index Finger Left /////////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter10 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(130, 254, 227, 168)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.0845083,size.height*0.3927857);
    path_0.lineTo(size.width*0.1997583,size.height*0.2995286);
    path_0.lineTo(size.width*0.2721167,size.height*0.2246857);
    path_0.lineTo(size.width*0.4147250,size.height*0.1971143);
    path_0.lineTo(size.width*0.5111833,size.height*0.1995571);
    path_0.lineTo(size.width*0.6190333,size.height*0.2336000);
    path_0.lineTo(size.width*0.7482083,size.height*0.2068286);
    path_0.lineTo(size.width*0.8277417,size.height*0.1907857);
    path_0.lineTo(size.width*0.8606000,size.height*0.1991143);
    path_0.lineTo(size.width*0.8793000,size.height*0.2547286);
    path_0.lineTo(size.width*0.8896417,size.height*0.3474143);
    path_0.lineTo(size.width*0.8788917,size.height*0.4401000);
    path_0.lineTo(size.width*0.8506250,size.height*0.5259857);
    path_0.lineTo(size.width*0.8069417,size.height*0.5915143);
    path_0.lineTo(size.width*0.7557917,size.height*0.6402857);
    path_0.lineTo(size.width*0.6892083,size.height*0.6773714);
    path_0.lineTo(size.width*0.6035917,size.height*0.7009000);
    path_0.lineTo(size.width*0.5249167,size.height*0.7080143);
    path_0.lineTo(size.width*0.4037083,size.height*0.6935714);
    path_0.lineTo(size.width*0.3428167,size.height*0.7464571);
    path_0.lineTo(size.width*0.2739833,size.height*0.8261143);
    path_0.lineTo(size.width*0.2043083,size.height*0.8785143);
    path_0.lineTo(size.width*0.1453750,size.height*0.9280143);
    path_0.lineTo(size.width*0.0845083,size.height*0.3927857);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 222, 75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.02
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
    // Layer 1
    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_1 = Path();
    path_1.moveTo(size.width*0.5499921,size.height*0.1863503);
    path_1.lineTo(size.width*0.5781388,size.height*0.2614018);
    path_1.lineTo(size.width*0.6187922,size.height*0.2971429);
    path_1.lineTo(size.width*0.6855102,size.height*0.2899923);
    path_1.lineTo(size.width*0.7397147,size.height*0.2792723);
    path_1.lineTo(size.width*0.8043437,size.height*0.2649712);
    path_1.lineTo(size.width*0.8585551,size.height*0.2578324);
    path_1.lineTo(size.width*0.9148417,size.height*0.2578324);
    path_1.lineTo(size.width*0.9190129,size.height*0.2220914);
    path_1.lineTo(size.width*0.8585551,size.height*0.1899197);
    path_1.lineTo(size.width*0.7918371,size.height*0.1613292);
    path_1.lineTo(size.width*0.7230369,size.height*0.1648986);
    path_1.lineTo(size.width*0.6438123,size.height*0.1613292);
    path_1.lineTo(size.width*0.5770943,size.height*0.1720492);
    path_1.lineTo(size.width*0.5499921,size.height*0.1863503);
    path_1.close();
    canvas.drawPath(path_1, paint_fill_1);
    // Layer 1
    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(162, 255, 229, 102)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_1, paint_stroke_1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Index Finger Left ///////////////////////////////////////
////////////////////////////////// Custom Paint class for My Index Finger Right /////////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter11 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(130, 254, 227, 168)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.9154917,size.height*0.3927857);
    path_0.lineTo(size.width*0.8002417,size.height*0.2995286);
    path_0.lineTo(size.width*0.7278833,size.height*0.2246857);
    path_0.lineTo(size.width*0.5852750,size.height*0.1971143);
    path_0.lineTo(size.width*0.4888167,size.height*0.1995571);
    path_0.lineTo(size.width*0.3809667,size.height*0.2336000);
    path_0.lineTo(size.width*0.2517917,size.height*0.2068286);
    path_0.lineTo(size.width*0.1722583,size.height*0.1907857);
    path_0.lineTo(size.width*0.1394000,size.height*0.1991143);
    path_0.lineTo(size.width*0.1207000,size.height*0.2547286);
    path_0.lineTo(size.width*0.1103583,size.height*0.3474143);
    path_0.lineTo(size.width*0.1211083,size.height*0.4401000);
    path_0.lineTo(size.width*0.1493750,size.height*0.5259857);
    path_0.lineTo(size.width*0.1930583,size.height*0.5915143);
    path_0.lineTo(size.width*0.2442083,size.height*0.6402857);
    path_0.lineTo(size.width*0.3107917,size.height*0.6773714);
    path_0.lineTo(size.width*0.3964083,size.height*0.7009000);
    path_0.lineTo(size.width*0.4750833,size.height*0.7080143);
    path_0.lineTo(size.width*0.5962917,size.height*0.6935714);
    path_0.lineTo(size.width*0.6571833,size.height*0.7464571);
    path_0.lineTo(size.width*0.7260167,size.height*0.8261143);
    path_0.lineTo(size.width*0.7956917,size.height*0.8785143);
    path_0.lineTo(size.width*0.8546250,size.height*0.9280143);
    path_0.lineTo(size.width*0.9154917,size.height*0.3927857);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 222, 75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.02
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
    // Layer 1
    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_1 = Path();
    path_1.moveTo(size.width*0.4500079,size.height*0.1863503);
    path_1.lineTo(size.width*0.4218612,size.height*0.2614018);
    path_1.lineTo(size.width*0.3812078,size.height*0.2971429);
    path_1.lineTo(size.width*0.3144898,size.height*0.2899923);
    path_1.lineTo(size.width*0.2602853,size.height*0.2792723);
    path_1.lineTo(size.width*0.1956563,size.height*0.2649712);
    path_1.lineTo(size.width*0.1414449,size.height*0.2578324);
    path_1.lineTo(size.width*0.0851583,size.height*0.2578324);
    path_1.lineTo(size.width*0.0809871,size.height*0.2220914);
    path_1.lineTo(size.width*0.1414449,size.height*0.1899197);
    path_1.lineTo(size.width*0.2081629,size.height*0.1613292);
    path_1.lineTo(size.width*0.2769631,size.height*0.1648986);
    path_1.lineTo(size.width*0.3561877,size.height*0.1613292);
    path_1.lineTo(size.width*0.4229057,size.height*0.1720492);
    path_1.lineTo(size.width*0.4500079,size.height*0.1863503);
    path_1.close();
    canvas.drawPath(path_1, paint_fill_1);
    // Layer 1
    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(162, 255, 229, 102)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_1, paint_stroke_1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Index Finger Right ////////////////////////////////////
////////////////////////////////// Custom Paint class for My Thumb Finger Left /////////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter13 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(130, 254, 227, 168)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.0845083,size.height*0.6072143);
    path_0.lineTo(size.width*0.1997583,size.height*0.7004714);
    path_0.lineTo(size.width*0.2721167,size.height*0.7753143);
    path_0.lineTo(size.width*0.4147250,size.height*0.8028857);
    path_0.lineTo(size.width*0.5111833,size.height*0.8004429);
    path_0.lineTo(size.width*0.6190333,size.height*0.7664000);
    path_0.lineTo(size.width*0.7482083,size.height*0.7931714);
    path_0.lineTo(size.width*0.8277417,size.height*0.8092143);
    path_0.lineTo(size.width*0.8606000,size.height*0.8008857);
    path_0.lineTo(size.width*0.8793000,size.height*0.7452714);
    path_0.lineTo(size.width*0.8896417,size.height*0.6525857);
    path_0.lineTo(size.width*0.8638917,size.height*0.5613286);
    path_0.lineTo(size.width*0.8220167,size.height*0.4840143);
    path_0.lineTo(size.width*0.7786083,size.height*0.4170571);
    path_0.lineTo(size.width*0.7316250,size.height*0.3554286);
    path_0.lineTo(size.width*0.6658750,size.height*0.3097714);
    path_0.lineTo(size.width*0.5985917,size.height*0.2905286);
    path_0.lineTo(size.width*0.5107500,size.height*0.2891286);
    path_0.lineTo(size.width*0.4037083,size.height*0.3064286);
    path_0.lineTo(size.width*0.3461500,size.height*0.2242571);
    path_0.lineTo(size.width*0.2785667,size.height*0.1510286);
    path_0.lineTo(size.width*0.2084750,size.height*0.0957714);
    path_0.lineTo(size.width*0.1453750,size.height*0.0719857);
    path_0.lineTo(size.width*0.0845083,size.height*0.6072143);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 222, 75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.02
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
    // Layer 1
    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_1 = Path();
    path_1.moveTo(size.width*0.5499921,size.height*0.8136497);
    path_1.lineTo(size.width*0.5781388,size.height*0.7385982);
    path_1.lineTo(size.width*0.6187922,size.height*0.7028571);
    path_1.lineTo(size.width*0.6855102,size.height*0.7100077);
    path_1.lineTo(size.width*0.7397147,size.height*0.7207277);
    path_1.lineTo(size.width*0.8043437,size.height*0.7350288);
    path_1.lineTo(size.width*0.8585551,size.height*0.7421676);
    path_1.lineTo(size.width*0.9148417,size.height*0.7421676);
    path_1.lineTo(size.width*0.9190129,size.height*0.7779086);
    path_1.lineTo(size.width*0.8585551,size.height*0.8100803);
    path_1.lineTo(size.width*0.7918371,size.height*0.8386708);
    path_1.lineTo(size.width*0.7230369,size.height*0.8351014);
    path_1.lineTo(size.width*0.6438123,size.height*0.8386708);
    path_1.lineTo(size.width*0.5770943,size.height*0.8279508);
    path_1.lineTo(size.width*0.5499921,size.height*0.8136497);
    path_1.close();
    canvas.drawPath(path_1, paint_fill_1);
    // Layer 1
    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(162, 255, 229, 102)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_1, paint_stroke_1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Thumb Finger Left ////////////////////////////////////
////////////////////////////////// Custom Paint class for My Thumb Finger Right /////////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter14 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(130, 254, 227, 168)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.9154917,size.height*0.6072143);
    path_0.lineTo(size.width*0.8002417,size.height*0.7004714);
    path_0.lineTo(size.width*0.7278833,size.height*0.7753143);
    path_0.lineTo(size.width*0.5852750,size.height*0.8028857);
    path_0.lineTo(size.width*0.4888167,size.height*0.8004429);
    path_0.lineTo(size.width*0.3809667,size.height*0.7664000);
    path_0.lineTo(size.width*0.2517917,size.height*0.7931714);
    path_0.lineTo(size.width*0.1722583,size.height*0.8092143);
    path_0.lineTo(size.width*0.1394000,size.height*0.8008857);
    path_0.lineTo(size.width*0.1207000,size.height*0.7452714);
    path_0.lineTo(size.width*0.1103583,size.height*0.6525857);
    path_0.lineTo(size.width*0.1361083,size.height*0.5613286);
    path_0.lineTo(size.width*0.1779833,size.height*0.4840143);
    path_0.lineTo(size.width*0.2213917,size.height*0.4170571);
    path_0.lineTo(size.width*0.2683750,size.height*0.3554286);
    path_0.lineTo(size.width*0.3341250,size.height*0.3097714);
    path_0.lineTo(size.width*0.4014083,size.height*0.2905286);
    path_0.lineTo(size.width*0.4892500,size.height*0.2891286);
    path_0.lineTo(size.width*0.5962917,size.height*0.3064286);
    path_0.lineTo(size.width*0.6538500,size.height*0.2242571);
    path_0.lineTo(size.width*0.7214333,size.height*0.1510286);
    path_0.lineTo(size.width*0.7915250,size.height*0.0957714);
    path_0.lineTo(size.width*0.8546250,size.height*0.0719857);
    path_0.lineTo(size.width*0.9154917,size.height*0.6072143);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 222, 75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.02
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
    // Layer 1
    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_1 = Path();
    path_1.moveTo(size.width*0.4500079,size.height*0.8136497);
    path_1.lineTo(size.width*0.4218612,size.height*0.7385982);
    path_1.lineTo(size.width*0.3812078,size.height*0.7028571);
    path_1.lineTo(size.width*0.3144898,size.height*0.7100077);
    path_1.lineTo(size.width*0.2602853,size.height*0.7207277);
    path_1.lineTo(size.width*0.1956563,size.height*0.7350288);
    path_1.lineTo(size.width*0.1414449,size.height*0.7421676);
    path_1.lineTo(size.width*0.0851583,size.height*0.7421676);
    path_1.lineTo(size.width*0.0809871,size.height*0.7779086);
    path_1.lineTo(size.width*0.1414449,size.height*0.8100803);
    path_1.lineTo(size.width*0.2081629,size.height*0.8386708);
    path_1.lineTo(size.width*0.2769631,size.height*0.8351014);
    path_1.lineTo(size.width*0.3561877,size.height*0.8386708);
    path_1.lineTo(size.width*0.4229057,size.height*0.8279508);
    path_1.lineTo(size.width*0.4500079,size.height*0.8136497);
    path_1.close();
    canvas.drawPath(path_1, paint_fill_1);
    // Layer 1
    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(162, 255, 229, 102)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_1, paint_stroke_1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Thumb Finger Right ////////////////////////////////////
////////////////////////////////// Custom Paint class for My Arrow Move Left /////////////////////////////////////// //Use Wrapping in Stack and InkWell for x-center aligning correctly
class RPSCustomPainter15 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(200, 255, 169, 71)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    Path path_0 = Path();
    path_0.moveTo(size.width*0.0408333,size.height*0.4989571);
    path_0.lineTo(size.width*0.2083333,size.height*0.4272714);
    path_0.lineTo(size.width*0.1983333,size.height*0.4813857);
    path_0.lineTo(size.width*0.9600000,size.height*0.4813857);
    path_0.lineTo(size.width*0.9600000,size.height*0.5151286);
    path_0.lineTo(size.width*0.1983333,size.height*0.5165286);
    path_0.lineTo(size.width*0.2091667,size.height*0.5671429);
    path_0.lineTo(size.width*0.0408333,size.height*0.4989571);
    path_0.close();
    canvas.drawPath(path_0, paint_fill_0);
    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 203, 255, 153)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path_0, paint_stroke_0);
    // Text Layer 1
    canvas.save();
    final pivot_9143102758311 = Offset(size.width*0.34,size.height*0.20);
    canvas.translate(pivot_9143102758311.dx,pivot_9143102758311.dy);
    canvas.rotate(0);
    canvas.translate(-pivot_9143102758311.dx,-pivot_9143102758311.dy);
    TextPainter tp_9143102758311 = TextPainter(
      text:  TextSpan(text: """Move Left""", style: TextStyle(
        //fontSize: size.width*0.15,
        fontSize: size.width*0.08,
        fontWeight: FontWeight.normal,
        color: Color(0xd6f9af1e),
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      )),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.width*0.60, minWidth: size.width*0.60);
    tp_9143102758311.paint(canvas,pivot_9143102758311);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//////////////////////////////////end Custom Paint class for My Arrow Move Left////////////////////////////////////
//
//
//
// --------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------------------------------------- //
// DART-Lang, Musical Tuition Project: African Harp Kora : Player, NotationReader, Tuner:  multi-Platform    //
// --------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------------------------------------- //