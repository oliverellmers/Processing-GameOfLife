class LemurController {

  //MOVE TO MODEL
  Pattern padButtonRE; 
  Pattern controlButtonRE;

//  ArrayList<Integer> pads;

  LemurController(int padCount) {
    initialize();
//    pads = new ArrayList(padCount);
//    for (int i=0; i < padCount; ++i) {
//      pads.add(0);
//    }
  } 

  void initialize() {
    try {
      String value = config.getValue("lemurPadButtonPattern");
      if (value == null ) {
        println("error getting config for lemurPadButtonPattern");
      } 
      else {
        padButtonRE = Pattern.compile(value);
      }    

      if (value == null ) {
        value = config.getValue("lemurControlButtonPattern");
      } 
      else {
        controlButtonRE = Pattern.compile(value);
      }
    } 
    catch(Exception e) {
      println(e);
    }
  }


//  void setPattern() {
//    RLEPattern pattern = new RLEPattern(9);
//    int cursor = 0;
//    ArrayList<Integer> pixels;
//    for (int j=0; j < pattern.cols; ++j ) {
//      pixels = new ArrayList<Integer>();
//      for (int i=0; i < pattern.rows; ++i ) {
//        pixels.add(pads.get(cursor));
//        ++cursor;
//      }
//      pattern.addRow(pixels);
//    }
//    println(pattern);
//  }

  void handleMessage(OscMessage msg) {
    String addr = msg.addrPattern();    
    Matcher m = padButtonRE.matcher(addr);

    if (m.matches()) {
      lemur.setPadState(Integer.parseInt(m.group(1)), int(msg.get(0).floatValue()));
    }
    m = controlButtonRE.matcher(addr);
    if (m.matches() ) {
      if (msg.get(0).floatValue() == 1 ) {
        println("PLAY");
//        lemur.setPattern();
      } 
      else {
        println("STOP");
      }
    }
  }

  void getPads() {
  }

  void setPadState(int index, int state) {
//    if (index >=0  && index < pads.size() ) {
//      pads.set(index, int(state));
//    }
  }
}

