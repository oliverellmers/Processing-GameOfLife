class LemurPad {
  private int rows, cols, size;
  private String addr;
  private ArrayList<Float> values;
  private String typeTag;

//  LemurPad(int rows, int cols, String addr) {
//    this.rows = rows;
//    this.cols = cols;
//    size = rows * cols;
//    this.addr = addr;
//    values = new ArrayList<Float>();
//    
//    //init typetag
//    typeTag = "";
//    for (int i=0; i < size; ++i) {
//      typeTag += "f";
//    }
//  }
//
//  void setValue(int i, float v) {
//    values.set(i, v);
//  }
//
//  void handleMessage(OscMessage msg ) {
//    if (msg.checkAddrPattern(addr) && msg.checkTypetag(typeTag)) {
//      for (int i=0; i < size; ++i) {
//        String pixel = msg.get(i).floatValue() > 0 ? "o" : ".";
//        if ( i % rows == 0 ) {
//          println("\n");
//        }
//      }
//    }
//  }
}

