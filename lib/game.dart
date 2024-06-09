import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

List<GridStatus> gridYellow = [];
bool hatirlatma=false;
String robotMetni="Merhaba! Oyunuma hoşgeldin \n"
    "Senin için en az maliyetli yolu\n bulamilmem için iki adet \nbuton seç ";
class _GamePageState extends State<GamePage> {
  final List<int> _initiallySelected = [];
  final List<int> _subsequentlySelected = [];
  final int _maxInitialSelections = 2;
  final int _maxSubsequentSelections = 40;
  Coordinate? start;
  Coordinate? goal;
  String? selectedAlgorithm;
  List<List<GridStatus>> grid = List<List<GridStatus>>.generate(
    9,
        (i) => List<GridStatus>.generate(
      9,
          (j) => GridStatus(Coordinate(i, j), 1),
      growable: false,
    ),
    growable: false,
  );

  void _onButtonPressed(int index) {
    setState(() {
      if (_initiallySelected.length < _maxInitialSelections) {
        robotMetni="İşte böyle bir tane daha seç";
        if (!_initiallySelected.contains(index)) {
          _initiallySelected.add(index);
          int row = index ~/ 9;
          int column = index % 9;
          if (_initiallySelected.length == 1) {
            start = Coordinate(column, row);
          } else if (_initiallySelected.length == 2) {
            goal = Coordinate(column, row);
            robotMetni="   Harika! Şimdi oyunu \nzorlaştırmak için iki nokta \narasına engeller koy 40 adet\n koyma hakkın var.";
          }

        }
      } else if (_subsequentlySelected.length < _maxSubsequentSelections) {
        if (!_subsequentlySelected.contains(index) &&
            !_initiallySelected.contains(index)) {
          _subsequentlySelected.add(index);

          int row = index ~/ 9;
          int column = index % 9;
          grid[column][row].color = 0;
          if(hatirlatma==false){
            DateTime startTime = DateTime.now();
            Timer.periodic(Duration(seconds: 1), (timer) {
              DateTime currentTime = DateTime.now();
              Duration elapsed = currentTime.difference(startTime);
              if (elapsed.inSeconds >= 10) {
                robotMetni="Unutma!En son aşağıdaki 3 \narama algoritmasından\n birini seç.";
                timer.cancel();
              }
            });
            print('Zamanlayıcı başlatıldı.');
          }
        }
      }
      if(_subsequentlySelected.length==1){
        robotMetni="Devam et!";
      }else if(_subsequentlySelected.length==5){
        robotMetni="35 tane daha koyabilirsin.";
      }else if(_subsequentlySelected.length==15){
        robotMetni="Üst sınır 40 unutma!";
      }else if(_subsequentlySelected.length==25){
        robotMetni="Biraz zorlicak gibi.";
      }else if(_subsequentlySelected.length==40){
        robotMetni="Allahım yardım et!";
      }
    });
  }

  void _printSelectedIndices() {
    print('Grey indices: $_initiallySelected');
    print('Red indices: $_subsequentlySelected');
    for (var row in grid) {
      for (var status in row) {
        if (status.color == 0) {
          print('Red coordinate: (${status.coor.x}, ${status.coor.y})');
        }
      }
    }
  }

