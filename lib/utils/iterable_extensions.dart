extension IterableExtensions<T> on Iterable<T> {
  num sumBy(num Function(T item) extractKey) {
    return fold(0, (accumulator, element) => accumulator + extractKey(element));
  }

  T maxBy<TKey extends Comparable<TKey>>(TKey Function(T item) keySelector) {
    return fold(
      first,
      (previousValue, element) =>
          keySelector(element).compareTo(keySelector(previousValue)) < 0
              ? element
              : previousValue,
    );
  }
}
