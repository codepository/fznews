import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fznews/http/tongji_api.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/select.dart';

import '../../app.dart';

class SearchToppageWidget extends StatefulWidget {
  final Map<String, dynamic> params;
  final List<dynamic> sitelist;
  SearchToppageWidget({Key key, this.params, this.sitelist}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _StateSearchToppageWidget();
  }
}

class _StateSearchToppageWidget extends State<SearchToppageWidget> {
  TextEditingController site;
  TextEditingController start;
  TextEditingController end;
  TextEditingController searchWord;
  Map<String, dynamic> params;
  @override
  void dispose() {
    super.dispose();
    site.dispose();
    start.dispose();
    end.dispose();
    searchWord.dispose();
  }

  @override
  void initState() {
    super.initState();
    params = widget.params ?? Map();
    site = TextEditingController(text: params["domain"] ?? "");
    start = TextEditingController(text: params["start_date"] ?? "");
    end = TextEditingController(text: params["end_date"] ?? "");
    searchWord = TextEditingController(text: params["searchWord"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        children: <Widget>[
          Select(
            textEditingController: site,
            items: widget.sitelist,
            onChange: (keys, vals) {
              params["siteID"] = "$keys";
              params["domain"] = vals;
            },
            keyTag: "site_id",
            valueTag: "domain",
            hintText: "选择站点",
          ),
          TextField(
            maxLines: 1,
            controller: start,
            onChanged: (val) {
              params["start_date"] = val;
            },
            decoration: InputDecoration(
              hintText: "开始日期,如：2020-02-03",
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
          TextField(
            maxLines: 1,
            controller: end,
            onChanged: (val) {
              params["end_date"] = val;
            },
            decoration: InputDecoration(
              hintText: "结束日期,如：2020-02-03",
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
          TextField(
            maxLines: 1,
            controller: searchWord,
            onChanged: (val) {
              params["searchWord"] = val;
            },
            decoration: InputDecoration(
              hintText: "输入网址,如：http://gov.fznews.com.cn/meiti/2015-5-11/2015511b6Sh5Ubn2215555.shtml",
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
