import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 64)),
      ),
      home: const MyHomePage(title: 'Flutter StreamBuilder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<int?> numbersStream;

  @override
  void initState() {
    super.initState();
    numbersStream = getNumbers();
  }

  Stream<int?> getNumbers() async* {
    await Future.delayed(const Duration(seconds: 4));
    yield 1;
    //throw 'error';

    await Future.delayed(const Duration(seconds: 1));
    yield 2;

    await Future.delayed(const Duration(seconds: 1));
    yield 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<int?>(
                stream: numbersStream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //stream is null
                    case ConnectionState.none:
                      return const Text('Stream is null');
                    case ConnectionState.waiting:
                      return const Text('Waiting');
                    //we have first value of the stream but it is not finished yet
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        int number = snapshot.data!;
                        return Text('$number');
                      } else {
                        return const Text('no data');
                      }
                    //Stream has finished
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        int number = snapshot.data!;
                        return Text('$number');
                      } else {
                        return const Text('no data');
                      }
                    default:
                      return Container();
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            numbersStream = getNumbers();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
