class Table {
    float rotationAngle = 0;;
    float x, y, diameter;
    ArrayList<UserMedia> mediaArray = new ArrayList<UserMedia>();;
    float alpha = 0;

    Table(float x, float y, float d) {
        this.x = x;
        this.y = y;
        this.diameter = d;
    }

    void addMedia(UserMedia media) {
        mediaArray.add(media);
    }

   ArrayList<UserMedia> getMedia() {
        return this.mediaArray;
    }

    void removeMedia() {

    }

    void display() {
        pushMatrix();
        // translate(x, y);
        
        rotate(radians(rotationAngle)); 
        // Draw circle (table)
        fill(173, 216, 230);
        ellipse(x, y, diameter, diameter);

        //Draw all media objects if mediaArray is not 0
        if (mediaArray.size() > 0) {
            for (int i = 0; i < mediaArray.size(); i++) {
                println("trying to output media");
                UserMedia media =  mediaArray.get(i);
                fadeIn();
                fill(0, 0, 0, alpha);
                textSize(20);
                text(media.getMedia(), media.getPositionX(), media.getPositionY() + (i * 20));
            }
        }
        popMatrix();
    }

    // Rotate the turntable and all objects inside
    void updateRotation(float speed) {
        rotationAngle += speed;
    }

        // Fade in effect
    void fadeIn() {
        if (alpha < 255) {
            alpha += 1; // Adjust speed of fade-in (higher = faster)
        }
    }

    //after some time fadeout objects
    void fadeOut() {
        if (alpha >= 255) {
            alpha -= 1;
        }
    }
}