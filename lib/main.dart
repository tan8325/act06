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
    if (age < 99) {
      age++;
      notifyListeners();
    }
  }

  void decrement() {
    if (age > 0) {
      age--;
      notifyListeners();
    }
  }

  void setAge(double newAge) {
    age = newAge.toInt();
    notifyListeners();
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

  Color get progressColor {
    if (age <= 33) {
      return Colors.green;
    } else if (age <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  double get progressValue {
    if (age <= 33) {
      return age / 33;
    } else if (age <= 67) {
      return (age - 33) / 34;
    } else {
      return (age - 67) / 32;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Your current age:', style: TextStyle(fontSize: 18)),
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

              Slider(
                value: ageCounter.age.toDouble(),
                min: 0,
                max: 99,
                divisions: 99,
                label: "${ageCounter.age}",
                onChanged: (newAge) {
                  ageCounter.setAge(newAge);
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "minusBtn",
                    onPressed: ageCounter.decrement,
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: "plusBtn",
                    onPressed: ageCounter.increment,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              LinearProgressIndicator(
                value: ageCounter.progressValue,
                color: ageCounter.progressColor,
                backgroundColor: Colors.grey.shade300,
                minHeight: 10,
              ),

              const SizedBox(height: 20),
              Text(
                "Progress: ${ageCounter.age}/99",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
