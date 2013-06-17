class AppModel {
  // -=-=-=CONFIG VARS with DEFAULTS
  int rows = 30, cols = 15;   //Default - Override in config file
  int gWidth = 100, gHeight = 100; //Default - Override in config file
  int renderSpeed = 5;

  int lemurInsertIndex;
  int lemurColOffset = 0;
  int lemurRows = 9, lemurCols =16;

  private ArrayList<LemurButton> padButtons; 
  private ArrayListPattern pattern;
  private Bitmap bitmap, next;

  //TODO: Refactor this into an ENUM - String
  Map<String, String> addrPatternMap = new HashMap<String, String>();
  String patternMenuAddr;

  String lemurPadButtonRootAddress;
  boolean playing = false;

  String[] patternFiles;

  boolean runSyphon = false;
  String syphonServer = "";

  AppModel() {
    padButtons = new ArrayList<LemurButton>();
  }

  ArrayList<LemurButton> getPad() {
    return padButtons;
  }

  void initializePad(int padRows, int padCols) {
    lemurRows = padRows;
    lemurCols = padCols;

    int padCount = padRows * padCols;
    pattern = new ArrayListPattern(padRows, padCols);

    for (int i=0; i<padCount; ++i) {      
      LemurButton lb = new LemurButton(model.getLemurPadButtonRootAddress(), i); 
      padButtons.add(lb);
      pattern.setValue(i, 0);
    }
  }

  void initializeBitmap() {
    int gWidth = model.getGridWidth();
    int gHeight = model.getGridHeight();
    int rows = model.getRows();
    int cols = model.getCols();

    model.setBitmap( new Bitmap(width/2 - gWidth/2, height/2 - gHeight/2, gWidth, gHeight, rows, cols) );
    model.setNextBitmap( new Bitmap(width/2 - gWidth/2, height/2 - gHeight/2, gWidth, gHeight, rows, cols) );
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


  public void addAddrPattern(String configName, String addrRoot, String oscMsgVariable ) {
    println("model::addAddrPattern = " + configName + "  " + addrRoot + "  " + oscMsgVariable);
    addrPatternMap.put(configName, formatAddrPattern(addrRoot, oscMsgVariable));
    println(addrPatternMap);
  }

  public String getAddrPattern(String configName) {
    //    println("model::getAddrPattern configName = " + configName );
    return addrPatternMap.get(configName);
  }

  public String getComponentFromAddrPattern(String addrPattern) {
    //    println("model:: getComponentFromAddrPattern for pattern = " + addrPattern);
    for (String k : addrPatternMap.keySet()) {
      //      println("\t component = " + k + "   -->  " + addrPatternMap.get(k) );

      if ( addrPatternMap.get(k).equals(addrPattern)) {
        //        println("\t found it" + k);
        return k;
      }
    }
    //    println("** Can't find component for address: " + addrPattern);
    return null;
  }

  public void setLemurPadButtonRootAddress(String s) {
    lemurPadButtonRootAddress = s;
  }

  public String getLemurPadButtonRootAddress() {
    return lemurPadButtonRootAddress;
  }

  public void setBitmapPixels(LifePattern pattern ) {
    Bitmap b = new Bitmap( pattern, bitmap.getW(), bitmap.getH(), model.getRows(), model.getCols(), model.getRows() / 2 - pattern.getRows() / 2, model.getCols() / 2 - pattern.getCols() / 2 );

    bitmap.setPixels( b.getPixels() );
    bitmap.draw();
  }

  public void setBitmapPixelFromLemur(LemurButton btn ) {
    int r = btn.getId() / lemurCols;
    int c = btn.getId() % lemurCols;
    int offset = r * getBitmap().getCols()+ c;//lemurColOffset + c;

    int i = lemurInsertIndex + offset;
    bitmap.setPixel(i, btn.getState());
  }

  public void setBitmap(Bitmap b) {
    bitmap = b;
  }

  public void clearBitmap() {
    bitmap.clear();
  }

  public void setNextBitmap(Bitmap b) {
    next = b;
  }

  public void setLemurColOffset( int offset ) {
    lemurColOffset = offset;
  }

  public int getLemurColOffset() { 
    return lemurColOffset;
  }

  public void setLemurInsertIndex(int i) {
    lemurInsertIndex = i;
  }

  public int  getLemurInsertIndex() { 
    return lemurInsertIndex;
  }  

  public int getLemurRows() { 
    return lemurRows;
  }
  public int getLemurCols() { 
    return lemurCols;
  }


  public Bitmap getBitmap() { 
    return bitmap;
  }
  public Bitmap getNextBitmap() { 
    return next;
  }

  //  public void setLemurMenuAddrPattern(String addrRoot) {
  //    patternMenuAddr = formatAddrPattern(addrRoot, "selection");// ;addrRoot;
  //  }
  //  
  //  public String getLemurMenuAddrPattern() {
  //    return patternMenuAddr;
  //  }

  private String formatAddrPattern(String addr, String variable) {
    return String.format("%s/%s", addr, variable);
  }

  public void setPlaying(boolean b) {
    playing = b;
  }

  public boolean isPlaying() {
    return playing;
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

  public void setPatternFiles(String[] fs) {
    patternFiles = fs;
  }

  public String getPatternFile(int i) {
    String ret = null;
    if (i < patternFiles.length) {
      ret = patternFiles[i];
    }
    return ret;
  }

  public boolean getRunSyphon() { 
    return runSyphon;
  }
  public void setRunSyphon(boolean b) { 
    runSyphon = b;
  } 

  public String getSyphonServer() { 
    return syphonServer;
  }
  public void setSyphonServer(String server) { 
    syphonServer = server;
  }
}

