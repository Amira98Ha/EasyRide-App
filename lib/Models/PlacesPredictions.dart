class PlacesPredictions{
  late String secondary_text;
  late String main_text;
  late String place_id;

  PlacesPredictions({
    required this.secondary_text, required this.main_text, required this.place_id
  });

  PlacesPredictions.formJson(Map<String, dynamic> json){
    secondary_text = json ["structured_formatting"]["secondary_text"];
    place_id = json ["place_id"];
    main_text = json ["structured_formatting"]["main_text"];

  }
}