import 'package:flutter/material.dart';
import 'package:alla_romana/components/rounded_expansion_tile.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final TextStyle? subtitleStyle;
  final List<Widget> children;
  final bool? open;

  const CustomCard(
      {Key? key,
      required this.title,
      required this.subtitleStyle,
      required this.children,
      this.open})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: RoundedExpansionTile(
          expanded: open,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          duration: const Duration(milliseconds: 200),
          title: Text(
            title,
            style: subtitleStyle,
          ),
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          selected: true,
          childrenPadding:
              const EdgeInsets.only(bottom: 15, right: 20, left: 20, top: 5),
          children: children),
    );
  }
}
