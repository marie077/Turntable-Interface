import processing.serial.*;

Serial myPort;  // Create object from Serial class
static String val;    // Data received from the serial port
String sensorVal = "";

int mainTableDiameter = 900;
int bowlDiameter = 50;
float reflectiveAngle = 0;
float textSpeed = 0.25;

float arrowAngle = 0;

PShape tempSvg;
PShape arrowSvg;

//user input as indiviual components - temp data coming through
PImage testImage;
PImage testIllustration;
String testText;

//main array of bowl mediaArrays
ArrayList<ArrayList<UserMedia>> mainArray = new ArrayList<ArrayList<UserMedia>>();

float b1_deg, b2_deg, b3_deg, b4_deg;

float bowl_x_1;
float bowl_y_1;

float bowl_x_2;
float bowl_y_2;

float bowl_x_3;
float bowl_y_3;

float bowl_x_4;
float bowl_y_4;

int bowl1_degree;
int bowl2_degree;
int bowl3_degree;
int bowl4_degree;

int bowl1_Index = 0;
int bowl2_Index = 0;
int bowl3_Index = 0;
int bowl4_Index = 0;

boolean bowl1_selected = false;
boolean bowl2_selected = false;
boolean bowl3_selected = false;
boolean bowl4_selected = false;

boolean prev_bowl1_selected = false;
boolean prev_bowl2_selected = false;
boolean prev_bowl3_selected = false;
boolean prev_bowl4_selected = false;

 //temp JSON Object

/*
{

    "user1": {
    "media1": "test text mad-lib response",
    "media2": "test text 2 mad-lib response",
    "media3": "test text 3 mad-lib response"
    },

    "user2": {
    "media1": "user 2 test text mad-lib response",
    "media2": "user 2 test text 2 mad-lib response",
    "media3": "user 2 test text 3 mad-lib response"
    },

    "user3": {
    "media1": "user 3 test text mad-lib response",
    "media2": "user 3 test text 2 mad-lib response",
    "media3": "user 3 test text 3 mad-lib response"
    },

    "user4": {
    "media1": "user 4 test text mad-lib response",
    "media2": "user 4 test text 2 mad-lib response",
    "media3": "user 4 test text 3 mad-lib response"
    }
}
*/

//I would like to have four arrays populated randomly by data in a big array, selecting randomly
/*
end structure
UserMedia[] bowl1;
UserMedia[] bowl2;
UserMedia[] bowl3;
UserMedia[] bowl4;

*/

// separate arrays based on themes instead of random. 

ArrayList<PShape> factArray = new ArrayList<PShape>();

//user inputs stuff, stuff gets stored as an object, object gets pushed into an array
// for testing purposes with temporary JSON data based in firebase db
// ArrayList<UserMedia> fakeData = new ArrayList<UserMedia>();


// Bowl positions
FoodBowl bowl1, bowl2, bowl3, bowl4;

//Turntable
Table table;
float rotateAngle = 0;
boolean rotating = false;
float lastAngle = 0;
float currentRotation = 0;  // stores degrees, updated on drag

