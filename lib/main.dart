import 'package:flutter/material.dart';
import 'package:ai_game/Bfs-DfsClass/action.dart';
import 'package:ai_game/Bfs-DfsClass/coordinate.dart';
import 'package:ai_game/Bfs-DfsClass/problem.dart';
import 'package:ai_game/Bfs-DfsClass/node.dart';
import 'package:ai_game/Bfs-DfsClass/queue.dart';
import 'package:ai_game/Bfs-DfsClass/stack.dart';
import 'package:ai_game/Bfs-DfsClass/States.dart';
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

  void _onButtonPressed(int index) {
    setState(() {
      if (_initiallySelected.length < _maxInitialSelections) {
        if (!_initiallySelected.contains(index)) {
          _initiallySelected.add(index);
        }
      } else if (_subsequentlySelected.length < _maxSubsequentSelections) {
        if (!_subsequentlySelected.contains(index) && !_initiallySelected.contains(index)) {
          _subsequentlySelected.add(index);
        }
      }
    });
  }

  void _printSelectedIndices() {
    print('Grey indices: $_initiallySelected');
    print('Red indices: $_subsequentlySelected');
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
              onPressed: _printSelectedIndices,
              child: const Text('Print Selected Indices'),
            ),
          ),
        ],
      ),
    );
  }
}
void BfsAlgoritma(){

  Problem problem = Problem(10, 10, Coordinate(1,7), Coordinate(6,2), grid); // Görseldeki başlangıç ve amaç durumlarına göre problemi oluşturuyoruz.

  graphSearchBFS(problem); // Toplam derinliği, toplam maliyeti ve eylemlerin Başlangıç durumundan Amaç durumuna kadar olan sıralı listesini yazdıracak.
  graphSearchDFS(problem); // Eylem listesi -> [[0,1], [1,1], ...., [0,-1]] şeklinde listeyi yazdması yeterli.
}
List<Action> graphSearchBFS(Problem problem){
  List<State> closed = [];
  Queue<Node> open = Queue();
  //List<Action> path = [];
  open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
  while(true){
    if(open.length() == 0) {
      return [];
    }
    Node n = open.pop();
    if(n.coor.x == problem.goal.x && n.coor.y == problem.goal.y){
      //getPath(path, n);
      print('Total cost: ${n.cost}');
      print('Solution depth: ${n.depth}');
      //print(path);
      print(getPath2(n));
    }
    if(closed.contains(n.state)) continue; //BURADA state bulamazsa koordinat x ve y lerini eşlemek lazım
    closed.add(n.state);
    for(Node nd in expand(n, problem)){
      open.push(nd);
    }
  }
}

List<Action> graphSearchDFS(Problem problem){
  List<State> closed = [];
  Stack<Node> open = Stack();
  //List<Action> path = [];
  open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
  while(true){
    if(open.length() == 0) {
      return [];
    }
    Node n = open.pop();
    if(n.coor.x == problem.goal.x && n.coor.y == problem.goal.y){
      //getPath(path, n);
      print('Total cost: ${n.cost}');
      print('Solution depth: ${n.depth}');
      //print(path);
      print(getPath2(n));
    }
    if(closed.contains(n.state)) continue; //BURADA state bulamazsa koordinat x ve y lerini eşlemek lazım
    closed.add(n.state);
    for(Node nd in expand(n, problem)){
      open.push(nd);
    }
  }
}

List<Node> expand(Node n, Problem p){
  List<Node> list = [];
  if(n.coor.x>0 && p.grid[n.coor.x-1][n.coor.y].color == 1) {
    list.add(Node(Coordinate(n.coor.x-1, n.coor.y), Action(-1, 0, 100), n, p.grid[n.coor.x-1][n.coor.y]));
  }
  if(n.coor.x<p.w-1 && p.grid[n.coor.x+1][n.coor.y].color == 1) {
    list.add(Node(Coordinate(n.coor.x+1, n.coor.y), Action(1, 0, 100), n, p.grid[n.coor.x+1][n.coor.y]));
  }
  if(n.coor.y>0 && p.grid[n.coor.x][n.coor.y-1].color == 1) {
    list.add(Node(Coordinate(n.coor.x, n.coor.y-1), Action(0, -1, 100), n, p.grid[n.coor.x][n.coor.y-1]));
  }
  if(n.coor.y<p.h-1 && p.grid[n.coor.x][n.coor.y+1].color == 1) {
    list.add(Node(Coordinate(n.coor.x, n.coor.y+1), Action(0, 1, 100), n, p.grid[n.coor.x][n.coor.y+1]));
  }
  //print('$n => $list');
  return list;
}

void getPath(List<Action> path, Node n){
  if(n.parent != null) {
    path.insert(0, n.action);
    getPath(path, n.parent);
  }
}

List<Action> getPath2(Node n){
  if(n.parent != null){
    return  getPath2(n.parent) + [n.action];
  }
  else {
    return [];
  }
}
class Action{ // Ajanın yapabileceği hareketi temsil eden sınıf.
  int x, y; // x ve y [-1, 0, 1] olabilir. Yapılan eylemi temsil eder.
  // [0, 1]  -> Bir adım aşağı
  // [0, -1] -> Bir adım yukarı
  // [1, 0]  -> Bir adım sağa
  // [-1, 0] -> Bir adım sola
  int cost; // Eylemin maliyetini temsil eder.
  Action(this.x, this.y, this.cost);

  @override
  String toString(){
    return '[$x, $y]';
  }
}