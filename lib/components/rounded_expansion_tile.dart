import 'package:flutter/material.dart';

class RoundedExpansionTile extends StatefulWidget {
  final bool? autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;
  final bool? enabled;
  final bool? enableFeedback;
  final Color? focusColor;
  final FocusNode? focusNode;
  final double? horizontalTitleGap;
  final Color? hoverColor;
  final bool? isThreeLine;
  final Widget? leading;
  final double? minLeadingWidth;
  final double? minVerticalPadding;
  final MouseCursor? mouseCursor;
  final void Function()? onLongPress;
  final bool? selected;
  final Color? selectedTileColor;
  final ShapeBorder? shape;
  final Widget? subtitle;
  final Widget? title;
  final Color? tileColor;
  final Widget? trailing;
  final VisualDensity? visualDensity;
  final void Function()? onTap;
  final Duration? duration;
  final List<Widget>? children;
  final Curve? curve;
  final EdgeInsets? childrenPadding;
  final bool? rotateTrailing;
  final bool? noTrailing;
  final bool? expanded;

  const RoundedExpansionTile(
      {super.key,
      this.title,
      this.subtitle,
      this.leading,
      this.trailing,
      this.duration,
      this.children,
      this.autofocus,
      this.contentPadding,
      this.dense,
      this.enabled,
      this.enableFeedback,
      this.focusColor,
      this.focusNode,
      this.horizontalTitleGap,
      this.hoverColor,
      this.isThreeLine,
      this.minLeadingWidth,
      this.minVerticalPadding,
      this.mouseCursor,
      this.onLongPress,
      this.selected,
      this.selectedTileColor,
      this.shape,
      this.tileColor,
      this.visualDensity,
      this.onTap,
      this.curve,
      this.childrenPadding,
      this.rotateTrailing,
      this.noTrailing,
      this.expanded});

  @override
  RoundedExpansionTileState createState() => RoundedExpansionTileState();
}

class RoundedExpansionTileState extends State<RoundedExpansionTile>
    with TickerProviderStateMixin {
  late bool _expanded;
  bool? _rotateTrailing;
  bool? _noTrailing;
  late AnimationController _controller;
  late AnimationController _iconController;

  Duration defaultDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded ?? false;
    _rotateTrailing = widget.rotateTrailing ?? true;
    _noTrailing = widget.noTrailing ?? false;
    _controller = AnimationController(
        vsync: this, duration: widget.duration ?? defaultDuration);

    _iconController = AnimationController(
      duration: widget.duration ?? defaultDuration,
      vsync: this,
    );

    if (!_expanded) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _iconController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // If bool is not provided the default will be false.
            autofocus: widget.autofocus == null ? false : widget.autofocus!,
            contentPadding: widget.contentPadding,
            // If bool is not provided the default will be false.
            dense: widget.dense ?? false,
            // If bool is not provided the default will be true.
            enabled: widget.enabled == null ? true : widget.enabled!,
            enableFeedback:
                // If bool is not provided the default will be false.
                widget.enableFeedback ?? false,
            focusColor: widget.focusColor,
            focusNode: widget.focusNode,
            horizontalTitleGap: widget.horizontalTitleGap,
            hoverColor: widget.hoverColor,
            // If bool is not provided the default will be false.
            isThreeLine:
                widget.isThreeLine == null ? false : widget.isThreeLine!,
            key: widget.key,
            leading: widget.leading,
            minLeadingWidth: widget.minLeadingWidth,
            minVerticalPadding: widget.minVerticalPadding,
            mouseCursor: widget.mouseCursor,
            onLongPress: widget.onLongPress,
            // If bool is not provided the default will be false.
            selected: widget.selected == null ? false : widget.selected!,
            selectedTileColor: widget.selectedTileColor,
            shape: widget.shape,
            subtitle: widget.subtitle,
            title: widget.title,
            tileColor: widget.tileColor,
            trailing: _noTrailing! ? null : _trailingIcon(),
            visualDensity: widget.visualDensity,
            onTap: () {
              if (widget.onTap != null) {
                /// Developers who uses this package can add custom functionality when tapped.
                ///
                /// When a developer defines an extra option on tap, this will be executed. If not provided this step will be skipped.
                /// ignore: unnecessary_statements
                widget.onTap;
              }
              setState(() {
                // Checks if the ListTile is expanded and sets state accordingly.
                if (_expanded) {
                  _expanded = !_expanded;
                  _controller.forward();
                  _iconController.reverse();
                } else {
                  _expanded = !_expanded;
                  _controller.reverse();
                  _iconController.forward();
                }
              });
            },
          ),
          AnimatedCrossFade(
              firstCurve: widget.curve == null
                  ? Curves.fastLinearToSlowEaseIn
                  : widget.curve!,
              secondCurve: widget.curve == null
                  ? Curves.fastLinearToSlowEaseIn
                  : widget.curve!,
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration:
                  widget.duration == null ? defaultDuration : widget.duration!,
              firstChild:

                  /// Returns Listviews for the children.
                  ///
                  /// ClampingScrollPhyiscs so the ListTile will scroll in the main screen and not its children.
                  /// Shrinkwrap is always true so the ExpansionTile will wrap its children and hide when not expanded.
                  ListView(
                physics: const ClampingScrollPhysics(),
                padding: widget.childrenPadding,
                shrinkWrap: true,
                children: widget.children!,
              ),
              // If not expanded just returns an empty containter so the ExpansionTile will only show the ListTile.
              secondChild: Container()),
        ]);
  }

  // Build trailing widget based on the user input.
  Widget? _trailingIcon() {
    if (widget.trailing != null) {
      if (_rotateTrailing!) {
        return RotationTransition(
            turns: Tween(begin: 0.0, end: 0.5).animate(_iconController),
            child: widget.trailing);
      } else {
        // If developer sets rotateTrailing to false the widget will just be returned.
        return widget.trailing;
      }
    } else {
      // Default trailing is an Animated Menu Icon.
      return AnimatedIcon(
          icon: AnimatedIcons.close_menu, progress: _controller);
    }
  }
}
