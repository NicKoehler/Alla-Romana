import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:alla_romana/l10n/s.dart';
import 'package:alla_romana/utils/regex.dart';
import 'package:alla_romana/pages/result.dart';
import 'package:alla_romana/classes/pair.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:alla_romana/components/custom_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.light);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) => MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme != null
              ? lightColorScheme.harmonized()
              : _defaultLightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme != null
              ? darkColorScheme.harmonized()
              : _defaultDarkColorScheme,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'ALLA ROMANA'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int nameLimit = 20;
  final int costLimit = 10;
  final listKey = GlobalKey<AnimatedListState>();
  late ScrollController _scrollController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final duration = const Duration(milliseconds: 300);
  bool _showFab = true;
  List<Pair> _data = [];
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _prefs.then((SharedPreferences prefs) {
      final p = prefs.getStringList('data');
      if (p != null) {
        _data = p.map((element) => Pair.fromString(element)).toList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addButton = FloatingActionButton.extended(
      heroTag: "add",
      onPressed: () => insertElement(context),
      label: Text(S.of(context)!.addPerson),
      icon: const Icon(Icons.person_add_rounded),
    );

    final appBar = AppBar(
      title: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      toolbarHeight: 100,
      centerTitle: true,
    );

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        final ScrollDirection direction = notification.direction;
        setState(() {
          if (direction == ScrollDirection.reverse) {
            _showFab = false;
          } else if (direction == ScrollDirection.forward) {
            _showFab = true;
          }
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: appBar,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _data.isEmpty
                ? Text(
                    S.of(context)!.addPersonDesc,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  )
                : AnimatedList(
                    key: listKey,
                    initialItemCount: _data.length,
                    itemBuilder: (context, index, animation) => CustomTile(
                      data: _data.elementAt(index),
                      animation: animation,
                      removeFunction: () => removeDialog(context, index).show(),
                      editFunction: () => createAddEditDialog(
                              context,
                              _data.elementAt(index).name,
                              _data.elementAt(index).cost,
                              index: index)
                          .show(),
                    ),
                  ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedSlide(
          duration: duration,
          offset:
              _showFab || _data.length < 5 ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: duration,
            opacity: _showFab || _data.length < 5 ? 1 : 0,
            child: _data.length > 1 && _data.any((e) => e.cost != _data[0].cost)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "calculate",
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResultPage(data: _data),
                          ),
                        ),
                        label: Text(S.of(context)!.calculate),
                        icon: const Icon(Icons.calculate_rounded),
                      ),
                      addButton,
                    ],
                  )
                : addButton,
          ),
        ),
      ),
    );
  }

  removeItemAt(int index) {
    final item = _data.elementAt(index);
    _data.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) => CustomTile(
        data: item,
        animation: animation,
        removeFunction: () {},
        editFunction: () {},
      ),
    );
    saveData();
  }

  insertElement(BuildContext context) {
    createAddEditDialog(context, "", Decimal.zero).show();
  }

  void saveData() {
    _prefs.then((value) =>
        value.setStringList("data", _data.map((e) => e.toString()).toList()));
  }

  AwesomeDialog removeDialog(BuildContext context, int index) {
    return AwesomeDialog(
      context: context,
      dialogBackgroundColor: Theme.of(context).colorScheme.background,
      dialogType: DialogType.noHeader,
      autoDismiss: false,
      onDismissCallback: (_) {},
      title: S.of(context)!.removePersonDescription,
      btnOk: FloatingActionButton.extended(
        heroTag: "yes",
        icon: const Icon(Icons.check_circle_rounded),
        label: Text(S.of(context)!.yes),
        onPressed: () => setState(() {
          removeItemAt(index);
          Navigator.pop(context);
        }),
      ),
      btnCancel: FloatingActionButton.extended(
        heroTag: "no",
        icon: const Icon(Icons.cancel),
        label: Text(S.of(context)!.no),
        backgroundColor: Theme.of(context).colorScheme.onError,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  AwesomeDialog createAddEditDialog(
      BuildContext context, String name, Decimal cost,
      {int? index}) {
    final formKey = GlobalKey<FormState>();
    return AwesomeDialog(
      context: context,
      dialogBackgroundColor: Theme.of(context).colorScheme.background,
      dialogType: DialogType.noHeader,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                    label: Text(
                      S.of(context)!.enterName,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  autofocus: true,
                  onChanged: (value) => formKey.currentState!.validate(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context)!.enterNameError;
                    }
                    if (value.length > nameLimit) {
                      return S.of(context)!.enterNameErrorLength(nameLimit);
                    }
                    name = value.trim();
                    return null;
                  },
                ),
              ),
              TextFormField(
                initialValue:
                    cost > Decimal.zero ? cost.toStringAsFixed(2) : "",
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text(
                    S.of(context)!.enterCost,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                onChanged: (value) {
                  formKey.currentState!.validate();
                },
                validator: (value) {
                  if (value == null || !regexNum.hasMatch(value)) {
                    return S.of(context)!.enterCostError;
                  }
                  if (value.length > 10) {
                    return S.of(context)!.enterCostErrorLength(costLimit);
                  }
                  cost = Decimal.parse(
                    value.replaceAll(",", "."),
                  );
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      autoDismiss: false,
      onDismissCallback: (_) {},
      btnOk: FloatingActionButton.extended(
        heroTag: "confirm",
        icon: const Icon(Icons.check_circle_rounded),
        label: Text(S.of(context)!.confirm),
        onPressed: () {
          if (!formKey.currentState!.validate()) {
            return;
          }
          setState(() {});
          final p = Pair(name, cost);
          if (index != null) {
            _data[index].name = name;
            _data[index].cost = cost;
            Navigator.pop(context);
            saveData();
            return;
          }
          if (_data.isEmpty) {
            _data.add(p);
          } else {
            _data.add(p);
            listKey.currentState!.insertItem(
              _data.length - 1,
            );
          }
          saveData();
          Navigator.pop(context);
        },
      ),
      btnCancel: FloatingActionButton.extended(
          heroTag: "cancel",
          icon: const Icon(Icons.cancel),
          label: Text(S.of(context)!.cancel),
          backgroundColor: Theme.of(context).colorScheme.onError,
          onPressed: () => Navigator.pop(context)),
    );
  }
}
