// The following short XML file called "sites.xml" is parsed 
// in the code below. It must be in the project's "data" directory
// <?xml version="1.0"?>
// <websites>
//   <site id="0" url="processing.org">Processing</site>
//   <site id="1" url="mobile.processing.org">Processing Mobile</site>
// </websites>

XMLElement xml;

void setup() {
  size(200, 200);
  xml = new XMLElement(this, "sites.xml");
  int numSites = xml.getChildCount();
  for (int i = 0; i < numSites; i++) {
    XMLElement kid = xml.getChild(i);
    int id = kid.getInt("id"); 
    String url = kid.getString("url"); 
    String site = kid.getContent();
    println(id + " : " + url + " : " + site);    
  }
}

