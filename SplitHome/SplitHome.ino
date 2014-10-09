int r01LightPin = A0;
int r02LightPin = A1;
int r01TempPin = A2; 
int r02TempPin = A3;
int p00PillPin = A5;

int r01LightValue = 0;  // variable to store the value coming from the sensor
int r02LightValue = 0;  // variable to store the value coming from the sensor
float r01TempValue = 0;  // variable to store the value coming from the sensor
float r02TempValue = 0;  // variable to store the value coming from the sensor
int p00PillValue = 0;  // variable to store the value coming from the sensor

int p00UprightPin = A4;
int UprightState = HIGH;      // the current state of the output pin
int reading;           // the current reading from the input pin
int previous = LOW;    // the previous reading from the input pin
int ledPin = 13;
  
void setup() {
  Serial.begin(9600);
  pinMode(p00UprightPin, INPUT);
}

void loop() {
  readUpright();
  readLight1();
  readLight2();  
  readTemp1();
  readTemp2();
  readPills();
  delay(1000);
}

void printSlash() {
  Serial.print("/");
}

void readLight1() {
  r01LightValue = analogRead(r01LightPin);
  Serial.print("r01/light");
  printSlash();
  if(r01LightValue > 200)
  Serial.println("true"); // ON
  else
  Serial.println("false"); // OFF
}
void readLight2() {
  r02LightValue = analogRead(r02LightPin);
  Serial.print("r02/light");
  printSlash();
  if(r02LightValue > 200)
  Serial.println("true"); // ON
  else
  Serial.println("false"); // OFF
}

void readTemp1() {
  r01TempValue = analogRead(r01TempPin);
  Serial.print("r01/temp");
  printSlash();
  r01TempValue = ((((((r01TempValue/1023)*4.5)-(0.75))/0.01)+33)*9/5)+32;
  Serial.println(r01TempValue); // Temperature value
}

void readTemp2() {
  r02TempValue = analogRead(r02TempPin);
  Serial.print("r02/temp");
  printSlash();
  r02TempValue = ((((((r02TempValue/1023)*4.5)-(0.75))/0.01)+33)*9/5)+32;
  Serial.println(r02TempValue); // Temperature value
}

void readPills() {
  p00PillValue = analogRead(p00PillPin);
  if(p00PillValue > 0) {
    Serial.print("p00/pills");
    printSlash();
    Serial.println("true"); // OPEN or CLOSED
  }
}

void readUpright() {
  reading = analogRead(p00UprightPin);
  if (reading == 0) {
    Serial.print("p00/upright");
    printSlash();
    Serial.println("false"); // OPEN or CLOSED
  //} else {
  //  Serial.println(reading);
  }
}

