import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CipherPage extends StatefulWidget {
  const CipherPage({super.key});

  @override
  State<CipherPage> createState() => _CipherPageState();
}

class _CipherPageState extends State<CipherPage> {
  Map data = {};
  final Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    stopwatch.reset();
    stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    String pageTitle = data['encoding'] ? 'Encoder' : 'Decoder';
    ConfettiController confettiController = ConfettiController(duration: const Duration(seconds: 5));

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(
          "${data['name']} $pageTitle",
          style: const TextStyle(
            fontFamily: 'Belanosima',
            fontWeight: FontWeight.bold,
            fontSize: 30
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              if (!data['encoding']) Confetti(confettiController: confettiController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: !data['encoding'] ? Timer(stopwatch: stopwatch) : const ListTile(tileColor: Colors.transparent,)
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                    ),
                    onPressed: () async {
                      if (data['encoding']) {
                        if (data['encodeReady']()) {
                          await data['encode']();
                          // ignore: use_build_context_synchronously
                          _dialogBuilder(context, (stopwatch.elapsedMilliseconds / 1000).truncate(), data['encodeCiphertext'](), true);
                        }
                      }
                      else if (data['checkWin']()) {
                        stopwatch.stop();
                        confettiController.play();
                        _dialogBuilder(context, (stopwatch.elapsedMilliseconds / 1000).truncate(), data['plaintext'](), false);
                      }
                    },
                    child: const Text("Submit"),
                  )
                ],
              ),
              const SizedBox(height: 20),
              data['page']
            ],
          )
        )
      )
    );
  }

  Future<void> _dialogBuilder(BuildContext context, int seconds, String text, bool encoding) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            encoding ? 'Your Ciphertext:' : 'Solved in $seconds seconds',
            style: const TextStyle(
              color: Colors.white
            )
          ),
          content: Text(
            encoding ? text : breakText(data['plaintext']()),
            style: const TextStyle(
              color: Colors.white
            )
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.grey[900]
                  )
                ),
              ),
            )
          ],
        );
      },
    );
  }

  String breakText(String text) {
    String result = "";
    int characters = 0;

    for (String char in text.split(' ')) {
      if (char.length + characters > 50) {
        result += '\n$char ';
        characters = 0;
      } else {
        result += '$char ';
      }
      characters += char.length;
    }

    return result;
  }
}

class Confetti extends StatefulWidget {
  final ConfettiController confettiController;
  const Confetti({super.key, required this.confettiController});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {

  @override
  void dispose() {
    widget.confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: widget.confettiController,
      blastDirectionality: BlastDirectionality
          .explosive,
      shouldLoop:
          false, 
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ],
      numberOfParticles: 2,
      emissionFrequency: 1,
    );
  }
}

class Timer extends StatefulWidget {
  final Stopwatch stopwatch;

  const Timer({super.key, required this.stopwatch});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  String? text;

  @override
  void initState() {
    super.initState();
    text = "Time";
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: ((event) {
        setState(() {
          text = '${(widget.stopwatch.elapsedMilliseconds / 1000).truncate()}';
        });
      }),
      onExit: (event) {
        setState(() {
          text = "Time";
        });
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.access_time),
        title: Text(
          text!,
          style: const TextStyle(
            fontFamily: 'Ysabeau',
            fontSize: 20
          ),
        ),
        tileColor: Colors.transparent,
        iconColor: Colors.grey[100],
        textColor: Colors.grey[100],
      ),
    );
  }
}