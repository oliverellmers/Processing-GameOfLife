class Bitmap {
  PVector pos, dim;
  int rows, cols;
  float uStep, vStep;
  boolean showGrid = true;
  PVector cellDim;
  int size;
  ArrayList<Integer> pixelValues;
  ArrayList<Integer> borderPixelValues; //shadow of pixelValues with 1 cell border around it
 


  //
  public Bitmap() {
    pos = new PVector();
    dim = new PVector();
    cellDim = new PVector();
  }

  //create a Bitmap
  public Bitmap( int x, int y, int w, int h, int r, int c) {
    pos = new PVector(x, y);
    dim = new PVector(w, h);
    rows = r;
    cols = c;

    initGrid();
    initPixelValues();
  } 

  //copy a Bitmap
  public Bitmap( Bitmap b ) {
    pos = b.pos.get();
    dim = b.dim.get();
    rows = b.rows;
    cols = b.cols;
    uStep = b.uStep;
    vStep = b.vStep;
    cellDim = b.cellDim.get();
    size = b.getPixelCount();

    initPixelValues();
  }


  //Read a bitmap from file
  public Bitmap( String filename, int x, int y, int w, int h) {
    this();    
    BufferedReader reader = createReader(filename);
    String l = null;
    int rows = 0, cols = 0;
    ArrayList<Integer> pixels = new ArrayList<Integer>();

    try {
      l = reader.readLine();
      //remove the comment
      String[] tokens = l.split("#");
      String[] dim = tokens[1].split(",");
      rows = int(dim[0]);
      cols = int(dim[1]);
      //get the data
      l = reader.readLine();

      for (int i=0; i < l.length(); ++i ) {
        pixels.add( Character.getNumericValue(l.charAt(i)) );
      }
    }
    catch(Exception e) {
      e.printStackTrace();
      l = null;
    }

    this.rows = rows;
    this.cols = cols;
    pos.x = x;
    pos.y = y;
    dim.x = w;
    dim.y = h;

    initGrid();
    initPixelValues();
    setPixels(pixels);
  }

  public Bitmap(RLEPattern pattern, int w, int h, int r, int c, int startRow, int startCol ) {
    this(0,0,w,h,r,c);
    
    int padding = (cols - pattern.cols);
    int cursor = 0;
    
    if( startCol + pattern.cols <= cols && 
        (startRow * cols + startCol + pattern.pixels.size() <= this.size )) {
      cursor = startRow * cols + startCol;
    }
    
    setPixel(0,pattern.pixels.get(0));
    ++cursor;
    for(int i=1; i < pattern.pixels.size(); ++i ) {
      if( i % pattern.cols == 0 ) {
         cursor += padding; 
      }
      setPixel(cursor,pattern.pixels.get(i));
      ++cursor;  
    }
  }  


  public void clear() {
    ArrayList a = new ArrayList();
    for (int i=0; i < getPixelCount(); ++i ) {
      a.add(0);
    }
    setPixels(a);
  }

  public void setPixels(ArrayList<Integer> cells) {
    if (cells.size() == getPixelCount() ) {
      for (int i=0; i < cells.size(); ++i) {
        if (i < size) {
          pixelValues.set(i, cells.get(i));
          //
          int offset = getBorderedOffset(i);
          borderPixelValues.set(offset, cells.get(i));
        }
      }
    }
  }
  
  public void setPixel(int pixel, Integer value) {
    if(pixel < getPixelCount() ) {
      pixelValues.set(pixel, value);
    }
  }

  public int getBorderedOffset(int p) {
    int r = p / cols;
    int c = p % cols;
    //extra row at top, 2 extra cols per row, 1 extra col at beg of current row
    int offset = (1 + r) * (cols + 2) + (c+1);

    return offset;
  }

  public ArrayList<Integer> getPixels() {
    return pixelValues;
  }

  public ArrayList<Integer> getBorderPixelArray() {
    return borderPixelValues;
  }


  public int getPixelCount() { 
    return size;
  }

  public int getWidth() {
    return int(dim.x);
  }

  public int getHeight() {
    return int(dim.y);
  }

  public String toString() {
    return pixelValues.toString();
  }

  public void save(String filename) {
    PrintWriter output = createWriter(filename);

    int count = 0;
    for ( Integer i : pixelValues ) {
      output.print(i);
      ++count;
      //This the magic part of the output. 
      //Change cols to be the number of items that you want to print on
      //one line. If you want to print it all on one line set:
      // replace cols with getPixelCount()
      // to print one value per line replace cols with the number 1
      if(count % cols == 0)
        output.println();
      
    } 
    output.flush();
    output.close();
  }

  public void draw() {
    if (showGrid) {
      stroke(125,50);
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

    for (int i=0; i < size; ++i) {
      if (pixelValues.get(i) > 0 )
        plot(i);
    }
  }


  private void initPixelValues() {
    pixelValues = new ArrayList<Integer>();
    for (int i=0; i < getPixelCount(); ++i) {
      pixelValues.add(0);
    }

    int r = rows + 2;
    int c = cols + 2;
    borderPixelValues = new ArrayList<Integer>();
    for (int i=0; i < r*c; ++i) {
      borderPixelValues.add(0);
    }
  }

  private void initGrid() {
    uStep = 1.0 / cols;
    vStep = 1.0 / rows;
    cellDim = new PVector(uStep * dim.x, vStep * dim.y);
    size = rows*cols;
  }

  private void plot(int cell) {
    if (cell < rows * cols) {
      int i = cell % cols;
      int j = cell / cols;
      plot(i, j);
    }
  }

  private void plot(int i, int j) {
    fill(100, 100, 10);
    noStroke();
//    stroke(150, 150, 5);
    float inorm = (i + 0.5)/cols;
    float jnorm = (j + 0.5)/rows;

    float _x = lerp(pos.x, pos.x + dim.x, inorm);
    float _y = lerp(pos.y, pos.y + dim.y, jnorm);

    //shift by 1 pixel and shorten 1 pixel for border
    ellipse(_x+1, _y+1, cellDim.x-2, cellDim.y-2); 
//    rect( _x+1, _y+1, cellDim.x-2, cellDim.y-2);
  }
}

