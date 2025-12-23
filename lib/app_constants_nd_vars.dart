import 'dart:io';
import 'package:flutter/material.dart';
import 'package:matrix2d/matrix2d.dart';
// import 'package:audioplayers/audioplayers.dart';
//
//
Color invertCustom(Color color) {
  final r = 255 - color.red;
  final g = 255 - color.green;
  final b = 255 - color.blue;
  return Color.fromARGB(color.alpha, r, g, b);
}
//
// toDo: Build Options, choose depending on Build Platform before starting build:
// INTO VOID MAIN() ADDED AUTOMATICALLY CHOSE OF PLATFORM (WIN,ANDROID,MACOS,IOS,LINUX), SO SIMPLY USE "FLUTTER BUILD APK", "FLUTTER BUILD WINDOWS", ("FLUTTER BUILD APK --no-tree-shake-icons", "FLUTTER BUILD WINDOWS --no-tree-shake-icons")
// AUTOMATIC SWITCH SOLUTION FOUND: SEE VOID MAIN()  !!!                        USE DOUBLE SPACE or DOUBLE SLASH     for Comment/Uncomment
////////////////////////////////////////////   Build Options  //////////////////////////////////////////// Recommended variants: 1,2 and 5
//   int csvMode = 1; int playerMode = 2; int extension = 1;  double mS =  10; // Windows---WAV--***EXE   (some notes stop sounding on Android, so for Android - another build option)  SEE ALSO: debugDefaultTargetPlatformOverride  in Void Main !!!!   (if plays Slow, it's Power Save Mode of Notebook)
int csvMode = 1; int playerMode = 1; int extension = 1;  double mS =  100; // Android,MacOS---WAV--***APK, MacOS***APP,***DMG, yes you can create DMG (like installer) via Node.js "create-dmg"      (if plays Slow, it's hash table mode, comment Windows)
//   int csvMode = 2; int playerMode = 4; int extension = 3;  double mS = 22;  // Web-Synth-Tone.JS-***JS toDo: (add manually Script to index.html) Many setState() cause Noise! Sounds like web midi Synth without delay at all
//// int csvMode = 2; int playerMode = 1; int extension = 2;  double mS = 22;  // Web------m4a--------   (too slow! Do not use this at all, sound disappear)
//   int csvMode = 2; int playerMode = 5; int extension = 3;  double mS =  6;  // Web--m4a-via-Tone.JS***JS toDo: (1 of 4: add manually Script to index.html; 2 of 4: add manually Script to index.html) Works Great! To protect JS code from copying recommends (try to) transfer JavaScript to TypeScript
//   int csvMode = 2; int playerMode = 6; int extension = 3;  double mS =  6;  // Linux, and maybe MacOS
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
// var player = AudioPlayer();                                        // if declare here, sounds non-simultaneously
// final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);    // ReleaseMode you may not specify
// List<AudioPlayer> audioPlayersList = [];                           // List of audioplayers, to dispose or release each one personally
const int mSsW = 4; // minimum possible additional delay for every bit until stopwatch elapsedMilliseconds < 200
// Map <String,AudioPlayer> audioPlayersMap = {};       // Map of many AudioPlayerS  Windows
// Map <String,AudioPlayer> audioPlayersMapLinux = {};  // can not use <int> !!!   Map of many AudioPlayerS Linux (planned 5..10 to dispose and prevent multiple volume regulators)
String dropdownValue = "Lydian (F) Aeol(A) Dor(D)";       // default tuning for Drop Down Menu
double fontSize = 18.0;                // default font size, Left and Right buttons Text
double fontSizeCnt = 16.0;             // "cents" of the tuning
int pxlsWidth = 600;     // it's Not a Pixels!!! default boundary width, for values less than or greater than Switches Text Alignment
double noteVolume = 0.9; // default personal volume of each note, or common volume (if value does not change while playing), =0.1,0.2...0.9,1.0; default =0.9
double noteVolumeBack = noteVolume; // to restore volume after stop, so that the sound of pressing individual buttons can be heard
double tempoCoeff = 1.0;            // global tempo coefficient, extends tempo range, default =1
// toDo: delay stall at a correction factor higher then 1.3
// const double mS = 19;   //ms 70/3=23    Windows, Android, Web, ?iOS?    // minimum possible duration, ms  (for measure tempo tuning) mS 70
// const mS = 5;           //ms 0         ?Web -No                         // 5mS is excessively small, and 19mS is optimal; do NOT try WEB  mS 5
// toDo: End Build Options
bool isReadOnce = false;  // for suggested variant of tuning read from csv
int maxNotEmptyPos = 1;   // for list size and text on button measure
String measureBtnTx = 'Measures 1 - ...';       // text on button measure
String LoadCSVBtnTx = 'Load csv/tsv file'; // text on button load
String tempperformrsInfo = '';          // performers info
int stringsNum = 21;                    // default number of strings, default =21
const int stringsNumExcel = 22;         // allways 22 rows in Excel file
String file1 = 'assets/csv/sample01.csv';                   // Type String
File notationCsvFile = new File(file1);                     // Type File
double crntSldrValT = 1.0;                                    // Tempo Slider default value =1.0
bool toggleIcnMsrBtn = true;                                  // toggle (switch) Play|Stop Icon on TextButton
bool fromTheBegin = false;                                    // toggle (switch) Play|Stop from the begin of the file or from the begin of the current table view
int maxLength = 1;                                            // max Length of List to PlaySound
/////Change it here:///////// !!! strict EVEN, Not Odd /////////// Notation Table Columns Number:    // Widget Rebuild with thousands elements is very expensive!!!
int nTTcolSHalf  = 8;    //default:8 is quarter of 64view (could be: 8,16,32,64...till slow down)    // notation Table Columns Number (number of bits)
//////////////////////////////////////////////////////////////////
int  isSwitched_32_64_128 = 64;  // 32   64   128                           // switching by short press and
int  mode_3264_or_64128 = 3264;  // 3264    64128                           // by a long press
int nTTcolSN = 2*nTTcolSHalf;       // 64
int nTcolS = nTTcolSN;              // Normal or Default 64
int nTTcolSDouble = 2*nTTcolSN;     // 128
var rngEnd = 4*nTTcolSN;            // for 64  is  128        // end range of the RangeSlider Depends on Cols Number (allways x2   32 is 64   64 is 128   128 is 256)
int playingBit = 1;                                           // currently playing bit (j) by playFromList() for cursor visualize
double centralColumnHeaderHeigth = 20;                        // central column above table block height
double nTtbLHeight = 126;   //toDo: put table into Container  // tailored height of the Notation Table (depends of edge insets=1 and font size=3)
//                  // cols1 is allways 22 (does not matter settings parameter number of strings)
const cols1 = 22;   // The Best Way to initialize filled List // Number of cells vertically in empty table (transpose!)
// it works also with 2*nTcolS, but when we changing view from 32 to 64 with empty data1, error occurs, so 4*nTcolS:
int rows1 = 4*nTcolS;   //default:64. To prevent index error  // Number of cells horizontally in empty table
final array1 = List.generate(rows1,(i) => List.generate(cols1 + 1, (j) => '', growable: true), growable: true); // fill up with '' ALL the list; the best way to fill up the List
List<dynamic> data1 = List.from(array1).transpose;            // List for NotationTable
List<dynamic> csvLst = [];                                    // List for Main Loops
//List<dynamic> data2 = [];                                     // List for ... reserved
////////////////////////////////////////// Used in DropDown Menu Too, part 1 of 3//////////////////
// To Add or Edit Tuning: See also file audio_isolate.dart, function playSound.
// Also see dropdown...dart and for menu sizing and audio_data.dart  for  List krSnd (koraSound 3d-List)   !!!
Map<int,String> tuneMap = {   // Names must match in all three lists and default in dropdownValue variable!!!
  1 : "Aeolian (F) Phrygian (C)",              // SEE: Clamp(1,15)  !!!
  2 : "Hardino (F) Major",
  3 : "Ionian (F) Major Phryg.(A)",
  4 : "Lydian (F) Aeol(A) Dor(D)",
  5 : "Aeolian (B) Phryg (F#)",
  6 : "Sauta (Major, augm. 4th)",
  7 : "Silaba (extreme)",
  8 : "Silaba or Tomora ba (F) Maj",
  9 : "Tomora Mesengo (F) Minor",
  11: "Ionian (F) (Malian kora)",
  12: "Lydian (F) (Malian kora)",
  14: "Dorian (F) Lydian (Ab)",
  15: "Mixolydian (F)",
  16: "Lydian (Bb) MixLyd(C) Aeol(D)"
};
Map<String,int> tuneMapRvrsd = {                    // SEE: selectedtuningNum   is number of Row-element in  krSnd 3-D List
  "Aeolian (F) Phrygian (C)"      : 1,              // SEE: "TUNING MATCHING WITH THE LIST ROW NUMBER" in the playSound()
  "Hardino (F) Major"             : 2,
  "Ionian (F) Major Phryg.(A)"    : 3,
  "Lydian (Bb) MixLyd(C) Aeol(D)" : 3,
  "Lydian (F) Aeol(A) Dor(D)"     : 4,
  "Aeolian (B) Phryg (F#)"        : 5,
  "Sauta (Major, augm. 4th)"      : 6,
  "Silaba (extreme)"              : 7,
  "Silaba or Tomora ba (F) Maj"   : 8,
  "Tomora Mesengo (F) Minor"      : 9,
  "---"                           : 4,
  "Ionian (F) (Malian kora)"      : 11,
  "Lydian (F) (Malian kora)"      : 12,
  "Dorian (F) Lydian (Ab)"        : 14,
  "Mixolydian (F)"                : 15
};       // if "---" then: default Lydian (4)
//List<String> droptuningList = <String>[];
List<String> droptuningList = <String>[  // we can send this List from the main.dart to dropdown...dart file via Constructor
  'Aeolian (F) Phrygian (C)',            // Names must match in all three lists! The selection is made not by index, but by text !!!
  'Hardino (F) Major',
  'Ionian (F) Major Phryg.(A)',
  'Lydian (F) Aeol(A) Dor(D)',
  'Aeolian (B) Phryg (F#)',
  'Sauta (Major, augm. 4th)',
  'Silaba (extreme)',
  'Silaba or Tomora ba (F) Maj',
  'Tomora Mesengo (F) Minor',
  '---',
  'Ionian (F) (Malian kora)',
  'Lydian (F) (Malian kora)',
  '---',
  'Dorian (F) Lydian (Ab)',
  'Mixolydian (F)',
  'Lydian (Bb) MixLyd(C) Aeol(D)',
  '---',
  '---',
];      // See Dropdown tuning file in the middle !!!
/////////////////// Web Only: /////////////////
/*
  List<String> droptuningList = <String>[
    'Ionian (F) Major Phryg.(A)',
    'Lydian (F) Aeol(A) Dor(D)',
    '---'
  ];
 */
