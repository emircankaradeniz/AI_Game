import 'package:ai_game/Bfs-DfsClass/coordinate.dart';

class States{  // Grafikteki durumları temsil eden sınıf.
  Coordinate coor; // x ve y -> 0 ile (problem bouyutu-1) arasında olabilir. Durumun haritadaki konumunu temsil eder.
  int color; // 0 = siyah, 1 = beyaz
  States(this.coor, this.color);

  @override
  String toString(){
    return 'Row: ${coor.x} | Col: ${coor.y} | ${(color == 0) ? 'Siyah' : 'Beyaz'} ';
  }

}