import 'package:flutter/material.dart';
import 'package:fznews/http/tongji_api.dart';
import 'package:fznews/tongji/editor_flow.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/button_group.dart';
import 'package:fznews/widget/news_card_with_flow.dart';

class ArticleRank extends StatefulWidget {
  final callback;
  final params;
  ArticleRank({Key key,this.callback,this.params}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _ArticleRankState();
  }
}
class _ArticleRankState extends State<ArticleRank> with AutomaticKeepAliveClientMixin{
    List<ButtonData> btns;
    ButtonGroupWidget btngroup;
    ScrollController _scrollController;
    List<dynamic> _articles;
    Tongji params;
    @override
    void dispose(){
      super.dispose();
      _scrollController.dispose();
    }
    @override
    void initState(){
      super.initState();
      print('init ArticleRank');
      _scrollController=ScrollController();
      setParams();
       _articles=List();
      btns =  <ButtonData>[
        ButtonData(title: '最近7天', icon: Icons.directions_boat, handler:(){
          params.body.metrics="文章top50-最近7天";
          getData();
          // callback({"start": start,"end": end});
        }),
        ButtonData(title: '最近30天', icon: Icons.directions_bus, handler:(){
          params.body.metrics="文章top50-最近30天";
          getData();
        }),
        ButtonData(title: '昨天', icon: Icons.directions_bike, handler:(){
          params.body.metrics="文章top50-昨天";
          getData();
        }),
      ];

      btngroup=ButtonGroupWidget(datas:btns,btnShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),btnTextStyle: TextStyle(fontSize: 10),callback: (index){
            // print('按钮$index 被激活');
            btns[index].handler();
      },);
      getData();
      
    }
  void setParams(){
    params = Tongji();
    params.body.method = "visit/article/flowWithAvators";
    params.body.metrics="文章top50-最近7天";
    params.body.maxResults = 50;
    params.body.startIndex = 0;
    params.body.total = 0;
  }
  void getData(){
    TongjiAPI.getData(params.toJson()).then((data){
      if (data["status"]!=200) {
          return;
      }
      var result = Tongji.fromJson(data["message"]);
        _articles=result.body.data[0];
        setState(() {
          
        });
    });
  }
  @override
  Widget build(BuildContext context){
    super.build(context);
    return Center(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 60,
              minHeight: 60,
              child: Center(
                child: ButtonGroupWidget(datas: btns,btnShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),btnTextStyle: TextStyle(fontSize: 10),callback: (index){
                      print('按钮$index 被激活');
                      btns[index].handler();
                },),
              )
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context,int index){
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: NewsCardWithFlow(
                      title: _articles[index]["title"],
                      source: '点击量:${_articles[index]["pv_count"]}  访客数:${_articles[index]["visitor_count"]}',
                      imgUrl: _articles[index]["avatar"],
                    )
                  ),
                );
              },
              childCount: _articles.length,
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600,
              crossAxisSpacing: 10.0,
              childAspectRatio: 5
            ),
          ),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
  
}