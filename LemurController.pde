public class LemurController implements InterfaceLemurController {

  ArrayList<String> messageAddresses;
  ArrayList<InterfaceLemurController> controllers;

  //MOVE TO MODEL
  Pattern padButtonRE; 
  Pattern controlButtonRE;


  LemurController() {
    initialize();
    messageAddresses = new ArrayList<String>();
    controllers = new ArrayList<InterfaceLemurController>();
    controllers.add(  new SwitchPadController());

  } 


  boolean handleMessage(OscMessage msg) {
    for (InterfaceLemurController lc : controllers ) {
      if (lc.handleMessage(msg) == true) {
        return true;
      }
    }
    return false;
  }



  public void addController(InterfaceLemurController ctrl) {
    controllers.add(ctrl);
  }


//  private class ControlButtonController implements InterfaceLemurController {
//  }

  private class SwitchPadController implements InterfaceLemurController {

    SwitchPadController() {      
    }


    public boolean handleMessage(OscMessage msg) {
      println("--button controller -- " + msg.addrPattern());
      //find the button with the address of this message
      int st = msg.addrPattern().indexOf("/")+1;
      int en = msg.addrPattern().lastIndexOf("/");

      String find = msg.addrPattern().substring(st, en);
      
      int count = 0;
      for (LemurButton btn : model.getPad()) {
        if (btn.getName().equals(find)) {
          btn.setState( int(msg.get(0).floatValue()));
          model.setPixel(count,btn.getState());          
          return true;
        }
        ++count;
      }
      return false;
    }
  }
}

