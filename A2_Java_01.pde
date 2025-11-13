int[][] grid = new int[9][9]; 
boolean[][] locked;           
int cell = 60;                
int[] selected = null;        
int buttonY = 560;            

void setup() {
  size(540, 620);
  textAlign(CENTER, CENTER);
  textSize(24);
  String[] lines = loadStrings("Data.txt");
  int r = 0;
  while (r < lines.length) {
    String[] nums = splitTokens(lines[r], " ,");
    int c = 0;
    while (c < nums.length) {
      grid[r][c] = Integer.parseInt(nums[c]);
      c++;
    }
    r++;
  }
  
  locked = new boolean[9][9];
  r = 0;
  while (r < 9) {
    int c = 0;
    while (c < 9) {
      locked[r][c] = grid[r][c] != 0;
      c++;
    }
    r++;
  }
}

void draw() {
  background(255);
  drawGrid(0, 0, 9, 9, cell);
  drawNumbers(0, 0, cell);
  drawButtons(0, buttonY, 60, 9);
  Finish(0, 0, cell);
}

void drawGrid(int x_start, int y_start, int rows, int cols, int cellSize) {
  int i = 0;
  while (i <= rows) {
    if (i % 3 == 0) {
      strokeWeight(3);
    } else {
      strokeWeight(1);
    }
    line(x_start, y_start + i * cellSize, x_start + cols * cellSize, y_start + i * cellSize);
    line(x_start + i * cellSize, y_start, x_start + i * cellSize, y_start + rows * cellSize);
    i++;
  }
  if (selected != null) {
    int r = selected[0];
    int c = selected[1];
    noFill();
    strokeWeight(3);
    rect(x_start + c * cellSize, y_start + r * cellSize, cellSize, cellSize);
  }
}

void drawNumbers(int x_start, int y_start, int cellSize) {
  textSize(32);
  int r = 0;
  while (r < 9) {
    int c = 0;
    while (c < 9) {
      if (grid[r][c] != 0) {
        if (locked[r][c]) {
          fill(0);
        } else if (isConflict(r, c, grid[r][c])) {
          fill(255, 0, 0);
        } else {
          fill(0, 200, 0);
        }
        text(str(grid[r][c]), x_start + c * cellSize + cellSize / 2, y_start + r * cellSize + cellSize / 2);
      }
      c++;
    }
    r++;
  }
}

void drawButtons(int x_start, int y_start, int buttonSize, int count) {
  textSize(30);
  int i = 0;
  while (i < count) {
    int x = x_start + i * buttonSize;
    int y = y_start;
    fill(220);
    rect(x, y, buttonSize, buttonSize);
    fill(0);
    text(str(i + 1), x + buttonSize / 2, y + buttonSize / 2);
    i++;
  }
}

void mousePressed() {
  if (mouseY < 540) {
    int c = mouseX / cell;
    int r = mouseY / cell;
    if (r >= 0 && r < 9 && c >= 0 && c < 9) {
      selected = new int[]{r, c}; 
    }
  } else if (mouseY >= buttonY && mouseY <= buttonY + 60) {
    int i = mouseX / 60;
    if (i >= 0 && i < 9 && selected != null) {
      int r = selected[0];
      int c = selected[1];
      if (!locked[r][c]) {
        grid[r][c] = i + 1;
      }
    }
  }
}

boolean isConflict(int row, int col, int val) {
  int c = 0;
  while (c < 9) {
    if (c != col && grid[row][c] == val) return true;
    c++;
  }

  int r = 0;
  while (r < 9) {
    if (r != row && grid[r][col] == val) return true;
    r++;
  }

  int startRow = row - row % 3;
  int startCol = col - col % 3;
  r = startRow;
  while (r < startRow + 3) {
    c = startCol;
    while (c < startCol + 3) {
      if ((r != row || c != col) && grid[r][c] == val) return true;
      c++;
    }
    r++;
  }
  return false;
}

boolean Finish(int x_start, int y_start, int cellSize) {
  int r = 0;
  while (r < 9) {
    int c = 0;
    while (c < 9) {
      if (grid[r][c] == 0) {
        return false;
      }
      if (isConflict(r, c, grid[r][c])) {
        return false;
      }
      c++;
    }
    r++;
  }
  background(255);
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("You Win !", width / 2, height / 2);
  noLoop();
  return true;
}