  void _highlightYellowButtons() {
    _runAlgorithm();
    setState(() {
      if (!ulasildi && selectedAlgorithm!=null) {
        robotMetni="         Bütün yollar kapalı .\n               Tekrar Dene!";
      } else if(ulasildi==true && selectedAlgorithm!=null){
        robotMetni="İşte! En Kısa Yol";
        setState(() {});
      }
    });

  }
  void _showPathNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Path Not Found'),
          content: const Text('The path could not be found.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _showSelectAlgorithmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Algorithm Not Selected'),
          content: const Text('Please select an algorithm before running.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      robotMetni="İşte! Yeniden başlıyoruz .";
      hatirlatma=false;
      _initiallySelected.clear();
      _subsequentlySelected.clear();
      start = null;
      goal = null;
      selectedAlgorithm = null;
      gridYellow.clear();
      grid = List<List<GridStatus>>.generate(
        9,
            (i) => List<GridStatus>.generate(
          9,
              (j) => GridStatus(Coordinate(i, j), 1),
          growable: false,
        ),
        growable: false,
      );
    });
  }

  void _runAlgorithm() {
    setState(() {
      if (selectedAlgorithm == null) {
        robotMetni="Lütfen bir algoritma seç!";
      } else if (start != null && goal != null) {
        AI_Algoritma(grid, start!, goal!, selectedAlgorithm!);
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              itemCount: 81,
              itemBuilder: (BuildContext context, int index) {
                Color backgroundColor;
                if (_initiallySelected.contains(index)) {
                  backgroundColor = Colors.grey;
                } else if (_subsequentlySelected.contains(index)) {
                  backgroundColor = Colors.red;
                } else {
                  int row = index ~/ 9;
                  int column = index % 9;
                  if (gridYellow.any((element) =>
                  element.coor.x == column && element.coor.y == row)) {
                    backgroundColor = Colors.yellow;
                  } else {
                    backgroundColor = Colors.blue;
                  }
                }

                return Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                    ),
                    onPressed: () => _onButtonPressed(index),
                    child: Text('$index'),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('lib/assets/robot.jpg', width: 200, height: 200),
              Stack(
                children: [
                  Image.asset('lib/assets/konuşmaBalonu.png', width: 200, height: 200),
                  Positioned(
                    top: 70,
                    left: 32,
                    child: Text(
                      robotMetni,
                      style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedAlgorithm = "BFS";
                      robotMetni="BFS algoritması deneyelim.";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: selectedAlgorithm == "BFS" ? Colors.black : null,
                  ),
                  child: const Text('BFS Algorithm'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedAlgorithm = "DFS";
                      robotMetni="DFS algoritması bakalım \nbakalım.";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: selectedAlgorithm == "DFS" ? Colors.black : null,
                  ),
                  child: const Text('DFS Algorithm'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedAlgorithm = "A*";
                      robotMetni="A star algoritması iyi seçim.";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: selectedAlgorithm == "A*" ? Colors.black : null,
                  ),
                  child: const Text('A* Algorithm'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _highlightYellowButtons,
                  child: const Text('Play'),
                ),
                ElevatedButton(
                  onPressed: _restartGame,
                  child: const Text('Restart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool ulasildi = false;

void AI_Algoritma(List<List<GridStatus>> grid, Coordinate start, Coordinate goal, String Algoritma) {
  Problem problem = Problem(9, 9, start, goal, grid);

  List<Action> graphSearchBFS(Problem problem) {
    List<GridStatus> closed = [];
    Queue<Node> open = Queue();
    open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
    ulasildi = false;
    while (true) {
      if (open.length() == 0) {
        return [];
      }
      Node n = open.pop();
      if (n.coor.x == problem.goal.x && n.coor.y == problem.goal.y) {
        ulasildi = true;
        print('Total cost: ${n.cost}');
        print('Solution depth: ${n.depth}');
        print(getPath2(n));
        int X = problem.start.x;
        int Y = problem.start.y;
        for (var i = 0; i < getPath2(n).length; i++) {
          X = X + getPath2(n)[i].x;
          Y = Y + getPath2(n)[i].y;
          Coordinate cordinat = Coordinate(X, Y);
          GridStatus gridStatus = GridStatus(cordinat, 2);
          gridYellow.add(gridStatus);
        }
        break;
      }
      if (closed.contains(n.status)) continue;
      closed.add(n.status);
      for (Node nd in expand(n, problem)) {
        open.push(nd);
      }
    }
    return [];
  }

  List<Action> graphSearchDFS(Problem problem) {
    List<GridStatus> closed = [];
    StackList<Node> open = StackList();
    open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
    while (true) {
      if (open.length() == 0) {
        return [];
      }
      Node n = open.pop();
      if (n.coor.x == problem.goal.x && n.coor.y == problem.goal.y) {
        ulasildi = true;
        print('Total cost: ${n.cost}');
        print('Solution depth: ${n.depth}');
        print(getPath2(n));
        int X = problem.start.x;
        int Y = problem.start.y;
        for (var i = 0; i < getPath2(n).length; i++) {
          X = X + getPath2(n)[i].x;
          Y = Y + getPath2(n)[i].y;
          Coordinate cordinat = Coordinate(X, Y);
          GridStatus gridStatus = GridStatus(cordinat, 2);
          gridYellow.add(gridStatus);
        }
        break;
      }
      if (closed.contains(n.status)) continue;
      closed.add(n.status);
      for (Node nd in expand(n, problem)) {
        open.push(nd);
      }
    }
    return [];
  }
  List<Action> graphSearchAStar(Problem problem) {
    List<GridStatus> closed = [];
    PriorityQueue<Node> open = PriorityQueue((a, b) => a.totalCost.compareTo(b.totalCost));

    Node startNode = Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]);
    open.push(startNode);

    while (open.isNotEmpty) {
      Node current = open.pop();

      if (current.coor.x == problem.goal.x && current.coor.y == problem.goal.y) {
        ulasildi = true;
        print('Total cost: ${current.cost}');
        print('Solution depth: ${current.depth}');
        print(getPath2(current));

        int X = problem.start.x;
        int Y = problem.start.y;
        for (var i = 0; i < getPath2(current).length; i++) {
          X = X + getPath2(current)[i].x;
          Y = Y + getPath2(current)[i].y;
          Coordinate coordinate = Coordinate(X, Y);
          GridStatus gridStatus = GridStatus(coordinate, 2);
          gridYellow.add(gridStatus);
        }
        break;
      }

      closed.add(current.status);

      for (Node neighbor in expand(current, problem)) {
        if (closed.contains(neighbor.status)) continue;
        if (!open.contains(neighbor)) {
          open.push(neighbor);
        }
      }
    }

    return [];
  }

  if (Algoritma == "BFS") {
    graphSearchBFS(problem);
  } else if (Algoritma == "DFS") {
    graphSearchDFS(problem);
  } else if (Algoritma == "A*") {
    graphSearchAStar(problem);
  }
}
List<Node> expand(Node n, Problem p) {
  List<Node> list = [];
  if (n.coor.x > 0 && p.grid[n.coor.x - 1][n.coor.y].color == 1) {
    list.add(Node(Coordinate(n.coor.x - 1, n.coor.y), Action(-1, 0, 100), n, p.grid[n.coor.x - 1][n.coor.y]));
  }
  if (n.coor.x < p.w - 1 && p.grid[n.coor.x + 1][n.coor.y].color == 1) {
    list.add(Node(Coordinate(n.coor.x + 1, n.coor.y), Action(1, 0, 100), n, p.grid[n.coor.x + 1][n.coor.y]));
  }
  if (n.coor.y > 0 && p.grid[n.coor.x][n.coor.y - 1].color == 1) {
    list.add(Node(Coordinate(n.coor.x, n.coor.y - 1), Action(0, -1, 100), n, p.grid[n.coor.x][n.coor.y - 1]));
  }
  if (n.coor.y < p.h - 1 && p.grid[n.coor.x][n.coor.y + 1].color == 1) {
    list.add(Node(Coordinate(n.coor.x, n.coor.y + 1), Action(0, 1, 100), n, p.grid[n.coor.x][n.coor.y + 1]));
  }
  return list;
}
List<Action> getPath2(Node n) {
  if (n.parent != null) {
    return getPath2(n.parent) + [n.action];
  } else {
    return [];
  }
}
class Action {
  int x, y;
  int cost;
  Action(this.x, this.y, this.cost);

  @override
  String toString() {
    return '[$x, $y]';
  }
}

class GridStatus {
  Coordinate coor;
  int color;
  GridStatus(this.coor, this.color);
  @override
  String toString() {
    return 'Row: ${coor.x} | Col: ${coor.y} | ${(color == 0) ? 'Black' : 'White'} ';
  }
}

class StackList<E> {
  StackList() : _storage = <E>[];

  final List<E> _storage;

  @override
  String toString() {
    return '--- Top ---\n'
        '${_storage.reversed.join('\n')}'
        '\n-----------';
  }

  void push(E element) => _storage.add(element);

  E pop() => _storage.removeLast();
  int length() => _storage.length;
}

class Node {
  Node(this.coor, this.action, this.parent, this.status) : depth = parent.depth + 1, cost = parent.cost + action.cost;
  Node.initState(this.coor, this.action, this.status) : parent = null, depth = 0, cost = 0;

  Coordinate coor;
  int depth, cost;
  Action action;
  var parent;
  GridStatus status;

  get totalCost => cost;

  @override
  String toString() {
    return '${coor.toString()}, $depth, $cost, ${(status.color == 0) ? 'Black' : 'White'}, $action';
  }
}

class Problem {
  int w, h;
  Coordinate start, goal;
  List<List<GridStatus>> grid;

  Problem(this.w, this.h, this.start, this.goal, this.grid);
  Problem.random(this.w, this.h, this.start, this.goal)
      : grid = List<List<GridStatus>>.generate(h, (i) => List<GridStatus>.generate(w, (index) => GridStatus(Coordinate(i, index), Random().nextInt(2)), growable: false), growable: false);

  @override
  String toString() {
    String res = 'Grid $h x $w\n';
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        res += '${grid[i][j].toString()} | ';
      }
      res += '\n';
    }
    return '$res\n***************';
  }
}

class Coordinate {
  int x, y;

  Coordinate(this.x, this.y);

  @override
  String toString() {
    return '($x, $y)';
  }
}

class Queue<E> {
  Queue() : _storage = <E>[];

  final List<E> _storage;

  @override
  String toString() {
    return '--- Top ---\n'
        '${_storage.reversed.join('\n')}'
        '\n-----------';
  }

  void push(E element) => _storage.add(element);

  E pop() => _storage.removeAt(0);
  int length() => _storage.length;
}
class PriorityQueue<T> {
  final List<T> _queue = [];
  final int Function(T, T) _compare;

  PriorityQueue(this._compare);

  void push(T value) {
    _queue.add(value);
    _queue.sort(_compare);
  }

  T pop() {
    if (_queue.isEmpty) {
      throw StateError("Priority queue is empty");
    }
    return _queue.removeAt(0);
  }

  bool get isNotEmpty => _queue.isNotEmpty;

  bool contains(T value) => _queue.contains(value);

  int get length => _queue.length;
}


