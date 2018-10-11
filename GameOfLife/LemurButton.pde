class LemurButton {
 String name;
 int state = 0;    //default off
 int behavior = 0; //default switch
 private int id;
 
 LemurButton(String name, int number) {
   this.name = name + number;
   id = number;
 }
 
 String getName() { return name; }
 void setState(int s) { state = s; }
 int getState() {return state; }
 void setBehavior(int b) { behavior = b; }
 int getId() { return id; }
}
