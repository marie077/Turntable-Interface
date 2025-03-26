// FoodBowl Class
class FoodBowl {
    PShape svg;
    float x, y;
    float angle;
    float direction;
    String text;
    boolean selected = false;
    int diameter = 100;
    ArrayList<UserMedia> mediaArray = new ArrayList<UserMedia>();
    
    FoodBowl(String text, PShape svgPath, float x, float y, float direction, float angle) {
        this.svg = svgPath;
        this.x = x;
        this.y = y;
        this.direction = direction;
        this.text = text;
        this.angle = angle;
    }
    //display bowl #
    void displayBowlNumber() {
      fill(255, 255, 255);
      textSize(12);
      text(this.text, x, y); 
    }
    
    void setCoordinates(float x, float y) {
      this.x = x;
      this.y = y;
    }

    float getX() {
      return this.x;
    }

    float getY() {
      return this.y;
    }

    void setDegree(float x, float y) {
      this.angle = angle;
    }

    float getDegree() {
      return this.angle;
    }

    //svg temp
    void rotateText() {
      displayCircle();
      pushMatrix(); // Save the current transformation state
      translate(x, y); // Move origin to bowl position
      rotate(radians(angle)); // Apply rotation
      shape(svg, -25, -40, 50, 50); // Draw SVG relative to the new origin
      popMatrix(); // Restore transformation state
      angle += (this.direction); // Increase angle for animation
    }


    void displayCircle() {
        fill(0);
        ellipse(this.x, this.y, diameter, diameter);
    }

    void updateSvg(PShape svgPath) {
        this.svg = svgPath;
    }

    void addMedia(String media, float amplitude) {
      UserMedia usermedia = new UserMedia(media, amplitude);
      mediaArray.add(usermedia);
    }

    void setSelection(boolean state) {
      this.selected = state;
    }

    boolean isSelected() {
      int r = diameter/2; // Click radius for bowl selection
       // Inverse-rotate the mouse position to match bowl space
      float mx = mouseX - width / 2;
      float my = mouseY - height / 2;

      float cosA = cos(-radians(arrowAngle));
      float sinA = sin(-radians(arrowAngle));

      float rotatedMX = mx * cosA - my * sinA;
      float rotatedMY = mx * sinA + my * cosA;

      // Now compare with bowl's unrotated (original) coordinates
      return dist(rotatedMX, rotatedMY, this.x, this.y) < r;
    }

    ArrayList<UserMedia> getMediaArray() {
      return mediaArray;
    }
}
