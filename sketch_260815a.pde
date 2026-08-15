// Kacky Labs Tech Tree - Free Camera Cyber Edition
// Passcode: !Kackylabs
// Controls: Left-Click & Drag to Pan | Scroll Wheel to Zoom | Press 'R' to Reset View

String passwordInput = "";
boolean isAuthenticated = false;
boolean passwordError = false;

// Pan & Zoom Camera Controls
float camX = 0;
float camY = 0;
float camScale = 1.0;
float dragStartX, dragStartY;
float camStartX, camStartY;
boolean isDragging = false;

// Nodes
Node root;
Node u1, u2, u3, u4a, u4b, u4c, u4Gen, u4Spec;
Node b1, b2, b3, b4a, b4b, b4c, b4Gen, b4Spec;
Node c1, c2, c3, c4v1, c4a, c4b, c4c, c4Gen, c4Spec;
Node p1, p2;
Node s1, s2, s3;

ArrayList<Node> allNodes;

// Palette (Techy Cyber Blue Theme)
color bgDark      = #060A10;
color panelBg     = #0A121E;
color neonBlue    = #00E5FF;
color mutedBlue   = #1A3654;
color textWhite   = #E6F7FF;
color textDim     = #4A739C;

void setup() {
  size(1100, 700);
  smooth();
  allNodes = new ArrayList<Node>();

  // Center initial view
  camX = width / 2;
  camY = height / 2;

  // --- Base Node ---
  root = new Node(-650, 0, "HyperM", neonBlue);
  root.unlocked = true;
  allNodes.add(root);

  // --- Undyn Branch (Top) ---
  u1 = new Node(-380, -280, "Undyn 1", neonBlue);
  u2 = new Node(-100, -310, "Undyn 2", neonBlue);
  u3 = new Node(180, -310, "Undyn 3", neonBlue);
  
  u4a = new Node(440, -390, "Undyn 4a", neonBlue);
  u4b = new Node(440, -310, "Undyn 4b", neonBlue);
  u4c = new Node(440, -230, "Undyn 4c", neonBlue);

  u4Gen  = new Node(720, -350, "Undyn 4 General", neonBlue);
  u4Spec = new Node(720, -230, "Undyn 4 Specialised", neonBlue);

  root.connectTo(u1);
  u1.connectTo(u2);
  u2.connectTo(u3);
  
  u3.connectTo(u4a);
  u3.connectTo(u4b);
  u3.connectTo(u4c);

  u4a.connectTo(u4Gen);
  u4b.connectTo(u4Gen);
  u4c.connectTo(u4Spec);

  // --- Bdy Branch (Upper Middle) ---
  b1 = new Node(-360, -90, "Bdy 1", neonBlue);
  b2 = new Node(-80, -80, "Bdy 2", neonBlue);
  b3 = new Node(200, -90, "Bdy 3", neonBlue);
  
  b4a = new Node(460, -150, "Bdy 4a", neonBlue);
  b4b = new Node(460, -70, "Bdy 4b", neonBlue);
  b4c = new Node(460,  10, "Bdy 4c", neonBlue);

  b4Gen  = new Node(740, -110, "Bdy 4 General", neonBlue);
  b4Spec = new Node(740,   10, "Bdy 4 Specialised", neonBlue);

  root.connectTo(b1);
  b1.connectTo(b2);
  b2.connectTo(b3);
  
  b3.connectTo(b4a);
  b3.connectTo(b4b);
  b3.connectTo(b4c);

  b4a.connectTo(b4Gen);
  b4b.connectTo(b4Gen);
  b4c.connectTo(b4Spec);

  // --- Cyn & Pyn Branch Network (Lower Middle) ---
  c1 = new Node(-400, 110, "Cyn 1", neonBlue);
  c2 = new Node(-180, 130, "Cyn 2", neonBlue);
  
  c3 = new Node(50, 90, "Cyn 3", neonBlue);
  
  p1 = new Node(50, 200, "Pyn 1", neonBlue);
  p2 = new Node(270, 200, "Pyn 2", neonBlue);

  c4v1 = new Node(480, 145, "Cyn 4 v1", neonBlue);
  
  c4a = new Node(740, 65, "Cyn 4a", neonBlue);
  c4b = new Node(740, 145, "Cyn 4b", neonBlue);
  c4c = new Node(740, 225, "Cyn 4c", neonBlue);

  c4Gen  = new Node(1000, 105, "Cyn 4 General", neonBlue);
  c4Spec = new Node(1000, 225, "Cyn 4 Specialised", neonBlue);

  root.connectTo(c1);
  c1.connectTo(c2);
  
  c2.connectTo(c3);
  c2.connectTo(p1);
  
  // Pyn 1 --> Pyn 2 --> Cyn 4 v1
  p1.connectTo(p2);
  p2.connectTo(c4v1);
  
  // Cyn 3 --> Cyn 4 v1
  c3.connectTo(c4v1);
  
  // Cyn 4 v1 splits into 4a, 4b, and 4c
  c4v1.connectTo(c4a);
  c4v1.connectTo(c4b);
  c4v1.connectTo(c4c);
  
  // 4a and 4b merge into General; 4c moves to Specialised
  c4a.connectTo(c4Gen);
  c4b.connectTo(c4Gen);
  c4c.connectTo(c4Spec);

  // --- Sfyt Branch (Under-most) ---
  s1 = new Node(-380, 390, "Sfyt 1", neonBlue);
  s2 = new Node(-80, 390, "Sfyt 2", neonBlue);
  s3 = new Node(220, 390, "Sfyt 3", neonBlue);

  root.connectTo(s1);
  s1.connectTo(s2);
  s2.connectTo(s3);

  // Register All Nodes
  allNodes.add(u1); allNodes.add(u2); allNodes.add(u3); 
  allNodes.add(u4a); allNodes.add(u4b); allNodes.add(u4c);
  allNodes.add(u4Gen); allNodes.add(u4Spec);
  
  allNodes.add(b1); allNodes.add(b2); allNodes.add(b3); 
  allNodes.add(b4a); allNodes.add(b4b); allNodes.add(b4c);
  allNodes.add(b4Gen); allNodes.add(b4Spec);
  
  allNodes.add(c1); allNodes.add(c2); allNodes.add(c3); 
  allNodes.add(p1); allNodes.add(p2); allNodes.add(c4v1);
  allNodes.add(c4a); allNodes.add(c4b); allNodes.add(c4c);
  allNodes.add(c4Gen); allNodes.add(c4Spec);

  allNodes.add(s1); allNodes.add(s2); allNodes.add(s3);
}

