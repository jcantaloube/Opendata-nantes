PFont maFonte;
String datanantesCle = "3O9NRRB5VI21JW6";
String datanantesCommande = "getDisponibiliteParkingsPublics";
String datanantesVersion = "1.0";
int NombreParkings;
String nom1;

void setup() 
{
  // Dimension de la fenêtre
  size(600,600);
  // On charge notre fonte
  maFonte = loadFont("Geneva-15.vlw");
  textFont(maFonte,20);
  // Addresse à laquelle nous allons accéder aux données
    String url = "http://data.nantes.fr/api/"+datanantesCommande+"/"+datanantesVersion+"/"+datanantesCle;
  // Connexion à l'API et chargement des données avec la clé et la commande
  XMLElement xml = new XMLElement(this, url);
  XMLElement[] parkings = xml.getChildren("answer/data/Groupes_Parking/Groupe_Parking");
  NombreParkings = parkings.length;
  XMLElement nomXML = parkings[1].getChild("Grp_nom");
  nom1 = nomXML.getContent();
}

void draw() 
{
  background(255);
  fill(0);
  textFont(maFonte,20);
  text("nombre de parkings sur Nantes :",0,20);
  fill(0,0,255);
  textFont(maFonte,20);
  text(NombreParkings,400,20);
  fill(0);
  text("parking n°1:",0,120,150,25);
  fill(0,0,255);
  text(nom1,150,120,300,25);  
}

