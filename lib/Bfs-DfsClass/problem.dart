import 'dart:math';
import 'package:ai_game/Bfs-DfsClass/coordinate.dart';
import 'package:ai_game/Bfs-DfsClass/States.dart';

class Problem{ // Izgara grafik, başlangıç ve amaç durumların koordinatlarının tutulduğu sınıf
  int w, h; // w ve h ızgara grafiğin enini ve boyunu temsil eder.
  Coordinate start, goal; // start başlangıç durumunun, goal ise amaç durumunun koordinatlarını tutar.
  List<List<States>> grid; // Durumların tutulduğu 2 boyutlu liste, örn. grid[0][0], x = 0 ve y = 0 olan durumu tutar.

  Problem(this.w, this.h, this.start, this.goal, this.grid); // Grafiğin elle girildiği constructor
  Problem.random(this.w, this.h, this.start, this.goal): grid = List<List<States>>.generate(h, (i) => List<States>.generate(w, (index) => States(Coordinate(i, index), Random().nextInt(2)), growable: false), growable: false);

  @override
  String toString(){
    String res = 'Grid $h x $w\n';
    for(int i=0;i<w;i++){
      for(int j=0;j<h;j++){
        res += '${grid[i][j].toString()} | ';
      }
      res += '\n';
    }
    return '$res\n***************';
  }
}