/////////////////// end Web ///////////////////
///ooooooooooooooooooooooooooooooooooooooooooo Gauges oooooooooooooooooooooooooooooooooooooooooooooooo///
Map<int,String> stringsDiamMapVariant1 = {0:"",1:"0.55mm",2:"0.55mm",3:"0.55mm",4:"0.55mm",5:"0.6mm",6:"0.6mm",7:"0.7mm",8:"0.7mm",9:"0.7mm",10:"0.8mm",11:"0.8mm",12:"0.9mm",13:"1.0mm",14:"1.0mm",15:"1.2mm",16:"1.2mm",17:"1.3mm",18:"1.4mm",19:"1.5mm",20:"1.6mm",21:"1.7mm",22:"2.2mm",23:"-mm"};
Map<int,String> stringsDiamMapVariant2  = {0:"",1:"0.50mm",2:"0.50mm",3:"0.50mm",4:"0.65mm",5:"0.65mm",6:"0.65mm",7:"0.75mm",8:"0.75mm",9:"0.75mm",10:"0.85mm",11:"0.85mm",12:"1.0mm",13:"1.0mm",14:"1.0mm",15:"1.2mm",16:"1.2mm",17:"1.2mm",18:"1.4mm",19:"1.4mm",20:"1.6mm",21:"1.6mm",22:"1.8-2.0",23:"-mm"};
Map<int,String> stringsLbMapToVariant2   = {0:"",1:"30 lb",2:"30 lb",3:"30 lb",4:"40 lb",5:"40 lb",6:"40 lb",7:"60 lb",8:"60 lb",9:"60 lb",10:"70 lb",11:"70 lb",12:"100 lb",13:"100 lb",14:"100 lb",15:"120 lb",16:"120 lb",17:"120 lb",18:"160 lb",19:"160 lb",20:"180 lb",21:"180 lb",22:"200-300 lb",23:"- lb"};
///ooooooooooooooooooooooooooooooooooooooooooo End Gauges oooooooooooooooooooooooooooooooooooooooooooo///
///////////////////////////////////////////////////////////////////////////////////////////////////
//////// non-default buttons labels and colours:      // List begins from 0 and ends at 23 (summary 24 elements) !!!  Null error in widget solution is 0:""
void fillVariant1ColorsList() {
  if(themeappLightDark==1) {
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
  } else {
    keysColorsList[1]=keysColorsList[2]=keysColorsList[3]=keysColorsList[4]=invertCustom(Colors.blueGrey!);
    keysColorsList[5]=keysColorsList[6]=invertCustom(Colors.deepPurpleAccent);
    keysColorsList[7]=keysColorsList[8]=keysColorsList[9]=invertCustom(Colors.red);
    keysColorsList[10]=keysColorsList[11]=invertCustom(Colors.brown);
    keysColorsList[12]=invertCustom(Colors.green);
    keysColorsList[13]=keysColorsList[14]=invertCustom(Colors.blue);
    keysColorsList[15]=keysColorsList[16]=invertCustom(Colors.pink);
    keysColorsList[17]=invertCustom(Colors.deepPurpleAccent);
    keysColorsList[18]=invertCustom(Colors.blue);
    keysColorsList[19]=invertCustom(Colors.red);
    keysColorsList[20]=invertCustom(Colors.green); keysColorsList[21]=invertCustom(Colors.black54); keysColorsList[22]=invertCustom(Colors.blueGrey); keysColorsList[23]=invertCustom(Colors.blueGrey);
  }
} //end variant1
void fillVariant2ColorsList() {
  if(themeappLightDark==1) {
    keysColorsList[1]=keysColorsList[2]=keysColorsList[3]=Colors.blueGrey;
    keysColorsList[4]=keysColorsList[5]=keysColorsList[6]=Colors.deepPurpleAccent;
    keysColorsList[7]=keysColorsList[8]=keysColorsList[9]=Colors.red;
    keysColorsList[10]=keysColorsList[11]=Colors.cyan;
    keysColorsList[12]=keysColorsList[13]=keysColorsList[14]=Colors.blue;
    keysColorsList[15]=keysColorsList[16]=keysColorsList[17]=Colors.pink;
    keysColorsList[18]=keysColorsList[19]=Colors.blue;
    keysColorsList[20]=Colors.green; keysColorsList[21]=Colors.black54; keysColorsList[22]=Colors.blueGrey; keysColorsList[23]=Colors.blueGrey;
  } else {
    keysColorsList[1]=keysColorsList[2]=keysColorsList[3]=invertCustom(Colors.blueGrey);
    keysColorsList[4]=keysColorsList[5]=keysColorsList[6]=invertCustom(Colors.deepPurpleAccent);
    keysColorsList[7]=keysColorsList[8]=keysColorsList[9]=invertCustom(Colors.red);
    keysColorsList[10]=keysColorsList[11]=invertCustom(Colors.cyan);
    keysColorsList[12]=keysColorsList[13]=keysColorsList[14]=invertCustom(Colors.blue);
    keysColorsList[15]=keysColorsList[16]=keysColorsList[17]=invertCustom(Colors.pink);
    keysColorsList[18]=keysColorsList[19]=invertCustom(Colors.blue);
    keysColorsList[20]=invertCustom(Colors.green); keysColorsList[21]=invertCustom(Colors.black54); keysColorsList[22]=invertCustom(Colors.blueGrey); keysColorsList[23]=invertCustom(Colors.blueGrey);
  }
} //end variant2
//////// end non-default buttons labels and colours
//// how to get key by value:
//// var key1 = tuneMap.keys.firstWhere((k) => tuneMap[k] == tuningName, orElse: () => 4); // not work inside async,  reverse Map
var reversedTuneMap = tuneMap.map((k, v) => MapEntry(v, k));  // reversed Map
List<Map<String, bool>> buttonsPS = []; // List of Maps !!! State of the both side columns of buttons
bool cancelDelay1 = false;
List<String>csvListOfFiles = [];
// List<Map<String, int>> bitStateList = []; // Not Used At All! // List of Maps !!! State of 1) notation table startBit, 2) animated cursor position
// List<Map<String, int>>        ntTblNtfrsList    = []; // List of Maps !!!  INT notifier
List<Map<String, String>> strTxtNotifierList    = []; // List of Maps !!!  STRING notifier
bool isSwitchedMonitorFile = false;            // file will be reloaded. Range, table change count and view will remain the same
String tempSMonitor = '';                      // Keeping string csvFile path
bool wasTSVextDetected = false;   // (Tab) is delimiter
bool googleCSVdetected = false;   // (,) comma is delimiter       // for example, excel's delimiter is (;) semicolon
bool oneTraversingInstanceLaunched = false;  // prevention of double- or even triple-start
List<String> ntTableCaptionTxt_0 = ['',' long press available'];         // table caption text
String ntTableCaptionTxt = '';                // NOT USED yet, for debug
List<double> sym_font = [18, 12, 8];          // [android ,win, reserved]         font-size: in win '⬤' is larger than '●' in android
List<List<String>> ntTableCaptionTxt_0_sym  = [['●','○','○'],['○','●','○'],['○','○','●']];       // List of the Lists //only for Android: 〇⬤〇     ⬤ is smaller than 〇
List<List<String>> ntTableCaptionTxt_0_win  = [['⬤','〇','〇'],['〇','⬤','〇'],['〇','〇','⬤']]; // List of the Lists //only for Windows: ○●○     ● is smaller than ○
String tapMadeOnUpperOrLowerTable = 'None';  // temp, only for Debug printing output
bool hideControlsForScreenshotMode = false;  // hide sliders and buttons
int buildKeysNotesOrFreqsMode = 0;            // 0 = display notes, 1 = display frequencies precisely (machine heads), 2 = display frequencies roughly (wooden pegs), 3 = strings diameter in mm
double WIDTH_0 = 70;                          // custom paint at the central column, bottom
double WIDTH_1 = 90;                          // wooden peg and measuring tool width for custom painter TWO (on upper right Button)
double WIDTH_2 = 80;                          // machine head width for custom painter ONE
// double WIDTH_3 = 50;                       // reserved
double WIDTH_8 = 80;                          // vertical text label Jalinativeistriment, view from the Left
double WIDTH_9 = WIDTH_8;                     // vertical text label Jalinativeistriment, view from the Right
bool showVerticalBigLables = false;           // showing big vertical text labels Jalinativeistriment in Stack at the left ant at the right
double WIDTH_10 = 50;                         // Find...
double WIDTH_11 = 50;                         // Fingers: Index and Thumb
double WIDTH_12 = 50;                         // Find...
double WIDTH_13 = 50;                         // Find...
double WIDTH_14 = 50;                         // Find...
double WIDTH_15 = 240;                        // arrow with text "move left" for stack under the Range Slider (shown after Completion Naturally)
bool showArrowMoveToTheLeft=false;            // true = show arrow with text "move left"
bool showNavButtonsForThreeSeconds=false;     // true = show Navigate Buttons (to Change Up and Down Measure Number)
dynamic restartableTimer1;                    // try to use restartable timer to increase time to nav buttons hide. Or you can use "var" instead of "dynamic"
List<int> showFingeringOnButtons = [];        // show Index fingers = 1 and Thumb fingers = 0 on buttons in stack (right or left by context: buildKeyRight or buildKeyLeft)
List<Color> keysColorsList = [];              // text on keys and guestures press button effect background colors
String crc32trackPerfInfo = '';               // checksum of track_performer info string
String stringKeySharedPref = '';              // string key = crc32 checksum of track_performer info
String stringValSharedPref = '';              // string value, contains last seen mode (32/64/128), measure number, selected range
bool tapCollisionPrevention = false;          // so that the cursor doesn't run away, waiting for previous tapping ends
bool clearRangeSharePref = false;             // for delete shared pref for opening file (keeping ranges individual for each file by performer's info CRC32 checksum) by Right coincidence of a Range Slider and pressing multi-purpose button
bool clearRangeSharePrefA = false;
bool isTunerModeEnable = false;               // central column (Width 54%) is used to show: 1) main table and controls, 2) tuner pitch up functions (Android and maybe iOS)
String tunerNotSupportedTextPlatformDepending = "";
String argument0 = '';                          // argument full file path for windows exe cmd arguments parse
bool isTempoSliderDisabled = false;             // temporary disable Tempo Slider so as not to accidentally move it
bool toShowVLbls = true;                        // show big side labels for 2 seconds
bool wasShownVLblsOnce = false;                 // only at first start
bool isFixNeededFlag = false;                 // when Tables onTab sometimes appears view change error, let's fix it
bool willGoogleSpreadsheetBeLoaded = false;   // load Shared Google Spreadsheet with Notation
bool isNowGoogleSpreadsheetLoaded = false;    // for Online monitor button text does not change to File monitor
String googleSpreadsheetLink = '';            // shared google spreadsheet (first 256-cols will be loaded) or link to google app script (get function with deployment) (all range will be loaded)
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
int themeappLightDark = 1; // Application Theme:  1 = default(light)   2 = dark          See invertCustom() function
// New global variables add here
///////////////////////////////////////////// End Global Variables declaration and assignment ///////////////////////////////////////////
//
///////////////////////////////////////////// Audio Isolate Constarts and Variables: ////////////////////////////////////////////////////
int ISOrngEnd = 64;               // specify
int ISOnTcolSN = 16;              // specify
int ISOrangeStart       = 0;
int ISOrangeEnd = ISOrngEnd;
int ISOstartBit = 1;             // specify
int ISOplayingBit       = 0;
int ISOtableChangeCount = 1;
int ISOmsrTgl           = 0;
int ISOtableChangeCount32  = 1;
int ISOtableChangeCount64  = 1;
int ISOtableChangeCount128 = 1;
int ISOisSwitched_32_64_128 = 64; // specify
int ISOmode_3264_or_64128 = 3264; // specify
int ISOnTcolS = ISOnTcolSN;
int ISOonTapCollisionPrevention_1 = 0;
int ISOonTapCollisionPrevention_2 = 0;
int ISOonTapCollisionPrevention_3 = 0;
int ISOiStarts = 1;
int ISOiEnds = 64;                  // specify
List ISOjBtnRelease = [];
List<dynamic> ISOcsvLst = [];
int ISOnotesByBit = 21;             // specify
bool ISOrngExtend = false;
bool ISOtoggleIcnMsrBtn = true;     // specify
bool ISOfromTheBegin = false;       // specify
int ISOshortOrLongNum = 1;          // specify
int ISOselectedtuningNum = 1;       // specify
double ISOnoteVolume = 0.9;         // specify
int ISOextension = 1;               // specify
double ISOcrntSldrValT = 1;            // specify
double ISOtempoCoeff = 1.0;            // specify
bool ISOcnslDelay1Ntfr = false;        // specify
List<Map<String, bool>> ISObuttonsNotifier = [];  // specify
Map<String, String> cachedFilesPaths = {};
//
int TMPi = 1;                          // to duplicate check received (i) from isolate
///////////////////////////////////////////// End Audio Isolate Constarts and Variables: ////////////////////////////////////////////////
typedef NtState = ({
int rangeStart,
int rangeEnd,
int startBit,
int playingBit,
int tableChangeCount,
int msrTgl,
int tableChangeCount32,
int tableChangeCount64,
int tableChangeCount128,
int rangeStart32bak,
int rangeEnd32bak,
int rangeStart64bak,
int rangeEnd64bak,
int rangeStart128bak,
int rangeEnd128bak,
int listener3264128,
int listener326464128,
int rngEndSlider,
int nTcolS,
int captionVariant0,
int captionVariant1,
int counterPlayerLinux,
int onTapCollision1,
int onTapCollision2,
int onTapCollision3,
});
final nt$ = ValueNotifier<NtState>((
rangeStart: 0,
rangeEnd: 0,
startBit: 0,
playingBit: 0,
tableChangeCount: 1,
msrTgl: 0,
tableChangeCount32: 1,
tableChangeCount64: 1,
tableChangeCount128: 1,
rangeStart32bak: 0,
rangeEnd32bak: 0,
rangeStart64bak: 0,
rangeEnd64bak: 0,
rangeStart128bak: 0,
rangeEnd128bak: 0,
listener3264128: 32,
listener326464128: 0,
rngEndSlider: 0,
nTcolS: 0,
captionVariant0: 1,
captionVariant1: 1,
counterPlayerLinux: 0,
onTapCollision1: 0,
onTapCollision2: 0,
onTapCollision3: 0,
));
extension CopyWith on NtState {
  NtState copyWith({
    int? rangeStart,
    int? rangeEnd,
    int? startBit,
    int? playingBit,
    int? tableChangeCount,
    int? msrTgl,
    int? tableChangeCount32,
    int? tableChangeCount64,
    int? tableChangeCount128,
    int? rangeStart32bak,
    int? rangeEnd32bak,
    int? rangeStart64bak,
    int? rangeEnd64bak,
    int? rangeStart128bak,
    int? rangeEnd128bak,
    int? listener3264128,
    int? listener326464128,
    int? rngEndSlider,
    int? nTcolS,
    int? captionVariant0,
    int? captionVariant1,
    int? counterPlayerLinux,
    int? onTapCollision1,
    int? onTapCollision2,
    int? onTapCollision3,
  }) => (
  rangeStart: rangeStart ?? this.rangeStart,
  rangeEnd: rangeEnd ?? this.rangeEnd,
  startBit: startBit ?? this.startBit,
  playingBit: playingBit ?? this.playingBit,
  tableChangeCount: tableChangeCount ?? this.tableChangeCount,
  msrTgl: msrTgl ?? this.msrTgl,
  tableChangeCount32: tableChangeCount32 ?? this.tableChangeCount32,
  tableChangeCount64: tableChangeCount64 ?? this.tableChangeCount64,
  tableChangeCount128: tableChangeCount128 ?? this.tableChangeCount128,
  rangeStart32bak: rangeStart32bak ?? this.rangeStart32bak,
  rangeEnd32bak: rangeEnd32bak ?? this.rangeEnd32bak,
  rangeStart64bak: rangeStart64bak ?? this.rangeStart64bak,
  rangeEnd64bak: rangeEnd64bak ?? this.rangeEnd64bak,
  rangeStart128bak: rangeStart128bak ?? this.rangeStart128bak,
  rangeEnd128bak: rangeEnd128bak ?? this.rangeEnd128bak,
  listener3264128: listener3264128 ?? this.listener3264128,
  listener326464128: listener326464128 ?? this.listener326464128,
  rngEndSlider: rngEndSlider ?? this.rngEndSlider,
  nTcolS: nTcolS ?? this.nTcolS,
  captionVariant0: captionVariant0 ?? this.captionVariant0,
  captionVariant1: captionVariant1 ?? this.captionVariant1,
  counterPlayerLinux: counterPlayerLinux ?? this.counterPlayerLinux,
  onTapCollision1: onTapCollision1 ?? this.onTapCollision1,
  onTapCollision2: onTapCollision2 ?? this.onTapCollision2,
  onTapCollision3: onTapCollision3 ?? this.onTapCollision3,
  );
}
void initNtState({
  int? rngEnd,
  int? isSwitched_32_64_128,
  int? mode_3264_or_64128,
  int? nTcolS,
}) {
  nt$.value = nt$.value.copyWith(
    rangeEnd: rngEnd,
    listener3264128: isSwitched_32_64_128,
    listener326464128: mode_3264_or_64128,
    nTcolS: nTcolS,
  );
}
