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