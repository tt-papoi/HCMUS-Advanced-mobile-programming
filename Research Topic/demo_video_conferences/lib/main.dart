import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jitsi Meet Flutter SDK Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Jitsi Meet Flutter SDK Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final roomController = TextEditingController(); // Room ID input
  final meetingNameController = TextEditingController(); // Meeting name input
  final jitsiMeet = JitsiMeet();

  void join() {
    // Retrieve both room and meeting name inputs
    var roomName = roomController.text.trim();
    var meetingName = meetingNameController.text.trim();

    if (roomName.isNotEmpty && meetingName.isNotEmpty) {
      var options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.jit.si",
        room: roomName, // Room identifier
        configOverrides: {
          "startWithAudioMuted": true,
          "startWithVideoMuted": true,
          "subject": meetingName, // Use the entered meeting name as the subject
          "localSubject": "Local - $meetingName",
        },
        featureFlags: {
          "unsaferoomwarning.enabled": false,
          "security-options.enabled": false
        },
        userInfo: JitsiMeetUserInfo(
            displayName: "Flutter user", email: "user@example.com"),
      );

      jitsiMeet.join(options);
    } else {
      // Show a warning if either field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both room ID and meeting name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                controller: roomController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter room ID',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                controller: meetingNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter meeting name',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              height: 50,
              child: FilledButton(
                onPressed: join,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 130, 171, 243)),
                  //foregroundColor: WidgetStateProperty.all(Colors.black54),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                ),
                child: const Text(
                  "Join",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
