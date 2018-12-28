import "package:akali/api/api.dart";
import 'package:test/test.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

void main(List<String> args) {
  final tester = TestHarness<AkaliApi>();
  tester.options.context = {};
  tester.install();

  group('Akali API', () {
    test('simple test', () {
      // TODO: write tests
    });
  });
}
