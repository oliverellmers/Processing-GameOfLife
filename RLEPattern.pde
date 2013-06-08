class RLEPattern {
 int rows;
 int cols;
 ArrayList<Integer> pixels;
  
 RLEPattern() {
   pixels = new ArrayList<Integer>();
 } 
 
 RLEPattern(int size) {
   this();
   rows = cols = int(sqrt(size));
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
   String zeroValue = ".";
   String oneValue = "1";
   
   for(int j=0; j < rows; ++j) {
     for(int i=0; i < cols; ++i) {
       int ind = j * cols + i;
       if( ind < pixels.size() ) {
         ret += pixels.get(j*cols + i ) == 0 ? zeroValue : oneValue;
         ret += separator;
       }
     }
     ret += "\n";
   }
   
   return ret;
 }
 
 String debugRow(int r) {
   String ret = "";
   int ind = r * cols;
   if(ind <= pixels.size() - cols) {
      for(int i = ind; i < ind + cols; ++i) {
        ret += pixels.get(i) == 0 ? "." : "1";
      }     
   }
   return ret;
 }
}
