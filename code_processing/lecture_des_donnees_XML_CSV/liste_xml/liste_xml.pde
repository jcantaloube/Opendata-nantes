XMLElement liste;

void setup() {
  size(200, 200);
  liste = new XMLElement(this, "liste.xml");
  XMLElement[] eleve = liste.getChildren();
  for (int i = 0; i < eleve.length; i++) {
    XMLElement X_nom = eleve[i].getChild("NOM");
    String nom = X_nom.getContent();
    XMLElement X_prenom = eleve[i].getChild("PRENOM");
    String prenom = X_prenom.getContent();
    XMLElement X_classe = eleve[i].getChild("CLASSE");
    String classe = X_classe.getContent();
    XMLElement X_sexe = eleve[i].getChild("SEXE");
    String sexe = X_sexe.getContent();
    println("nom : "+nom+" prenom : "+prenom+" classe : "+classe+" sexe : "+sexe);
  }
}

