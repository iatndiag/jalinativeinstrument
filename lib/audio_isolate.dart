import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:developer' as developer;   //  usage:  developer.log(message.toString());
import 'dart:isolate';
import 'dart:async';
import '../constants/app_constants_nd_vars.dart';
import 'audio_data.dart'; // visualMarks и krSnd
SoLoud audioEngine = SoLoud.instance;
Map<String, AudioSource> soundCache = {};
late SendPort portToMain;
// ---------------------------------------------------------------- SOLUTION: Timer Should Be In This (Second) Isolate Without GUI
@pragma('vm:entry-point')                                         // for Release, To prevent playerIsolateEntryPoint from being automatically removed as unnecessary
void playerIsolateEntryPoint (SendPort sendPortToMain) async{     // Top-Level Function Always !!!
  portToMain = sendPortToMain;
  final receivePortFromMain = ReceivePort();
  sendPortToMain.send(receivePortFromMain.sendPort);
  receivePortFromMain.listen((message) async {                                                     // async is Here
//
    bool isParentAlive(SendPort sendPort)
    {
      try {
        sendPort.send('ping');
        return true;
      } catch (e) {
        return false;
      }
    }
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (!isParentAlive(sendPortToMain)) {
        developer.log('Parent isolate not responding - terminating child');
        timer.cancel();
        Isolate.exit(null);
      }
    });
    if (message == 'shutdown') {
      developer.log('Termination signal received - closing child isolate');
      Isolate.exit(null);
    }
//
    if (message is Map) {
      cachedFilesPaths = message.map((key, value) => MapEntry(key.toString(), value.toString()));
      developer.log('cachedFilesPaths received: OK. Count: ${cachedFilesPaths.length}');
      await preCacheAll();
   // await preCacheAll_NEW();
    }
    if (message is RootIsolateToken) {                                                             // audioEngine needs Token  !
      BackgroundIsolateBinaryMessenger.ensureInitialized(message);
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        if (!audioEngine.isInitialized) {
          await audioEngine.init();
          audioEngine.setGlobalVolume(1.0);
          await Future.delayed(const Duration(milliseconds: 200));
          developer.log('ISOLATE: init OK');
          portToMain.send("TOKEN_READY"); // the Answer will be send allData
        }
      } catch (e) {
        developer.log('ISOLATE: init err: $e');
      }
    }
 //
    if (message is List && message[0] == 'sliderUpdate') {
      ISOcrntSldrValT = message[1];   // Directly from the Tempo Slider by User
    }
 //
    if (message is List && message.length > 14) {     // don't forget to change the Length of List here !!!
      ISOrangeStart = message[0][0][0]['rangeStart']; //  = = = = = = = = = = =  operator needed !!!   !!!   !!!
      ISOrangeEnd = message[0][0][1]['rangeEnd'];     // It is the assignment operator that is required! It simulates an event listener
      ISOstartBit = message[0][0][2]['startBit'];
      ISOplayingBit = message[0][0][3]['playingBit'];
      ISOtableChangeCount = message[0][0][4]['tableChangeCount'];
      ISOmsrTgl = message[0][0][5]['msrTgl'];
      ISOtableChangeCount32 = message[0][0][6]['tableChangeCount32'];
      ISOtableChangeCount64 = message[0][0][7]['tableChangeCount64'];
      ISOtableChangeCount128 = message[0][0][8]['tableChangeCount128'];
      ISOisSwitched_32_64_128 = message[0][0][15]['listener_32_64_128'];
      ISOmode_3264_or_64128 = message[0][0][16]['listener_3264_64128'];
      ISOnTcolS = message[0][0][21]['nTcolS'];
      ISOonTapCollisionPrevention_1 = message[0][0][25]['onTapCollisionPrevention_1'];
      ISOonTapCollisionPrevention_2 = message[0][0][26]['onTapCollisionPrevention_2'];
      ISOonTapCollisionPrevention_3 = message[0][0][27]['onTapCollisionPrevention_3'];
      ISOiStarts = message[1][0];
      ISOiEnds = message[2][0];
      ISOjBtnRelease = message[3];
      ISOcsvLst = message[4];
      ISOnotesByBit = message[5][0];
      ISOrngExtend = message[6][0];
      ISOtoggleIcnMsrBtn = message[7][0];
      ISOfromTheBegin = message[8][0];
      ISOshortOrLongNum = message[9][0];
      ISOselectedtuningNum = message[10][0];
      ISOnoteVolume = message[11][0];
      ISOextension = message[12][0];
      ISOcnslDelay1Ntfr = message[13][0];
      ISObuttonsNotifier = message[14][0];
      ISOtempoCoeff = message[15][0];
      developer.log('allData received: OK');
      // await preCacheAll(); // see if message is Map
// await Future.delayed(Duration(milliseconds: 100));
      portToMain.send("DATA_READY");                        // the Answer will be PLAY
    }
    if (message == 'PLAY') {
      isPlaying = false;
      await Future.delayed(Duration(milliseconds: 100));
      developer.log('PLAY command recieved');               // Ping-Pong from the Main after DATA_READY confirmation
      await ISOlistTraversal (cachedFilesPaths);
    }
    if (message == 'STOP') {
      ISOtoggleIcnMsrBtn = true;
      ISOmsrTgl = 0;
      developer.log('STOP command received');               // Directly From The Measures Toggle Button by User
    }
    // if (message == 'rngExtend') {
    //   ISOrngExtend = true;
    //   developer.log('RangeExtend command received');        // Directly From The Range Slider by User
    // }
});
//
} //end IsolateEntryPoint
//
// Do not use delay less than 0.001s or 1ms or 1000 us (microseconds)! Delay breakdown occurs!
reCalculateMD () {  // minimum possible duration // const mS look in Build Options at the beginning:
  // double mSiC = ((mS + mS*(1.0-ISOcrntSldrValT))/ISOtempoCoeff); // int = round ((double + (1-double))/double)
  double mSiC = ((mS + mS*(1.0-ISOcrntSldrValT))/ISOtempoCoeff)/8;  // int = round ((double + (1-double))/double)
  if (0.79 < ISOcrntSldrValT && ISOcrntSldrValT < 0.81) {mSiC = (mSiC*1.2);}        // imitation of Slider's log or exponential Slowdown
  else if (0.69 < ISOcrntSldrValT && ISOcrntSldrValT < 0.71) {mSiC = (mSiC*1.6);}   //because slider returns something like 0.7999999997
  else if (0.59 < ISOcrntSldrValT && ISOcrntSldrValT < 0.61) {mSiC = (mSiC*2.4);}
  else if (0.49 < ISOcrntSldrValT && ISOcrntSldrValT < 0.51) {mSiC = (mSiC*4.0);}
  else if (0.39 < ISOcrntSldrValT && ISOcrntSldrValT < 0.41) {mSiC = (mSiC*7.2);}    // Log or Exponent Slider Imitation
  else if (0.29 < ISOcrntSldrValT && ISOcrntSldrValT < 0.31) {mSiC = (mSiC*13.6);}   //because slider returns something like 0.3000000007
  else if (0.19 < ISOcrntSldrValT && ISOcrntSldrValT < 0.21) {mSiC = (mSiC*26.4);}
  else if (0.09 < ISOcrntSldrValT && ISOcrntSldrValT < 0.11) {mSiC = (mSiC*52.0);} else {}  //70mS*52=3.64 Sec
  num mSiCn = num.parse((mSiC/5).toStringAsFixed(3));   // round to 3 digits
  int mSiC5 = (mSiCn * 1000).round(); Duration mD1 = Duration(microseconds: mSiC5);   // print(mSiC);  print(mD1);
  return mD1;
} // end reCalculateMD()
reCalculateMD2 () {  // minimum possible duration // const mS look in Build Options at the beginning:
  double mSiC = ((mS + mS*(1.0-ISOcrntSldrValT))/ISOtempoCoeff); // int = round ((double + (1-double))/double)
  if (0.79 < ISOcrntSldrValT && ISOcrntSldrValT < 0.81) {mSiC = (mSiC*1.2);}   // imitation of Slider's log or exponential Slowdown
  else if (0.69 < ISOcrntSldrValT && ISOcrntSldrValT < 0.71) {mSiC = (mSiC*1.6);}   //because slider returns something like 0.7999999997
  else if (0.59 < ISOcrntSldrValT && ISOcrntSldrValT < 0.61) {mSiC = (mSiC*2.4);}
  else if (0.49 < ISOcrntSldrValT && ISOcrntSldrValT < 0.51) {mSiC = (mSiC*4.0);}
  else if (0.39 < ISOcrntSldrValT && ISOcrntSldrValT < 0.41) {mSiC = (mSiC*7.2);}    // Log or Exponent Slider Imitation
  else if (0.29 < ISOcrntSldrValT && ISOcrntSldrValT < 0.31) {mSiC = (mSiC*13.6);}   //because slider returns something like 0.3000000007
  else if (0.19 < ISOcrntSldrValT && ISOcrntSldrValT < 0.21) {mSiC = (mSiC*26.4);}
  else if (0.09 < ISOcrntSldrValT && ISOcrntSldrValT < 0.11) {mSiC = (mSiC*52.0);} else {}  //70mS*52=3.64 Sec
  int mSiCi = (mSiC).round(); Duration mD = Duration(milliseconds: mSiCi);  // print(mSiCi);  print(mD);
  return mD;
} // end reCalculateMD2()
//
Future<void> preCacheAll() async {
  // You can also try Modern Variant of access to rootBundle directly via received Token without copying into Temp folder in main.dart
  developer.log('ISOLATE: Pre-caching started (WAV only)...');
  for (var entry in cachedFilesPaths.entries) {
    if (entry.key.toUpperCase().endsWith('.WAV')) {
      String cleanKey = entry.key.replaceAll('\r', '').trim();
      if (!soundCache.containsKey(cleanKey)) {
        try {
          final bytes = await File(entry.value).readAsBytes();
          final src = await audioEngine.loadMem(cleanKey, bytes);
          if (src != null) soundCache[cleanKey] = src;
          developer.log('Cached file: $cleanKey');
        } catch (e) {
          developer.log('Cache error $cleanKey: $e');
        }
      }
    }
  }
  developer.log('ISOLATE: Pre-caching finished. Total WAV: ${soundCache.length}');
  portToMain.send("DATA_READY");
}
//
// Try to pre-Cache Directly from the rootBundle via Token without copying Files to Temp, try New Variant:
Future<void> preCacheAll_NEW() async {
  // WidgetsFlutterBinding.ensureInitialized();
  developer.log('ISOLATE: Pre-caching started (WAV only, direct rootBundle access)...');
  for (var entry in cachedFilesPaths.entries) {
    if (entry.key.toUpperCase().endsWith('.WAV')) {
      String cleanKey = entry.key.replaceAll('\r', '').trim();
      if (!soundCache.containsKey(cleanKey)) {
        try {
          final ByteData byteData = await rootBundle.load(entry.key);
          final Uint8List bytes = byteData.buffer.asUint8List();
          final src = await audioEngine.loadMem(cleanKey, bytes);
          if (src != null) {
            soundCache[cleanKey] = src;
            developer.log('Cached from rootBundle: $cleanKey');
          } else {
            developer.log('Failed to load into audioEngine: $cleanKey');
          }
        } catch (e) {
          developer.log('Cache error $cleanKey: $e');
        }
      }
    }
  }
  developer.log('ISOLATE: Pre-caching finished. Total WAV: ${soundCache.length}');
  portToMain.send("DATA_READY");
}
// //
// List<SoundHandle> _activeHandles = List.filled(7,  const SoundHandle(0));            // 16-voices Limit Solution is Circular Buffer ("Round Robin")
// List<SoundHandle> _activeHandles = List.filled(16, const SoundHandle(0));            // 16-voices Limit Solution is Circular Buffer ("Round Robin")
   List<SoundHandle> _activeHandles = List.filled(10, const SoundHandle(0));            // 16-voices Limit Solution is Circular Buffer ("Round Robin")
