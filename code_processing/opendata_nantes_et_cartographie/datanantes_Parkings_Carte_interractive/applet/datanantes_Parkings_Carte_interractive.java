import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import de.fhpotsdam.unfolding.*; 
import de.fhpotsdam.unfolding.geo.*; 
import de.fhpotsdam.unfolding.utils.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class datanantes_Parkings_Carte_interractive extends PApplet {

// http://data.nantes.fr/les-donnees/documentation-de-lapi/getdisponibiliteparkingspublics/
// Unfolding : http://unfoldingmaps.org/ 






PImage datanantesPictoParking;

String datanantesCle = "3O9NRRB5VI21JW6";
String datanantesCommande = "getDisponibiliteParkingsPublics";
String datanantesVersion = "1.0";

// Fonte
PFont maFonte;

Parking parkingAffichee=null;
int parkingPictoTaille=20;

de.fhpotsdam.unfolding.Map carte;
ArrayList<Parking> parkingsListe;

public void setup() 
{
  // Dimension de la fen\u00eatre
  size(1000,600);
  
  // Chargement de la fonte
  maFonte = loadFont("Geneva-15.vlw");
  
  // Cr\u00e9ation de la carte
  // Nantes est situ\u00e9e \u00e0 47.2172 de latitude et -1.591 de longitude
  carte = new de.fhpotsdam.unfolding.Map(this);
  carte.zoomAndPanTo(new Location(47.215f, -1.55f), 14);

  // Cette ligne de code permet d'avoir les comportements de navigation par d\u00e9faut
  // Glisser / D\u00e9placer + Zoom avec la mollette
  MapUtils.createDefaultEventDispatcher(this, carte);

  // Chargement des pictos
  datanantesPictoParking = loadImage("Picto B+M+P+Parking-100x100.png");

  // Addresse \u00e0 laquelle nous allons acc\u00e9der aux donn\u00e9es
  String url = "http://data.nantes.fr/api/"+datanantesCommande+"/"+datanantesVersion+"/"+datanantesCle;
  
  // Chargement des donn\u00e9es dans un objet permettant de lire le XML
  XMLElement xml = new XMLElement(this, url);

  // On est pr\u00eat \u00e0 analyser les donn\u00e9es \u00e0 pr\u00e9sent
  // Nous acc\u00e8dons d'abord aux noeuds <station>
   XMLElement[] parkingsXML = xml.getChildren("answer/data/Groupes_Parking/Groupe_Parking");
   
   // Ici on va r\u00e9cup\u00e9rer les informations relatives \u00e0 une station (nom, latitude, longitude)
   // en parcourant la liste des stations
   parkingsListe = new ArrayList<Parking>();
   
   for (int i=0;i<parkingsXML.length;i++){
     parkingsListe.add(new Parking(parkingsXML[i]));
   }
   

}

public void draw() 
{
  background(0xffdfdfdf);
  carte.draw();
  
  for (Parking p : parkingsListe)
  {
    String chaine[] = loadStrings("Equipements_publics_deplacement.csv"); // the name and extension of the file to import!

    for(int i = 0; i < chaine.length; ++i)
    {
      String[] element = split(chaine[i], ';');       // use the split array with character to isolate each component
      String[] split_element = split(element[0], ',');
      
      if(split_element[0].equals(p.id) == true){
      
        String[] split_lat = split(element[15], ',');
        String joine_lat = join(split_lat, ".");
        float lat=PApplet.parseFloat(joine_lat);
        
        String[] split_lon = split(element[14], ',');
        String joine_lon = join(split_lon, ".");
        float lon=PApplet.parseFloat(joine_lon);
        
        Location position = new Location(lat,lon);
        
        // Mets \u00e0 jour la position de la station sur la carte (en pixels)
        p.xy = carte.getScreenPositionFromLocation(position);
        // Affichage du picto pour cette station
        image(datanantesPictoParking,p.xy[0]-parkingPictoTaille/2,p.xy[1]-parkingPictoTaille/2,parkingPictoTaille,parkingPictoTaille);
        
      }      
    }
  }
  
  
  // Affichage des infos si un parking a \u00e9t\u00e9 cliqu\u00e9
  if (parkingAffichee != null)
  {
    float x=4,y=4;
    noStroke();
    fill(0xffdfdfdf);
    rect(y,x,200,50);
    textFont(maFonte,12);
    fill(0);
    y+=12;
    text(parkingAffichee.nom,x+4,y+4);
    y+=16;
    text(parkingAffichee.placesLibres+"/"+(parkingAffichee.placesDisponibles+parkingAffichee.placesLibres),x+4,y+4);
  }
}

public void mousePressed()
{
  parkingAffichee=null;
  for (Parking p : parkingsListe)
  {
    if (mouseX>=p.xy[0]-parkingPictoTaille/2 && mouseX<=p.xy[0]+parkingPictoTaille/2 && mouseY>=p.xy[1]-parkingPictoTaille/2 && mouseY<=p.xy[1]+parkingPictoTaille/2)
    {
      parkingAffichee = p;
      break;
    }
  }  
}

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

    this.placesDisponibles = PApplet.parseInt(dispoXML.getContent());
    this.placesLibres = PApplet.parseInt(libreXML.getContent());
    this.nom = nomXML.getContent();
    this.id = idXML.getContent(); 
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "datanantes_Parkings_Carte_interractive" });
  }
}
