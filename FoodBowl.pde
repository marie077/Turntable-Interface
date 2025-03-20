// FoodBowl Class
class FoodBowl {
    PShape svg;
    float x, y;
    float direction;
    float angle = 0; 
    String text;
    boolean selected = false;
    ArrayList<UserMedia> mediaArray = new ArrayList<UserMedia>();
    
    FoodBowl(String text, PShape svgPath, float x, float y, float direction) {
        this.svg = svgPath;
        this.x = x;
        this.y = y;
        this.direction = direction;
        this.text = text;
    }
    //display bowl #
    void displayBowlNumber() {
      fill(255, 255, 255);
      textSize(12);
      text(this.text, x, y); 
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
        ellipse(x, y, 50, 50);
    }

    void updateSvg(PShape svgPath) {
        this.svg = svgPath;
    }

    void addMedia(UserMedia media) {
      mediaArray.add(media);
    }

    void setSelection(boolean state) {
      this.selected = state;
    }

    boolean isSelected() {
      return selected;
    }

    ArrayList<UserMedia> getMediaArray() {
      return mediaArray;
    }
}