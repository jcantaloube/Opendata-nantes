import processing.opengl.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

PImage datanantesPictoParking;
int parkingPictoTaille=20;
float xy[];

de.fhpotsdam.unfolding.Map carte;

String datanantesCle = "3O9NRRB5VI21JW6";
String datanantesCommande = "getDisponibiliteParkingsPublics";
String datanantesVersion = "1.0";

String nom_1;
String dispo_1;
String IdObj_1;

void setup() 
{
  // Dimension de la fenêtre
  size(1000, 600);
  // Création de la carte
  // Nantes est située à 47.2172 de latitude et -1.591 de longitude
  carte = new de.fhpotsdam.unfolding.Map(this, new Microsoft.AerialProvider());
  carte.zoomAndPanTo(new Location(47.215f, -1.55f), 14);
  // Cette ligne de code permet d'avoir les comportements de navigation par défaut
  // Glisser / Déplacer + Zoom avec la mollette
  MapUtils.createDefaultEventDispatcher(this, carte);
  // Chargement des pictos
  datanantesPictoParking = loadImage("Picto B+M+P+Parking-100x100.png");
  // Addresse à laquelle nous allons accéder aux données
  String url = "http://data.nantes.fr/api/"+datanantesCommande+"/"+datanantesVersion+"/"+datanantesCle;
  // Chargement des données dans un objet permettant de lire le XML
  XMLElement xml = new XMLElement(this, url);
  // On est prêt à analyser les données à présent
  // Nous accèdons d'abord aux noeuds <Groupe_Parking>
  XMLElement[] parkingsXML = xml.getChildren("answer/data/Groupes_Parking/Groupe_Parking");
  XMLElement nom_1_XML = parkingsXML[1].getChild("Grp_nom");
  nom_1 = nom_1_XML.getContent();
  XMLElement dispo_1_XML = parkingsXML[1].getChild("Grp_disponible");
  dispo_1 = dispo_1_XML.getContent();
  XMLElement IdObj_1_XML = parkingsXML[1].getChild("IdObj");
  IdObj_1 = IdObj_1_XML.getContent();
}

void draw() 
{
  background(#dfdfdf);
  carte.draw();
  String chaine[] = loadStrings("Equipements_publics_deplacement.csv");
  for (int i = 0; i < chaine.length; ++i)
  {
    String[] element = split(chaine[i], ';');
    String[] split_element = split(element[0], ',');
    if (split_element[0].equals(IdObj_1) == true) {
      String[] split_lat = split(element[15], ',');
      String joine_lat = join(split_lat, ".");
      float lat=float(joine_lat);
      String[] split_lon = split(element[14], ',');
      String joine_lon = join(split_lon, ".");
      float lon=float(joine_lon);
      Location position = new Location(lat, lon);
      // Mets à jour la position du parking sur la carte (en pixels)
      xy = carte.getScreenPositionFromLocation(position);
      // Affichage du picto pour ce parking
      image(datanantesPictoParking, xy[0]-parkingPictoTaille/2, xy[1]-parkingPictoTaille/2, parkingPictoTaille, parkingPictoTaille);
    }
  }
}
