import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const methodsChannel = MethodChannel('p3s.com/methods');

  String batteryLevel = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(batteryLevel),
        Center(
            child: ElevatedButton(
                onPressed: getBatteryLevel,
                child: const Text('Get Baterry level'))),
        Center(
            child: ElevatedButton(
                onPressed: requestPush, child: const Text('request push'))),
        Center(
            child: ElevatedButton(
                onPressed: shedulePush, child: const Text('schedulePush'))),
        Center(
            child: ElevatedButton(
                onPressed: tokenPush, child: const Text('tokenPush')))
      ],
    ));
  }

  Future getBatteryLevel() async {
    final arguments = {'name': 'Sara alves', 'versao': '1'};
    final int newBatteryLevel =
        await methodsChannel.invokeMethod('getBatteryLevel', arguments);

    setState(() {
      batteryLevel = "$newBatteryLevel";
    });
  }

  Future requestPush() async {
    final dynamic request = await methodsChannel.invokeMethod('requestPush');

    print(request);
  }

  Future shedulePush() async {
    final dynamic request = await methodsChannel.invokeMethod('schedulePush');
    print(request);
  }

  Future tokenPush() async {
    final dynamic request = await methodsChannel.invokeMethod('tokenPush');
    print(request);
  }
}
