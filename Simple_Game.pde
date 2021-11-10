import java.util.Random;
import java.lang.Math;

final int SIZE_X = 600;
final int SIZE_Y = 600;

final int PLAYER_SIZE = 25;
final int START_AREA_SIZE = 100;

int num_enemies = 0;

boolean game_over = false;
boolean level_won = false;

class Player {
  protected float x;
  protected float y;
  protected float xvel;
  protected float yvel;
  protected int size;
  
  Player() {
    this.x = SIZE_X / 2;
    this.y = (START_AREA_SIZE / 2) + SIZE_Y - START_AREA_SIZE;
    this.xvel = 0;
    this.xvel = 0;
    this.size = PLAYER_SIZE;
  }
  
  Player(float x, float y, float xvel, float yvel, int size) {
    this.x = x;
    this.y = y;
    this.xvel = xvel;
    this.yvel = yvel;
    this.size = size;
  }
  
  public void Draw() {
    rectMode(CENTER);
    stroke(0);
    fill(#4B9335);
    rect(this.x, this.y, size, size);
  }
  
  public void Move() {
    this.x += this.xvel;
    this.y += this.yvel;
    
    Contain();
  }
  
  protected void Contain() {
    if(this.x + (this.size/2) >= SIZE_X) {
      this.x = SIZE_X - (this.size/2 + 1);
    }
    else if(this.x - (this.size/2) <= 0) {
      this.x = 0 + (this.size/2 + 1);
    }
    if(this.y + (this.size/2) >= SIZE_Y) {
      this.y = SIZE_Y - (this.size/2 + 1);
    }
    else if(this.y - (this.size/2) <= 0) {
      this.y = 0 + (this.size/2 + 1);
    }
  }
  
  private void CheckAtFinishLine() {    
    if(this.y - this.size/2 <= PLAYER_SIZE - 5) {
      level_won = true;
    }
  }
}

class Enemy extends Player {
  Enemy() {
    Random rand = new Random();
    this.size = rand.nextInt(80) + 20;
    this.x = rand.nextInt(600 - size);
    this.y = rand.nextInt(600 - size);
    this.xvel = (rand.nextFloat() * 6.0) + -3;
    this.yvel = (rand.nextFloat() * 6.0) + -3;
  }
  
  public void Draw() {
    rectMode(CENTER);
    stroke(0);
    fill(#FF0000);
    rect(this.x, this.y, size, size);
  }
  
  void Contain() {
    if(this.x + (this.size/2) >= SIZE_X) {
      this.x = SIZE_X - (this.size/2 + 1);
      this.xvel *= -1;
    }
    else if(this.x - (this.size/2) <= 0) {
      this.x = 0 + (this.size/2 + 1);
      this.xvel *= -1;
    }
    if(this.y + (this.size/2) >= SIZE_Y - START_AREA_SIZE) {
      this.y = (SIZE_Y - START_AREA_SIZE) - (this.size/2 + 1);
      this.yvel *= -1;
    }
    else if(this.y - (this.size/2) <= PLAYER_SIZE) {
      this.y = PLAYER_SIZE + (this.size/2 + 1);
      this.yvel *= -1;
    }
  }
  
  void CheckCollision() {
    if(Math.abs(this.x - Player1.x) <= (this.size/2) + (Player1.size/2)) {
      if(Math.abs(this.y - Player1.y) <= (this.size/2) + (Player1.size/2)) {
        game_over = true;
      }
    }
  }
}

class Node {
  Enemy e;
  Node next;
  
  Node(Enemy e) {
    this.e = e;
    this.next = null;
  }
  
  Node(Node next) {
    this.e = new Enemy();
    this.next = next;
  }
  
  Node() {
    this.e = new Enemy();
    this.next = null;
  }
}

class LinkedList {
  Node head;
  
  LinkedList(Enemy e) {
    this.head = new Node(e);
  }
  
  LinkedList() {
    this.head = null;
  }
  
  void PushNode() {
    Node newNode = new Node(this.head);
    this.head = newNode;        
  }
  
  void InitializeEnemies(int numEnemies) {
    this.head = null;
    for(int i = 0; i < numEnemies; ++i) {
      PushNode();
      //Print();
    }
  }
  
