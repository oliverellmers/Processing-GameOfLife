class RLEPattern {
 int rows;
 int cols;
 ArrayList<Integer> pixels;
  
 RLEPattern() {
   pixels = new ArrayList<Integer>();
 } 
 
 int getWidth() { return cols; }
 int getHeight() { return rows; }
 
 boolean addRow(ArrayList<Integer> values) {
   boolean added = false;
   if(values.size() <= cols ) {
     pixels.addAll(values);
     int extra = cols - values.size();
     
     for(int i=0; i < extra; i++) {
       pixels.add(0);
     }
     added = true;
   } 
   return added;
 }
 
 String toString(){
   String ret = "";
   String separator = "   ";
   for(int j=0; j < rows; ++j) {
     for(int i=0; i < cols; ++i) {
       ret += pixels.get(j*cols + i);
       ret += separator;
     }
     ret += "\n";
   }
   
   return ret;
 }
}
