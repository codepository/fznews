// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.




import 'package:fznews/http/user_api.dart';
import 'package:test/test.dart';


void main() {
  test('unit test',(){
    Deee a=Deee("abc");
     Deee b=a;
     b.name="cba";
     print("a:${a.name},b:${b.name}");
  });
}
class Deee{
  String name;
  Deee(this.name);
}
