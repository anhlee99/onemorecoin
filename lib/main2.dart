import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: false,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return FadePageRoute(builder: (context) => const HomePage());
          } else if (settings.name == "/abc") {
            return FadePageRoute(builder: (context) => const SecondPage());
          }
          return null;
        },
      ),
    );
  }
}

class FadePageRoute<T> extends CupertinoPageRoute<T> {
  FadePageRoute({required super.builder});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final widget =
    super.buildTransitions(context, animation, secondaryAnimation, child);
    if (widget is CupertinoPageTransition) {
      return FadeTransition(
        opacity: animation,
        child: widget.child,
      );
    } else {
      return widget;
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: const Text('Next Page',
              style: TextStyle(
                fontSize: 48,
              )),
          onPressed: () {
            Navigator.of(context).pushNamed('/abc');
          },
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          '2nd Page',
          style: TextStyle(
            fontSize: 48,
          ),
        ),
      ),
    );
  }
}