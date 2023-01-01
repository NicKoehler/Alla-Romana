import 'dart:collection';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:alla_romana/l10n/s.dart';
import 'package:alla_romana/classes/pair.dart';
import 'package:alla_romana/classes/expenses.dart';
import 'package:alla_romana/components/custom_card.dart';
import 'package:alla_romana/components/euro_settings.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:appinio_social_share/appinio_social_share.dart';

class ResultPage extends StatelessWidget {
  final List<Pair> data;
  static const SizedBox spacer = SizedBox(height: 20);
  final AppinioSocialShare _appinioSocialShare = AppinioSocialShare();
  final List<String> _solutionText = [];

  ResultPage({super.key, required this.data});

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

    final subtitleStyle = Theme.of(context).textTheme.headline5!.copyWith(
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

    final listCosts = makeCustomCard(
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

    final listPayers = makeCustomCard(
      S.of(context)!.debitors,
      S.of(context)!.hasToPay,
      subtitleStyle,
      haveToPay,
      context,
    );

    final listPayed = makeCustomCard(
      S.of(context)!.creditors,
      S.of(context)!.shouldReceive,
      subtitleStyle,
      toBePayed,
      context,
    );

    final List<Widget> solutionChildren = [];

    Pair payer = haveToPay.removeFirst();
    Pair payed = toBePayed.removeFirst();

    while (true) {
      if (payer.cost > payed.cost) {
        solutionChildren.add(
          makeSolutionRow(payer, payed, payed.cost, context),
        );
        payer.cost -= payed.cost;
        if (toBePayed.isEmpty) {
          break;
        }
        payed = toBePayed.removeFirst();
      } else {
        solutionChildren.add(
          makeSolutionRow(payer, payed, payer.cost, context),
        );
        payed.cost -= payer.cost;
        if (haveToPay.isEmpty) {
          break;
        }
        payer = haveToPay.removeFirst();
      }
    }

    final solution = CustomCard(
      open: true,
      title: S.of(context)!.solution,
      subtitleStyle: subtitleStyle,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...solutionChildren,
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.small(
                    heroTag: "share",
                    child: const Icon(Icons.share_rounded),
                    onPressed: () => _appinioSocialShare.shareToSystem(
                      "",
                      _solutionText.join("\n"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );

    final List<Widget> results = [
      ...headline,
      solution,
      listCosts,
      listPayers,
      listPayed,
    ];

    return results;
  }

  Widget makeSolutionRow(
    Pair pagante,
    Pair daPagare,
    Decimal cost,
    BuildContext context,
  ) {
    String payText = S.of(context)!.pay;
    String costToPay = CurrencyFormatter.format(
      cost,
      euroSettings,
      enforceDecimals: true,
    );
    String toText = S.of(context)!.to(
          "aeiou".contains(
            daPagare.name.characters.first.toLowerCase(),
          )
              ? 1
              : 0,
        );
    _solutionText.add(
      "• ${pagante.name} $payText $costToPay $toText ${daPagare.name}",
    );
    return Wrap(
      children: [
        const Text("• "),
        Text(
          pagante.name,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        Text(" $payText "),
        Text(
          costToPay,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        Text(
          " $toText ",
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

  CustomCard makeCustomCard(
    String title,
    String middleString,
    TextStyle? subtitleStyle,
    Iterable iterable,
    BuildContext context,
  ) {
    return CustomCard(
      title: title,
      subtitleStyle: subtitleStyle,
      children: iterable
          .map(
            (person) => Row(
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
            ),
          )
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
        heroTag: "close",
        onPressed: () => Navigator.of(context).pop(),
        label: Text(S.of(context)!.close),
        icon: const Icon(Icons.close_rounded),
      ),
    );
  }
}
