class LemurController {
  
  //MOVE TO MODEL
  
  ArrayList<Integer> pads;
  
  LemurController(int padCount) {
    pads = new ArrayList(padCount);
    for(int i=0; i < padCount; ++i) {
      pads.add(0);
    }
  } 


  void setPattern() {
    RLEPattern pattern = new RLEPattern(9);
    int cursor = 0;
    ArrayList<Integer> pixels;
    for(int j=0; j < pattern.cols; ++j ) {
      pixels = new ArrayList<Integer>();
      for(int i=0; i < pattern.rows; ++i ) {
        pixels.add(pads.get(cursor));
        ++cursor;
      }
      pattern.addRow(pixels);
    }
    println(pattern);
  }

  void getPads() {
  }
  
  void setPadState(int index,  int state) {
    if(index >=0  && index < pads.size() ) {
      pads.set(index,int(state));
    }
  }
}

