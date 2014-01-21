String chaine[] = loadStrings("Equipements_publics_deplacement.csv"); // importer fichier csv
for (int i = 0; i < chaine.length; ++i){
  String[] element = split(chaine[i], ';'); //décomposition de ligne en function du spérateur ;         
  String[] split_element = split(element[0], ','); //mise en forme de la donnée 299,000 en 299
  if(split_element[0].equals("299")==true){
    String lat = element[15];
    println(lat);
    String lon = element[14];
    println(lon);
  }
}

