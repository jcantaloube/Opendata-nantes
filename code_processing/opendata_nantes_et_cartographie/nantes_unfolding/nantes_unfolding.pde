import processing.opengl.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
de.fhpotsdam.unfolding.Map carte;

void setup(){
  // Dimension de la fenêtre
  size(1000,600);
  // Création de la carte de Nantes est située à 47.2172 de latitude et 
  // -1.591 de longitude
  carte = new de.fhpotsdam.unfolding.Map(this, new Microsoft.AerialProvider());
  carte.zoomAndPanTo(new Location(47.215f, -1.55f), 14);
  carte.setPanningRestriction(new Location(47.215f, -1.55f), 10);
  // Cette ligne de code permet d'avoir les comportements de navigation 
  //par défaut Glisser / Déplacer + Zoom avec la mollette
  MapUtils.createDefaultEventDispatcher(this, carte);
}

void draw(){
  background(#dfdfdf);
  carte.draw();
}