int _circularIdx = 0;
playSound(int tuning, int number, int shortOrLong, double vol, int ext) async {
  if (!audioEngine.isInitialized) {
    await audioEngine.init();
    audioEngine.setGlobalVolume(1.0);
  }
  String xts = '';
  String pth = '';
  int tIdx = tuning - 1;
  int nIdx = number - 1;
  int sOl = shortOrLong - 1;
  switch (ext) {
    case 1:  xts = 'WAV'; pth = 'assets/wavn/'; break;       // softly-sounded samples
    case 2:  xts = 'm4a'; pth = 'assets/m4a/'; break;
    case 4:  xts = 'mp3'; pth = 'assets/mp3/'; break;
    default: xts = 'WAV'; pth = 'assets/wav/'; break;        // big-sized and loud instrument
  }
  ////////////////// Tuning-based samples list indexes (Change Them to Add or Edit Tuning) /////////////////////////////////////
  if (tuning == 11) { tIdx = 2;  pth = 'assets/wavn/'; }    // see file constants_nd_vars.dart for Tuning Numbers
  if (tuning == 12) { tIdx = 3;  pth = 'assets/wavn/'; }
  if (tuning == 14) { tIdx = 9;  pth = 'assets/wav/'; }
  if (tuning == 15) { tIdx = 10; pth = 'assets/wav/'; }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  See audio_data.dart   for  List krSnd (koraSound 3d-List):
  String nam = krSnd[tIdx][nIdx][sOl].toString().replaceAll('\r', '').trim();
  String ful = '$pth$nam.$xts';
  final src = soundCache[ful];
  if (src != null) {
    if (_activeHandles[_circularIdx] != const SoundHandle(0)) {
      audioEngine.stop(_activeHandles[_circularIdx]);
    }
    final newHandle = await audioEngine.play(src, volume: vol);
    _activeHandles[_circularIdx] = newHandle;
    var test = src.hashCode.toString();
    developer.log('Playing: $ful      $nIdx     $test   ');
    if (_circularIdx < 6) {
      _circularIdx++;
    } else {
      _circularIdx = 0;
    }
  }
} // end playSound()
// //
//
//
//////// Simple Player Variant, Works Fine:
        // bool isPlaying = false;
        // //
        // Future<void> ISOlistTraversal(Map<String, String> paths) async {
        //   if (isPlaying) { isPlaying = false; await Future.delayed(const Duration(milliseconds: 200)); }
        //   isPlaying = true;
        //   for (int i = 0; i < ISOcsvLst.length; i++) {
        //     if (!isPlaying) break;
        //     for (int j = 1; j <= ISOnotesByBit; j++) {
        //       if (!isPlaying) break;
        //       if (ISOcsvLst[i][j] != "") {
        //         if (ISOcsvLst[i][j].toString().contains("*")) ISOshortOrLongNum = 2;
        //         playSound(ISOselectedtuningNum, j, ISOshortOrLongNum, ISOnoteVolume, ISOextension);
        //         ISOshortOrLongNum = 1;
        //       }
        //     }
        //     await Future.delayed(Duration(milliseconds: 80));
        //   }
        //   isPlaying = false;
        // }
