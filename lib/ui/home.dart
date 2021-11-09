import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:microphone/microphone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AudioState { recording, stop, play, init }

const veryDarkBlue = Color(0xff172133);
const kindaDarkBlue = Color(0xff202641);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioState audioState;
  MicrophoneRecorder _recorder;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _recorder = MicrophoneRecorder()..init();
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    final bytes = await _recorder.toBytes();
    print(bytes);

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("recording-data");
    return _collectionRef.doc(currentUser.email).collection("list").doc().set({
      "byte-code": "$bytes",
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Successfully stored to DB", toastLength: Toast.LENGTH_LONG);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    }).catchError((error) => Fluttertoast.showToast(
        msg: "Something is wrong", toastLength: Toast.LENGTH_LONG));
  }

  void handleAudioState(AudioState state) {
    setState(() {
      if (audioState == null) {
        // Starts recording
        audioState = AudioState.recording;
        _recorder.start();
        // Finished recording
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.play;
        _recorder.stop();
        // Play recorded audio
      } else if (audioState == AudioState.play) {
        audioState = AudioState.stop;
        _audioPlayer = AudioPlayer();
        _audioPlayer.setUrl(_recorder.value.recording.url).then((_) {
          _audioPlayer.play().then((_) {
            setState(() => audioState = AudioState.play);
          });
        });

        // Stop recorded audio
      } else if (audioState == AudioState.stop) {
        audioState = AudioState.play;
        _audioPlayer.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: veryDarkBlue,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: handleAudioColour(),
              ),
              child: RawMaterialButton(
                fillColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(30),
                onPressed: () => handleAudioState(audioState),
                child: getIcon(audioState),
              ),
            ),
            SizedBox(width: 20),
            if (audioState == AudioState.play || audioState == AudioState.stop)
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kindaDarkBlue,
                    ),
                    child: RawMaterialButton(
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(30),
                      onPressed: () => setState(() {
                        audioState = null;
                        _recorder.dispose();
                        _recorder = MicrophoneRecorder()..init();
                      }),
                      child: Icon(Icons.replay, size: 50),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kindaDarkBlue,
                    ),
                    child: RawMaterialButton(
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(30),
                      onPressed: () =>sendUserDataToDB(),
                      child: Icon(Icons.upload_file_outlined, size: 50),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color handleAudioColour() {
    if (audioState == AudioState.recording) {
      return Colors.deepOrangeAccent.shade700.withOpacity(0.5);
    } else if (audioState == AudioState.stop) {
      return Colors.green.shade900;
    } else {
      return kindaDarkBlue;
    }
  }

  Icon getIcon(AudioState state) {
    switch (state) {
      case AudioState.play:
        return Icon(Icons.play_arrow, size: 50);
      case AudioState.stop:
        return Icon(Icons.stop, size: 50);
      case AudioState.recording:
        return Icon(Icons.mic, color: Colors.redAccent, size: 50);
      default:
        return Icon(Icons.mic, size: 50);
    }
  }
}

	
	
	
