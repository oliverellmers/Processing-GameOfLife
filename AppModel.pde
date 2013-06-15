class AppModel {
  // -=-=-=CONFIG VARS with DEFAULTS
  int rows = 30, cols = 15;   //Default - Override in config file
  int gWidth = 100, gHeight = 100; //Default - Override in config file
  int renderSpeed = 5;



  private ArrayList<LemurButton> padButtons; 
  private ArrayListPattern pattern;
  private Bitmap bitmap, next;

  String playBtnAddr, clearBtnAddr;
  
  boolean paused = false;

  AppModel() {
    padButtons = new ArrayList<LemurButton>();
  }

  ArrayList<LemurButton> getPad() {
    return padButtons;
  }

  void initializePad(int padRows, int padCols, String padRootName) {
    int padCount = padRows * padCols;
    pattern = new ArrayListPattern(padRows, padCols);

    for (int i=0; i<padCount; ++i) {      
      LemurButton lb = new LemurButton(padRootName, i); 
      padButtons.add(lb);
      pattern.setValue(i, 0);
    }
  }

  void parsePattern(ArrayList<Integer> values, int rows, int cols) {
    pattern = new ArrayListPattern(rows, cols);
    if ( rows*cols <= values.size() ) {
      for (int i=0; i < values.size(); ++i ) {
        pattern.setValue(i, values.get(i));
      }
    }
  }

  void setPatternPixel(int ind, int value) {
    pattern.setValue(ind, value);
  }

  public ArrayListPattern getCurrentLemurPattern() { 
    return pattern;
  }  

  public void setBitmapPixels(LifePattern pattern ) {
    Bitmap b = new Bitmap( pattern, bitmap.getW(), bitmap.getH(), model.getRows(), model.getCols(), model.getRows() / 2 - pattern.getRows() / 2, model.getCols() / 2 - pattern.getCols() / 2 );

    println(b.getPixelCount() +" vs "+ getBitmap().getPixelCount());  
    bitmap.setPixels( b.getPixels() );
    bitmap.draw();
  }

  public void setBitmap(Bitmap b) {
    bitmap = b;
  }

  public void setNextBitmap(Bitmap b) {
    next = b;
  }

  public Bitmap getBitmap() { 
    return bitmap;
  }
  public Bitmap getNextBitmap() { 
    return next;
  }

  public void setLemurPlayBtnAddr(String addrRoot) {
    playBtnAddr = "/"+addrRoot+"/x";
  }

  public String getLemurPlayBtnAddr() {
    return playBtnAddr;
  }

  public void setLemurClearBtnAddr(String addrRoot) {
    clearBtnAddr  = "/"+addrRoot+"/x";
  }  

  public void setPause(boolean b) {
    paused = b;
  }
  
  public boolean isPaused() {
    return paused;
  }

  public String getLemurClearBtnAddr() {
    return clearBtnAddr;
  }  

  public int getRows() { 
    return rows;
  }
  public void setRows(int r) { 
    rows = r;
  }

  public int getCols() { 
    return cols;
  }
  public void setCols(int c) { 
    cols = c;
  }  

  public int getGridWidth() { 
    return gWidth;
  }
  public void setGridWidth(int w) { 
    gWidth = w;
  }  

  public int getGridHeight() { 
    return gHeight;
  }
  public void setGridHeight(int h) { 
    gHeight = h;
  }

  public int getRenderSpeed() { 
    return renderSpeed;
  }
  public void setRenderSpeed( int s ) { 
    renderSpeed = s;
  }
}

