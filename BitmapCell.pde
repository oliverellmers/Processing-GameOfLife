class BitmapCell {
  final String RECTANGLE = "rectangle";
  final String ELLIPSE = "ellipse";

  private int value;
  private PVector pos, index, dimension;
  String shape = ELLIPSE;

  float targetAlpha, alpha;
  float alphaEasing = 0.1;

  int r = 150;
  int g = 150;
  int b = 5;

  BitmapCell(int i, int j, float ax, float ay, float w, float h) {
    targetAlpha = alpha = 0;
    value = 0;
    index = new PVector(i, j);
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
      if (shape.equals(ELLIPSE)) {
        ellipse(pos.x+1, pos.y+1, dimension.x-2, dimension.y-2);
      }
      else {
        //shift by 1 pixel and shorten 1 pixel for border      
        rect( pos.x+1, pos.y+1, dimension.x-2, dimension.y-2);
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

