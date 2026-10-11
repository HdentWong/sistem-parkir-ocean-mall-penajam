import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/parking_home_page.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const OceanMallParkingApp());
}

class OceanMallParkingApp extends StatelessWidget {
  const OceanMallParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Parkir Ocean Mall Penajam',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const DefaultTabController(length: 2, child: ParkingHomePage()),
    );
  }
}
