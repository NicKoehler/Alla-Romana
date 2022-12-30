import 'package:flutter/material.dart';
import 'package:alla_romana/classes/pair.dart';
import 'package:alla_romana/components/base_tile.dart';
import 'package:alla_romana/components/euro_settings.dart';
import 'package:currency_formatter/currency_formatter.dart';

class CustomTile extends StatelessWidget {
  final Pair data;
  final Animation<double> animation;
  final void Function()? removeFunction;
  final void Function()? editFunction;
  const CustomTile(
      {super.key,
      required this.data,
      required this.animation,
      required this.removeFunction,
      required this.editFunction});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.background,
          ),
          child: BaseTile(
            leading: IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: editFunction,
            ),
            title: Text(data.name),
            subtitle: Text(
              CurrencyFormatter.format(
                data.cost,
                euroSettings,
                enforceDecimals: true,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: removeFunction,
            ),
          ),
        ),
      ),
    );
  }
}
