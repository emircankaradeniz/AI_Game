
import 'package:ai_game/Bfs-DfsClass/States.dart';
import 'package:ai_game/Bfs-DfsClass/problem.dart';
import 'package:ai_game/Bfs-DfsClass/queue.dart';
import 'action.dart';
import 'coordinate.dart';
import 'node.dart';

void main(){
  List<List<States>> grid = List<List<States>>.generate(10, (i) => List<States>.generate(10, (index) => States(Coordinate(i, index), 1), growable: false), growable: false);
  grid[2][0].color = 0; 
  grid[1][1].color = 0; grid[2][1].color = 0; grid[4][1].color = 0; grid[8][1].color = 0; 
  grid[5][2].color = 0; grid[7][2].color = 0;
  grid[6][3].color = 0;
  grid[2][4].color = 0;
  grid[2][5].color = 0; grid[8][5].color = 0;
  grid[1][6].color = 0; grid[2][6].color = 0; grid[3][6].color = 0; grid[7][6].color = 0; grid[9][6].color = 0;
  grid[5][7].color = 0; grid[7][7].color = 0;
  grid[0][8].color = 0; grid[6][8].color = 0; grid[9][8].color = 0;
  grid[5][9].color = 0;
  //Görseldeki 10x10 ızgara grafiği elle oluşturuyoruz.
  
  Problem problem = Problem(10, 10, Coordinate(1,7), Coordinate(6,2), grid); // Görseldeki başlangıç ve amaç durumlarına göre problemi oluşturuyoruz.
  
  graphSearchBFS(problem); // Toplam derinliği, toplam maliyeti ve eylemlerin Başlangıç durumundan Amaç durumuna kadar olan sıralı listesini yazdıracak.
  graphSearchDFS(problem); // Eylem listesi -> [[0,1], [1,1], ...., [0,-1]] şeklinde listeyi yazdması yeterli.
}

List<Action> graphSearchBFS(Problem problem){
  List<States> closed = [];
  Queue<Node> open = Queue();
  List<Action> path = [];
  open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
  // Burayı doldurun
  return [];
}

List<Action> graphSearchDFS(Problem problem){
  // Burayı doldurun
  return [];
}

List<Node> expand(Node n, Problem p){
  // Burayı doldurun
  /* Bir düğümün çocuk düğümlerini bulmak için izin verilen eylemler (Siyaha gidilemez, sadece yukarı, aşağı, sağa ve sola gidilebilir)
    çerçevesinde oluşturulan düğümleri liste olarak döndürür. Döndürülen listedeki düğümler fonksiyonda açık listeye eklenir. */
  return [];
}

void getPath(List<Action> path, Node n){
  // Burayı doldurun
  // Girilen çözüm düğümü için, ilk düğüme ulaşana kadar ebeveyn düğümleri ziyaret edip
  // Ziyaret edilen düğümlerdeki Action öğesini path listesine ekleyecek.
  // Recursive yazmak daha kolay, içine girilen path listesini sonuç olarak yazdırabilirsiniz.
}
