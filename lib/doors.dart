// ignore_for_file: avoid_print

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt_ctl.dart';

class Doors extends StatefulWidget {
  final String whichDoor;
  const Doors({super.key, required this.whichDoor});

  @override
  DoorsState createState() => DoorsState();
}

class DoorsState extends State<Doors> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      child: NeumorphicButton(
        onPressed: () {
          pubTopic = 'garage/${widget.whichDoor}';
          builder.clear();
          builder.addString('pressed');
          client.publishMessage(
              pubTopic, MqttQos.exactlyOnce, builder.payload!);
          print("Door button pressed");
        },
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          depth: 10,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Icon(Icons.garage_outlined, size: 150, color: gotColor),
      ),
    );
  }
}

class NotifyMagSwitches extends ChangeNotifier {
  Color magColor = Colors.purple;

  void changeColor(Color newMagColor) {
    magColor = newMagColor;
    notifyListeners();
  }
}
