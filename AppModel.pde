class AppModel {
  // -=-=-=CONFIG VARS with DEFAULTS
  int rows = 30, cols = 15;   //Default - Override in config file
  int gWidth = 100, gHeight = 100; //Default - Override in config file
  int renderSpeed = 5;



  private ArrayList<LemurButton> padButtons; 
  private ArrayListPattern pattern;
  private Bitmap bitmap,next;
  
  String playBtnAddr, clearBtnAddr;
  
  AppModel() {
    padButtons = new ArrayList<LemurButton>();
  }

  ArrayList<LemurButton> getPad() {
    return padButtons;
  }

  void initializePad(int padRows, int padCols, String padRootName) {
    int padCount = padRows * padCols;
    pattern = new ArrayListPattern(padRows,padCols);
    
    for (int i=0; i<padCount; ++i) {      
      LemurButton lb = new LemurButton(padRootName + i); 
      padButtons.add(lb);
      pattern.setValue(i,0);
    }
  }
  
  void parsePattern(ArrayList<Integer> values, int rows, int cols) {
    pattern = new ArrayListPattern(rows, cols);
    if( rows*cols <= values.size() ) {
      for(int i=0; i < values.size(); ++i ) {
        pattern.setValue(i,values.get(i));
      } 
    }
  }
  
  void setPixel(int ind, int value) {
    pattern.setValue(ind,value);
  }
  
  ArrayListPattern getPattern() { return pattern; }  
  
  public void setBitmap(Bitmap b) {
    bitmap = b;
  }
  
  public void setNextBitmap(Bitmap b) {
    next = b;
  }
  
  public Bitmap getBitmap() { return bitmap; }
  public Bitmap getNextBitmap() { return next; }
  
  public void setLemurPlayBtnAddr(String addrRoot) {
    playBtnAddr = "/"+addrRoot+"/x";
  }

  public String getLemurPlayBtnAddr() {
    return playBtnAddr;
  }
  
  public void setLemurClearBtnAddr(String addrRoot) {
    clearBtnAddr  = "/"+addrRoot+"/x";
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

