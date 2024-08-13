import 'dart:async';

void main() {
  // Create a stream that emits random numbers every second
  // StreamSubscription<int>? _randomStreamSubscription =
  //     Stream.periodic(const Duration(seconds: 1), (count) => Random().nextInt(100))
  //         .listen((randomNumber) {
  //   // Process the random number here
  //   print('Random Number: $randomNumber');
  // });

  final stream =
    Stream<int>.periodic(const Duration(
        seconds: 1), (count) => count * count).take(10);

stream.forEach(print);

  // Remember to cancel the subscription when you're done
  // _randomStreamSubscription.cancel();
}









