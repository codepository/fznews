import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/user/department_widget.dart';
import 'package:fznews/user/roles_widget.dart';
import 'package:fznews/user/users_list.dart';
import 'package:fznews/widget/app/app_basic.dart';

class UsersWidget extends StatefulWidget {
  final Map<String, dynamic> params;
  UsersWidget({Key key, this.params}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UsersWidgetState();
  }
}

class _UsersWidgetState extends State<UsersWidget> with TickerProviderStateMixin {
  TabController tabController;
  List<RouteHandler> choices;
  @override
  void initState() {
    super.initState();
    choices = <RouteHandler>[
      RouteHandler(title: '用户', icon: Icons.people, handler: ({Map<String, dynamic> params}) => UsersList()),
      RouteHandler(title: '角色', icon: Icons.face, handler: ({Map<String, dynamic> params}) => RolesWidget()),
      RouteHandler(title: '部门', icon: Icons.group, handler: ({Map<String, dynamic> params}) => DepartmentWidget()),
    ];
    tabController = TabController(length: choices.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicApp(
      title: Text('用户管理'),
      tabController: tabController,
      tabs: choices,
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: () => App.router.navigateTo(context, Routes.Dashboard),
      ),
    );
  }
}