void draw() {
  background(bgDark);

  if (!isAuthenticated) {
    drawLoginScreen();
  } else {
    drawTechTree();
  }
}

// --- Login Screen ---
void drawLoginScreen() {
  stroke(#0F1D2E);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int j = 0; j < height; j += 40) line(0, j, width, j);

  rectMode(CENTER);
  fill(panelBg, 240);
  stroke(neonBlue);
  strokeWeight(2);
  rect(width/2, height/2, 480, 260, 24);

  fill(neonBlue);
  textAlign(CENTER, CENTER);
  textFont(createFont("Monospaced", 20, true));
  text("[ KACKY LABS TERMINAL ]", width/2, height/2 - 80);

  fill(textDim);
  textFont(createFont("Monospaced", 12, true));
  text("ENTER ACCESS KEY:", width/2, height/2 - 35);

  fill(#04070D);
  stroke(passwordError ? color(255, 60, 60) : neonBlue);
  strokeWeight(1.5);
  rect(width/2, height/2 + 15, 360, 42, 21);

  fill(textWhite);
  textFont(createFont("Monospaced", 16, true));
  String masked = "";
  for (int i = 0; i < passwordInput.length(); i++) masked += "*";
  if ((frameCount / 30) % 2 == 0) masked += "_";
  text(masked, width/2, height/2 + 13);

  if (passwordError) {
    fill(255, 75, 75);
    textFont(createFont("Monospaced", 11, true));
    text(">> ACCESS DENIED: INVALID KEY <<", width/2, height/2 + 75);
  } else {
    fill(neonBlue, 180);
    textFont(createFont("Monospaced", 11, true));
    text("AWAITING PASSCODE... PRESS ENTER", width/2, height/2 + 75);
  }
}

// --- Main Tech Tree Visualizer ---
void drawTechTree() {
  pushMatrix();
  // Apply World Camera Transformations (Pan & Zoom)
  translate(camX, camY);
  scale(camScale);

  // Dynamic Cyber Grid aligned with camera
  stroke(#0D1726);
  strokeWeight(1 / camScale);
  for (int i = -3000; i <= 3000; i += 50) {
    line(i, -3000, i, 3000);
    line(-3000, i, 3000, i);
  }

  // Render Connections (Only between unlocked nodes)
  root.drawConnections();
  for (Node n : allNodes) n.drawConnections();

  // Render Nodes
  root.display();
  for (Node n : allNodes) n.display();

  popMatrix();

  // Screen Space Overlay UI
  drawUIOverlay();
}

void drawUIOverlay() {
  fill(panelBg);
  stroke(mutedBlue);
  strokeWeight(1);
  rectMode(CORNER);
  rect(0, 0, width, 45);

  fill(neonBlue);
  textFont(createFont("Monospaced", 13, true));
  textAlign(LEFT, CENTER);
  text("SYS.ONLINE // FREE_CAM_ACTIVE", 25, 22);
  textAlign(RIGHT, CENTER);
  text("DRAG: PAN | SCROLL: ZOOM | [R]: RESET", width - 25, 22);
}

// --- Controls & Camera Mechanics ---
void mousePressed() {
  if (!isAuthenticated) return;

  // Convert screen coordinates to world coordinates
  float worldMouseX = (mouseX - camX) / camScale;
  float worldMouseY = (mouseY - camY) / camScale;

  boolean nodeClicked = false;

  // Check Node Clicks
  if (root.containsPoint(worldMouseX, worldMouseY)) {
    u1.unlocked = true;
    b1.unlocked = true;
    c1.unlocked = true;
    s1.unlocked = true;
    nodeClicked = true;
  }

  for (Node n : allNodes) {
    if (n.unlocked && n.containsPoint(worldMouseX, worldMouseY)) {
      for (Node child : n.children) {
        child.unlocked = true;
      }
      nodeClicked = true;
    }
  }

  // Drag canvas if not clicking on an active node
  if (!nodeClicked) {
    isDragging = true;
    dragStartX = mouseX;
    dragStartY = mouseY;
    camStartX = camX;
    camStartY = camY;
  }
}

void mouseDragged() {
  if (isDragging) {
    camX = camStartX + (mouseX - dragStartX);
    camY = camStartY + (mouseY - dragStartY);
  }
}

void mouseReleased() {
  isDragging = false;
}

void mouseWheel(MouseEvent event) {
  if (!isAuthenticated) return;
  float e = event.getCount();
  float zoomFactor = (e < 0) ? 1.08 : 0.92;

  // Zoom towards mouse pointer
  camX = mouseX - (mouseX - camX) * zoomFactor;
  camY = mouseY - (mouseY - camY) * zoomFactor;
  camScale *= zoomFactor;
  camScale = constrain(camScale, 0.25, 2.5);
}

void keyPressed() {
  if (!isAuthenticated) {
    if (key == ENTER || key == RETURN) {
      if (passwordInput.equals("!Kackylabs")) {
        isAuthenticated = true;
        passwordError = false;
      } else {
        passwordError = true;
        passwordInput = "";
      }
    } else if (key == BACKSPACE) {
      if (passwordInput.length() > 0) {
        passwordInput = passwordInput.substring(0, passwordInput.length() - 1);
      }
    } else if (key != CODED && key >= 32 && key <= 126) {
      passwordInput += key;
      passwordError = false;
    }
  } else {
    // Reset camera position
    if (key == 'r' || key == 'R') {
      camX = width / 2;
      camY = height / 2;
      camScale = 1.0;
    }
  }
}

// --- Fully Rounded Capsule Node Class ---
class Node {
  float x, y;
  float w = 150;
  float h = 46;
  String title;
  color mainColor;
  boolean unlocked = false;
  ArrayList<Node> children;

  Node(float x, float y, String title, color mainColor) {
    this.x = x;
    this.y = y;
    this.title = title;
    this.mainColor = mainColor;
    this.children = new ArrayList<Node>();
  }

  void connectTo(Node child) {
    children.add(child);
  }

  boolean containsPoint(float px, float py) {
    return px >= x - w/2 && px <= x + w/2 && py >= y - h/2 && py <= y + h/2;
  }

  void drawConnections() {
    if (!unlocked) return;

    for (Node child : children) {
      if (child.unlocked) {
        stroke(neonBlue, 180);
        strokeWeight(2.5 / camScale);

        // Smooth organic Bézier curve connection
        noFill();
        float ctrlOffset = dist(this.x, this.y, child.x, child.y) * 0.4;
        bezier(this.x + w/2, this.y, 
               this.x + w/2 + ctrlOffset, this.y, 
               child.x - child.w/2 - ctrlOffset, child.y, 
               child.x - child.w/2, child.y);
      }
    }
  }

  void display() {
    if (!unlocked) return;

    float worldMouseX = (mouseX - camX) / camScale;
    float worldMouseY = (mouseY - camY) / camScale;
    boolean hover = containsPoint(worldMouseX, worldMouseY);

    rectMode(CENTER);

    // Node Capsule Frame (Fully rounded edges)
    fill(#050B14, 240);
    stroke(hover ? textWhite : neonBlue);
    strokeWeight((hover ? 2.5 : 1.5) / camScale);
    rect(x, y, w, h, h / 2);

    // Inner Glow on Hover
    if (hover) {
      fill(neonBlue, 30);
      noStroke();
      rect(x, y, w - 4, h - 4, (h - 4) / 2);
    }

    // Node Title Text
    textAlign(CENTER, CENTER);
    fill(hover ? neonBlue : textWhite);
    textFont(createFont("Monospaced", 11, true));
    text(title, x, y - 1);
  }
}
