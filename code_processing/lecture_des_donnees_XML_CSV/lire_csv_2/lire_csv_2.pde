String[] lignes = loadStrings("liste.csv");
for (int i=0; i < lignes.length; i++) {
  println("ligne n°"+i+":"+lignes[i]);
  String[] tableau = split(lignes[i], ';');
  println(tableau);
}


