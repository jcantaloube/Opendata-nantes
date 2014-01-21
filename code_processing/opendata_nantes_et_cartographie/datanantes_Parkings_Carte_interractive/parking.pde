class Parking
{
  String nom;
  String id;
  int placesDisponibles;
  int placesLibres;
  float xy[];
  
  Parking(XMLElement parkingXML)
  {
    XMLElement nomXML = parkingXML.getChild("Grp_nom");
    XMLElement idXML = parkingXML.getChild("IdObj");
    XMLElement dispoXML = parkingXML.getChild("Grp_exploitation");
    XMLElement libreXML = parkingXML.getChild("Grp_disponible");

    this.placesDisponibles = int(dispoXML.getContent());
    this.placesLibres = int(libreXML.getContent());
    this.nom = nomXML.getContent();
    this.id = idXML.getContent(); 
  }
}
