import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AgeCounter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('ACT06');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class AgeCounter with ChangeNotifier {
  int age = 0;

  void increment() {
    age++;
    notifyListeners();
  }

  void decrement() {
    if (age > 0) {
      age--;
      notifyListeners();
    }
  }

  Map<String, dynamic> get milestone {
    if (age <= 12) {
      return {"message": "You're a child!", "color": Colors.lightBlue};
    } else if (age <= 19) {
      return {"message": "Teenager time!", "color": Colors.lightGreen};
    } else if (age <= 30) {
      return {"message": "You're a young adult!", "color": Colors.yellow.shade200};
    } else if (age <= 50) {
      return {"message": "You're an adult now!", "color": Colors.orange};
    } else {
      return {"message": "Golden years!", "color": Colors.grey};
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACT06',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
    final ageCounter = Provider.of<AgeCounter>(context);

    return Scaffold(
      backgroundColor: ageCounter.milestone["color"],
      appBar: AppBar(
        title: const Text('ACT06'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your current age:'),
            Consumer<AgeCounter>(
              builder: (context, ageCounter, child) => Text(
                '${ageCounter.age}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              ageCounter.milestone["message"],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: ageCounter.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: ageCounter.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
