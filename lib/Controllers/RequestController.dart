import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestController{
  static Future<dynamic> getRequest(String url) async{
    http.Response response = await http.get(Uri.parse(url));

    try{
      if(response.statusCode == 200){
        String JSonData = response.body;
        var decodeData =jsonDecode(JSonData);
        return decodeData;
      }
      else{
        return "Failed";
      }
    }
    catch(exp){
      return "Failed";
    }

  }

}