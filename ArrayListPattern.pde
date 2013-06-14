class ArrayListPattern {
 ArrayList<Integer> pixels;
 int rows, cols;
 
 ArrayListPattern(int rows, int cols) {
   this.rows = rows;
   this.cols = cols;
   
   pixels = new ArrayList<Integer>(rows*cols);
   for(int i=0; i< rows*cols; ++i) {
     pixels.add(0);
   }
 } 
 
 void setValue( int index, int value ) {
   pixels.set(index, value);
 }
 
 ArrayList<Integer> getPattern() { return pixels; }
 
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
}
