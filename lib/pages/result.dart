import 'dart:collection';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:alla_romana/l10n/s.dart';
import 'package:alla_romana/classes/pair.dart';
import 'package:alla_romana/classes/expenses.dart';
import 'package:alla_romana/components/custom_card.dart';
import 'package:alla_romana/components/euro_settings.dart';
import 'package:currency_formatter/currency_formatter.dart';

class ResultPage extends StatelessWidget {
  final List<Pair> data;
  const ResultPage({super.key, required this.data});

  static const SizedBox spacer = SizedBox(height: 20);

  Widget makeRow(
          String text, Decimal cost, TextStyle? style, BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: style,
          ),
          Text(
            CurrencyFormatter.format(
              cost,
              euroSettings,
              enforceDecimals: true,
            ),
            textAlign: TextAlign.end,
            style:
                style!.copyWith(color: Theme.of(context).colorScheme.primary),
          )
        ],
      );

  List<Widget> createResultDialog(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline3!.copyWith(
          fontWeight: FontWeight.bold,
        );

    final subtitleStyle = Theme.of(context).textTheme.headline5?.copyWith(
          color: titleStyle.color,
          fontWeight: FontWeight.bold,
        );

    final expenses = Expenses();
    expenses.addAll(data);

    Decimal total = expenses.people
        .map((p) => p.cost)
        .reduce((value, element) => value + element);

    int length = expenses.people.length;

    final oneUnit = (total / Decimal.fromInt(length))
        .toDecimal(scaleOnInfinitePrecision: 10);
    final headline = [
      makeRow(S.of(context)!.total, total, titleStyle, context),
      makeRow(S.of(context)!.costPerPerson(length), oneUnit, subtitleStyle,
          context),
      const Divider(
        height: 50,
      ),
    ];

    final costs = makeCustomCard(
      S.of(context)!.enteredCosts,
      S.of(context)!.spent,
      subtitleStyle,
      expenses.people,
      context,
    );

    final haveToPay = Queue<Pair>();
    final toBePayed = Queue<Pair>();

    for (var person in expenses.people) {
      Decimal amount = oneUnit - person.cost;
      if (amount == Decimal.zero) {
        continue;
      } else if (amount > Decimal.zero) {
        haveToPay.add(Pair(person.name, amount));
      } else {
        toBePayed.add(Pair(person.name, -amount));
      }
    }

    final payers = makeCustomCard(
      S.of(context)!.debitors,
      S.of(context)!.hasToPay,
      subtitleStyle,
      haveToPay,
      context,
    );

    final payed = makeCustomCard(
      S.of(context)!.creditors,
      S.of(context)!.shouldReceive,
      subtitleStyle,
      toBePayed,
      context,
    );

    final List<Widget> solutionChildren = [];

    Pair pagante = haveToPay.removeFirst();
    Pair daPagare = toBePayed.removeFirst();

    while (true) {
      if (pagante.cost > daPagare.cost) {
        solutionChildren.add(
          makeSolutionRow(pagante, daPagare, daPagare.cost, context),
        );
        pagante.cost -= daPagare.cost;
        if (toBePayed.isEmpty) {
          break;
        }
        daPagare = toBePayed.removeFirst();
      } else {
        solutionChildren.add(
          makeSolutionRow(pagante, daPagare, pagante.cost, context),
        );
        daPagare.cost -= pagante.cost;
        if (haveToPay.isEmpty) {
          break;
        }
        pagante = haveToPay.removeFirst();
      }
    }

    final solution = CustomCard(
      open: true,
      title: S.of(context)!.solution,
      subtitleStyle: subtitleStyle,
      children: solutionChildren,
    );

    final List<Widget> results = [
      ...headline,
      solution,
      costs,
      payers,
      payed,
    ];

    return results;
  }

  Row makeSolutionRow(
    Pair pagante,
    Pair daPagare,
    Decimal cost,
    BuildContext context,
  ) {
    return Row(
      children: [
        const Text("• "),
        Text(
          pagante.name,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        Text(" ${S.of(context)!.pay} "),
        Text(
          CurrencyFormatter.format(
            cost,
            euroSettings,
            enforceDecimals: true,
          ),
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        Text(
          " ${S.of(context)!.to(
                "aeiou".contains(
                  daPagare.name.characters.first.toLowerCase(),
                )
                    ? 1
                    : 0,
              )} ",
        ),
        Text(
          daPagare.name,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  CustomCard makeCustomCard(String title, String middleString,
      TextStyle? subtitleStyle, Iterable iterable, BuildContext context) {
    return CustomCard(
      title: title,
      subtitleStyle: subtitleStyle,
      children: iterable
          .map((person) => Row(
                children: [
                  const Text("• "),
                  Text(
                    person.name,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(" $middleString "),
                  Text(
                    CurrencyFormatter.format(
                      person.cost,
                      euroSettings,
                      enforceDecimals: true,
                    ),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        children: createResultDialog(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        label: Text(S.of(context)!.close),
        icon: const Icon(Icons.close_rounded),
      ),
    );
  }
}
