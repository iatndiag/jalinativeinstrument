import 'dart:ui';
import 'package:flutter/material.dart';
//
//
void main() {
  runApp(MaterialApp(home: Jaliinstrument(),),);    }
//
class Jaliinstrument extends StatefulWidget{
//
  Jaliinstrument();
//
  @override
  State<StatefulWidget> createState() {
    return JaliinstrumentState();
  }
}
//                    //toDo: ... State ... extends !!! With ...    !!! for AnimationController (part 0a)
class JaliinstrumentState extends State<Jaliinstrument> with SingleTickerProviderStateMixin {
//                                            // mix in with Single_Ticker_Provider_State !
  late AnimationController _controller; late Animation _animation;  late Path _path;  //for AnimationController (part 0b)
//
///////////////////////////////////////////////////////////////////////////////////////////  toDo: try to make it Without SetState() !!! try to make it Without SetState() !!!
  @override
  void initState() {
    //------------------------- AnimationController First Part (of 3) in initState--------//
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 5000));              // total travel time, mS
    super.initState();  _animation = Tween(begin: 0.0,end: 1.0).animate(_controller)..addListener((){   // 0.5 starts from half ot path, 1.0 path ends
        setState(() {     }); //end setState
    }); // end add Listener
    _controller.forward();  _path  = drawPath();
    //----------------------------------------- End 1 ------------------------------------//
  } // end initState()
//
//////////////////////////////////////////////////////////////////////////////////////////
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        child:       Stack( // allows us to Stack some elements on Top of Others (for AnimationController)
          children: <Widget>[
            Positioned( // the Lowest element on the stack   (for AnimationController)
              width: 800, // Should have dimensions !!! Otherwise - blank screen !!!
              height: 800,
              child: Container(
                color: Colors.blueGrey,
                child: Row(),
              ),
              //color: Colors.blueGrey,
            ),
            Positioned( // Path is Above previous element (main content or table)  (for AnimationController)
              top: 0,
//
              child: CustomPaint(painter: PathPainter(_path),),
//
            ),
            Positioned( // Positioned element is Above previous element Path   (for AnimationController)
//          // automatic (do not change):
              top: calculate(_animation.value)?.dy, left: calculate(_animation.value)?.dx,  // auto calculated positioning
//
              child: Container(
//          // Geometrical Form of the Moving Object  (for AnimationController):
                //decoration: BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.circular(10)),  width: 10,  height: 10, // form: circle
                decoration: BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.circular(1)),  width: 5,  height: 100,  // form: rectangle
//
              ),
            ),
          ],
        ),
      ),
    );
  } // end Widget Build
//
//////////////////////////////// AnimationController Second Block //////////////////
  @override // follow the Widget Build ends, still inside Class Extends ... State
  void dispose() {  _controller.dispose();  super.dispose();  } //AnimationController dispose
//
  Path drawPath(){  // movable element by AnimationController (along the Path)
    Size size = Size(600,600);  //  width, height (double)
    Path path = Path();
    //path.moveTo(0, size.height / 2); // starts from x=0, y=height/2 (from Upper Left Corner)
    path.moveTo(0, 250); // (from 0,0 Upper Left Corner)
    //path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height / 2); // Bezier Curve
    path.lineTo(500, 250);
    return path;
  } // end drawPath()
//
  Offset? calculate(value) {  // calculate movable element position by AnimationController
    PathMetrics pathMetrics = _path.computeMetrics(); PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;  Tangent? pos = pathMetric.getTangentForOffset(value); return pos?.position;
  } //end calculate (for AnimationController)
/////////////////////////////////////////End 2//////////////////////////////////////
//
}  // end Class Extends ... State toDo: Class Extends ... State - ends here !
//
//////////////////////////////// AnimationController Third Block //////////////////
// follows the Class Extends ... State, it's a New Class
class PathPainter extends CustomPainter {   // Сlass for drawing a moving element and its path
//
  Path path;                // Path to move element
  PathPainter(this.path);   // Drawing the path's Curve or Line
//
  @override
  void paint(Canvas canvas, Size size) {  // Drawing on Canvas with specific Size
    Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3) // Path's Color and Opacity
      ..style = PaintingStyle.stroke      // Curve or Line Style
      ..strokeWidth = 3.0;                // Width of the Path Curve or Line Width
    //canvas.drawPath(this.path, paint);    // Drawing the Path with the specified parameters (Comment it do Hide the Path)
  } // end void Paint()
//
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;  // Should be So
} // end separate Class PathPainter (follows the Class Extends ...)
/////////////////////////////////////////End 3//////////////////////////////////////
