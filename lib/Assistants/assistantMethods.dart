
import 'package:easy_ride_app/Assistants/requestAssistant.dart';
import 'package:geolocator/geolocator.dart';
import '../GoogleMapsConfig.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position, context) async{
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?"
        "latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);

    placeAddress = response["results"][0]["formatted_address"];
    //Just for Test
    print("This is your address:: $placeAddress");
    return placeAddress;

  }
}