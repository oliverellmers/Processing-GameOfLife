class Bitmap {

  private PVector pos, dim;
  private int rows;
  private int cols;
  float uStep, vStep;
  boolean showGrid = true;
  PVector cellDim;

  ArrayList<BitmapCell> borderPixelValues; //shadow of pixelValues with 1 cell border around it

  //
  public Bitmap() {
    initialize();
    pos = new PVector();
    dim = new PVector();
    cellDim = new PVector();
  }

  //create a Bitmap
  public Bitmap( int _x, int _y, int w, int h, int r, int c) {
    this();
    dim.x = w;
    dim.y =h;
    pos.x = _x;
    pos.y = _y;
    initGrid(r, c);
    initPixelValues();
  } 

  public Bitmap(RLEPattern pattern, int w, int h, int r, int c, int startRow, int startCol ) {
    this(0, 0, w, h, r, c);

    int padding = (cols - pattern.cols);
    int cursor = 0;

    if ( startCol + pattern.cols <= cols && 
      (startRow * cols + startCol + pattern.pixels.size() <= this.getPixelCount() )) {
      cursor = startRow * cols + startCol;
    }

    setPixel(0, pattern.pixels.get(0));
    ++cursor;
    for (int i=1; i < pattern.pixels.size(); ++i ) {
      if ( i % pattern.cols == 0 ) {
        cursor += padding;
      }
      setPixel(cursor, pattern.pixels.get(i));
      ++cursor;
    }
  }  

  private void initialize() {
    try {
    } 
    catch( Exception e) {
      println(e);
    }
  }

  public void clear() {
    for (int i=0; i < getPixelCount(); ++i ) {
      setPixel(i, 0);
    }
  }

  int getCols() { 
    return cols;
  }
  int getRows() { 
    return rows;
  }

  BitmapCell getPixel(int i) {
    if ( i < getPixelCount() ) {
      return borderPixelValues.get(i);
    }
    return null;
  }

  BitmapCell getPixel(int i, int j) {
    int ind = i * cols + j;
    if (ind < getPixelCount() ) {
      return borderPixelValues.get(ind);
    }
    return null;
  }

  public void setPixels(ArrayList<BitmapCell> cells) {
    if (cells.size() == getPixelCount() ) {
      for (int i=0; i < cells.size(); ++i) {
        borderPixelValues.get(i).setValue(cells.get(i).getValue());
      }
    }
  }

  public void setPixel(int pixel, Integer value) {
    if (pixel < getPixelCount() ) {
      borderPixelValues.get(pixel).setValue(value);
    }
  }

  public void setPixel(int i, int j, Integer value ) {
    int pixel = i * getCols() + j;
    setPixel(pixel, value);
  }

  public int getBorderedOffset(int p) {
    int r = p / cols;
    int c = p % cols;
    //extra row at top, 2 extra cols per row, 1 extra col at beg of current row
    int offset = (1 + r) * (cols + 2) + (c+1);

    return offset;
  }

  public ArrayList<BitmapCell> getPixels() {
    return borderPixelValues;
  }

  public int getPixelCount() { 
    return borderPixelValues.size();
  }

  public int getWidth() {
    return int(dim.x);
  }

  public int getHeight() {
    return int(dim.y);
  }

  public String toString() {
    return borderPixelValues.toString();
  }

  public void save(String filename) {
    PrintWriter output = createWriter(filename);

    int count = 0;
    for ( BitmapCell b : borderPixelValues ) {
      output.print(b);
      ++count;
      //This the magic part of the output. 
      //Change cols to be the number of items that you want to print on
      //one line. If you want to print it all on one line set:
      // replace cols with getPixelCount()
      // to print one value per line replace cols with the number 1
      if (count % cols == 0)
        output.println();
    } 
    output.flush();
    output.close();
  }

  public void update() {
    for ( BitmapCell bmp : borderPixelValues ) {
      bmp.update();
    }
  }

  public void draw() {
    if (showGrid) {
      stroke(100, 100);
      for (float u = 0.0; u <= 1.0; u += uStep) {
        float _x = lerp(pos.x, pos.x + dim.x, u);
        line(_x, pos.y, _x, pos.y + dim.y);
      }
      for (float v = 0.0; v <= 1.0; v += vStep) {      
        float _y = lerp(pos.y, pos.y + dim.y, v);
        line(pos.x, _y, pos.x + dim.x, _y);
      } 

      line(pos.x + dim.x, pos.y, pos.x + dim.x, pos.y + dim.y);
      line(pos.x, pos.y + dim.y, pos.x + dim.x, pos.y + dim.y);
    }

    for (BitmapCell b : borderPixelValues ) {
      if (b.getValue() > 0 )
        b.draw();
    }
  }

  private void initPixelValues() {    
    borderPixelValues = new ArrayList<BitmapCell>();

    borderPixelValues = new ArrayList<BitmapCell>(rows * cols);
    for (int i=0; i < rows*cols; ++i) {

      int currentC = i % cols;
      int currentR = i / cols;      

      float inorm = (currentR + 0.5)/cols;
      float jnorm = (currentC + 0.5)/rows;

      float _x = lerp(pos.x, pos.x + dim.x, inorm);
      float _y = lerp(pos.y, pos.y + dim.y, jnorm);

      BitmapCell bmp = new BitmapCell(currentR, currentC, _x, _y, cellDim.x, cellDim.y);
      bmp.setValue(0);
      borderPixelValues.add( bmp );
    }
  }

  private void initGrid(int r, int c) {
    this.rows = r + 2;
    this.cols = c + 2;


    uStep = 1.0 / cols;
    vStep = 1.0 / rows;
    cellDim = new PVector(uStep * dim.x, vStep * dim.y);
  }

  private void plot(int cell) {
    if (cell < rows * cols) {
      int i = cell % cols;
      int j = cell / cols;
      plot(i, j);
    }
  }

  private void plot(int i, int j) {
    noStroke();
    fill(150, 150, 5);
    float inorm = (i + 0.5)/cols;
    float jnorm = (j + 0.5)/rows;

    float _x = lerp(pos.x, pos.x + dim.x, inorm);
    float _y = lerp(pos.y, pos.y + dim.y, jnorm);

    //TODO:: this is a wasted calculation
    int index = i*j + j;
    //    bitmapCells.get(index).draw(_x,_y,cellDim);
    //shift by 1 pixel and shorten 1 pixel for border
    if (drawAsRectangle) {
      rect( _x+1, _y+1, cellDim.x-2, cellDim.y-2);
    } 
    else {    
      ellipse(_x+1, _y+1, cellDim.x-2, cellDim.y-2);
    }
  }
}

