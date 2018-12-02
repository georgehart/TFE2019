/* Processing code for this example

  // Graphing sketch

  // This program takes ASCII-encoded strings from the serial port at 9600 baud
  // and graphs them. It expects values in the range 0 to 1023, followed by a
  // newline, or newline and carriage return

*/


  import processing.serial.*;
  Serial myPort;        // The serial port

  PrintWriter output; // schrijf data naar file voor GNU PLOT
  
  
  int xPos = 1;         // horizontal position of the graph
  float inByte = 0;
  
  float myalpha=0.01; // backgnd transparancy

  void setup () {

    // set the window size:
    size(800, 600);
    surface.setTitle("TFE 2019 - Georges Hart");
     
    frameRate(100);

   // List all the available serial ports:
    printArray(Serial.list());

    // I know that the first port in the serial list on my Mac is always my
    // Arduino, so I open Serial.list()[0].
    // Open whatever port is the one you're using.
    myPort = new Serial(this, Serial.list()[0], 115200);

    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');

    // set initial background:
    background(0);
    
    // ----- data file -----
    output = createWriter( "max4466.dat" ); // schrijf data naar file voor GNU PLOT
  }

  void draw () {
    // draw the line:
    
    stroke(0, 255, 100);
/*   
    if((inByte > 200.0)&&(inByte < 300.0)){
      background(#727EC6);
    } else {
      background(0);
    }
*/      
    line(xPos, height, xPos, height - inByte);

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      background(0,myalpha);
    } else {
      // increment the horizontal position:
      xPos++;
    }
  }

  void serialEvent (Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // convert to an int and map to the screen height:
      inByte = float(inString);
      

      println(inByte);
      output.println(inByte); // schrijf data naar file voor GNU PLOT
      inByte = map(inByte, 0, 1023, 0, height);
    }
  }
  
  
  void keyPressed() {
    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    exit();  // Stops the program
}
