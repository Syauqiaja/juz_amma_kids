extension ListIntExtensions on int{
  List<int> to(int end) {
    if (this <= end) {
      return List.generate(end - this + 1, (index) => this + index);
    } else {
      return List.generate(this - end + 1, (index) => this - index);
    }
  }
}

extension IterableMapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) transform) {
    int index = 0;
    return map((e) => transform(index++, e));
  }
}

extension FirstWhereOrNullExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}