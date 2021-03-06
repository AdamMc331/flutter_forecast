import 'package:flutter/material.dart';
import 'package:flutter_forecast/forecast/app_bar.dart';
import 'package:flutter_forecast/forecast/forecast.dart';
import 'package:flutter_forecast/forecast/forecast_list.dart';
import 'package:flutter_forecast/forecast/generic_widgets/sliding_drawer.dart';
import 'package:flutter_forecast/forecast/radial_list.dart';
import 'package:flutter_forecast/forecast/week_drawer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  OpenableController openableController;
  SlidingRadialListController slidingListController;
  String selectedDay = 'Monday, August 26';

  @override
  void initState() {
    super.initState();

    openableController = new OpenableController(
      vsync: this,
      openDuration: const Duration(milliseconds: 250),
    )..addListener(() => setState(() {}));

    slidingListController = new SlidingRadialListController(
      itemCount: forecastRadialList.items.length,
      vsync: this,
    )..open();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Forecast(
            radialList: forecastRadialList,
            slidingListController: slidingListController,
          ),
          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: new ForecastAppBar(
              onDrawerArrowTap: openableController.open,
              selectedDay: selectedDay,
            ),
          ),
          new SlidingDrawer(
            openableController: openableController,
            drawer: new WeekDrawer(
              onDaySelected: (String title) {
                setState(() {
                  //TODO: Consider passing around more structured data not just a string.
                  selectedDay = title.replaceAll('\n', ', ');
                });

                openableController.close();

                slidingListController
                    .close()
                    .then((_) => slidingListController.open());
              },
            ),
          ),
        ],
      ),
    );
  }
}
