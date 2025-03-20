//class to control each User Inputted Media such as mad-lib, illustrations (images), images
class UserMedia {
    String content;
    // PImage image; //either image of illustration or personal photo
    float x, y;

    //text-input
    UserMedia(String text) {
        this.content = text;
        // this.image = null;
    }
    
    //image-input
    // UserMedia(PImage image) {
    //     this.image = image;
    //     this.madLib = null;
    // }

    // Override toString() to return meaningful output
    @Override
    public String toString() {
        return this.content;  // Now thisit prints the actual content!
    }


    // //need to set position beofre display...?
    // void display() {
    //     if (image != null) {
    //         fadeIn();
    //         tint(255, alpha);
    //         image(image, x, y, 100, 100); // Display image
    //         noTint();
    //     }
    //     if (madLib != null) {
    //         fadeIn();
    //         fill(0, 0, 0, alpha);
    //         textSize(12);
    //         textAlign(CENTER, CENTER);
    //         text(madLib, this.x, this.y);
    //     }
    // }

    String getMedia() {
        return this.content;
    }

    void setPosition(float x, float y) {
        this.x = x;
        this.y = y;
    }

    float getPositionX() {
        return this.x;
    }

    float getPositionY() {
        return this.y;
    }

    // void remove() {
    //     if (image != null) {
    //         fadeOut();
    //         tint(255, alpha);
    //         image(image, x, y, 100, 100); // Display image
    //         noTint();
    //     }
    //     if (madLib != null) {
    //         fadeOut();
    //         fill(0, 0, 0, alpha);
    //         textSize(12);
    //         textAlign(CENTER, CENTER);
    //         text(madLib, this.x, this.y);
    //     }

    //     //after fadeout completes stop referencing it in draw()
    // }

 
}