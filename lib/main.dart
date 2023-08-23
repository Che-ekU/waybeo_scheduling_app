import 'dart:math';

import 'package:ajay_flutter_task/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set your weekly hours',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<AppProvider>(
        builder: (context, AppProvider appProvider, child) {
          bool isScheduleAvailable = false;
          for (DaySchedule e in appProvider.days) {
            isScheduleAvailable = e.availableTime.isNotEmpty;
            if (isScheduleAvailable) break;
          }
          return GestureDetector(
            onTap: () {
              if (isScheduleAvailable) {
                appProvider.selectedTile.removeWhere((day) => (appProvider
                    .days[appProvider.days
                        .indexWhere((element) => element.title == day)]
                    .availableTime
                    .isEmpty));
                appProvider.notify();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const _SecondPage()));
              }
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isScheduleAvailable
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                borderRadius: BorderRadius.circular(26),
                boxShadow: isScheduleAvailable
                    ? [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 12),
                        ),
                      ]
                    : [],
              ),
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              child: const Center(
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Selector<AppProvider, dynamic>(
              builder: (context, value, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...appProvider.days.map((e) => _DayTile(title: e.title))
                ],
              ),
              selector: (p0, p1) => p1.selectedTile,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.watch<AppProvider>();
    return GestureDetector(
      // onTap: () {
      //   !appProvider.selectedTile.contains(title)
      //       ? appProvider.selectedTile.add(title)
      //       : appProvider.selectedTile.remove(title);
      //   appProvider.notify();
      // },
      // behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        side: const BorderSide(color: Colors.grey),
                        value: appProvider.selectedTile.contains(title),
                        onChanged: (value) {
                          !appProvider.selectedTile.contains(title)
                              ? appProvider.selectedTile.add(title)
                              : {
                                  appProvider.selectedTile.remove(title),
                                  appProvider
                                      .days[appProvider.days.indexWhere(
                                          (element) => element.title == title)]
                                      .availableTime
                                      .clear()
                                };
                          appProvider.notify();
                        },
                        shape: const CircleBorder(),
                        activeColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(title),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              if (appProvider.selectedTile.contains(title))
                ...['Morning', 'Afternoon', 'Evening'].map(
                  (e) => _Badge(
                    day: title,
                    title: e,
                  ),
                )
              else
                const Text(
                  "Unavailable",
                  style: TextStyle(color: Colors.grey),
                )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.day, required this.title});
  final String title;
  final String day;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.watch<AppProvider>();
    int currentIndex =
        appProvider.days.indexWhere((element) => element.title == day);
    return GestureDetector(
      onTap: () {
        if (!appProvider.days[currentIndex].availableTime.contains(title)) {
          appProvider.days[currentIndex].availableTime.add(title);
        } else {
          appProvider.days[currentIndex].availableTime.remove(title);
        }
        appProvider.notify();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color:
                  appProvider.days[currentIndex].availableTime.contains(title)
                      ? Theme.of(context).primaryColor
                      : Colors.grey),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: appProvider.days[currentIndex].availableTime.contains(title)
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _SecondPage extends StatelessWidget {
  const _SecondPage();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          margin: const EdgeInsets.all(20),
          width: double.infinity,
          child: const Center(
            child: Text(
              // appProvider.days
              //         .any((element) => element.availableTime.isNotEmpty)
              //     ?
              "Edit schedule",
              // : "Save",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(appProvider.getAvailableTime())],
        ),
      ),
    );
  }
}
