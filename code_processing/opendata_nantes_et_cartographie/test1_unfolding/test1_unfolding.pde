import processing.opengl.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

UnfoldingMap carte ;
	
void setup() {
    size(800, 600);
    carte = new UnfoldingMap(this);
    MapUtils.createDefaultEventDispatcher(this, carte);
}

void draw() {
    carte.draw();
}

