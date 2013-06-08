class LemurController {
  ArrayList<Integer> pads;

  LemurController(int padCount) {
    pads = new ArrayList(padCount);
    for(int i=0; i < padCount; ++i) {
      pads.add(0);
    }
  } 



  void getPads() {
  }
  
  void setPadState(int index,  int state) {
    if(index >=0  && index < pads.size() ) {
      pads.set(index,int(state));
    }
  }
}