//
//
bool isPlaying = false;
//
Future<void> ISOlistTraversal (cachedFilesPaths) async {
  if (isPlaying) { isPlaying = false; await Future.delayed(const Duration(milliseconds: 200)); }
  isPlaying = true;
//   //**********************************************************************//
  var PBIT     = ISOplayingBit!;
  var TCC      = ISOtableChangeCount!;
  var OisLEFT  = ISOrangeStart?.round().remainder(ISOnTcolS!*2);  // Range slider left Handle at the Left position
  var OisRIGHT = ISOrangeEnd?.round().remainder(ISOnTcolS!*4);    // Range slider right Handle at the Right position
  var rSTART   = ISOrangeStart!;
  var rEND     = ISOrangeEnd!;
//   //**********************************************************************//
  portToMain.send('oneTraversingInstanceLaunched:true');                 // prevention of double- or multi- starts
  portToMain.send('showArrowMoveToTheLeft:false');                       // hide Arrow "Move Left"
  portToMain.send('showVerticalBigLables:false');                        // hide
  bool showLocalFinger = false;
  int iEndsTmp;                                             // for dynamical shortening or extending range by slider
  bool shouldChangeView = true;                             // to not increase TCC when stopped by user
  if(TCC == 1) {iEndsTmp = ((rEND)/2).round() + 0;} else {iEndsTmp = ((rEND)/2).round() + 0 + (TCC - 1) * (ISOnTcolS!*2);}
//   bool dontChangeView = true;     // don't change Current Page View with Current Numbers of Measures
// sendPortToMain.send('GETNOTIFIERREQUEST');
//   ///////////////////////////////////
//   // range Extends: if range was already set and now it extends by user using range slider
  if (ISOrngExtend == true) {
    PBIT = ISOiStarts;
  portToMain.send('msrTgl:1');
    ISOplayingBit = PBIT;
// sendPortToMain.send('GETNOTIFIERREQUEST');
    portToMain.send('toggleIcnMsrBtn:false');
  } else {}
//   ///////////////////////////////////
  if (ISOiEnds > ISOcsvLst.length) {ISOiEnds = ISOcsvLst.length - 0;} else {} // end if
//   //--------------------------------------- Main Cycle Loops Begin ---------------------------------------//
  for (int i = ISOiStarts; i < ISOiEnds; i++) { // traversing a list from start to finish //"mS" could be changed at any time by Slider
    if (!isPlaying) break;
// sendPortToMain.send('GETNOTIFIERREQUEST');
    TCC    = ISOtableChangeCount!;
    if(TCC == 1) {iEndsTmp = ((ISOrangeEnd!)/2).round() + 0;} else {iEndsTmp = ((ISOrangeEnd!)/2).round() + 0 + (TCC - 1) * (ISOnTcolS!*2);}  // use listenable value ISOrangeEnd!
        if((i==ISOiEnds-1) && OisLEFT == 0 && OisRIGHT == 0 && rSTART==0 && TCC > 1) {
   portToMain.send('showArrowMoveToTheLeft:true');                       // show Arrow "Move Left"
        } else {};      // show suggest to move to the left handle of the range slider to start from the beginning // fix rSTART==0  arrow Move Left appears at the middle Left Handle position
//
/////////////////////// Animation of Cursor Move
    PBIT       = i;  // animation of cursor move
    ISOplayingBit = PBIT;
    developer.log('ISOplayingBit: $ISOplayingBit');
    portToMain.send('playingBit:' + ISOplayingBit.toString());
/////////////////////// End Animation of Cursor Move
//
//
//     // if range slider became All the way to the left and All the way to the right, then:
    if (OisLEFT == 0 && OisRIGHT == 0 && ISOfromTheBegin == true) { // restore cursor position when range released by user
  portToMain.send('fromTheBegin:false');                            // will not start from the begin of the List
    } else {} // end if
//     //
//     ////////////////////////////////////////////////////////////////////
//     range WAS all the way to the left and right (not set), and NOW it changed by user, then Stop:
    if((OisLEFT==0 && ISOrangeStart?.round().remainder(ISOnTcolS!*2) != 0) || (OisRIGHT==0 && ISOrangeEnd?.round().remainder(ISOnTcolS!*4) != 0)) {
      portToMain.send('toggleIcnMsrBtn:true');
// portToMain.send('GETNOTIFIERREQUEST');
      portToMain.send('msrTgl:0');
// // portToMain.send('SETNOTIFIERREQUEST');
// portToMain.send('GETNOTIFIERREQUEST');
      portToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
      portToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
    }
    else {}
//     ////////////////////////////////////////////////////////////////////
//     //
//     //
//     /////////////////////////////////////////////////////////////////////////////////////////
    if (ISOtoggleIcnMsrBtn) {  // if measure button pressed by user
      shouldChangeView = false;
      if (ISOfromTheBegin) {
        i = ISOiEnds - 1; // exit from cycle = release, stop
        ISOstartBit         = 0;
        ISOplayingBit       = 0;
        ISOtableChangeCount = 1;
      portToMain.send('msrTgl:0');
// sendPortToMain.send('tableChangeCount32:1');
// sendPortToMain.send('tableChangeCount64:1');
// sendPortToMain.send('tableChangeCount128:1');
//  sendPortToMain.send('SETNOTIFIERREQUEST');
      } else {
        i = ISOiEnds - 1; // exit from cycle = release, stop
        // So that there is no empty space at the cursor position after stopping:
        ISOplayingBit       = maxLength;
// sendPortToMain.send('SETNOTIFIERREQUEST');
        //
      } // end if (start from the begin)
      portToMain.send('toggleIcnMsrBtn:true');
      portToMain.send('oneTraversingInstanceLaunched:false');
// portToMain.send('GETNOTIFIERREQUEST');
// sendPortToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
// sendPortToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
// portToMain.send('SETSTATE:DO');
    } else {} // end exiting cycle (stop play), measure button pressed by user
//     /////////////////////////////////////////////////////////////////////////////////////////
//     ///////////////////////////////////////////////////////////////////////////////
//     // if range dynamically changed by user (rangeEnd became less than playingBit):
//     if ((iEndsTmp <= PBIT && (OisLEFT != 0 || OisRIGHT != 0))) {  // if range dynamically changed by user
//       i = ISOiEnds - 1;    // exit from cycle = release, stop
// // sendPortToMain.send('SETSTATE');
//     } else {} // end if
//     //////////////////////////////////////////////////////////////////////////////
//     //////////////////////////// Current Bit Traversal by "j", PlayingNotes ////////////////////////////////
    for (int j = 1; j <= ISOnotesByBit; j++) {     // (j) is number of playing string at the moment, and  shortOrLong - is variant of note's length // <=   <=   <=  less or equal
      if (!isPlaying) break;
      if (ISOcsvLst[i][j] != "") {                 // for simple Lists Use "add" method!!          // ISOshortOrLongNum = 1 or 2 (Long|Short)  // You not to have to escape "asterisk", or "\" an "raw"
        if (ISOcsvLst[i][j].toString().contains("*")) {
          ISOshortOrLongNum = 2;
// ISOjBtnRelease.add(j);
        } else {} // note with (*) is a Short Note, sounds faster //LONG NOTES NOT WORKED BY THE REASON OF LIST.FROM data1, inherit changed it's parent!!! You not to have to escape symbol '\' or use a raw string
 playSound(ISOselectedtuningNum, j, ISOshortOrLongNum, ISOnoteVolume, ISOextension);  // without Await, sounds from here !
 // developer.log(j.toString());
        if(ISOmsrTgl == 0) {noteVolume = noteVolumeBack;} else {}   //restoring normal Vol    // to (ISOiEnds - 1) note will not hear    2 of 2
        ISOshortOrLongNum = 1; // resetting to Long ones !!!
        if((ISOcsvLst[i][j].toString().contains("i") && showFingeringOnButtons[j] == 0) || (ISOcsvLst[i][j].toString().contains("t") && showFingeringOnButtons[j] == 1)) {
          showLocalFinger=true;    // if notation contains "index finger" and by default rule this string played not by Index
        } else {
          showLocalFinger=false;   // if notation contains "thumb finger" and by default rule this string played not by Thumb
        } // end if, for show Locally Fingering   // As planned, local finger is shown ONLY if the default fingering rule is not followed
// addButtonsStates(j, showLocalFinger);        // pressing the button
      }  // will be hear async parallel simultaneously sounds notes by one bit and aftertones of previous bits notes
    } // ind for (j)
//     //////////////////////////// End Current Bit Traversal by "j", PlayingNotes ////////////////////////////
// //       sendPortToMain.send('GETNOTIFIERREQUEST');
//     if(ISOonTapCollisionPrevention_1 == 0 && ISOonTapCollisionPrevention_2 == 0 && ISOonTapCollisionPrevention_3 == 0) {
//       if (shouldChangeView == true) {
//         await changeTableView(i, ISOiStarts, dontChangeView);  // await added!
//       } else {} // instead of 256 "ISOnTcolS!" replace to  "ntTblNtfrsList[21]['ISOnTcolS!']" . It seems impossible!
//     } else {} //  end onTap collision prevention
//     //
//     //
//     if(OisLEFT == 0 && OisRIGHT == 0 && rSTART?.round() != 2*ISOnTcolS!) {
// // ISOiEnds = maxLength; // <======================================================================= !!!!!!!!!!!!!!!!!!!!!! Issue Is Here !!!
//       // if TSV, prevention of ISOiEnds range error at the end of playback (2 of 2):
//       if(wasTSVextDetected==true || googleCSVdetected==true) { // ??? TSV needs minus one element at the end (this is the difference from CSV):
//         ISOiEnds = ISOcsvLst.length - 0;
//       } else {
//       } //end if TSV was detected
//     } else {}; //end if
//     if((i+1).remainder(ISOnTcolS!*2) == 0) {dontChangeView = false;} else {} //end if // don't change table view after manually toggle button play
//     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     ///////////////////////------End Change table View------////////////////////////
//     //
//     //////////////////////// imitation of cancelable Delay: ///////////////// Eeach time calling function, because "ISOcrntSldrValT" may changed any time by user
//       await Future.delayed(Duration(milliseconds: 80));    // test
//     // if(ISOtempoCoeff<=1.8) { // Do cancelable delay:
//     //   // toDo: first pause of 3 (silence) before short-sounding notes buttons release:
       for (int u = 0; u < 3; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=3; ISOcnslDelay1Ntfr=false;}} // end for
//     //   if (ISOjBtnRelease.isNotEmpty) {                                                                 // toDo: setState() N2
//     //     for (int k in ISOjBtnRelease){   // for simple Lists Use simple construction "in"
//     //       releaseButtonsStates(k);    // release shortly sounded notes buttons
//     //     } // end for (k)
//     //   } else {} // end if (ISOjBtnRelease.length)
//     //   ISOjBtnRelease.clear();  // the best way to clear List
//     //   // toDo: second pause of 3 (silence) before normal long-sounding notes buttons release:
       for (int u = 0; u < 7; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=7; ISOcnslDelay1Ntfr=false;}} // end for
