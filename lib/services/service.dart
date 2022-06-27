import 'package:http/http.dart' as http;
import 'package:memeshare/services/mappingfile.dart';

Future<String> getImageFromAPI() async {
  final Uri apiURL = Uri.parse("https://meme-api.herokuapp.com/gimme");
  final response = await http.get(apiURL);
  return memeFromJson(response.body).url;
}