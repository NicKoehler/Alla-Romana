import 'package:flutter/material.dart';

class BaseTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  const BaseTile(
      {super.key, this.leading, this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            backgroundBlendMode: BlendMode.luminosity),
        child: ListTile(
          minLeadingWidth: 0,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          leading: leading ?? const SizedBox(),
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      ),
    );
  }
}
