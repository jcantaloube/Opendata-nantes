// http://data.nantes.fr/les-donnees/documentation-de-lapi/getdisponibiliteparkingspublics/
// Unfolding : http://unfoldingmaps.org/ 

import processing.opengl.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

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

void setup() 
{
  // Dimension de la fenêtre
  size(1000,600);
  
  // Chargement de la fonte
  maFonte = loadFont("Geneva-15.vlw");
  
  // Création de la carte
  // Nantes est située à 47.2172 de latitude et -1.591 de longitude
  carte = new de.fhpotsdam.unfolding.Map(this, new Microsoft.AerialProvider());
  //carte = new de.fhpotsdam.unfolding.Map(this, new OpenStreetMap.OpenStreetMapProvider());
  //carte = new de.fhpotsdam.unfolding.Map(this, new Microsoft.RoadProvider());
  //carte = new de.fhpotsdam.unfolding.Map(this, new Yahoo.RoadProvider());
  //carte = new de.fhpotsdam.unfolding.Map(this, new Yahoo.HybridProvider());
  
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
   
   // Ici on va récupérer les informations relatives à une station (nom, latitude, longitude)
   // en parcourant la liste des stations
   parkingsListe = new ArrayList<Parking>();
   
   for (int i=0;i<parkingsXML.length;i++){
     parkingsListe.add(new Parking(parkingsXML[i]));
   }
   

}

void draw() 
{
  background(#dfdfdf);
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
        float lat=float(joine_lat);
        
        String[] split_lon = split(element[14], ',');
        String joine_lon = join(split_lon, ".");
        float lon=float(joine_lon);
        
        Location position = new Location(lat,lon);
        
        // Mets à jour la position de la station sur la carte (en pixels)
        p.xy = carte.getScreenPositionFromLocation(position);
        // Affichage du picto pour cette station
        image(datanantesPictoParking,p.xy[0]-parkingPictoTaille/2,p.xy[1]-parkingPictoTaille/2,parkingPictoTaille,parkingPictoTaille);
        
      }      
    }
  }
  
  
  // Affichage des infos si un parking a été cliqué
  if (parkingAffichee != null)
  {
    float x=4,y=4;
    noStroke();
    fill(#dfdfdf);
    rect(y,x,200,50);
    textFont(maFonte,12);
    fill(0);
    y+=12;
    text(parkingAffichee.nom,x+4,y+4);
    y+=16;
    text(parkingAffichee.placesLibres+"/"+(parkingAffichee.placesDisponibles+parkingAffichee.placesLibres),x+4,y+4);
  }
}

void mousePressed()
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

