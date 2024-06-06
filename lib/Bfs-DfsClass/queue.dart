class Queue<E>{
  Queue(): _storage = <E>[];

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