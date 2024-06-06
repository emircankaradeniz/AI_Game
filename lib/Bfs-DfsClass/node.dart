import 'package:ai_game/Bfs-DfsClass/States.dart';
import 'package:ai_game/Bfs-DfsClass/coordinate.dart';

import 'action.dart';

class Node{ // Arama Ağacındaki Düğümleri temsil eden sınıf
  Node(this.coor, this.action, this.parent, this.state): depth = parent.depth + 1, cost = parent.cost + action.cost;
  Node.initState(this.coor, this.action, this.state): parent = null, depth = 0, cost = 0; // İlk durumu temsil eden düğüm, ebeveyn düğümü null, derinlik ve maliyeti = 0
  
  Coordinate coor; // Düğümün koordinatı (x, y)
  int depth, cost; // Depth -> derinlik, cost -> düğüme kadar olan maliyet toplamı.
  Action action;   // Düğüme getiren eylem
  var parent;      // Düğümün ebeveyn düğümü, (kök düğüm için null)
  States state;     // Ağaçtaki düğümün grafik üzerinde temsil ettiği durum. (Aynı durum birden fazla düğüm tarafından temsil edilebilir.)

  @override
  String toString(){
    return '${coor.toString()}, $depth, $cost, ${(state.color == 0)?'Siyah':'Beyaz'}, $action';
  }
}