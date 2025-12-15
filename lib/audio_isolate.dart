import 'dart:developer' as developer;   //  usage:  developer.log(message.toString());
import 'dart:isolate';
import 'dart:async';
import '../constants/app_constants_nd_vars.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_data.dart';
// import 'audio_data.dart'; // visualMarks и krSnd
// ---------------------------------------------------------------- SOLUTION: Timer Should Be In The Second Isolate Without GUI
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
//
void playerIsolateEntryPoint (SendPort sendPortToMain) {
  final receivePortFromMain = ReceivePort();
  sendPortToMain.send(receivePortFromMain.sendPort);
  receivePortFromMain.listen((message) async {                                                     // async is Here
 //
 //
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
    if (message is List) {
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      ISOrangeStart         = message[0][0][0]['rangeStart'];                                      //  = = = = = = = = = = =  operator !!!
      ISOrangeEnd           = message[0][0][1]['rangeEnd'];                                        // It is the assignment operator that is required! It simulates an event listener
      ISOstartBit           = message[0][0][2]['startBit'];
      ISOplayingBit          = message[0][0][3]['playingBit'];
      ISOtableChangeCount    = message[0][0][4]['tableChangeCount'];
      ISOmsrTgl              = message[0][0][5]['msrTgl'];
      ISOtableChangeCount32  = message[0][0][6]['tableChangeCount32'];
      ISOtableChangeCount64  = message[0][0][7]['tableChangeCount64'];
      ISOtableChangeCount128 = message[0][0][8]['tableChangeCount128'];
      ISOisSwitched_32_64_128       = message[0][0][15]['listener_32_64_128'];
      ISOmode_3264_or_64128         = message[0][0][16]['listener_3264_64128'];
      ISOnTcolS                     = message[0][0][21]['nTcolS'];
      ISOonTapCollisionPrevention_1 = message[0][0][25]['onTapCollisionPrevention_1'];
      ISOonTapCollisionPrevention_2 = message[0][0][26]['onTapCollisionPrevention_2'];
      ISOonTapCollisionPrevention_3 = message[0][0][27]['onTapCollisionPrevention_3'];
      ISOiStarts          = message[1][0];
      ISOiEnds            = message[2][0]; //developer.log(ISOiEnds.toString());
      // ISOjBtnRelease      = message[3][0];
      ISOcsvLst           = message[4][0];
      ISOnotesByBit       = message[5][0];
      ISOrngExtend        = message[6][0];
      ISOtoggleIcnMsrBtn  = message[7][0];
      ISOfromTheBegin     = message[8][0];
      ISOshortOrLongNum   = message[9][0];
      ISOselectedtuningNum = message[10][0];
      ISOnoteVolume        = message[11][0];
      ISOextension         = message[12][0];
      ISOcnslDelay1Ntfr    = message[13][0];
      ISObuttonsNotifier   = message[14][0];
      //
      //
      //
      //
      void addButtonsStates(int btnNum, bool locFing) {                                        // See also SplayTreeMap (Sorted! HashMap), "Splay"!
        //if(stringsNum==21 && btnNum==21) { btnNum = 22;} else if(stringsNum==21 && btnNum==22)  { btnNum = 21;} else {}   // remember that in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string, but in csvLst does not changed
        if (btnNum==0)  {
          buttonsPS.clear();
          for (int i = 0; i < 24; i++) {        // to prevent Range error: max index is 23
            buttonsPS.add({'prsd' : false});    // List of unsorted HashMapS (no need to Sort, it's primitive!)
          } //end for
          buttonsPS.add({'fngr' : false});    // for Local showFingering              24th element
      sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
        } else if( (stringsNum==21 && btnNum != 21) || stringsNum==22 ) {             // in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string
          buttonsPS = ISObuttonsNotifier; // "..." !!! it is called "Spread operator"     // If you want to get previous values!
          buttonsPS[btnNum]['prsd'] = true;
          if (locFing==true) {buttonsPS[24]['fngr'] = true;} else {};
      sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
        } else {} // end if()
      } // end addButtonsStates()
      void releaseButtonsStates(int btnNum) {
        //if(stringsNum==21 && btnNum==21) { btnNum = 22;} else if(stringsNum==21 && btnNum==22)  { btnNum = 21;} else {}   // remember that in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string, but in csvLst does not changed
        buttonsPS = ISObuttonsNotifier; // "..." !!! it is called "Spread operator"
        if (btnNum==0)  {
          for (int i = 0; i < 24; i++) {
            buttonsPS[i]['prsd'] = false;
          } //end for
          buttonsPS[24]['fngr'] = false;
      sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
        } else if( (stringsNum==21 && btnNum != 21) || stringsNum==22 ) {             // in loadTagsFirst() data1[i][21] and  data1[i][22] were changed by place for 21-string
          buttonsPS[btnNum]['prsd'] = false;
          buttonsPS[24]['fngr'] = false;
      sendPortToMain.send('SETBUTTONSNOTIFIERREQUEST');  // here List attached to Notifier
        } else {} // end if()
      } // end releaseButtonsStates()
      //
      //
      changeTableView(i,iStarts,dontChangeView) {  //changes view Only in UP direction, by "i"
        sendPortToMain.send('onTapCollisionPrevention_1:' + 1.toString());
        sendPortToMain.send('SETNOTIFIERREQUEST');
        //**********************************************************************//  "Assembler-style" variables names:
        sendPortToMain.send('GETNOTIFIERREQUEST');
        var TCC128 = ISOtableChangeCount128!;
        var TCC064 = ISOtableChangeCount64!;
        var TCC032 = ISOtableChangeCount32!;
        var PBIT   = ISOplayingBit!;
        var TCC    = ISOtableChangeCount!;
        var SBIT   = ISOstartBit!;
        var OisLEFT =  ISOrangeStart?.round().remainder(ISOnTcolS!*2);  // Range slider left Handle at the Left position
        var OisRIGHT = ISOrangeEnd?.round().remainder(ISOnTcolS!*4);    // Range slider right Handle at the Right position
        var rSTART = ISOrangeStart!;
        var rEND = ISOrangeEnd!;
        var ALLCOL = ISOnTcolS!*2;
        var STARTr = rSTART?.round();
        //**********************************************************************//
        //
        if(ISOisSwitched_32_64_128! ==128) {
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
        } else if(ISOisSwitched_32_64_128! ==64) {
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
        } else if (ISOisSwitched_32_64_128!  == 32) {
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
        sendPortToMain.send('tableChangeCount128:' + TCC128.toString());
        sendPortToMain.send('tableChangeCount64:' + TCC064.toString());
        sendPortToMain.send('tableChangeCount32:' + TCC032.toString());
        sendPortToMain.send('playingBit:' + PBIT.toString());
        sendPortToMain.send('startBit:' + SBIT.toString());
        sendPortToMain.send('tableChangeCount:' + TCC.toString());
        sendPortToMain.send('rangeStart:' + rSTART.toString());
        sendPortToMain.send('rangeEnd:' + rEND.toString());
        ////////////////////////////
        sendPortToMain.send('SETNOTIFIERREQUEST');     // without setState()
        ////////////////////////////
//**********************************************************************//
//
        sendPortToMain.send('onTapCollisionPrevention_1:' + 0.toString());
        sendPortToMain.send('SETNOTIFIERREQUEST');
      } // end changeTableView()
//
//
//
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
/////////// TUNING MATCHING WITH THE LIST ROW NUMBER: ///////////
        if (tuning == 11) {tI_ =  3 - 1; aP_ = 'wavn/';} else {}   // two new sets of samples for Ionian (F) Major Phryg.(A) Lydian (Bb) MixLyd(C) Aeol(D) and Lydian (F) Aeol(A) Dor(D) tunings
        if (tuning == 12) {tI_ =  4 - 1; aP_ = 'wavn/';} else {}
        if (tuning == 14) {tI_ = 10 - 1; aP_ = 'wav/';} else {}   // ROW of krSnd minus One
        if (tuning == 15) {tI_ = 11 - 1; aP_ = 'wav/';} else {}
////////// END TUNING MATCHING WITH THE LIST ROW NUMBER /////////
        String kM_; // String as index (key) in hash table
        kM_ = krSnd[tI_][nI_][sOl_].toString();
        nT_ = aP_ + krSnd[tI_][nI_][sOl_] + '.' + xtsn_; // = ready path to the sound file
        switch (playerMode) {
          case 1:                                                 // build mode: android
            await player.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);  // Android Sounds fine From Here, Mode for each note: lowLatency ! But Memory Leak Windows! Multiple Endless list of Volume Regulators Linux!
            break;
          case 2:                                                 // build mode: Windows
          ///////////////////////////////// Prevention of Memory Leakage Win ////////////////////////////////
            if(audioPlayersMap.containsKey(kM_)) {} else {                // do nothing
              audioPlayersMap.addEntries({kM_ : AudioPlayer()}.entries);  // adding AudioPlayer for absolutely new note, .stop() method !!!
            } //end if
            audioPlayersMap[kM_]?.setVolume(nVol); await audioPlayersMap[kM_]?.stop(); await audioPlayersMap[kM_]?.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);
            ///////////////////////////////// End Prevent Memory Leak Win /////////////////////////////////////
            break;
          case 3:                                                 // dart midi, only Android and iOS, functions and package commented, not ready yet
          // midiPlay(60); // print('Playing ~ 60'); // toDo: correspondence table of midi notes (0...256) only Android, iOS
            break;
          case 4:                                                 // Web JavaScript via Tone.js, Sounds like web midi Synth without delay at all
          // playJS(60); // needed correspondence table // works fine  // DO Not Use setState()s !!!
          // await Future.delayed(Duration(milliseconds: ((mS + mS*(1.0-crntSldrValT))/tempoCoeff).round()));
          // playNoteJS('E4'); // native Web tonic JS, works perfect!
            dynamic keyTuning = visualMarks (tuning);
            var noteJS = keyTuning[number].values.elementAt(1).toString(); // toDo: split string (remove -15c, +5c etc.)
//playNoteJS(noteJS); // native Web tonic JS, works perfect!
            await Future.delayed(Duration(milliseconds: ((mS + mS*(1.0-crntSldrValT))/tempoCoeff).round()));
            // plaYm4a();
            break;
          case 5:                                                 // Web JavaScript via Tone.js, trying to play m4a via Tone.js
            dynamic keyTuning = visualMarks (tuning);
            var noteJS = keyTuning[number].values.elementAt(1).toString();
//plaYm4a(noteJS);
            await Future.delayed(Duration(milliseconds: ((mS + mS*(1.0-crntSldrValT))/tempoCoeff).round()));
            break;
          case 6:                                                 // Linux, maybe MacOs too?
          //player.audioCache.loadAsFile('$nT_');                 // works fine, Linux tested
            String tempCLinux = '0';
            String tempCLinux_toRelease = '0';
            // Prevention of endless Multiple instanses of Volume Regulators in Linux Sound Settings:
            //if(audioPlayersMapLinux.containsKey(ntTblNtfrsList[24]['counterPlayerLinux'].toString())) {} else {}                // do nothing
            tempCLinux = ntTblNtfrsList[24]['counterPlayerLinux'].toString();
            if(audioPlayersMapLinux.length < 7) {
              audioPlayersMapLinux.addEntries({tempCLinux : AudioPlayer()}.entries);  // adding AudioPlayer for absolutely new note, .stop() method !!!
            } else {
              if(ntTblNtfrsList[24]['counterPlayerLinux'] == 6 && audioPlayersMapLinux.length == 7) {       // LINUX SOLUTION IS a RELEASE()    NO Dispose()   !!!
                tempCLinux_toRelease = '0';
              } else if (ntTblNtfrsList[24]['counterPlayerLinux'] == 5 && audioPlayersMapLinux.length == 7) {       // seven elements are quite enough for the previous notes to sound out and the zero element could be filled again, and so on in a circle
                tempCLinux_toRelease = '6';
              } else if (ntTblNtfrsList[24]['counterPlayerLinux'] == 4 && audioPlayersMapLinux.length == 7) {
                tempCLinux_toRelease = '5';
              } else if (ntTblNtfrsList[24]['counterPlayerLinux'] == 3 && audioPlayersMapLinux.length == 7) {
                tempCLinux_toRelease = '4';
              } else if (ntTblNtfrsList[24]['counterPlayerLinux'] == 2 && audioPlayersMapLinux.length == 7) {
                tempCLinux_toRelease = '3';
              } else if (ntTblNtfrsList[24]['counterPlayerLinux'] == 1 && audioPlayersMapLinux.length == 7) {
                tempCLinux_toRelease = '2';
              } else if (ntTblNtfrsList[24]['counterPlayerLinux'] == 0 && audioPlayersMapLinux.length == 7) {
                tempCLinux_toRelease = '1';
              } else {}
            } //end if
            audioPlayersMapLinux[tempCLinux]?.setVolume(nVol);
            //await audioPlayersMapLinux[tempCLinux]?.stop(); await audioPlayersMapLinux[tempCLinux]?.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);
            await audioPlayersMapLinux[tempCLinux]?.stop(); await audioPlayersMapLinux[tempCLinux]?.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);
            if(audioPlayersMapLinux.length >= 7)  {
              await audioPlayersMapLinux[tempCLinux_toRelease]?.release();    // LINUX SOLUTION IS a RELEASE()    NOT Dispose()   !!!   Number of Volume Regulators Stops to grow!
              //await audioPlayersMapLinux[tempCLinux_toRelease]?.dispose();    // sound disappers after number of volume regulators overflow
            } else {}       // Linux Solution is DISPOSE()
            if(ntTblNtfrsList[24]['counterPlayerLinux']! < 6) {ntTblNtfrsList[24]['counterPlayerLinux'] = ntTblNtfrsList[24]['counterPlayerLinux']! + 1;} else {ntTblNtfrsList[24]['counterPlayerLinux'] = 0;}
            sendPortToMain.send('SETNOTIFIERREQUEST');
            // await player.dispose();     // NO DISPOSE! Linux added  RELEASE() to delete volume Regulators (Sliders). Sounds stops Linux when Number of volume Regulators Overfilled !!!
            // player.release();
            break;
          default:
            await player.play(AssetSource('$nT_'), mode: PlayerMode.lowLatency);  // Sounds From Here, Mode for each note: lowLatency ! But Memory Leak Windows!
            break;
        } //end switch (playerMode)
//
      } // end PlaySound ()
//
//
      //
      //
      //
      //
      //
        //**********************************************************************//
        var PBIT   = ISOplayingBit!;
        var TCC    = ISOtableChangeCount!;
        var OisLEFT =  ISOrangeStart?.round().remainder(ISOnTcolS!*2);  // Range slider left Handle at the Left position
        var OisRIGHT = ISOrangeEnd?.round().remainder(ISOnTcolS!*4);    // Range slider right Handle at the Right position
        var rSTART = ISOrangeStart!;
        var rEND = ISOrangeEnd!;
        //**********************************************************************//
      sendPortToMain.send('oneTraversingInstanceLaunched:true');            // prevention of double- or multi- starts
      sendPortToMain.send('showArrowMoveToTheLeft:false');                  // hide Arrow "Move Left"
      sendPortToMain.send('showVerticalBigLables:false');                   // hide
      sendPortToMain.send('SETSTATE');
        bool showLocalFinger = false;
        int iEndsTmp;                                             // for dynamical shortening or extending range by slider
        bool shouldChangeView = true;                             // to not increase TCC when stopped by user
        if(TCC == 1) {iEndsTmp = ((rEND)/2).round() + 0;} else {iEndsTmp = ((rEND)/2).round() + 0 + (TCC - 1) * (ISOnTcolS!*2);}
        //////////////////////////// Playback speed Slowdown correction using Stopwatch (part 1 of 3): /////////////////
        // Android: first ~3 measures after first file load - playback accelerates, then slows down,
        // Windows: in background - playback accelerates (when result of widget rebuild is not visible)
        // Conclusion: needs speed correction, SLOWDOWN (!), so used stopwatch steps 1-3:
        Stopwatch stopwatch;  // measure execution duration in between lines of code 1 of 2
        // print('Elapse Start: ${stopwatch.elapsed}'); // works fine
        ////////////////////////////////////////////////// End Stopwatch 1 of 2 ////////////////////////////////////////
        bool dontChangeView = true;     // don't change Current Page View with Current Numbers of Measures
      sendPortToMain.send('GETNOTIFIERREQUEST');
        ///////////////////////////////////     // toDo: issue: measure toggle
        // range Extends: if range was already set and now it extends by user using range slider
        if (ISOrngExtend == true) {
          PBIT = ISOiStarts;
      sendPortToMain.send('msrTgl:1');
      sendPortToMain.send('SETNOTIFIERREQUEST');
          ISOplayingBit = PBIT;
      sendPortToMain.send('GETNOTIFIERREQUEST');
      sendPortToMain.send('toggleIcnMsrBtn:false');
      sendPortToMain.send('SETSTATE');
        } else {}
        ///////////////////////////////////
        if (ISOiEnds > csvLst.length) {ISOiEnds = csvLst.length - 0;} else {} // end if toDo: (prevention of grey screen) when List Naturally Ended
        //print(ISOiEnds);print(wasTSVextDetected);
        //--------------------------------------- Main Cycle Loops Begin ---------------------------------------//
        outerloop:                // NOT Used    try to break for-loop by label and keyword "break outerloop;"   No very good idea!
        for (int i = ISOiStarts; i < ISOiEnds; i++) { // traversing a list from start to finish //"mS" could be changed at any time by Slider
          //
          var sw = Stopwatch()..start();
          while((ISOonTapCollisionPrevention_1 == 1 || ISOonTapCollisionPrevention_2 == 1 || ISOonTapCollisionPrevention_3 == 1)  && sw.elapsedMilliseconds < 625)
          {
            // NO ENDLESS LOOP !!!  2 SECONDS
          }
          //
      sendPortToMain.send('GETNOTIFIERREQUEST');
          TCC    = ISOtableChangeCount!;    // try to fix incorrect view change after bothTables onTap
          if(TCC == 1) {iEndsTmp = ((ISOrangeEnd!)/2).round() + 0;} else {iEndsTmp = ((ISOrangeEnd!)/2).round() + 0 + (TCC - 1) * (ISOnTcolS!*2);}  // use listenable value ISOrangeEnd!
          if((i==ISOiEnds-1) && OisLEFT == 0 && OisRIGHT == 0 && rSTART==0 && TCC > 1) {
       sendPortToMain.send('showArrowMoveToTheLeft:true');
       sendPortToMain.send('SETSTATE');
          } else {};      // show suggest to move to the left handle of the range slider to start from the beginning // fix rSTART==0  arrow Move Left appears at the middle Left Handle position
          ////////// Stopwatch (part 2 of 3)///////////
          stopwatch = Stopwatch()..start();
          stopwatch.reset();
          //print('Elapse Start: ${stopwatch.elapsed}');
          /////////// End Stopwatch (part 2 of 3)//////
          //
          /////////////// Animation of Cursor Move
          PBIT       = i;  // animation of cursor move
          ISOplayingBit = PBIT;
sendPortToMain.send('playingBit' + ISOplayingBit.toString());
          developer.log(ISOplayingBit.toString());
       sendPortToMain.send('SETNOTIFIERREQUEST');        // instead of previous value attach
          /////////////// End Animation of Cursor Move
          //
          //
          // if range slider became All the way to the left and All the way to the right, then:
          if (OisLEFT == 0 && OisRIGHT == 0 && fromTheBegin == true) { // restore cursor position when range released by user
       sendPortToMain.send('fromTheBegin:false');    // will not start from the begin of the List
       sendPortToMain.send('SETSTATE');
          } else {} // end if
          //
          //////////////////////////////////////////////////////////////////// // range WAS all the way to the left and right (not set), and NOW it changed by user, then Stop:
          if((OisLEFT==0 && ISOrangeStart?.round().remainder(ISOnTcolS!*2) != 0) || (OisRIGHT==0 && ISOrangeEnd?.round().remainder(ISOnTcolS!*4) != 0)) {
       sendPortToMain.send('toggleIcnMsrBtn:true');
       sendPortToMain.send('SETSTATE');
       sendPortToMain.send('GETNOTIFIERREQUEST');
       sendPortToMain.send('msrTgl:0');
       sendPortToMain.send('SETNOTIFIERREQUEST');
       sendPortToMain.send('GETNOTIFIERREQUEST');
       sendPortToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
       sendPortToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
       sendPortToMain.send('SETSTATE');
          }
          else {}
          ////////////////////////////////////////////////////////////////////
          //
          //
          /////////////////////////////////////////////////////////////////////////////////////////
          if (toggleIcnMsrBtn) {  // if measure button pressed by user
            shouldChangeView = false;
            if (fromTheBegin) {
              i = ISOiEnds - 1; // exit from cycle = release, stop
              //break outerloop;  // was: i = ISOiEnds - 1;    // try to break outerloop by label
              ntTblNtfrsList[2]['startBit']         = 0;
              ISOplayingBit       = 0;
        ISOtableChangeCount = 1;
        sendPortToMain.send('msrTgl:0');
        sendPortToMain.send('tableChangeCount32:1');
        sendPortToMain.send('tableChangeCount64:1');
        sendPortToMain.send('tableChangeCount128:1');
         sendPortToMain.send('SETNOTIFIERREQUEST');
            } else {
              i = ISOiEnds - 1; // exit from cycle = release, stop
              //break outerloop;  // was: i = ISOiEnds - 1;    // try to break outerloop by label
              //                                               // So that there is no empty space at the cursor position after stopping:
              ISOplayingBit       = maxLength;
         sendPortToMain.send('SETNOTIFIERREQUEST');
              //
            } // end if (start from the begin)
        sendPortToMain.send('toggleIcnMsrBtn:true');
        sendPortToMain.send('oneTraversingInstanceLaunched:false');
        sendPortToMain.send('SETSTATE');
        sendPortToMain.send('GETNOTIFIERREQUEST');
        sendPortToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
        sendPortToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
        sendPortToMain.send('SETSTATE');
          } else {} // end exiting cycle (stop play), measure button pressed by user
          /////////////////////////////////////////////////////////////////////////////////////////
          ///////////////////////////////////////////////////////////////////////////////
          // if range dynamically changed by user (rangeEnd became less than playingBit):
          if ((iEndsTmp <= PBIT && (OisLEFT != 0 || OisRIGHT != 0))) {  // if range dynamically changed by user
            i = ISOiEnds - 1;    // exit from cycle = release, stop
            // break outerloop;  // was: i = ISOiEnds - 1;    // try to break outerloop by label
        sendPortToMain.send('SETSTATE');
          } else {} // end if
          //////////////////////////////////////////////////////////////////////////////
          //////////////////////////// Current Bit Traversal by "j", PlayingNotes ////////////////////////////////
          for (int j = 1; j <= ISOnotesByBit; j++) {     // (j) is number of playing string at the moment, and  shortOrLong - is variant of note's length // <=   <=   <=  less or equal
            if (csvLst[i][j] != "") {                 // for simple Lists Use "add" method!!          // ISOshortOrLongNum = 1 or 2 (Long|Short)  // You not to have to escape "asterisk", or "\" an "raw"
              if (csvLst[i][j].toString().contains("*")) {ISOshortOrLongNum = 2; ISOjBtnRelease.add(j);} else {} // note with (*) is a Short Note, sounds faster //LONG NOTES NOT WORKED BY THE REASON OF LIST.FROM data1, inherit changed it's parent!!! You not to have to escape symbol '\' or use a raw string
              if(ntTblNtfrsList[5]['msrTgl'] == 0) {noteVolumeBack = noteVolume; noteVolume = 0.0;} else {}           // to (ISOiEnds - 1) note will not hear    1 of 2
              playSound(ISOselectedtuningNum, j, ISOshortOrLongNum, ISOnoteVolume, ISOextension);  // sounds from here !
              if(ntTblNtfrsList[5]['msrTgl'] == 0) {noteVolume = noteVolumeBack;} else {}   //restoring normal Vol    // to (ISOiEnds - 1) note will not hear    2 of 2
              ISOshortOrLongNum = 1; // resetting to Long ones !!!
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
          while((ISOonTapCollisionPrevention_1 == 1 || ISOonTapCollisionPrevention_2 == 1 || ISOonTapCollisionPrevention_3 == 1)  && sw1.elapsedMilliseconds < 625)
          {
            // NO ENDLESS LOOP !!!  2 SECONDS
          }
      sendPortToMain.send('GETNOTIFIERREQUEST');
          if(ISOonTapCollisionPrevention_1 == 0 && ISOonTapCollisionPrevention_2 == 0 && ISOonTapCollisionPrevention_3 == 0) {
            if (shouldChangeView == true) {
              await changeTableView(i, ISOiStarts, dontChangeView);  // await added!
            } else {} // instead of 256 "ISOnTcolS!" replace to  "ntTblNtfrsList[21]['ISOnTcolS!']" . It seems impossible!
          } else {} //  end onTap collision prevention
          //
          //
          if(OisLEFT == 0 && OisRIGHT == 0 && rSTART?.round() != 2*ISOnTcolS!) {
            ISOiEnds = maxLength;
            // if TSV, prevention of ISOiEnds range error at the end of playback (2 of 2):
            if(wasTSVextDetected==true || googleCSVdetected==true) { // ??? TSV needs minus one element at the end (this is the difference from CSV):
              ISOiEnds = csvLst.length - 0;
            } else {
            } //end if TSV was detected
          } else {}; //end if
          if((i+1).remainder(ISOnTcolS!*2) == 0) {dontChangeView = false;} else {} //end if // don't change table view after manually toggle button play
          /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          ///////////////////////------End Change table View------////////////////////////
          //
          //////////////////////// imitation of cancelable Delay: ///////////////// Eeach time calling function, because "crntSldrValT" may changed any time by user
          if(tempoCoeff<=1.8) { // Do cancelable delay:
            // toDo: first pause of 3 (silence) before short-sounding notes buttons release:
            for (int u = 0; u < 3; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=3; ISOcnslDelay1Ntfr=false;}} // end for
            if (ISOjBtnRelease.isNotEmpty) {                                                                 // toDo: setState() N2
              for (int k in ISOjBtnRelease){   // for simple Lists Use simple construction "in"
                releaseButtonsStates(k);    // release shortly sounded notes buttons
              } // end for (k)
            } else {} // end if (ISOjBtnRelease.length)
            ISOjBtnRelease.clear();  // the best way to clear List
            // toDo: second pause of 3 (silence) before normal long-sounding notes buttons release:
            for (int u = 0; u < 7; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=7; ISOcnslDelay1Ntfr=false;}} // end for
            releaseButtonsStates(0);         // release All notes buttons                                // toDo: setState() N3
            // toDo: third pause of 3 (silence) before starting next bit:
            for (int u = 0; u < 5; u++) {await Future.delayed(reCalculateMD());if(ISOcnslDelay1Ntfr==true){u=5; ISOcnslDelay1Ntfr=false;}} // end for
          } else {      // too high table visualisation speed, NO cancelable delay:
            // toDo: first pause of 3 (silence) before short-sounding notes buttons release:
            await Future.delayed(reCalculateMD2());
            if (ISOjBtnRelease.isNotEmpty) {                                                                 // toDo: setState() N2
              for (int k in ISOjBtnRelease){   // for simple Lists Use simple construction "in"
                releaseButtonsStates(k);    // release shortly sounded notes buttons
              } // end for (k)
            } else {} // end if (ISOjBtnRelease.length)
            ISOjBtnRelease.clear();  // the best way to clear List
            // toDo: second pause of 3 (silence) before normal long-sounding notes buttons release:
            await Future.delayed(reCalculateMD2());
            releaseButtonsStates(0);         // release All notes buttons                                // toDo: setState() N3
            // toDo: third pause of 3 (silence) before starting next bit:
            await Future.delayed(reCalculateMD2());
          } //end if additional tempo coeff > 1
          ////////////////////// End imitation of cancelable Delay//////////////////                            // toDo: setState() N4
          //
          ////////////////////// Completion naturally //////////////////////
          if (i == ISOiEnds - 1) {      // completion naturally upon reaching ISOiEnds OR at the end of the List
            shouldChangeView = false;
            // print('ends naturally');
        sendPortToMain.send('GETNOTIFIERREQUEST');
            if(fromTheBegin) {
              ntTblNtfrsList[2]['startBit']         = 0;
              ISOplayingBit       = 0;
              ISOtableChangeCount = 1;
        sendPortToMain.send('msrTgl:0');
        sendPortToMain.send('tableChangeCount32:1');
        sendPortToMain.send('tableChangeCount64:1');
        sendPortToMain.send('tableChangeCount128:1');
            } else {                          // completion naturally at the end of the selected Range
        sendPortToMain.send('msrTgl:0');
              //                           // So that there is no empty space at the cursor position after stopping:
              ISOplayingBit       = maxLength;
        sendPortToMain.send('SETNOTIFIERREQUEST');
              //
            } //end if(start from the begin)
        sendPortToMain.send('toggleIcnMsrBtn:true');
        sendPortToMain.send('oneTraversingInstanceLaunched:false');
        sendPortToMain.send('SETSTATE');
        sendPortToMain.send('SETNOTIFIERREQUEST');
        sendPortToMain.send('GETNOTIFIERREQUEST');
        sendPortToMain.send('isSwitched_32_64_128:' + ISOisSwitched_32_64_128.toString());
        sendPortToMain.send('mode_3264_or_64128:' + ISOmode_3264_or_64128.toString());
        sendPortToMain.send('SETSTATE');
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
        //await setDataSharedPref();   // CALL
      sendPortToMain.send('setDataSharedPref');
        } // end for (i)                                        // "oneTraversingInstanceLaunched" is a Double-start prevention
        //await checkIfTCCareOutOfLimits();  // if previous session ends incorrectly or table change view ends incorrectly
      sendPortToMain.send('checkIfTCCareOutOfLimits');
      sendPortToMain.send('oneTraversingInstanceLaunched:false');  // after additional list traversal it could be "true", so setting it to "false" at the end
      sendPortToMain.send('SETSTATE');
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
  });
} //end IsolateEntryPoint
//
//
