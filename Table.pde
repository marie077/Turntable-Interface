class Table {
    float rotationAngle = 0;;
    float x, y;
    int diameter;
    ArrayList<UserMedia> mediaArray = new ArrayList<UserMedia>();;
    float alpha = 0;
    PImage noiseTexture;
    PImage circleMask;
    float noiseScale = 0.004;
    float t = 0;

    Table(float x, float y, int d) {
        this.x = x;
        this.y = y;
        this.diameter = d;
        noiseTexture = createImage(this.diameter, this.diameter, RGB);

        // Create a circular mask once.
        PGraphics pg = createGraphics(this.diameter, this.diameter);
        pg.beginDraw();
        pg.background(0);
        pg.fill(255);
        pg.noStroke();
        pg.ellipse(this.diameter/2, this.diameter/2, this.diameter, this.diameter);
        pg.endDraw();
        circleMask = pg.get();
    }

    void addMedia(UserMedia media) {
        mediaArray.add(media);
    }

   ArrayList<UserMedia> getMediaArray() {
        return this.mediaArray;
    }

    void removeMedia() {
        int randomIndex = (int)random(0, this.mediaArray.size());
        mediaArray.get(randomIndex).removeMediaAnimation();
        mediaArray.remove(randomIndex);
    }

    void display() {
        pushMatrix();
        noiseTexture.loadPixels();
        for (int i = 0; i < diameter; i++) {
            for (int j = 0; j < diameter; j++) {
                // Create a dynamic noise value that moves with time.
                float n = noise(i * noiseScale, j * noiseScale, t);
                // Map noise to a watery blue color. You can adjust these values for different effects.
                int col = color(0, 100 + n * 155, 200 + n * 55);
                noiseTexture.pixels[i + j * diameter] = col;
            }
        }
        noiseTexture.updatePixels();

        // Apply the circular mask so the noise appears only within the table circle.
        PImage maskedNoise = noiseTexture.get();  // Make a copy to mask
        maskedNoise.mask(circleMask);

        background(0);
        // Draw the masked noise texture at the center of the canvas.
        pushMatrix();
        // translate(x, y);
        imageMode(CENTER);  
        image(maskedNoise, 0, 0, diameter, diameter);
        popMatrix();
        // Update time to animate the noise.
        t += 0.06;
     
        rotate(radians(rotationAngle)); 
        // Draw circle (table)
        fill(173, 216, 230);
        //ellipse(x, y, diameter, diameter);

        //Draw all media objects if mediaArray is not 0
        if (mediaArray.size() > 0) {
            for (int i = 0; i < mediaArray.size(); i++) {
                UserMedia media =  mediaArray.get(i);
                // fadeIn();
                // fill(0, 0, 0, alpha);
                // textSize(20);
                media.wiggle();
                media.display();
            }
        }
        popMatrix();
    }

    // Rotate the turntable and all objects inside
    void updateRotation(float speed) {
        rotationAngle += speed;
    }
}
