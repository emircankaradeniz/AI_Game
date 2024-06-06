import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final List<int> _initiallySelected = [];
  final List<int> _subsequentlySelected = [];
  final int _maxInitialSelections = 2;
  final int _maxSubsequentSelections = 40;

  // Initialize the grid
  final List<List<GridStatus>> grid = List<List<GridStatus>>.generate(
      9, // Assuming a 9x9 grid based on itemCount
          (i) => List<GridStatus>.generate(
          9,
              (j) => GridStatus(Coordinate(i, j), 1),
          growable: false
      ),
      growable: false
  );

  void _onButtonPressed(int index) {
    setState(() {
      if (_initiallySelected.length < _maxInitialSelections) {
        if (!_initiallySelected.contains(index)) {
          _initiallySelected.add(index);
        }
      } else if (_subsequentlySelected.length < _maxSubsequentSelections) {
        if (!_subsequentlySelected.contains(index) && !_initiallySelected.contains(index)) {
          _subsequentlySelected.add(index);

          // Update the grid color to red (0) for the subsequently selected index
          int row = index ~/ 9; // Assuming a 9x9 grid
          int column = index % 9;
          grid[row][column].color = 0;
        }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9, // Number of columns
              ),
              itemCount: 81, // Number of buttons (9x9)
              itemBuilder: (BuildContext context, int index) {
                Color backgroundColor;
                if (_initiallySelected.contains(index)) {
                  backgroundColor = Colors.grey;
                } else if (_subsequentlySelected.contains(index)) {
                  backgroundColor = Colors.red;
                } else {
                  backgroundColor = Colors.blue;
                }

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                  ),
                  onPressed: () => _onButtonPressed(index),
                  child: Text('$index'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => BfsAlgoritma(grid),
              child: const Text('Print Selected Indices'),
            ),
          ),
        ],
      ),
    );
  }
}

void BfsAlgoritma(List<List<GridStatus>> grid) {
  Problem problem = Problem(9, 9, Coordinate(1, 7), Coordinate(6, 2), grid); // Create the problem based on the grid

  print('BFS Function');
  graphSearchBFS(problem);
  print('\n\nDFS Function');
  graphSearchDFS(problem);
}
List<Action> graphSearchBFS(Problem problem) {
  List<GridStatus> closed = [];
  Queue<Node> open = Queue();
  open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
  while (true) {
    if (open.length() == 0) {
      return [];
    }
    Node n = open.pop();
    if (n.coor.x == problem.goal.x && n.coor.y == problem.goal.y) {
      print('Total cost: ${n.cost}');
      print('Solution depth: ${n.depth}');
      print(getPath2(n));
    }
    if (closed.contains(n.status)) continue; // Ensure the status is unique
    closed.add(n.status);
    for (Node nd in expand(n, problem)) {
      open.push(nd);
    }
  }
}

List<Action> graphSearchDFS(Problem problem) {
  List<GridStatus> closed = [];
  Stack<Node> open = Stack();
  open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
  while (true) {
    if (open.length() == 0) {
      return [];
    }
    Node n = open.pop();
    if (n.coor.x == problem.goal.x && n.coor.y == problem.goal.y) {
      print('Total cost: ${n.cost}');
      print('Solution depth: ${n.depth}');
      print(getPath2(n));
    }
    if (closed.contains(n.status)) continue; // Ensure the status is unique
    closed.add(n.status);
    for (Node nd in expand(n, problem)) {
      open.push(nd);
    }
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

  get coordinate => null;

  @override
  String toString() {
    return 'Row: ${coor.x} | Col: ${coor.y} | ${(color == 0) ? 'Black' : 'White'} ';
  }
}

class Stack<E> {
  Stack() : _storage = <E>[];

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
