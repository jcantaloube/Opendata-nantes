import processing.opengl.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

PImage datanantesPictoParking;
int parkingPictoTaille=20;
float xy[];
float[] x= new float[50];
float[] y= new float[50];
boolean parkingAffichee;

de.fhpotsdam.unfolding.Map carte;

String datanantesCle = "3O9NRRB5VI21JW6";
String datanantesCommande = "getDisponibiliteParkingsPublics";
String datanantesVersion = "1.0";
int NombreParkings;
String[] nom = new String[50];
String[] dispo = new String[50];
String[] IdObj = new String[50];
String nom_parking;
String disponibilite;

// Fonte
PFont maFonte;

void setup() 
{
  // Dimension de la fenêtre
  size(1000, 600);
  // Chargement de la fonte
  maFonte = loadFont("Geneva-15.vlw");
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
  // Nous accèdons d'abord aux noeuds <station>
  XMLElement[] parkingsXML = xml.getChildren("answer/data/Groupes_Parking/Groupe_Parking");
  NombreParkings = parkingsXML.length;
  for (int i=0;i<NombreParkings;i++) {
    XMLElement nom_XML = parkingsXML[i].getChild("Grp_nom");
    nom[i] = nom_XML.getContent();
    XMLElement dispo_XML = parkingsXML[i].getChild("Grp_disponible");
    dispo[i] = dispo_XML.getContent();
    XMLElement IdObj_XML = parkingsXML[i].getChild("IdObj");
    IdObj[i] = IdObj_XML.getContent();
  }
}

void draw() 
{
  background(#dfdfdf);
  carte.draw();
  for (int j=0;j<NombreParkings;j++) {
    String chaine[] = loadStrings("Equipements_publics_deplacement.csv"); // the name and extension of the file to import!
    for (int i = 0; i < chaine.length; ++i)
    {
      String[] element = split(chaine[i], ';');       // use the split array with character to isolate each component
      String[] split_element = split(element[0], ',');
      if (split_element[0].equals(IdObj[j]) == true) {
        String[] split_lat = split(element[15], ',');
        String joine_lat = join(split_lat, ".");
        float lat=float(joine_lat);
        String[] split_lon = split(element[14], ',');
        String joine_lon = join(split_lon, ".");
        float lon=float(joine_lon);
        Location position = new Location(lat, lon);
        // Mets à jour la position de la station sur la carte (en pixels)
        xy = carte.getScreenPositionFromLocation(position);
        x[j]=xy[0];
        y[j]=xy[1];
        // Affichage du picto pour cette station
        image(datanantesPictoParking, xy[0]-parkingPictoTaille/2, xy[1]-parkingPictoTaille/2, parkingPictoTaille, parkingPictoTaille);
      }
    }
    // Affichage des infos si un parking a été cliqué
    if (parkingAffichee)
    {
      float x=4, y=4;
      noStroke();
      fill(#dfdfdf);
      rect(y, x, 200, 50);
      textFont(maFonte, 12);
      fill(0);
      y+=12;
      text(nom_parking, x+4, y+4);
      y+=16;
      text(disponibilite, x+4, y+4);
    }
  }
}

void mousePressed()
{
  parkingAffichee=false;
  for (int i=0;i<NombreParkings;i++) {
    if (mouseX>=x[i]-parkingPictoTaille/2 && mouseX<=x[i]+parkingPictoTaille/2 && mouseY>=y[i]-parkingPictoTaille/2 && mouseY<=y[i]+parkingPictoTaille/2)
    {
      nom_parking=nom[i];
      disponibilite=dispo[i];
      parkingAffichee = true;      
    }
  }
}

