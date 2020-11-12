import 'package:flutter/material.dart';
import 'package:fznews/widget/search/search_route.dart';

class SearchPage extends StatelessWidget{
  final params;
  SearchPage({Key key,this.params}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return SearchRoutePage();
  }
  
}