void setup() {
    size(900, 900); // Adjust canvas size as needed
    frameRate(30);
    background(0);
    tempSvg = loadShape("./data/fillertextTemp.svg");
    arrowSvg = loadShape("./data/arrow.svg");

    //serial setup
    String portName = "COM6";// Change the number (in this case ) to match the corresponding port number connected to your Arduino. 

    myPort = new Serial(this, portName, 115200);

    //temp factarray
    factArray.add(tempSvg);

        //bowl coordinates
    bowl1_degree = 45;
    bowl2_degree = 135;
    bowl3_degree = 225;
    bowl4_degree = 315;

    bowl_x_1 = ((mainTableDiameter / 4) / 2) * cos(radians(bowl1_degree));
    bowl_y_1 = ((mainTableDiameter / 4) / 2) * sin(radians(bowl1_degree));

    bowl_x_2 = ((mainTableDiameter / 4) / 2) * cos(radians(bowl2_degree));
    bowl_y_2 = ((mainTableDiameter / 4) / 2) * sin(radians(bowl2_degree));

    bowl_x_3 = ((mainTableDiameter / 4) / 2) * cos(radians(bowl3_degree));
    bowl_y_3 = ((mainTableDiameter / 4) / 2) * sin(radians(bowl3_degree));

    bowl_x_4 = ((mainTableDiameter / 4) / 2) * cos(radians(bowl4_degree));
    bowl_y_4 = ((mainTableDiameter / 4) / 2) * sin(radians(bowl4_degree));
    

    // Initialize bowls with empty text
    bowl1 = new FoodBowl("Family", factArray.get(0), bowl_x_1, bowl_y_1, textSpeed, bowl1_degree);
    bowl2 = new FoodBowl("Community", factArray.get(0), bowl_x_2, bowl_y_2, -textSpeed, bowl2_degree);
    bowl3 = new FoodBowl("Food", factArray.get(0), bowl_x_3, bowl_y_3, textSpeed, bowl3_degree);
    bowl4 = new FoodBowl("Media", factArray.get(0), bowl_x_4, bowl_y_4, -textSpeed, bowl4_degree);

    // ADD USER DATA HERE

    //COMMUNITY MEDIA
    float tiltAngle = 0.25;

    bowl1.addMedia("./data/usermedia/community/usermedia0.jpg", tiltAngle);
    bowl1.addMedia("./data/usermedia/community/usermedia1.jpg", -tiltAngle);

    //FAMILY MEDIA
    bowl2.addMedia("./data/usermedia/family/usermedia0.jpg", tiltAngle);
    bowl2.addMedia("./data/usermedia/family/usermedia1.jpg", -tiltAngle);

    //FOOD MEDIA
    bowl3.addMedia("./data/usermedia/food/usermedia0.jpg", tiltAngle);
    bowl3.addMedia("./data/usermedia/food/usermedia1.jpg", -tiltAngle);
    // bowl3.addMedia("./data/usermedia/food/usermedia2.jpg");

    //TECHNOLOGY MEDIA
    bowl4.addMedia("./data/usermedia/technology/usermedia0.jpg", tiltAngle);
    bowl4.addMedia("./data/usermedia/technology/usermedia1.jpg", -tiltAngle);


    //add each bowl object media array into the mainArray.
    mainArray.add(bowl1.getMediaArray()); // index 0 and Family
    mainArray.add(bowl2.getMediaArray()); // index 1 and Community
    mainArray.add(bowl3.getMediaArray()); // index 2 and Food
    mainArray.add(bowl4.getMediaArray()); // index 3 and Media

    // Initialize mainTable
    table = new Table(0, 0, mainTableDiameter);
}

