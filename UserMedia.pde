//class to control each User Inputted Media such as mad-lib, illustrations (images), images
class UserMedia {
    PImage media;
    // PImage image; //either image of illustration or personal photo
    float x, y;
    float alpha = 0;
    float angle = 0;
    float amplitude = 1.8;
    float speed = 0.15;
    PGraphics shadow;
    float offsetX = 20;  // Horizontal shadow offset
    float offsetY = 20;  // Vertical shadow offset
    int dispSize = 120;

    //text-input
    UserMedia(String text, float amplitude) {
        this.media = loadImage(text);
        this.media.resize(dispSize - 10, dispSize - 10);
        this.amplitude = amplitude;
        float newWidth = this.media.width + 15;
        float newHeight = this.media.height + 15;

        this.shadow = createGraphics((int)newWidth, (int)newHeight);
        generateShadow();
    }
    
    //image-input
    // UserMedia(PImage image) {
    //     this.image = image;
    //     this.madLib = null;
    // }

    // // Override toString() to return meaningful output
    // @Override
    // public String toString() {
    //     return this.content;  // Now thisit prints the actual content!
    // }


    // //need to set position beofre display...?
    void display() {
        if (media != null) {
            fadeIn();
            float outwardAngle = atan2((height/2) - y, (width/2) - x) + HALF_PI;
            pushMatrix();
            translate(x, y);
            rotate(outwardAngle + radians(angle));
            imageMode(CENTER);
            // Draw the shadow offset from the original image
            image(shadow, 0, 0);
            fill(255);
            rectMode(CENTER);
            rect(0, 18, media.width + 15, media.height + 45);
            tint(255, alpha);
            image(media, 0, 0); // Display image
            noTint();
            popMatrix();
            
        }
    }

    void wiggle() {
        this.angle = amplitude * sin(frameCount * speed);
    }

    PImage getMedia() {
        return this.media;
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

    void updateRotatePosition(float x, float y) {
        this.x = x;
        this.y = y;  
    }

    // This function creates a drop shadow by tinting and blurring the image.
    void generateShadow() {
        shadow.beginDraw();
        shadow.clear();
        // Apply a black tint with transparency (alpha value out of 255)
        shadow.tint(0, 0, 0, 75);
        shadow.image(this.media, 0, 0);
        // Apply a blur filter to soften the shadow edges
        shadow.filter(BLUR, 10);
        shadow.endDraw();
    }

    void removeMediaAnimation() {
        if (media != null) {
            fadeOut();
            pushMatrix();
            translate(x, y);
            tint(255, alpha);
            image(media, 0, 0); // Display image
            noTint();
            popMatrix();
        }

        //after fadeout completes stop referencing it in draw()
    }

        // Fade in effect
    void fadeIn() {
        if (alpha < 255) {
            alpha += 2.5; // Adjust speed of fade-in (higher = faster)
        }
    } 

    void fadeOut() {
        if (alpha >= 255) {
            alpha -= 2.5;
        }
    }
}