  void MoveEnemies() {
    Node curr = this.head;
    while(curr != null) {
      curr.e.Move();
      curr = curr.next;
    }
  }
  
  void DrawEnemies() {
    Node curr = this.head;
    while(curr != null) {
      curr.e.Draw();
      curr = curr.next;
    }
  }
  
  void ContainEnemies() {
    Node curr = this.head;
    while(curr != null) {
      curr.e.Contain();
      curr = curr.next;
    }
  }
  
  void CheckCollisions() {
    Node curr = this.head;
    while(curr != null) {
      curr.e.CheckCollision();
      curr = curr.next;
    }
  }
  
  void Print() {
    Node curr = this.head;
    while(curr != null) {
      curr = curr.next;
    }
  }
}

LinkedList Enemies = new LinkedList();
Player Player1;

void DrawScreen() {
  background(255);
  noStroke();
  rectMode(CORNER);
  fill(#94C3D1);
  rect(0, SIZE_Y - START_AREA_SIZE, SIZE_X, START_AREA_SIZE);
  fill(#87E56B);
  rect(0, 0, SIZE_X, PLAYER_SIZE + 1);
  fill(0);
  textSize(20);
  textAlign(LEFT, TOP);
  text("Level " + num_enemies, 0, 0);
}

void setup() {
  size(600, 600);
  DrawScreen();
  Enemies.InitializeEnemies(num_enemies);
  Player1 = new Player();
}

void PrintMouse() {
  println("X: " + mouseX);
  println("Y: " + mouseY);
}

void draw() {
  //PrintMouse();
  
  if(game_over) {
    textSize(50);
    textAlign(CENTER, CENTER);
    fill(0);
    text("GAME OVER", SIZE_X/2, SIZE_Y/2 - 100);
    textSize(36);
    text("You made it to level " + num_enemies, SIZE_X/2, SIZE_Y/2 - 25);
    text("Play Again?", SIZE_X/2, SIZE_Y/2 + 50);
  }
  
  else if(level_won) {
    textSize(50);
    textAlign(CENTER, CENTER);
    fill(0);
    text("LEVEL PASSED!", SIZE_X/2, SIZE_Y/2 - 100);
    
    textSize(36);
    text("Next Level?", SIZE_X/2, SIZE_Y/2 - 25);
  }
  
  else {
    DrawScreen();
    
    Enemies.DrawEnemies();
    Enemies.MoveEnemies();
    Enemies.CheckCollisions();
    
    Player1.Draw();
    Player1.Move();
    Player1.CheckAtFinishLine();
  }
  
}

void keyPressed() {
  switch(keyCode) {
    case UP:
      Player1.yvel = -3;
      break;
    case DOWN:
      Player1.yvel = 3;
      break;
    case LEFT:
      Player1.xvel = -3;
      break;
    case RIGHT:
      Player1.xvel = 3;
      break;
    case 87:
      Player1.yvel = -3;
      break;
    case 83:
      Player1.yvel = 3;
      break;
    case 65:
      Player1.xvel = -3;
      break;
    case 68:
      Player1.xvel = 3;
      break;
  }
}

void keyReleased() {
  switch(keyCode) {
    case UP:
      Player1.yvel = 0;
      break;
    case DOWN:
      Player1.yvel = 0;
      break;
    case LEFT:
      Player1.xvel = 0;
      break;
    case RIGHT:
      Player1.xvel = 0;
      break;
    case 87:
      Player1.yvel = 0;
      break;
    case 83:
      Player1.yvel = 0;
      break;
    case 65:
      Player1.xvel = 0;
      break;
    case 68:
      Player1.xvel = 0;
      break;
  }
}

void mousePressed() {
  if(game_over) {
    if(mouseX >= 200 && mouseX <= 400 && mouseY >= 335 && mouseY <= 375) {
      num_enemies = 1;
      setup();
      game_over = false;
    }
  }
  else if(level_won) {
    if(mouseX >= 200 && mouseX <= 400 && mouseY >= 260 && mouseY <= 300) {
      num_enemies++;
      setup();
      level_won = false;
    }
  }
}
