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


  boolean handleMessage(OscMessage msg) {
    for (InterfaceLemurController lc : controllers ) {
      if (lc.handleMessage(msg) == true) {
        return true;
      }
    }
    return false;
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
    //    ArrayList<LemurButton> padButtons;

    SwitchPadController(String addrRoot, int padCount) {      
      //      padButtons = new ArrayList<LemurButton>();
      //      for(int i=0; i<padCount; ++i) {
      //        String name = addrRoot + i;
      //        String addr = "/" + name + "/x";
      //        addrs.add(addr);
      //       
      //        LemurButton lb = new LemurButton(name); 
      //        padButtons.add(lb);
      //      }
    }


    public boolean handleMessage(OscMessage msg) {
      println("--button controller -- " + msg.addrPattern());
      //find the button with the address of this message
      int st = msg.addrPattern().indexOf("/")+1;
      int en = msg.addrPattern().lastIndexOf("/");

      String find = msg.addrPattern().substring(st, en);
      ArrayList<LemurButton> padButtons = model.getPad();
      println(padButtons);
      for (LemurButton btn : padButtons) {
        if (btn.getName().equals(find)) {
          print(btn.getState()); 
          print( "   "  + msg.get(0).floatValue());
          btn.setState( int(msg.get(0).floatValue()));
          println(" -- " + btn.getState());   

          return true;
        }
      }
      //      String msgTo = msg.addrPattern().substring(msg.addrPattern().indexOf("/") - msg.addrPattern().lastIndexOf("/"));
      //      println("MEssage to: " + msgTo);
      return false;
    }
  }
}

