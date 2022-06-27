import 'dart:convert';

Meme memeFromJson(String str) => Meme.fromJson(json.decode(str));

String memeToJson(Meme data) => json.encode(data.toJson());

class Meme {
    Meme({
        required this.postLink,
        required this.subreddit,
        required this.title,
        required this.url,
        required this.nsfw,
        required this.spoiler,
        required this.author,
        required this.ups,
        required this.preview,
    });

    String postLink;
    String subreddit;
    String title;
    String url;
    bool nsfw;
    bool spoiler;
    String author;
    int ups;
    List<String> preview;

    factory Meme.fromJson(Map<String, dynamic> json) => Meme(
        postLink: json["postLink"],
        subreddit: json["subreddit"],
        title: json["title"],
        url: json["url"],
        nsfw: json["nsfw"],
        spoiler: json["spoiler"],
        author: json["author"],
        ups: json["ups"],
        preview: List<String>.from(json["preview"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "postLink": postLink,
        "subreddit": subreddit,
        "title": title,
        "url": url,
        "nsfw": nsfw,
        "spoiler": spoiler,
        "author": author,
        "ups": ups,
        "preview": List<dynamic>.from(preview.map((x) => x)),
    };
}
