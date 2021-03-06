import 'package:flutter/material.dart';

class SpinnerText extends StatefulWidget {
  final String text;

  SpinnerText({
    this.text = '',
  });

  @override
  _SpinnerTextState createState() => _SpinnerTextState();
}

class _SpinnerTextState extends State<SpinnerText>
    with SingleTickerProviderStateMixin {
  String topText = '';
  String bottomText = '';
  AnimationController _spinTextAnimationController;
  Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();

    bottomText = widget.text;
    _spinTextAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 750,
        ))
      ..addListener(() => setState(() {}))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          // Switch back to where bottom text is visible and top text is off screen.
          // Always sliding down, never sliding up, so reset at the end.
          setState(() {
            bottomText = topText;
            topText = '';
            _spinTextAnimationController.value = 0.0;
          });
        }
      });

    _spinAnimation = new CurvedAnimation(
      parent: _spinTextAnimationController,
      curve: Curves.elasticInOut,
    );
  }

  @override
  void dispose() {
    _spinTextAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: new RectClipper(),
      child: new Stack(
        children: <Widget>[
          new FractionalTranslation(
            translation: new Offset(0.0, _spinAnimation.value - 1.0),
            child: new Text(
              topText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          new FractionalTranslation(
            translation: new Offset(0.0, _spinAnimation.value),
            child: new Text(
              bottomText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(SpinnerText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      // Need to spin new value down
      topText = widget.text;
      _spinTextAnimationController.forward();
    }
  }
}

class RectClipper extends CustomClipper<Rect> {

  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
