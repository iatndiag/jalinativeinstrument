//
import 'package:flutter/material.dart';
import 'dart:math' as math;
class AppColors {                                           // Change Colors for gradient Drop-Down Menu
  static const Color gradientStart = Color(0xfffdf3d9);
  static const Color gradientEnd = Color(0xfff1b77b);
  static const Color textColor = Color(0xffdcb499);

  static const bgGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [gradientStart, gradientEnd],
      transform: GradientRotation(math.pi / 4),
      stops: [0.3, 1]);
}

class DropdownTuningBox extends StatefulWidget {
  final String tuningFromDropDown;
  ValueSetter<String> callBack;

  DropdownTuningBox(this.tuningFromDropDown, {Key? key, required this.callBack})
      : super(key: key);

  @override
  _DropdownTuningBoxState createState() => _DropdownTuningBoxState();
}

class _DropdownTuningBoxState extends State<DropdownTuningBox> {
  GlobalKey? actionKey;
  double height = 0, width = 0, xPosition = 0, yPosition = 0;
  bool isDropdownOpened = false;
  OverlayEntry? floatingDropdown;

  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.tuningFromDropDown);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        key: actionKey,
        onTap: () {
          setState(() {
            if (isDropdownOpened) {
              floatingDropdown?.remove();
            } else {
              findDropdownPosition();
              floatingDropdown = _createFloatingDropdown();
              Overlay.of(context)?.insert(floatingDropdown!);
            }
            isDropdownOpened = !isDropdownOpened;
          });
        },
        child: _createHeader());
  }

  void findDropdownPosition() {

    var size = MediaQuery.of(context).size;
    double YposUPshift  = size.height * 0.30;  //for example 0.3 is 30% UpShift along the Y axis (Change it Here!)

    RenderBox? renderBox =
    actionKey?.currentContext?.findRenderObject() as RenderBox?;
    height = renderBox?.size.height ?? 0;
    width = renderBox?.size.width ?? 0;
    Offset? offset = renderBox?.localToGlobal(Offset.zero);
    xPosition = offset?.dx ?? 0;
    // yPosition = offset?.dy ?? 0;           // default Y-position: directly below the drop down menu bar
    // yPosition = offset!.dy - 300 ?? 0;     // variant of Y-offset 300px UP !
       yPosition = offset!.dy - YposUPshift ?? 0;  // depending media query height
  }

  OverlayEntry _createFloatingDropdown() {

    var size = MediaQuery.of(context).size;
    //double width28  = size.width * 0.28;      // width is changing here!!!
      double width28  = size.width * 0.21;      // width is changing here!!!

    return OverlayEntry(builder: (context) {
      return Stack(
        children: [
          //For tap outside overlay to dismiss
          Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  floatingDropdown?.remove();
                  isDropdownOpened = !isDropdownOpened;
                },
                child: Container(
                  color: Colors.transparent,
                ),
              )),
          //position of Overlay
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: yPosition + height,
            child: Container(
              margin:
              MediaQuery.of(context).size.width < 700 ?
              const EdgeInsets.symmetric(horizontal: 76)    // margins from the edges Mobile sets here (width)
              :
              new EdgeInsets.symmetric(horizontal: width28),  // margins from the edges Laptop sets here (width); new, not const (!)
              child: DropDown(
                itemHeight: height,
                selectedItem: widget.tuningFromDropDown,
                callBack: (value) => {hideDropdown(), widget.callBack(value)},
              ),
            ),
          ),
        ],
      );
    });
  }

  void hideDropdown() {
    floatingDropdown?.remove();
    isDropdownOpened = !isDropdownOpened;
  }

  Widget _createHeader() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 0.1,
                offset: const Offset(0, 0.1)),
          ],
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Text(
            widget.tuningFromDropDown,
            style: const TextStyle(color: Colors.orange, fontSize: 15, fontWeight: FontWeight.w400,  fontStyle: FontStyle.italic),  // Text color (Menu not expanded Yet)
            //overflow: TextOverflow.fade,    // fade if it does not fit in width
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
          const Spacer(),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;
  final String selectedItem;
  ValueSetter<String> callBack;
  ////////////////////////////////////////// DropDown Menu, part 2 of 3//////////////////////////////////////////
  ///////////////////////// For Full or/ simplified Web variant Use all nine or / Only Two Scales: //////////////
  ////////////////// Default: /////////////////
  List<String> droptuningFromDropDownData = <String>[
    'Aeolian',
    'Hardino',
    'Ionian',
    'Lydian',
    'Phrygian',
    'Sauta',
    'Silaba (extreme)',
    'Silaba or Tomora ba',
    'Tomora Mesengo',
    '---',
    'Ionian (Malian kora)',
    'Lydian (Malian kora)',
  ];
/////////////////// Web Only: /////////////////
/*
  List<String> droptuningFromDropDownData = <String>[
    'Ionian',
    'Lydian',
  ];
 */
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////// End DropDown Menu, part 2 of 3//////////////////////////////////////////
  DropDown(
      {Key? key,
        required this.itemHeight,
        required this.selectedItem,
        required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /////////////////Menu DropDown Column Widget////////////////
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        Material(
          color: Colors.transparent,
          child: Container(
            height: droptuningFromDropDownData.length * itemHeight + 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 0.1,
                    offset: const Offset(0, 0.1)),
              ],
            ),
            child: Column(
              children: <Widget>[
                ////////////////////////////////////////// DropDown Menu, part 3 of 3//////////////////////////////////////////
                DropDownItem(
                    text: droptuningFromDropDownData[0],
                    isSelected: selectedItem == droptuningFromDropDownData[0],
                    callBack: callBack,
                    isFirstItem: true),
                DropDownItem(
                  text: droptuningFromDropDownData[1],
                  isSelected: selectedItem == droptuningFromDropDownData[1],
                  callBack: callBack,
                ),
                DropDownItem(
                  text: droptuningFromDropDownData[2],
                  isSelected: selectedItem == droptuningFromDropDownData[2],
                  callBack: callBack,
                ),
                DropDownItem(
                  text: droptuningFromDropDownData[3],
                  isSelected: selectedItem == droptuningFromDropDownData[3],
                  callBack: callBack,
                ),
                DropDownItem(
                    text: droptuningFromDropDownData[4],
                    isSelected: selectedItem == droptuningFromDropDownData[4],
                    callBack: callBack,
                    isLastItem: true),
                DropDownItem(
                    text: droptuningFromDropDownData[5],
                    isSelected: selectedItem == droptuningFromDropDownData[5],
                    callBack: callBack,
                    isLastItem: true),
                DropDownItem(
                    text: droptuningFromDropDownData[6],
                    isSelected: selectedItem == droptuningFromDropDownData[6],
                    callBack: callBack,
                    isLastItem: true),
                DropDownItem(
                    text: droptuningFromDropDownData[7],
                    isSelected: selectedItem == droptuningFromDropDownData[7],
                    callBack: callBack,
                    isLastItem: true),
                DropDownItem(
                    text: droptuningFromDropDownData[8],
                    isSelected: selectedItem == droptuningFromDropDownData[8],
                    callBack: callBack,
                    isLastItem: true),
//
                DropDownItem(
                    text: droptuningFromDropDownData[9],
                    isSelected: selectedItem == droptuningFromDropDownData[9],
                    callBack: callBack,
                    isLastItem: true),
                DropDownItem(
                    text: droptuningFromDropDownData[10],
                    isSelected: selectedItem == droptuningFromDropDownData[10],
                    callBack: callBack,
                    isLastItem: true),
                DropDownItem(
                    text: droptuningFromDropDownData[11],
                    isSelected: selectedItem == droptuningFromDropDownData[11],
                    callBack: callBack,
                    isLastItem: true),
//
                /////////////////////////////////////// End DropDown Menu, part 3 of 3//////////////////////////////////////////
              ],
            ),
          ),
        ),
      ],
    );
    /////////////////End Menu DropDown Column Widget////////////
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;
  ValueSetter<String> callBack;

  DropDownItem(
      {required this.text,
        this.isSelected = false,
        this.isFirstItem = false,
        this.isLastItem = false,
        required this.callBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //return value
        callBack(text);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          gradient: isSelected
              ? AppColors.bgGradient
              : const LinearGradient(colors: [Colors.white, Colors.white]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textColor,             // Text color if item SELECTED
                fontSize: 14),
            //overflow: TextOverflow.fade,    // fade if it does not fit in width
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}