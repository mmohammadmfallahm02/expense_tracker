import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var isar = await openDb();

  runApp(const MyApp());
}

Future<Isar> openDb() async {
  final dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open([], directory: dir.path, name: 'expenseInstance');
  }
  return Future.value(Isar.getInstance());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Container(),
    );
  }
}
