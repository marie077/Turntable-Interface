JSONObject json;
JSONArray jsonarray;

int mainTableDiameter = 600;
int bowlDiameter = 30;
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

//MOCK DATA
String[] mad_lib_test = { "test text mad-lib response", "test text mad-lib response 2", "test text mad-lib response 3" };
String[] illustration = { "Goat", "Leopard", "Zebra", "cow" };
String[] photo = { "photo1", "photo2", "photo3", "photo4" };

//bowl coordinates
float bowl_x_1, bowl_y_1;
float bowl_x_2, bowl_y_2;
float bowl_x_3, bowl_y_3;
float bowl_x_4, bowl_y_4;

int bowl1_Index = 0;
int bowl2_Index = 0;
int bowl3_Index = 0;
int bowl4_Index = 0;


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

void setup() {
    size(800, 800); // Adjust canvas size as needed
    background(0);
    tempSvg = loadShape("./data/fillertextTemp.svg");
    arrowSvg = loadShape("./data/arrow.svg");

    //load temp json object from data file
    json = loadJSONObject("./data/new.json");

    //temp factarray
    factArray.add(tempSvg);

    bowl_x_1 = width / 2 + ((mainTableDiameter / 4) / 2) * cos(radians(45));
    bowl_y_1 = height / 2 + ((mainTableDiameter / 4) / 2) * sin(radians(45));

    bowl_x_2 = width / 2 + ((mainTableDiameter / 4) / 2) * cos(radians(135));
    bowl_y_2 = height / 2 + ((mainTableDiameter / 4) / 2) * sin(radians(135));

    bowl_x_3 = width / 2 + ((mainTableDiameter / 4) / 2) * cos(radians(225));
    bowl_y_3 = height / 2 + ((mainTableDiameter / 4) / 2) * sin(radians(225));

    bowl_x_4 = width / 2 + ((mainTableDiameter / 4) / 2) * cos(radians(315));
    bowl_y_4 = height / 2 + ((mainTableDiameter / 4) / 2) * sin(radians(315));


    // Initialize bowls with empty text
    bowl1 = new FoodBowl("1", factArray.get(0), bowl_x_1, bowl_y_1, textSpeed);
    bowl2 = new FoodBowl("2", factArray.get(0), bowl_x_2, bowl_y_2, -textSpeed);
    bowl3 = new FoodBowl("3", factArray.get(0), bowl_x_3, bowl_y_3, textSpeed);
    bowl4 = new FoodBowl("4", factArray.get(0), bowl_x_4, bowl_y_4, -textSpeed);

    //add each bowl object media array into the mainArray.
    mainArray.add(bowl1.getMediaArray());
    mainArray.add(bowl2.getMediaArray());
    mainArray.add(bowl3.getMediaArray());
    mainArray.add(bowl4.getMediaArray());

    
    // Parse each user's media
    int bowlIndex = 0; // Rotating index to distribute evenly

    // Parse each user's media into a usable structure
    for (Object user : json.keys()) {
        JSONObject userMedia = json.getJSONObject((String)user);

        // Extract media items
        UserMedia illustration = new UserMedia(userMedia.getString("illustrations"));
        UserMedia photo = new UserMedia(userMedia.getString("photo"));
        UserMedia madLib = new UserMedia(userMedia.getString("mad-lib"));

        // Assign all three items from one user to the same bowl
        mainArray.get(bowlIndex).add(illustration);
        mainArray.get(bowlIndex).add(photo);
        mainArray.get(bowlIndex).add(madLib);

        // rotate through bowls for the next user
        bowlIndex = (bowlIndex + 1) % 4; 
    }

    // Initialize Turntable
    table = new Table(width/2, height/2, mainTableDiameter);
}

void draw() {
    background(0); // Clears previous frames to prevent ghosting effects
    //arrowsvg
     // Calculate the rotation angle based on mouse position
    arrowAngle = atan2(mouseY - height / 2, mouseX - width / 2);
    
    // Display angle text
    fill(255);
    textSize(20);
    text("Angle: " + degrees(arrowAngle) + "°", 10, 30);

    // Redraw main table
    noStroke();
    table.display();

    // Redraw turntable
    fill(245, 245, 220);
    ellipse(width/2, height/2, mainTableDiameter/2, mainTableDiameter/2);

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

    pushMatrix(); // Save the current transformation state
    translate(width/2, height/2); // Move origin to bowl position
    rotate(arrowAngle + PI); // Apply rotation
    shape(arrowSvg, 0, 0, 10, 10); // Draw SVG relative to the new origin
    popMatrix(); 

    bowl1.displayBowlNumber();
    bowl2.displayBowlNumber();
    bowl3.displayBowlNumber();
    bowl4.displayBowlNumber(); 
}

//temporary interaction will be replaced by sensor data
void mouseClicked() {
    int r = 25;
    int radiusOffset = mainTableDiameter/3;
    float x,y;

    if(dist(mouseX, mouseY, bowl_x_1, bowl_y_1) < r) {
        println("bowl1");
        UserMedia media = bowl1.getMediaArray().get(bowl1_Index);
        x = width / 2 + radiusOffset * cos(radians(135));
        y = height / 2 + radiusOffset * sin(radians(135));       
        media.setPosition(x, y);
        table.addMedia(media);
        
        //steps through the mediaArray incrementally
        bowl1_Index = (bowl1_Index + 1) % bowl1.getMediaArray().size();
        println(media);
    }
    if(dist(mouseX, mouseY, bowl_x_2, bowl_y_2) < r) {
        println("bowl2");

    }
    if(dist(mouseX, mouseY, bowl_x_3, bowl_y_3) < r) {
        println("bowl3");

    }
    if(dist(mouseX, mouseY, bowl_x_4, bowl_y_4) < r) {
        println("bowl4");

    }
}
