import 'dart:async';
import 'dart:math';
import 'package:cube_snake/control_panel.dart';
import 'package:cube_snake/direction.dart';
import 'package:cube_snake/piece.dart';
import 'package:cube_snake/welcome_page.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenWidth, screenHeight;
  int step = 20;
  int length = 5;
  int score = 0;
  double speed = 1.0;
  Offset? foodPosition;
  Piece? food;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  Timer? timer;

  // AudioPlayer player = AudioPlayer();

  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    timer = Timer.periodic(
      Duration(milliseconds: speed == 4 ? 100 : 400 ~/ speed),
      (timer) {
        setState(() {});
      },
    );
  }

  Widget getControls() {
    return ControlPanel(
      onTapped: (Direction newDirection) {
        direction = newDirection;
      },
    );
  }

  // Direction getRandomDirection() {
  //   int val = Random().nextInt(4);
  //   direction = Direction.values[val];
  //   return direction;
  // }

  void restart() {
    length = 5;
    score = 0;
    speed = 1;
    positions = [];
    direction = Direction.right;

    changeSpeed();
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int getNearestTens(int number) {
    int output;
    output = (number ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;

    position = Offset(
      getNearestTens(posX).toDouble(),
      getNearestTens(posY).toDouble(),
    );

    return position;
  }

  void draw() async {
    if (positions.isEmpty) {
      positions.add(getRandomPosition());
    }

    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = await getNextPosition(positions[0]);
  }

  bool delectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }
    return false;
  }

  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctr) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            'Game Over',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Your game is over, but you played so well. Your score is $score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              child: const Text(
                'RESTART',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
              child: const Text(
                'BACK TO MAIN MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Offset> getNextPosition(Offset position) async {
    late Offset nextPosition;

    if (direction == Direction.right) {
      nextPosition = Offset(
        position.dx + step,
        position.dy,
      );
    } else if (direction == Direction.left) {
      nextPosition = Offset(
        position.dx - step,
        position.dy,
      );
    } else if (direction == Direction.up) {
      nextPosition = Offset(
        position.dx,
        position.dy - step,
      );
    } else if (direction == Direction.down) {
      nextPosition = Offset(
        position.dx,
        position.dy + step,
      );
    }

    if (delectCollision(position) == true) {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }

      await Future.delayed(
        const Duration(milliseconds: 200),
        () => showGameOverDialog(),
      );
      return position;
    }
    return nextPosition;
  }

  void drawFood() {
    foodPosition ??= getRandomPosition();

    if (foodPosition == positions[0]) {
      length++;
      score = score + 5;
      speed = speed + 0.2;
      foodPosition = getRandomPosition();
    }
    food = Piece(
      posX: foodPosition!.dx.toInt(),
      posY: foodPosition!.dy.toInt(),
      size: step,
      color: Colors.lightGreen,
      isAnimated: true,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];

    draw();
    drawFood();
    for (var i = 0; i < length; ++i) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(Piece(
        posX: positions[i].dx.toInt(),
        posY: positions[i].dy.toInt(),
        size: step,
        color: Colors.amber,
        isAnimated: false,
      ));
    }

    return pieces;
  }

  Widget getScore() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        "Score : $score",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget getSpeed() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        "Speed : x${speed.toStringAsFixed(1)}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    lowerBoundX = 0;
    lowerBoundY = 0;

    upperBoundX = getNearestTens(screenWidth.toInt());
    upperBoundY = getNearestTens(screenHeight.toInt());

    return Scaffold(
      body: Container(
        color: Colors.indigoAccent,
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  getScore(),
                  const Spacer(),
                  getSpeed(),
                ],
              ),
              Stack(
                children: getPieces(),
              ),
              getControls(),
              food as Widget,
            ],
          ),
        ),
      ),
    );
  }
}
