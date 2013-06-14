class AppModel {
  ArrayList<LemurButton> padButtons; 

  AppModel() {
    padButtons = new ArrayList<LemurButton>();
  }

  ArrayList<LemurButton> getPad() {
    return padButtons;
  }

  void initializePad(int padRows, int padCols, String padRootName) {
    int padCount = padRows * padCols;
    for (int i=0; i<padCount; ++i) {      
      LemurButton lb = new LemurButton(padRootName + i); 
      padButtons.add(lb);
    }
  }
}

