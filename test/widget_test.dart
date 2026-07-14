import 'package:flutter_test/flutter_test.dart';

import 'package:credi_app/app/app.dart';

void main() {
  testWidgets('WelcomePage shows the entry actions', (WidgetTester tester) async {
    await tester.pumpWidget(const CrediAppRoot());
    await tester.pump();

    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Registrarse'), findsOneWidget);
  });
}
