import 'package:flutter/material.dart';
import 'package:fznews/http/tongji_api.dart';
import 'package:fznews/tongji/editor_detail_title.dart';
import 'package:fznews/tongji/editor_flow.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/news_card_widget.dart';
import 'package:fznews/widget/sliver_grid_widget.dart';
import 'package:fznews/widget/tabbar_card.dart';
import 'package:fznews/widget/webflow_table_card.dart';

class EditorDetail extends StatefulWidget{

  final params;
  EditorDetail({Key key,this.params}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _EditorDetailState();
  }
  
}
class _EditorDetailState extends State<EditorDetail>{
  String _username;
  Tongji thisyearParams = Tongji();
  Tongji articlePars =Tongji();
  Color pickColor = Colors.blue;
  bool loading = false;
  bool noMore = false;
  List<dynamic> editorDetais;
  List<dynamic> articles;
  // 查询天数间隔
  int searchDays;
  int pageNumber=1;
  List<Widget> gridWidgets;
  double maxGridWidth;
  List<TabItem> tabs;
  ScrollController _scrollController = ScrollController();
  double gridHeight=500;
  // 背景颜色
  Color backGroudColor=Colors.white;
  double get screenH => MediaQuery.of(context).size.height;
  @override
  void dispose(){
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    _username=widget.params['username']?.first;
    initParams();
    gridWidgets = List();
    articles=List();
    maxGridWidth = 600;
    getGridItems();
    getArticles();
    _scrollController.addListener(
      (){
        if (_scrollController.position.pixels>=_scrollController.position.maxScrollExtent-50){
          getArticles();
        }
      }
    );
    var tabTitles = ["今年","最近7天","最近30天"];
    tabs=tabTitles.map((t){
      return TabItem(t);
    }).toList();
  }
  void initParams(){
    thisyearParams.body.method = "visit/editor/details";
    thisyearParams.body.startDate = '${DateTime.now()}'.substring(0,4)+'-01-01';
    thisyearParams.body.endDate = '${DateTime.now()}'.substring(0,10);
    thisyearParams.body.maxResults = 20;
    thisyearParams.body.startIndex = 0;
    thisyearParams.body.userName = _username;

    articlePars.body.method = "visit/editor/articles";
    articlePars.body.startDate = '${DateTime.now()}'.substring(0,4)+'-01-01';
    articlePars.body.endDate = '${DateTime.now()}'.substring(0,10);
    articlePars.body.maxResults = 20;
    articlePars.body.startIndex = 0;
    articlePars.body.userName = _username;
  }
  void getArticles() async{
    if (noMore){
      return;
    }
    if (articlePars.body.startIndex !=0 &&( articlePars.body.total<=articles.length || articlePars.body.startIndex>=articlePars.body.total)){
      noMore = true;
      return;
    }
    if (!loading){
      loading=true;
      articlePars.body.startIndex = (pageNumber-1)*articlePars.body.maxResults;
      TongjiAPI.getData(articlePars.toJson()).then((data){
        if (data["status"]!=200){
          return;
        }
        var tj=Tongji.fromJson(data["message"]);
        articlePars.body.total = tj.body.total;
        pageNumber++;
        articles.addAll(tj.body.data[0]);

        DateTime start = DateTime.parse(articlePars.body.startDate);
        DateTime end = DateTime.parse(articlePars.body.endDate);
        searchDays=end.difference(start).inDays+1;
        setState(() {
          loading=false;
        });
      });
    }
  }
  refreshArticles(String title){
    articles.clear();
    articlePars.body.startIndex = 0;
    articlePars.body.total = 0;
    pageNumber=1;
    switch (title) {
      case "今年":
        articlePars.body.startDate = '${DateTime.now()}'.substring(0,4)+'-01-01';
        
        break;
      case "最近7天":
        articlePars.body.startDate = '${DateTime.now().subtract(Duration(days:6))}'.substring(0,10);
        break;
      case "最近30天":
        articlePars.body.startDate = '${DateTime.now().subtract(Duration(days:29))}'.substring(0,10);
        break;
      default:
    }
    
    getArticles();
  }
  Future<dynamic> getEditorDetails() async{
    var result = await TongjiAPI.getData(thisyearParams.toJson());
    if (result["status"]!=200){
      return;
    }
    var tj=Tongji.fromJson(result["message"]);
    return tj.body.data;
  }

  void getGridItems(){
    if (this.editorDetais==null){
      getEditorDetails().then((data){
        this.editorDetais = data;
  
        getGridWidget();
        
      });
    } else {
      getGridWidget();
    }
  }
  void getGridWidget(){
    gridWidgets.clear();
    gridWidgets.add(
      EditorDetailTitleWidget(
          TitleDetail('${editorDetais[0][0]["realname"]}/ ${editorDetais[0][0]["username"]}',"流量:${editorDetais[0][0]["pv_count"]}\n访客数:${editorDetais[0][0]["visitor_count"]}\n贡献下游浏览量:${editorDetais[0][0]["outward_count"]}\n退出页面次数:${editorDetais[0][0]["exit_count"]}\n停留时长:${editorDetais[0][0]["average_stay_time"]}\n",editorDetais[0][0]["avatar"],editorDetais[0][0]["star"]),
          width: maxGridWidth,
          height: gridHeight,
          aspectRatio: 2,
          backGroudColor:backGroudColor,
        )
    );

    gridWidgets.add(
      WebflowTableCard(width: maxGridWidth,height: gridHeight,data: editorDetais[1],backGroudColor:backGroudColor)
    );
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    // print('build editor detail');
    return Center(
      child: Scaffold(
      appBar: AppBar(
          title: Text('编辑'),
          centerTitle: true,
          backgroundColor: pickColor,
        ),
      backgroundColor: pickColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
         SliverGridWidget(items: gridWidgets,childAspectRatio: 2,maxCrossAxisExtent: maxGridWidth,gridHeight: gridHeight,),
         SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 80,
              minHeight: 80,
              child: Container(
                child: TabBarCard(tabs: tabs,unselectedLabelColor:Colors.white,callback: (val){
                  refreshArticles(tabs[val].title);
                },)
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 100,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context,int index){
                return NewsCard(
                  data: NewsData(days:searchDays,title:articles[index]["title"],source:articles[index]["source"],pvCount: articles[index]["pv_count"],visitorCount: articles[index]["visitor_count"]),
                );
              },
              childCount: articles.length
            ),
          ),
        ],
      )
    ),
    );
  }
}