void draw() {
   if (myPort.available() > 0) {
    val = myPort.readStringUntil('\n');

    // Always reset the bowl selections first
    bowl1_selected = false;
    bowl2_selected = false;
    bowl3_selected = false;
    bowl4_selected = false;

    if (val != null) {
        val = val.trim();  // remove whitespace, newline chars

        // Check if data has correct length (at least 4 chars: "0000")
        if (val.length() >= 4) {
            sensorVal = val.replace(",", "");

            bowl1_selected = sensorVal.charAt(0) == '1';
            bowl2_selected = sensorVal.charAt(1) == '1';
            bowl3_selected = sensorVal.charAt(2) == '1';
            bowl4_selected = sensorVal.charAt(3) == '1';

            println(bowl1_selected + "," + bowl2_selected + "," + bowl3_selected + "," + bowl4_selected);
        } else {
            println("Incomplete data: " + val);
        }
    } else {
        println("Null data received from serial");
    }
       // After updating current states, do the edge-detection logic
      bowlInteractedStatusCheck();

      // Now update previous states
      prev_bowl1_selected = bowl1_selected;
      prev_bowl2_selected = bowl2_selected;
      prev_bowl3_selected = bowl3_selected;
      prev_bowl4_selected = bowl4_selected;
  }
   
    background(0); // Clears previous frames to prevent ghosting effects
    //arrowsvg
     // Calculate the rotation angle based on mouse position
    
    
    // Display angle text
    fill(255);
    textSize(20);
    text("Angle: " + arrowAngle + "°", 10, 30);
    rotateAngle = arrowAngle;

    // Redraw main table
    noStroke();
    translate(width/2, height/2);
    rotate(radians(rotateAngle));
    table.display();
        
    //in degrees
    b1_deg = bowl1_degree + rotateAngle;
    b2_deg = bowl2_degree + rotateAngle;
    b3_deg = bowl3_degree + rotateAngle;
    b4_deg = bowl4_degree + rotateAngle;

    //translate and draw at the origin to keep it at its place
    bowl_x_1 = ((mainTableDiameter / 4) / 2) * cos(radians(b1_deg));
    bowl_y_1 = ((mainTableDiameter / 4) / 2) * sin(radians(b1_deg));

    bowl_x_2 = ((mainTableDiameter / 4) / 2) * cos(radians(b2_deg));
    bowl_y_2 = ((mainTableDiameter / 4) / 2) * sin(radians(b2_deg));

    bowl_x_3 = ((mainTableDiameter / 4) / 2) * cos(radians(b3_deg));
    bowl_y_3 = ((mainTableDiameter / 4) / 2) * sin(radians(b3_deg));

    bowl_x_4 = ((mainTableDiameter / 4) / 2) * cos(radians(b4_deg));
    bowl_y_4 = ((mainTableDiameter / 4) / 2) * sin(radians(b4_deg));
    
    //set the bowl coordinates with new rotaed positions.
    bowl1.setCoordinates(bowl_x_1, bowl_y_1);
    bowl2.setCoordinates(bowl_x_2, bowl_y_2);
    bowl3.setCoordinates(bowl_x_3, bowl_y_3);
    bowl4.setCoordinates(bowl_x_4, bowl_y_4);

    // Redraw turntable
    fill(255);
    ellipse(0, 0, mainTableDiameter/2, mainTableDiameter/2);

    fill(255, 0, 0);
    ellipse(0, 100, 10, 10);

    //   technically works but will replace with new svg and adjust coordinates
    // rotating reflective question
    //pushMatrix(); // Save the current transformation state
    //translate(width/2, height/2); // Move origin to turntable position
    //rotate(radians(reflectiveAngle)); // Apply rotation
    //shape(tempSvg, -60, -50, 100, 100); // Draw SVG relative to the new origin
    //popMatrix(); // Restore transformation state
    //reflectiveAngle += (textSpeed); // Increase angle for animation

    bowl1.displayCircle();
    bowl2.displayCircle();
    bowl3.displayCircle();
    bowl4.displayCircle();
    
    
    bowl1.rotateText();
    bowl2.rotateText();
    bowl3.rotateText();
    bowl4.rotateText();

    bowl1.displayBowlNumber();
    bowl2.displayBowlNumber();
    bowl3.displayBowlNumber();
    bowl4.displayBowlNumber(); 

}

void generatePosition(FoodBowl bowl, float minDegree, float maxDegree, int bowlIndex) {
    float minDistance = 80; // Minimum distance between media to prevent overlap
    // translate(width/2, height/2);
    // rotate(degrees(rotateAngle));
    float radius = mainTableDiameter/2.6;     // outer blue circle (bigger target area)

    float x, y;
    UserMedia media = bowl.getMediaArray().get(bowlIndex);

    if (!table.getMediaArray().contains(media)) {
    // Try to find a non-overlapping position in the lower right quadrant
    int attempts = 0;
    int maxAttempts = 50;
    float randomDegree;

    //to handle wrapping of degrees
    if (minDegree <= 0 || maxDegree <= 0) {
        minDegree = (minDegree + 360) % 360;
        maxDegree = (maxDegree + 360) % 360;
    } else {
        minDegree = (minDegree) % 360;
        maxDegree = (maxDegree) % 360;
    }

    do {
        // Generate random angle and radius in lower-right quadrant
        randomDegree = random(minDegree, maxDegree);

        // randomRadius = random(radiusMin, radiusMax); // Inside the larger circle
        
        // Convert to Cartesian coordinates
        // Generate point in unrotated space
        // translate(width/2, height/2);
        // rotate(radians(rotateAngle));

        x = radius * cos(radians(randomDegree));
        y = radius * sin(radians(randomDegree));
       

        attempts++;
        //needs to not overlap, be outside of the inner circle and within the larger circle
        //|| !isInsideLargeCircle(x, y, radiusMax) || !isOutsideInnerCircle(x, y, radiusMin)

      
    } while (isOverlapping(x, y, minDistance) && (attempts < maxAttempts));

      if (!isOverlapping(x, y, minDistance)) {
          // these x y are in radians
          media.setPosition(x, y);
          table.addMedia(media);
      } else {
        println("media overlapped and was not placed");
      }
    }

    //Print current media in table
    for (int i = 0; i < table.getMediaArray().size(); i++) {
     println(table.getMediaArray().get(i));
    }
}

