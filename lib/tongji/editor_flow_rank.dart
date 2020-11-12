import 'package:flutter/material.dart';
import 'package:fznews/http/tongji_api.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/movies_stack_card.dart';

class EditorFlowRankSliverGrid extends StatefulWidget{
  EditorFlowRankSliverGrid({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {

    return _EditorFlowRankSliverGridState();
  }

}
class _EditorFlowRankSliverGridState extends State<EditorFlowRankSliverGrid> with AutomaticKeepAliveClientMixin{
  Tongji monthParams = Tongji();
  List<dynamic> monthDataList;
  List<String> monthEditorAvatars = [];
  Tongji weekParams = Tongji();
  List<dynamic> weekDataList;
  List<String> weekEditorAvatars = [];
  List<Widget> items=[];
  Map<String,dynamic> datas=Map();
  double maxWidth=600;
  double ratio=3;
  // 每个grid的高度
  double gridHeight = 200.0;
  @override
  void initState(){
    super.initState();
    print('init EditorFlowRankSliverGrid');
    initParam();
    monthDataList=List();
    weekDataList=List();
    getItems();
  }
  void setItems(){
    // print("setitems");
    items.clear();
    datas.forEach((val,data){
        // print("val:$val");
        items.add(MoviesStackCard(
          data.map((d){
            return d["avatar"];
          }).toList(),
          val,
          maxWidth: getMaxWidthOfMovieStackCard(),
      ),);
    });
    setState(() {
   
    });
  }
  void getItems(){

    if (this.datas.length==0) {
 
      getDatas().then((result){
        // // print("data:$result");
        this.datas = result;
        setItems();
      });
    } else {
      // // print('editor flow rank getitems 3');
      setItems();
    }
  }
  
  double getMaxWidthOfMovieStackCard(){
    double mediawidth = MediaQuery.of(context).size.width;
    if (mediawidth>1200){
      maxWidth = 0.4*mediawidth;
      this.ratio = 0.4*mediawidth/gridHeight;
      return 0.4*mediawidth;
    }
    if (mediawidth>800){
      this.ratio = 0.6*mediawidth/gridHeight;
      return 0.5*mediawidth;
    }
    if (mediawidth>400){
      this.ratio =1.2*mediawidth/gridHeight;
      return mediawidth;
    }
    this.ratio = 1.2*mediawidth/gridHeight;
    return mediawidth;
  }
  void initParam(){
    monthParams.body.method = "visit/editor/flowWithAvators";
    monthParams.body.startDate = '${DateTime.now().subtract(Duration(days:29))}'.substring(0,10);
    monthParams.body.endDate = '${DateTime.now()}'.substring(0,10);
    monthParams.body.maxResults = 10;
    monthParams.body.startIndex = 0;

    weekParams.body.method = "visit/editor/flowWithAvators";
    weekParams.body.startDate = '${DateTime.now().subtract(Duration(days:6))}'.substring(0,10);
    weekParams.body.endDate = '${DateTime.now()}'.substring(0,10);
    weekParams.body.maxResults = 10;
    weekParams.body.startIndex = 0;
  }
  Future<dynamic> getDatas() async{
    // // print('get datas1');
    Map<String,dynamic> result=Map();
    var data1 = await TongjiAPI.getData(monthParams.toJson());
    var result1;
    if (data1["status"]==200) {
        result1 = Tongji.fromJson(data1["message"]);
    }
    // // print('get datas2');
    
    
    if (result1!=null&&result1.body.data!=null){
       monthDataList = result1.body.data[0];
       result["月度流量排行"]=monthDataList;
    }
    var data2 = await TongjiAPI.getData(weekParams.toJson());
    var result2 ;
    if (data2["status"]==200) {
        result2 = Tongji.fromJson(data2["message"]);
      }
    // // print('get datas3');
    
    //  // print('get datas3.1');
    if (result2!=null&&result2.body.data!=null) {
      weekDataList = result2.body.data[0];
      result["每周流量排行"]=weekDataList;
    }
 
 

    return result;
  }
  @override
  void dispose(){
    super.dispose();
    datas.clear();
    weekDataList.clear();
    monthDataList.clear();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context,int index) {
          return items[index];
        },
        childCount: items.length
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: getMaxWidthOfMovieStackCard(),
        crossAxisSpacing: 10.0,
        childAspectRatio: this.ratio,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}