//     //   releaseButtonsStates(0);         // release All notes buttons                                // toDo: setState() N3
//     //   // toDo: third pause of 3 (silence) before starting next bit:
       for (int u = 0; u < 5; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=5; ISOcnslDelay1Ntfr=false;}} // end for
//     // } else {      // too high table visualisation speed, NO cancelable delay:
//     //   // toDo: first pause of 3 (silence) before short-sounding notes buttons release:
//     //   await Future.delayed(reCalculateMD2());
//     //   if (ISOjBtnRelease.isNotEmpty) {                                                                 // toDo: setState() N2
//     //     for (int k in ISOjBtnRelease){   // for simple Lists Use simple construction "in"
//     //       releaseButtonsStates(k);    // release shortly sounded notes buttons
//     //     } // end for (k)
//     //   } else {} // end if (ISOjBtnRelease.length)
//     //   ISOjBtnRelease.clear();  // the best way to clear List
//     //   // toDo: second pause of 3 (silence) before normal long-sounding notes buttons release:
//     //   await Future.delayed(reCalculateMD2());
//     //   releaseButtonsStates(0);         // release All notes buttons                                    // toDo: setState() N3
//     //   // toDo: third pause of 3 (silence) before starting next bit:
//     //   await Future.delayed(reCalculateMD2());
//     // } //end if additional tempo coeff > 1
//     ////////////////////// End imitation of cancelable Delay//////////////////                            // toDo: setState() N4
//     //
//     ////////////////////// Completion naturally //////////////////////
//     if (i == ISOiEnds - 1) {      // completion naturally upon reaching ISOiEnds OR at the end of the List
//       shouldChangeView = false;
//       // print('ends naturally');
// // sendPortToMain.send('GETNOTIFIERREQUEST');
//       if(ISOfromTheBegin) {
//         ISOstartBit         = 0;
//         ISOplayingBit       = 0;
//         ISOtableChangeCount = 1;
// // sendPortToMain.send('msrTgl:0');
// // sendPortToMain.send('tableChangeCount32:1');
// // sendPortToMain.send('tableChangeCount64:1');
// // sendPortToMain.send('tableChangeCount128:1');
//       } else {                          // completion naturally at the end of the selected Range
// // sendPortToMain.send('msrTgl:0');
//         //                           // So that there is no empty space at the cursor position after stopping:
//         ISOplayingBit       = maxLength;
// // sendPortToMain.send('SETNOTIFIERREQUEST');
//         //
//       } //end if(start from the begin)
// // sendPortToMain.send('toggleIcnMsrBtn:true');
// // sendPortToMain.send('oneTraversingInstanceLaunched:false');
// // sendPortToMain.send('SETSTATE');
// // sendPortToMain.send('SETNOTIFIERREQUEST');
// // sendPortToMain.send('GETNOTIFIERREQUEST');
// // sendPortToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
// // sendPortToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
// // sendPortToMain.send('SETSTATE');
//     } // end if(): setting Icon on Measure Button to "Play" (default)
//     /////////////////// End Completion naturally /////////////////////
//     //await setDataSharedPref();   // CALL
// // sendPortToMain.send('setDataSharedPref');
  } // end for (i)                                        // "oneTraversingInstanceLaunched" is a Double-start prevention
//   //await checkIfTCCareOutOfLimits();  // if previous session ends incorrectly or table change view ends incorrectly
// // sendPortToMain.send('checkIfTCCareOutOfLimits');
// // sendPortToMain.send('oneTraversingInstanceLaunched:false');  // after additional list traversal it could be "true", so setting it to "false" at the end
// // sendPortToMain.send('SETSTATE');
// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  isPlaying = false;
 } // end ISOlistTraversal()
//