boolean checkSelected(char sensorValue) {
  // println(sensorVal);
  if (sensorValue == '0') {
    // println("it was true" + numericValue);
    return false;
  } else {
    // println("it was false:" + numericValue);
    return true;
  }
}

/* inputting the potential x y position of the media to determine if it would overlap with
any of the other media that is actively on the table. The first one would not overlap
because there is no other media to overlap on. So to check if its overlapping, we must
compare distance between the current x y with the other x y of the other media to ensure there is 
a distance between them. The UserMedia needs to have a set position before getting the position...
and it is setting the position once we know that it is valid. 
*/
boolean isOverlapping(float x, float y, float minDistance) {
    for (UserMedia m : table.getMediaArray()) {
        float dx = m.getPositionX();
        float dy = m.getPositionY();
        // float dist = sqrt(dx*dx + dy*dy);
        if (dist(dx, dy, x, y) < minDistance) {
            return true;
        }
    }
    return false;
}

// Helper function to ensure the media stays outside of the inside circle
boolean isOutsideInnerCircle(float x, float y, float minRadius) {
    float distFromCenter = dist(x, y, 0, 0); // centered around origin
    return distFromCenter > minRadius;
}

// Helper function to ensure the media stays inside the larger circle
boolean isInsideLargeCircle(float x, float y, float maxRadius) {
    float distFromCenter = dist(x, y, 0, 0);
    return distFromCenter < maxRadius;
}

void bowlInteractedStatusCheck() {
    int offset = 50;

    // Trigger only on rising edge: previously false -> currently true
    if (bowl1_selected && !prev_bowl1_selected) {
        if (bowl1.getMediaArray().size() > 0) {
            generatePosition(bowl1, b1_deg - offset, b1_deg + offset, bowl1_Index);
            bowl1_Index = (bowl1_Index + 1) % bowl1.getMediaArray().size();
        }
    }

    if (bowl2_selected && !prev_bowl2_selected) {
        if (bowl2.getMediaArray().size() > 0) {
            generatePosition(bowl2, b2_deg - offset, b2_deg + offset, bowl2_Index);
            bowl2_Index = (bowl2_Index + 1) % bowl2.getMediaArray().size();
        }
    }

    if (bowl3_selected && !prev_bowl3_selected) {
        if (bowl3.getMediaArray().size() > 0) {
            generatePosition(bowl3, b3_deg - offset, b3_deg + offset, bowl3_Index);
            bowl3_Index = (bowl3_Index + 1) % bowl3.getMediaArray().size();
        }
    }

    if (bowl4_selected && !prev_bowl4_selected) {
        if (bowl4.getMediaArray().size() > 0) {
            generatePosition(bowl4, b4_deg - offset, b4_deg + offset, bowl4_Index);
            bowl4_Index = (bowl4_Index + 1) % bowl4.getMediaArray().size();
        }
    }
}


void mousePressed() {
  // Check if the mouse click is within the circle's bounds
  if (dist(mouseX, mouseY, width/2, height/2) < mainTableDiameter/2) {
    rotating = true;
    lastAngle = atan2(mouseY - height / 2, mouseX - width / 2);
  }
}

void mouseReleased() {
  rotating = false; // Stop rotating
}

void mouseDragged() {
  if (rotating) {
    float newAngle = degrees(atan2(mouseY - height / 2, mouseX - width / 2));
    // float delta = newAngle - lastAngle;
    // currentRotation += degrees(delta);  // keep degrees here
    // lastAngle = newAngle;
    newAngle = newAngle % 360;
    if (newAngle >= 0) {
        arrowAngle = newAngle;
    } else {
        arrowAngle = newAngle + 360;
    }
  }
}

