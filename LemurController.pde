public class LemurController implements InterfaceLemurController {

  ArrayList<String> messageAddresses;
  ArrayList<InterfaceLemurController> controllers;

  //MOVE TO MODEL
  Pattern padButtonRE; 
  Pattern controlButtonRE;


  LemurController() {
    messageAddresses = new ArrayList<String>();
    controllers = new ArrayList<InterfaceLemurController>();
    controllers.add(  new SwitchPadController());
    controllers.add( new ControlButtonController());

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


  private class ControlButtonController implements InterfaceLemurController {
    public boolean handleMessage(OscMessage msg) {
      boolean handled = false;
      if( msg.checkAddrPattern( model.getLemurPlayBtnAddr()) == true) {
        handleLemurPlayBtn(msg);
        handled = true;
      } 
      else if( msg.checkAddrPattern( model.getLemurClearBtnAddr()) == true) {
        handleLemurClearBtn(msg);
        handled = true;
      }
      
      return handled;
    }    
    
    private void handleLemurPlayBtn(OscMessage msg) {
      //if button is on then nap the current pattern and send it to the bitmap
      //if button is off then what??
      int state = msg.get(0).floatValue() > 0 ? 1 : 0;
      if(state == 1) {
        println("Play button handler state = " + state);        
        model.setBitmapPixels( model.getCurrentLemurPattern() );
      }
      
    }
    
    private void handleLemurClearBtn(OscMessage msg) {
    }
  }

  private class SwitchPadController implements InterfaceLemurController {
    
    public boolean handleMessage(OscMessage msg) {
      //find the button with the address of this message
      int st = msg.addrPattern().indexOf("/")+1;
      int en = msg.addrPattern().lastIndexOf("/");

      String find = msg.addrPattern().substring(st, en);
      
      int count = 0;
      for (LemurButton btn : model.getPad()) {
        if (btn.getName().equals(find)) {
          btn.setState( int(msg.get(0).floatValue()));
          model.setPatternPixel(count,btn.getState());

          println("SwitchPadController::handleMessage\n" + model.getCurrentLemurPattern());           
          return true;
        }
        ++count;
      }
      return false;
    }
  }
}

