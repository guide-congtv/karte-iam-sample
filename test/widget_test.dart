import 'package:flutter_test/flutter_test.dart';
import 'package:karte_iam_flutter_sample/main.dart';

void main() {
  testWidgets('renders the five tab buttons', (tester) async {
    await tester.pumpWidget(const SampleApp());
    for (final label in ['通常', 'IFD', 'OCO', 'IFDOCO', 'トレール']) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
