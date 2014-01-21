void setup() {
  // télécharge le flux rss portant sur les nouvelles actualités yahoo.com     
  String url = "http://rss.news.yahoo.com/rss/topstories";
  XMLElement rss = new XMLElement(this, url);
  println(rss);
  XMLElement[] links = rss.getChildren("channel/item/link");
  for (int i = 0; i < 4; i++) {
    println(links[i].getContent());
  }
}

