import 'package:flutter/material.dart';

class PlayerButton extends StatefulWidget {
  final double size;
  final String iconPath;
  final VoidCallback onPressed;
  final Color backgrounColor, iconColor;
  final bool circle;
  final Widget? customIcon;

  const PlayerButton({
    Key? key,
    this.size = 40,
    required this.iconPath,
    required this.onPressed,
    this.circle = true,
    this.backgrounColor = Colors.white54,
    this.iconColor = Colors.black,
    this.customIcon,
  }) : super(key: key);

  @override
  State<PlayerButton> createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        radius: 32,
        splashColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32),
        onHover: (isHovered) {
          setState(() {
            _isHovered = isHovered;
          });
        },
        child: widget.customIcon ??
            Container(
              padding: EdgeInsets.all(widget.size * 0.5),
              decoration: BoxDecoration(
                color: _isHovered
                    ? Colors.grey.withOpacity(0.2)
                    : widget.backgrounColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                widget.iconPath,
                color: widget.iconColor,
                width: widget.size*0.7,
                height: widget.size*0.7,
                package: 'flutter_meedu_videoplayer',
              ),
            ),
      ),
    );
  }
}
