class BitmapCell {

  private int value;
  private PVector pos, dimension;

  float targetAlpha, alpha;
  float alphaEasing = 0.8;

  int r = 150;
  int g = 150;
  int b = 5;

  BitmapCell(int i, int j, float ax, float ay, float w, float h) {
    targetAlpha = alpha = 0;
    value = 0;
    dimension = new PVector(w, h);
    pos = new PVector(ax, ay);
    
  }

  void update() {
    alpha += (targetAlpha - alpha ) * alphaEasing;
  }

  void draw() {
    noStroke();
    fill(r, g, b, alpha);

    if (alpha > 0 ) {
      if (drawAsRectangle) {
        //shift by 1 pixel and shorten 1 pixel for border      
        rect( pos.x+1, pos.y+1, dimension.x-2, dimension.y-2);        
      }
      else {
        ellipse(pos.x+1, pos.y+1, dimension.x-2, dimension.y-2);        
      }
    }
  }

  void setValue(int newValue ) {
    if (newValue != value) {
      if (newValue == 0) {
        targetAlpha = 0.0;
      } 
      else {
        targetAlpha = 255.0;
      }
      value = newValue;
    }
  }

  int getValue() { 
    return value;
  }
  
  String toString() { return "" + getValue(); }
}

