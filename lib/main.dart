import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

///Main App to run
class MyApp extends StatelessWidget {
  ///Constructor for main app to run
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

///Main screen of the app
class HomePage extends StatefulWidget {
  ///Constructor for the Main screen of the app
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberToGuess = Random().nextInt(101);
  String? errorText;
  TextEditingController guessController = TextEditingController();
  int? userNumber;

  Future<dynamic> openDialog(int number, String messageForDialog) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('You guessed right'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(messageForDialog),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Reset'),
                      onPressed: () {
                        setState(() {
                          numberToGuess = Random().nextInt(101);
                          guessController.clear();
                          userNumber = null;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Guess my number'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('I am thinking of a number between 1 and 100.'),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('It is your turn to guess my number!'),
              ),
              if (userNumber != null && userNumber! > numberToGuess)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'You tried $userNumber, go lower.',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              if (userNumber != null && userNumber! < numberToGuess)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'You tried $userNumber, go higher.',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              Column(
                children: [
                  const Text('Try a number!'),
                  TextField(
                    controller: guessController,
                    decoration: InputDecoration(errorText: errorText),
                    keyboardType: TextInputType.number,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        if (userNumber == numberToGuess) {
                          numberToGuess = Random().nextInt(101);
                          userNumber = null;
                        } else {
                          userNumber = int.tryParse(guessController.text);
                          if (userNumber == null || userNumber! < 1 || userNumber! > 100) {
                            errorText = 'This is not a valid number';
                          } else {
                            errorText = null;
                          }
                        }
                        if (userNumber == numberToGuess) {
                          openDialog(
                            numberToGuess,
                            'You are right the number is $numberToGuess',
                          );
                        }
                        guessController.clear();
                      });
                    },
                    child: userNumber == numberToGuess ? const Text('Reset') : const Text('Guess'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
