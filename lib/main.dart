import 'package:flutter/material.dart';
import 'package:fznews/fluro_router.dart';
import 'package:fznews/layout/appContainer.dart';
import 'package:fznews/routes.dart';
import 'app.dart';

// import 'package:flutter/rendering.dart';


void main() {
  // debugPaintSizeEnabled = true;
  // 加载二进制文件
    //   print("widows:${Platform.isWindows}");
    // Map<String, String> envVars = Platform.environment;
    // print('env:$envVars');
  WidgetsFlutterBinding.ensureInitialized();
  // App.getConf().then((String val){
  //   App.loadConf(val);
  //   runApp(MyApp());
  // });
     App.getConf().then((String val){
       App.loadConf(val).then((v)=>runApp(MyApp()));
     });
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MaterialApp(
        theme: ThemeData(backgroundColor: Colors.white),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: AppContainer(),
        ),
        // 在以下注册的页面可以直接通过url访问
          routes: Routes.getNeedsRoutesRegistry(context),
          initialRoute: "/",
          // onGenerateRoute: FluroRouter.onGenerateRoute,
      )
    );
  }
}
class RestartWidget extends StatefulWidget{
  final Widget child;
  RestartWidget({
    Key key, @required this.child
  }):assert(child!=null),super(key:key);
  static restartApp(BuildContext context){
    final _RestartWidgetState state = context.findAncestorStateOfType<_RestartWidgetState>();
    state.restartApp();
  }
  @override
  State<StatefulWidget> createState() {
    
    return _RestartWidgetState();
  }
  
}
class  _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();
  void restartApp(){
    setState(() {
      key = UniqueKey();
      print("restart key:$key");
      print("token:${App.userinfos.token}");
    });
  }
  @override
  void dispose() {
    super.dispose();
    // print("========销毁APP===");

  }
  @override
  Widget build(BuildContext context) {
    
    return Container(
      key:key,
      child: widget.child,
    );
  }
  
}