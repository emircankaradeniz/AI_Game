class Coordinate{
  int x, y; // Izgara grafik üzerinde Durumun x ve y koordinatları.
  // (x = 0, y = 0) sol üst köşe, x arttıkça sağa, y arttıkça aşağı yönde ilerler.
  // (x, y) = (3, 4) durumunda, eylem = [0, 1] yapılırsa => (x, y) = (3, 5) durumuna gelinir.

  Coordinate(this.x, this.y);

  @override
  String toString(){
    return '($x, $y)';
  }
}