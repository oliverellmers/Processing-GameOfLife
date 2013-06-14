public class LemurController implements InterfaceLemurController {


  ArrayList<String> messageAddresses;
  ArrayList<InterfaceLemurController> controllers;
  
  //MOVE TO MODEL
  Pattern padButtonRE; 
  Pattern controlButtonRE;

  //  ArrayList<Integer> pads;

  LemurController(ArrayList<String> oscAddresses) {
    initialize();
    messageAddresses = oscAddresses;  

    //    switchPadController = new LemurController
  }

  LemurController(int padCount) {
    initialize();
    messageAddresses = new ArrayList<String>();
    controllers = new ArrayList<InterfaceLemurController>();
    
    //    pads = new ArrayList(padCount);
    //    for (int i=0; i < padCount; ++i) {
    //      pads.add(0);
    //    }
  } 


  void initialize() {
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


  boolean canHandleMessage(OscMessage msg) {
    for (InterfaceLemurController lc : controllers ) {
      if (lc.canHandleMessage(msg) == true) {
        return true;
      }
    }
    return false;
  }

  void handleMessage(OscMessage msg) {
    String addr = msg.addrPattern();    
    Matcher m = padButtonRE.matcher(addr);

    if (m.matches()) {
      lemurController.setPadState(Integer.parseInt(m.group(1)), int(msg.get(0).floatValue()));
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
  
  public void addSwitchPadController( String addrRoot, int padCount ) {
    SwitchPadController spc = new SwitchPadController(addrRoot, padCount);
    addController(spc);
  }
  
  public void addController(InterfaceLemurController ctrl) {
    controllers.add(ctrl);
  }
  
  private class SwitchPadController implements InterfaceLemurController {
    ArrayList<String> addrs;
    
    SwitchPadController(String addrRoot, int padCount) {      
      
      addrs = new ArrayList<String>(padCount);
      for(int i=0; i<padCount; ++i) {
        String a = "/" + addrRoot + i + "/x";
        addrs.add(a); 
      }
    }
    
    boolean canHandleMessage(OscMessage msg) {
      for (String a : addrs ) {
        if (msg.checkAddrPattern(a) == true) {
          return true;
        }
      }
      return false;
    }
  }
}

