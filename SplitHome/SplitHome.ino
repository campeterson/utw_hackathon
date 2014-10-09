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

void setup() {
  Serial.begin(9600);
}

void loop() {
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
  r01TempValue = ((((((r01TempValue/1023)*4.5)-(0.75))/0.01)+25)*9/5)+32;
  Serial.println(r01TempValue); // Temperature value
}

void readTemp2() {
  r02TempValue = analogRead(r02TempPin);
  Serial.print("r02/temp");
  printSlash();
  r02TempValue = ((((((r02TempValue/1023)*4.5)-(0.75))/0.01)+25)*9/5)+32;
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

