/*******************************************************
TFE 2019
Calibration \checker based on a MAXIM 4466 Amplifier

Hart Georges

********************************************************/

 
const int sampleWindow = 50; // Sample window width in mS (50 mS = 20Hz)
unsigned int sample;
 
void setup() 
{
   Serial.begin(115200);
}
 
 
void loop() 
{
   unsigned long startMillis= millis();  // Start of sample window
   unsigned int peakToPeak = 0;   // peak-to-peak level
 
   unsigned int signalMax = 0;
   unsigned int signalMin = 1024;
 
   // collect data for 50 mS
   while (millis() - startMillis < sampleWindow)
   {
      sample = analogRead(0);
      if (sample < 1024)  // toss out spurious readings
      {
         if (sample > signalMax)
         {
            signalMax = sample;  // save just the max levels
         }
         else if (sample < signalMin)
         {
            signalMin = sample;  // save just the min levels
         }
      }
   }
   peakToPeak = signalMax - signalMin;  // max - min = peak-peak amplitude
   double volts = (peakToPeak * 5.0) / 1024;  // convert to volts
   double rms = (volts*(sqrt(2)/2));
   
   /* ------------------------------------------   
      Serial.print(100* volts);
      Serial.print(" - ");
   --------------------------------------------- */
      Serial.println(1000*rms,0);
}
