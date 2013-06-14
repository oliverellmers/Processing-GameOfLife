class LemurButton {
 String name;
 int state = 0;    //default off
 int behavior = 0; //default switch
 
 LemurButton(String name) {
   this.name = name;
 }
 
 String getName() { return name; }
 void setState(int s) { state = s; }
 int getState() {return state; }
 void setBehavior(int b) { behavior = b; }
}
