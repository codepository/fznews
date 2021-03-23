import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRequest {
  final client;
  HttpRequest(this.client);
  Future<dynamic> post(String uri, dynamic body, {Map<String, String> headers}) async {
    try {
      http.Response response = await client.post(uri, body: body);
      var result = jsonDecode(response.body);
      return result;
    } catch (e) {
      // print('[uri=$uri] exception e=$e');
      return null;
    }
  }

  Future<dynamic> get(String uri) async {
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      }
    } catch (e) {
      // print('[uri=$uri] exception e=$e');
      return null;
    }
  }

  Future<void> download(String uri, {Map<String, String> headers, String body, String filename}) async {
    //  headers=Map();
    //  headers["Content-Type"]="application/octet-stream";
    // //  headers["Content-Disposition"]="attachment;filename=export.csv";
    http.Response response = await client.post(uri, body: body);
    html.Element elink = html.document.createElement("a");
    elink.setAttribute("download", filename ?? "export.csv");
    elink.style.display = 'none';
    var uris = Uri.dataFromBytes(response.bodyBytes);
    elink.setAttribute("href", uris.toString());
    html.document.body.append(elink);
    elink.click();
    elink.remove();
  }

  Future<String> upload({String uri, String token, String filetype, String method}) async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    String responseMsg;
    bool finish = false;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      var formData = html.FormData();
      formData.appendBlob("filename", files[0].slice(), files[0].name);
      formData.append("token", token);
      formData.append("filetype", filetype);
      formData.append("method", method);
      var req = html.HttpRequest();
      req.open("POST", uri);
      req.send(formData);
      req.onLoadEnd.listen((e) {
        // html.window.alert(req.responseText);
        responseMsg = req.responseText;
        finish = true;
      });
    });
    const timeout = Duration(milliseconds: 200);
    await Future.doWhile(() async {
      await Future.delayed(timeout);
      return !finish;
    });
    return responseMsg;
  }
}
