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
    if (message is Map) {
      cachedFilesPaths = message.map((key, value) => MapEntry(key.toString(), value.toString()));
      developer.log('cachedFilesPaths received: OK. Count: ${cachedFilesPaths.length}');
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
    if (message is List && message.length > 14) {
      ISOrangeStart = message[0][0][0]['rangeStart']; //  = = = = = = = = = = =  operator !!!
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
      // ISObuttonsNotifier   = message[14][0];
      developer.log('allData received: OK');
      await preCacheAll();
      portToMain.send("DATA_READY"); // the Answer will be PLAY
    }
    if (message == "PLAY") {
      isPlaying = false;
      await Future.delayed(Duration(milliseconds: 100));
      developer.log('PLAY command recieved');
      await ISOlistTraversal (cachedFilesPaths);
    }
});
//
} //end IsolateEntryPoint
//
Future<void> preCacheAll() async {
  developer.log('ISOLATE: Pre-caching started (WAV only)...');
  for (var entry in cachedFilesPaths.entries) {
    if (entry.key.toUpperCase().contains('.WAV') && !soundCache.containsKey(entry.key)) {
      try {
        final bytes = await File(entry.value).readAsBytes();
        final src = await audioEngine.loadMem(entry.key, bytes);
        if (src != null) {
          soundCache[entry.key] = src;
        }
      } catch (e) {
        developer.log('Cache error ${entry.key}: $e');
      }
    }
  }
  developer.log('ISOLATE: Pre-caching finished. Total WAV: ${soundCache.length}');
  portToMain.send("DATA_READY");
}
// //
playSound(int tuning, int number, int shortOrLong, double vol, int ext) async {
  // if (!SoLoud.instance.isInitialized) return;
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
  // case 3: ;break;                                         // reserved for future ideas (? try stereo auditorium Reverberation)
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
  String nam = krSnd[tIdx][nIdx][sOl].toString();
  String ful = '$pth$nam.$xts';
   developer.log('Playing ful: $ful $nIdx');
  final src = soundCache[ful];
  if (src != null) {
    await audioEngine.play(src, volume: vol);
    // developer.log('Playing: $ful');
  }
} // end playSound()
// //
//
  // Do not use delay less than 0.001s or 1ms or 1000 us (microseconds)! Delay breakdown occurs!
  reCalculateMD () {  // minimum possible duration // const mS look in Build Options at the beginning:
    double mSiC = ((mS + mS*(1.0-crntSldrValT))/tempoCoeff); // int = round ((double + (1-double))/double)
    if (0.79 < crntSldrValT && crntSldrValT < 0.81) {mSiC = (mSiC*1.2);}        // imitation of Slider's log or exponential Slowdown
    else if (0.69 < crntSldrValT && crntSldrValT < 0.71) {mSiC = (mSiC*1.6);}   //because slider returns something like 0.7999999997
    else if (0.59 < crntSldrValT && crntSldrValT < 0.61) {mSiC = (mSiC*2.4);}
    else if (0.49 < crntSldrValT && crntSldrValT < 0.51) {mSiC = (mSiC*4.0);}
    else if (0.39 < crntSldrValT && crntSldrValT < 0.41) {mSiC = (mSiC*7.2);}    // Log or Exponent Slider Imitation
    else if (0.29 < crntSldrValT && crntSldrValT < 0.31) {mSiC = (mSiC*13.6);}   //because slider returns something like 0.3000000007
    else if (0.19 < crntSldrValT && crntSldrValT < 0.21) {mSiC = (mSiC*26.4);}
    else if (0.09 < crntSldrValT && crntSldrValT < 0.11) {mSiC = (mSiC*52.0);} else {}  //70mS*52=3.64 Sec
    num mSiCn = num.parse((mSiC/5).toStringAsFixed(3));   // round to 3 digits
    int mSiC5 = (mSiCn * 1000).round(); Duration mD1 = Duration(microseconds: mSiC5);   // print(mSiC);  print(mD1);
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
  //
//
bool isPlaying = false;
Future<void> ISOlistTraversal(Map<String, String> paths) async {
  if (isPlaying) { isPlaying = false; await Future.delayed(const Duration(milliseconds: 200)); }
  isPlaying = true;
  for (int i = 0; i < ISOcsvLst.length; i++) {
    if (!isPlaying) break;
    for (int j = 1; j <= ISOnotesByBit; j++) {
      if (!isPlaying) break;
      if (ISOcsvLst[i][j] != "") {
        if (ISOcsvLst[i][j].toString().contains("*")) ISOshortOrLongNum = 2;
        playSound(ISOselectedtuningNum, j, ISOshortOrLongNum, ISOnoteVolume, ISOextension);
        ISOshortOrLongNum = 1;
      }
    }
    await Future.delayed(Duration(milliseconds: 150));
  }
  isPlaying = false;
}
//
// Future<void> ISOlistTraversal (cachedFilesPaths) async {
//   //
//   if (audioEngine.isInitialized) {
//     try {
//       await audioEngine.disposeAllSources();
//       soundCache.clear();
//       await Future.delayed(const Duration(milliseconds: 100));
//     } catch (e) {
//       developer.log('Clear error: $e');
//     }
//   }
//   //
//   void addButtonsStates(int btnNum, bool locFing) {
//     // See also SplayTreeMap (Sorted! HashMap), "Splay"!
//     //   //if(stringsNum==21 && btnNum==21) { btnNum = 22;} else if(stringsNum==21 && btnNum==22)  { btnNum = 21;} else {}   // remember that in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string, but in csvLst does not changed
//     //   if (btnNum==0)  {
//     //     buttonsPS.clear();
//     //     for (int i = 0; i < 24; i++) {        // to prevent Range error: max index is 23
//     //       buttonsPS.add({'prsd' : false});    // List of unsorted HashMapS (no need to Sort, it's primitive!)
//     //     } //end for
//     //     buttonsPS.add({'fngr' : false});    // for Local showFingering              24th element
//     // sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
//     //   } else if( (stringsNum==21 && btnNum != 21) || stringsNum==22 ) {             // in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string
//     //     buttonsPS = ISObuttonsNotifier; // "..." !!! it is called "Spread operator"     // If you want to get previous values!
//     //     buttonsPS[btnNum]['prsd'] = true;
//     //     if (locFing==true) {buttonsPS[24]['fngr'] = true;} else {};
//     // sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
//     //   } else {} // end if()
//   } // end addButtonsStates()
//   void releaseButtonsStates(int btnNum) {
//     //   //if(stringsNum==21 && btnNum==21) { btnNum = 22;} else if(stringsNum==21 && btnNum==22)  { btnNum = 21;} else {}   // remember that in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string, but in csvLst does not changed
//     //   buttonsPS = ISObuttonsNotifier; // "..." !!! it is called "Spread operator"
//     //   if (btnNum==0)  {
//     //     for (int i = 0; i < 24; i++) {
//     //       buttonsPS[i]['prsd'] = false;
//     //     } //end for
//     //     buttonsPS[24]['fngr'] = false;
//     // sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
//     //   } else if( (stringsNum==21 && btnNum != 21) || stringsNum==22 ) {             // in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string
//     //     buttonsPS[btnNum]['prsd'] = false;
//     //     buttonsPS[24]['fngr'] = false;
//     // sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
//     //   } else {} // end if()
//   } // end releaseButtonsStates()
// // //
// // //
//   changeTableView(i,iStarts,dontChangeView) {
//     //changes view Only in UP direction, by "i"
// // sendPortToMain.send('onTapCollisionPrevention_1:' + 1.toString());
// // sendPortToMain.send('SETNOTIFIERREQUEST');
//     //**********************************************************************//  "Assembler-style" variables names:
// // sendPortToMain.send('GETNOTIFIERREQUEST');
//     var TCC128 = ISOtableChangeCount128!;
//     var TCC064 = ISOtableChangeCount64!;
//     var TCC032 = ISOtableChangeCount32!;
//     var PBIT   = ISOplayingBit!;
//     var TCC    = ISOtableChangeCount!;
//     var SBIT   = ISOstartBit!;
//     var OisLEFT =  ISOrangeStart?.round().remainder(ISOnTcolS!*2);  // Range slider left Handle at the Left position
//     var OisRIGHT = ISOrangeEnd?.round().remainder(ISOnTcolS!*4);    // Range slider right Handle at the Right position
//     var rSTART = ISOrangeStart!;
//     var rEND = ISOrangeEnd!;
//     var ALLCOL = ISOnTcolS!*2;
//     var STARTr = rSTART?.round();
//     //**********************************************************************//
//     //
//     if(ISOisSwitched_32_64_128! ==128) {
//       TCC=TCC128;
//       if ((i - 1).remainder(ALLCOL) == 0 && i != 1 && TCC == 1 && STARTr != ALLCOL) {                                                			 // if (i - 1) !!!
//         TCC032 = TCC032 + 4;
//         TCC064 = TCC064 + 2;
//         TCC128 = TCC128 + 1;
//         TCC = TCC128;
//         iStarts = ((rSTART)/2).round() + 1 + (TCC - 1) * (ALLCOL);
//         SBIT = ((rSTART)/2).round() + ALLCOL + 0;
//         PBIT = iStarts;
//       } else if((i).remainder(ALLCOL) == 0 && TCC == 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i)
//         TCC032 = TCC032 + 4;
//         TCC064 = TCC064 + 2;
//         TCC128 = TCC128 + 1;
//         TCC = TCC128;
//         iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ALLCOL);
//         SBIT = iStarts + 0;
//         PBIT = iStarts + 0;
//       } else if((i).remainder(ALLCOL) == 0 && TCC > 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i)
//         TCC032 = TCC032 + 4;
//         TCC064 = TCC064 + 2;
//         TCC128 = TCC128 + 1;
//         TCC = TCC128;
//         iStarts = ((rSTART)/2).round() + 0 + (TCC - 1) * (ALLCOL);
//         SBIT = iStarts + 0;
//         PBIT = iStarts + 0;
//       } else {} //end if //
//     } else if(ISOisSwitched_32_64_128! ==64) {
//       TCC=TCC064;
//       if ((i - 1).remainder(ALLCOL) == 0 && i != 1 && TCC == 1 && STARTr != ALLCOL) {          						                                 // if (i - 1)  !!!
//         if ((TCC032).remainder(2) != 0) {TCC032 = TCC032 + 2;} else {TCC032 = TCC032 + 1;}
//         TCC064 = TCC064 + 1;
//         TCC = TCC064;
//         if ((TCC032).remainder(2) != 0 && TCC064.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
//         iStarts = ((rSTART) / 2).round() + 1 + (TCC - 1) * (ALLCOL);
//         SBIT = ((rSTART) / 2).round() + ALLCOL + 0;
//         PBIT = iStarts;
//       } else if ((i).remainder(ALLCOL) == 0 && TCC == 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
//         if ((TCC032).remainder(2) != 0) {TCC032 = TCC032 + 2;} else {TCC032 = TCC032 + 1;}
//         TCC064 = TCC064 + 1;
//         TCC = TCC064;
//         if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
//         iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
//         SBIT = iStarts + 0;
//         PBIT = iStarts + 0;
//       } else if ((i).remainder(ALLCOL) == 0 && TCC > 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
//         if ((TCC032).remainder(2) != 0) {TCC032 = TCC032 + 2;} else {TCC032 = TCC032 + 1;}
//         TCC064 = TCC064 + 1;
//         TCC = TCC064;
//         if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
//         iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
//         SBIT = iStarts + 0;
//         PBIT = iStarts + 0;
//       } else {} //end if //
//     } else if (ISOisSwitched_32_64_128!  == 32) {
//       TCC=TCC032;
//       if ((i - 1).remainder(ALLCOL) == 0 && i != 1 && TCC == 1 && STARTr != ALLCOL) {         					                                 	  // if (i - 1)  !!!
//         TCC032 = TCC032 + 1;
//         TCC = TCC032;
//         if (TCC032.remainder(2) != 0 && TCC032 != 1) {TCC064 = TCC064 + 1;} else {}
//         if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0 && TCC128.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
//         iStarts = ((rSTART) / 2).round() + 1 + (TCC - 1) * (ALLCOL);
//         SBIT = ((rSTART) / 2).round() + ALLCOL + 0;
//         PBIT = iStarts;
//       } else if ((i).remainder(ALLCOL) == 0 && TCC == 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
//         TCC032 = TCC032 + 1;
//         TCC = TCC032;
//         if (TCC032.remainder(2) != 0 && TCC032 != 1) {TCC064 = TCC064 + 1;} else {}
//         if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0 && TCC128.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
//         iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
//         SBIT = iStarts + 0;
//         PBIT = iStarts + 0;
//       } else if ((i).remainder(ALLCOL) == 0 && TCC > 2 && (OisLEFT == 0 && OisRIGHT == 0 && STARTr != ALLCOL) && dontChangeView == false) { // if (i) !!!
//         TCC032 = TCC032 + 1;
//         TCC = TCC032;
//         if (TCC032.remainder(2) != 0 && TCC032 != 1) {TCC064 = TCC064 + 1;} else {}
//         if (TCC032.remainder(2) != 0 && TCC064.remainder(2) != 0 && TCC128.remainder(2) != 0) {TCC128 = TCC128 + 1;} else {}
//         iStarts = ((rSTART) / 2).round() + 0 + (TCC - 1) * (ALLCOL);
//         SBIT = iStarts + 0;
//         PBIT = iStarts + 0;
//       } else {} //end if //
//     } else {} //end if (128 64 32)
// //
// //
// //**********************************************************************//
// // sendPortToMain.send('tableChangeCount128:' + TCC128.toString());
// // sendPortToMain.send('tableChangeCount64:' + TCC064.toString());
// // sendPortToMain.send('tableChangeCount32:' + TCC032.toString());
// // sendPortToMain.send('playingBit:' + PBIT.toString());
// // sendPortToMain.send('startBit:' + SBIT.toString());
// // sendPortToMain.send('tableChangeCount:' + TCC.toString());
// // sendPortToMain.send('rangeStart:' + rSTART.toString());
// // sendPortToMain.send('rangeEnd:' + rEND.toString());
//     ////////////////////////////
// // sendPortToMain.send('SETNOTIFIERREQUEST');     // without setState()
//     ////////////////////////////
// //**********************************************************************//
// //
// // sendPortToMain.send('onTapCollisionPrevention_1:' + 0.toString());
// // sendPortToMain.send('SETNOTIFIERREQUEST');
//   } // end changeTableView()
// // //
//   //**********************************************************************//
//   var PBIT     = ISOplayingBit!;
//   var TCC      = ISOtableChangeCount!;
//   var OisLEFT  = ISOrangeStart?.round().remainder(ISOnTcolS!*2);  // Range slider left Handle at the Left position
//   var OisRIGHT = ISOrangeEnd?.round().remainder(ISOnTcolS!*4);    // Range slider right Handle at the Right position
//   var rSTART   = ISOrangeStart!;
//   var rEND     = ISOrangeEnd!;
//   //**********************************************************************//
// // sendPortToMain.send('oneTraversingInstanceLaunched:true');            // prevention of double- or multi- starts
// // sendPortToMain.send('showArrowMoveToTheLeft:false');                  // hide Arrow "Move Left"
// // sendPortToMain.send('showVerticalBigLables:false');                   // hide
// // sendPortToMain.send('SETSTATE');
//   bool showLocalFinger = false;
//   int iEndsTmp;                                             // for dynamical shortening or extending range by slider
//   bool shouldChangeView = true;                             // to not increase TCC when stopped by user
//   if(TCC == 1) {iEndsTmp = ((rEND)/2).round() + 0;} else {iEndsTmp = ((rEND)/2).round() + 0 + (TCC - 1) * (ISOnTcolS!*2);}
//   //////////////////////////// Playback speed Slowdown correction using Stopwatch (part 1 of 3): /////////////////
//   // Android: first ~3 measures after first file load - playback accelerates, then slows down,
//   // Windows: in background - playback accelerates (when result of widget rebuild is not visible)
//   // Conclusion: needs speed correction, SLOWDOWN (!), so used stopwatch steps 1-3:
//   // // Stopwatch stopwatch;  // measure execution duration in between lines of code 1 of 2
//   // // print('Elapse Start: ${stopwatch.elapsed}'); // works fine
//   //   ////////////////////////////////////////////////// End Stopwatch 1 of 2 ////////////////////////////////////////
//   bool dontChangeView = true;     // don't change Current Page View with Current Numbers of Measures
// // sendPortToMain.send('GETNOTIFIERREQUEST');
//   ///////////////////////////////////     // toDo: issue: measure toggle
//   // range Extends: if range was already set and now it extends by user using range slider
//   if (ISOrngExtend == true) {
//     PBIT = ISOiStarts;
// // sendPortToMain.send('msrTgl:1');
// // sendPortToMain.send('SETNOTIFIERREQUEST');
//     ISOplayingBit = PBIT;
// // sendPortToMain.send('GETNOTIFIERREQUEST');
// // sendPortToMain.send('toggleIcnMsrBtn:false');
// // sendPortToMain.send('SETSTATE');
//   } else {}
//   ///////////////////////////////////
//   if (ISOiEnds > ISOcsvLst.length) {ISOiEnds = ISOcsvLst.length - 0;} else {} // end if toDo: (prevention of grey screen) when List Naturally Ended
//   //print(ISOiEnds);print(wasTSVextDetected);
//   //--------------------------------------- Main Cycle Loops Begin ---------------------------------------//
//
//   // outerloop:                // NOT Used    try to break for-loop by label and keyword "break outerloop;"   No very good idea!
//   for (int i = ISOiStarts; i < ISOiEnds; i++) { // traversing a list from start to finish //"mS" could be changed at any time by Slider
//     //
// // var sw = Stopwatch()..start();
// //           while((ISOonTapCollisionPrevention_1 == 1 || ISOonTapCollisionPrevention_2 == 1 || ISOonTapCollisionPrevention_3 == 1)  && sw.elapsedMilliseconds < 625)
// //           {
// //             // NO ENDLESS LOOP !!!  2 SECONDS
// //           }
//     //
// // sendPortToMain.send('GETNOTIFIERREQUEST');
//     TCC    = ISOtableChangeCount!;    // try to fix incorrect view change after bothTables onTap
//     if(TCC == 1) {iEndsTmp = ((ISOrangeEnd!)/2).round() + 0;} else {iEndsTmp = ((ISOrangeEnd!)/2).round() + 0 + (TCC - 1) * (ISOnTcolS!*2);}  // use listenable value ISOrangeEnd!
//     if((i==ISOiEnds-1) && OisLEFT == 0 && OisRIGHT == 0 && rSTART==0 && TCC > 1) {
// // sendPortToMain.send('showArrowMoveToTheLeft:true');
// // sendPortToMain.send('SETSTATE');
//     } else {};      // show suggest to move to the left handle of the range slider to start from the beginning // fix rSTART==0  arrow Move Left appears at the middle Left Handle position
//     ////////// Stopwatch (part 2 of 3)///////////
// //           stopwatch = Stopwatch()..start();
// //         stopwatch.reset();
//     //print('Elapse Start: ${stopwatch.elapsed}');
//     /////////// End Stopwatch (part 2 of 3)//////
//     //
//     /////////////// Animation of Cursor Move
//     PBIT       = i;  // animation of cursor move
//     ISOplayingBit = PBIT;
// // sendPortToMain.send('playingBit' + ISOplayingBit.toString());
// // sendPortToMain.send('SETNOTIFIERREQUEST');        // instead of previous value attach
//     /////////////// End Animation of Cursor Move
//     //
//     //
//     // if range slider became All the way to the left and All the way to the right, then:
//     if (OisLEFT == 0 && OisRIGHT == 0 && ISOfromTheBegin == true) { // restore cursor position when range released by user
// // sendPortToMain.send('fromTheBegin:false');    // will not start from the begin of the List
// // sendPortToMain.send('SETSTATE');
//     } else {} // end if
//     //
//     //////////////////////////////////////////////////////////////////// // range WAS all the way to the left and right (not set), and NOW it changed by user, then Stop:
//     if((OisLEFT==0 && ISOrangeStart?.round().remainder(ISOnTcolS!*2) != 0) || (OisRIGHT==0 && ISOrangeEnd?.round().remainder(ISOnTcolS!*4) != 0)) {
// // sendPortToMain.send('toggleIcnMsrBtn:true');
// // sendPortToMain.send('SETSTATE');
// // sendPortToMain.send('GETNOTIFIERREQUEST');
// // sendPortToMain.send('msrTgl:0');
// // sendPortToMain.send('SETNOTIFIERREQUEST');
// // sendPortToMain.send('GETNOTIFIERREQUEST');
// // sendPortToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
// // sendPortToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
// // sendPortToMain.send('SETSTATE');
//     }
//     else {}
//     ////////////////////////////////////////////////////////////////////
//     //
//     //
//     /////////////////////////////////////////////////////////////////////////////////////////
//     if (ISOtoggleIcnMsrBtn) {  // if measure button pressed by user
//       shouldChangeView = false;
//       if (ISOfromTheBegin) {
//         i = ISOiEnds - 1; // exit from cycle = release, stop
//         //break outerloop;  // was: i = ISOiEnds - 1;    // try to break outerloop by label
//         ISOstartBit         = 0;
//         ISOplayingBit       = 0;
//         ISOtableChangeCount = 1;
// // sendPortToMain.send('msrTgl:0');
// // sendPortToMain.send('tableChangeCount32:1');
// // sendPortToMain.send('tableChangeCount64:1');
// // sendPortToMain.send('tableChangeCount128:1');
// //  sendPortToMain.send('SETNOTIFIERREQUEST');
//       } else {
//         i = ISOiEnds - 1; // exit from cycle = release, stop
//         //break outerloop;  // was: i = ISOiEnds - 1;    // try to break outerloop by label
//         //                                               // So that there is no empty space at the cursor position after stopping:
//         ISOplayingBit       = maxLength;
// // sendPortToMain.send('SETNOTIFIERREQUEST');
//         //
//       } // end if (start from the begin)
// // sendPortToMain.send('toggleIcnMsrBtn:true');
// // sendPortToMain.send('oneTraversingInstanceLaunched:false');
// // sendPortToMain.send('SETSTATE');
// // sendPortToMain.send('GETNOTIFIERREQUEST');
// // sendPortToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
// // sendPortToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
// // sendPortToMain.send('SETSTATE');
//     } else {} // end exiting cycle (stop play), measure button pressed by user
//     /////////////////////////////////////////////////////////////////////////////////////////
//     ///////////////////////////////////////////////////////////////////////////////
//     // if range dynamically changed by user (rangeEnd became less than playingBit):
//     if ((iEndsTmp <= PBIT && (OisLEFT != 0 || OisRIGHT != 0))) {  // if range dynamically changed by user
//       i = ISOiEnds - 1;    // exit from cycle = release, stop
//       // break outerloop;  // was: i = ISOiEnds - 1;    // try to break outerloop by label
// // sendPortToMain.send('SETSTATE');
//     } else {} // end if
//     //////////////////////////////////////////////////////////////////////////////
//     //////////////////////////// Current Bit Traversal by "j", PlayingNotes ////////////////////////////////
//     for (int j = 1; j <= ISOnotesByBit; j++) {     // (j) is number of playing string at the moment, and  shortOrLong - is variant of note's length // <=   <=   <=  less or equal
//       if (ISOcsvLst[i][j] != "") {                 // for simple Lists Use "add" method!!          // ISOshortOrLongNum = 1 or 2 (Long|Short)  // You not to have to escape "asterisk", or "\" an "raw"
//         if (ISOcsvLst[i][j].toString().contains("*")) {
//           ISOshortOrLongNum = 2;
// // ISOjBtnRelease.add(j);
//         } else {} // note with (*) is a Short Note, sounds faster //LONG NOTES NOT WORKED BY THE REASON OF LIST.FROM data1, inherit changed it's parent!!! You not to have to escape symbol '\' or use a raw string
//  playSound(ISOselectedtuningNum, j, ISOshortOrLongNum, ISOnoteVolume, ISOextension);  // without Await, sounds from here !
//  developer.log(j.toString());
//         if(ISOmsrTgl == 0) {noteVolume = noteVolumeBack;} else {}   //restoring normal Vol    // to (ISOiEnds - 1) note will not hear    2 of 2
//         ISOshortOrLongNum = 1; // resetting to Long ones !!!
//         if((ISOcsvLst[i][j].toString().contains("i") && showFingeringOnButtons[j] == 0) || (ISOcsvLst[i][j].toString().contains("t") && showFingeringOnButtons[j] == 1)) {
//           showLocalFinger=true;    // if notation contains "index finger" and by default rule this string played not by Index
//         } else {
//           showLocalFinger=false;   // if notation contains "thumb finger" and by default rule this string played not by Thumb
//         } // end if, for show Locally Fingering   // As planned, local finger is shown ONLY if the default fingering rule is not followed
// // addButtonsStates(j, showLocalFinger);        // pressing the button
//       }  // will be hear async parallel simultaneously sounds notes by one bit and aftertones of previous bits notes
//     } // ind for (j)
//     //////////////////////////// End Current Bit Traversal by "j", PlayingNotes ////////////////////////////
// // var sw1 = Stopwatch()..start();
// //           while((ISOonTapCollisionPrevention_1 == 1 || ISOonTapCollisionPrevention_2 == 1 || ISOonTapCollisionPrevention_3 == 1)  && sw1.elapsedMilliseconds < 625)
// //           {
// //             // NO ENDLESS LOOP !!!  2 SECONDS
// //           }
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
//     //////////////////////// imitation of cancelable Delay: ///////////////// Eeach time calling function, because "crntSldrValT" may changed any time by user
//     // if(tempoCoeff<=1.8) { // Do cancelable delay:
//     //   // toDo: first pause of 3 (silence) before short-sounding notes buttons release:
//       for (int u = 0; u < 3; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=3; ISOcnslDelay1Ntfr=false;}} // end for
//     //   if (ISOjBtnRelease.isNotEmpty) {                                                                 // toDo: setState() N2
//     //     for (int k in ISOjBtnRelease){   // for simple Lists Use simple construction "in"
//     //       releaseButtonsStates(k);    // release shortly sounded notes buttons
//     //     } // end for (k)
//     //   } else {} // end if (ISOjBtnRelease.length)
//     //   ISOjBtnRelease.clear();  // the best way to clear List
//     //   // toDo: second pause of 3 (silence) before normal long-sounding notes buttons release:
//     //   for (int u = 0; u < 7; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=7; ISOcnslDelay1Ntfr=false;}} // end for
//     //   releaseButtonsStates(0);         // release All notes buttons                                // toDo: setState() N3
//     //   // toDo: third pause of 3 (silence) before starting next bit:
//     //   for (int u = 0; u < 5; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=5; ISOcnslDelay1Ntfr=false;}} // end for
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
//     //   releaseButtonsStates(0);         // release All notes buttons                                // toDo: setState() N3
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
//     //
//     //
//     //// Extra Delay (especially relevant: to Android - ONLY at App launch and first file load - it is accelerating, so, it needs to some slowDown):
//     //// toDo: There was a very significant smoothness, it's very good:
//     // if(stopwatch.elapsedMilliseconds < 100) {   // < 100 mS clean code execution time
//     //   for (int u = 0; u < 6; u++) {await Future.delayed(reCalculateMD());} // end for(u)
//     // } else {} //end if
//     //
//     //
//     ///////////////////////////////////////////// End Stopwatch 3 of 3 ////////////////////////////////////////////////
//     //await setDataSharedPref();   // CALL
// // sendPortToMain.send('setDataSharedPref');
// // developer.log(ISOtoggleIcnMsrBtn.toString());
//   } // end for (i)                                        // "oneTraversingInstanceLaunched" is a Double-start prevention
//   //await checkIfTCCareOutOfLimits();  // if previous session ends incorrectly or table change view ends incorrectly
// // sendPortToMain.send('checkIfTCCareOutOfLimits');
// // sendPortToMain.send('oneTraversingInstanceLaunched:false');  // after additional list traversal it could be "true", so setting it to "false" at the end
// // sendPortToMain.send('SETSTATE');
// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// }
//
