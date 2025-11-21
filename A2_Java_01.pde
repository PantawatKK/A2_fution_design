int[][] grid = new int[9][9];
boolean[][] locked;
int cell = 80;
int[] selected = null;
int buttonY = 720;
boolean countMode = true;
int currentRow = 0;
int[] emptyCellsCount = new int[9];
boolean showAllEmpty = false;
color currentEmptyColor = color(0);
int currentEmptyValue = -1;

void setup() {
  size(800, 900);
  textAlign(CENTER, CENTER);
  textSize(24);
  String[] lines = loadStrings("Data.txt");
  int row = 0;
  while (row < lines.length) {
    String[] nums = splitTokens(lines[row], " ,");
    int col = 0;
    while (col < nums.length) {
      grid[row][col] = Integer.parseInt(nums[col]);
      col++;
    }
    row++;
  }
  locked = new boolean[9][9];
  row = 0;
  while (row < 9) {
    int col = 0;
    while (col < 9) {
      locked[row][col] = grid[row][col] != 0;
      col++;
    }
    row++;
  }
  row = 0;
  while (row < 9) {
    emptyCellsCount[row] = countEmptyInRow(row);
    row++;
  }
}

void draw() {
  background(255);
  drawGrid(0, 0, 9, 9, cell);
  drawNumbers(0, 0, cell);
  drawEmptyCounts(750, 45);
  drawButtons(0, buttonY, 80, 9);
  if (currentRow >= 9) {
    Finish(0, 0, cell);
  }
}

void drawGrid(int x_start, int y_start, int rows, int cols, int cellSize) {
  int row = 0;
  while (row < rows) {
    int col = 0;
    while (col < cols) {
      if (selected != null && row == selected[0] && col == selected[1]) {
        fill(0, 150, 255, 150);
      } else if (grid[row][col] == 0) {
        fill(255, 255, 150);
      } else if (!locked[row][col]) {
        if (isConflict(row, col, grid[row][col])) {
          fill(255, 150, 150);
        } else {
          fill(150, 255, 150);
        }
      } else {
        fill(255);
      }
      stroke(0);
      strokeWeight(1);
      rect(x_start + col * cellSize, y_start + row * cellSize, cellSize, cellSize);
      col++;
    }
    row++;
  }
  int i = 0;
  while (i <= rows) {
    if (i % 3 == 0) strokeWeight(6);
    else strokeWeight(2);
    stroke(0);
    line(x_start, y_start + i * cellSize, x_start + cols * cellSize, y_start + i * cellSize);
    line(x_start + i * cellSize, y_start, x_start + i * cellSize, y_start + rows * cellSize);
    i++;
  }
  highlightCurrentRow(x_start, y_start, cols, cellSize);
  if (selected != null) {
    int sr = selected[0];
    int sc = selected[1];
    noFill();
    stroke(0, 150, 255);
    strokeWeight(4);
    rect(x_start + sc * cellSize, y_start + sr * cellSize, cellSize, cellSize);
  }
}

void drawNumbers(int x_start, int y_start, int cellSize) {
  textSize(40);
  int row = 0;
  while (row < 9) {
    int col = 0;
    while (col < 9) {
      if (grid[row][col] != 0) {
        fill(0);
        text(str(grid[row][col]), x_start + col * cellSize + cellSize / 2, y_start + row * cellSize + cellSize / 2);
      }
      col++;
    }
    row++;
  }
}

void drawButtons(int x_start, int y_start, int buttonSize, int count) {
  textSize(36);
  int i = 0;
  while (i < count) {
    int x = x_start + i * buttonSize;
    fill(220);
    stroke(0);
    strokeWeight(4);
    rect(x, y_start, buttonSize, buttonSize);
    fill(0);
    text(str(i + 1), x + buttonSize / 2, y_start + buttonSize / 2);
    i++;
  }
}

void mousePressed() {
  int row = mouseY / cell;
  int col = mouseX / cell;
  if (row >= 0 && row < 9 && col >= 0 && col < 9) {
    selected = new int[]{row, col};
  }
  if (mouseY >= buttonY && mouseY <= buttonY + 80) {
    int i = mouseX / 80;
    if (i >= 0 && i < 9) {
      if (countMode) {
        mouseCountMode(i);
      }
      else if (selected != null) {
        int sr = selected[0];
        int sc = selected[1];
        if (!locked[sr][sc]) {
          grid[sr][sc] = i + 1;
        }
        selected = null;
      }
    }
  }
}

boolean isConflict(int row, int col, int val) {
  int colCheck = 0;
  while (colCheck < 9) {
    if (colCheck != col && grid[row][colCheck] == val) {
      return true;
    }
    colCheck++;
  }
  int rowCheck = 0;
  while (rowCheck < 9) {
    if (rowCheck != row && grid[rowCheck][col] == val) {
      return true;
    }
    rowCheck++;
  }
  int startRow = row - row % 3;
  int startCol = col - col % 3;
  rowCheck = startRow;
  while (rowCheck < startRow + 3) {
    int colCheckBox = startCol;
    while (colCheckBox < startCol + 3) {
      if ((rowCheck != row || colCheckBox != col) && grid[rowCheck][colCheckBox] == val) {
        return true;
      }
      colCheckBox++;
    }
    rowCheck++;
  }
  return false;
}

boolean Finish(int x_start, int y_start, int cellSize) {
  int row = 0;
  while (row < 9) {
    int col = 0;
    while (col < 9) {
      if (grid[row][col] == 0 || isConflict(row, col, grid[row][col])) {
        return false;
      }
      col++;
    }
    row++;
  }
  background(255);
  fill(0);
  textSize(60);
  text("You Win !", width / 2, height / 2);
  noLoop();
  return true;
}

int countEmptyInRow(int row) {
  int count = 0;
  int col = 0;
  while (col < 9) {
    if (grid[row][col] == 0) {
      count++;
    }
    col++;
  }
  return count;
}

void drawEmptyCounts(int x, int y) {
  textSize(30);
  int row = 0;
  int offset = 0;
  while (row < currentRow) {
    int emptyCount = countEmptyInRow(row);
    if (emptyCount > 0) {
      fill(0);
      text(emptyCount, x, y + offset);
    }
    row++;
    offset += 80;
  }
  if (currentRow < 9 && currentEmptyValue != -1 && countEmptyInRow(currentRow) > 0) {
    fill(currentEmptyColor);
    text(currentEmptyValue, x, y + offset);
  }
}

void highlightCurrentRow(int x_start, int y_start, int cols, int cellSize) {
  if (!showAllEmpty && currentRow < 9) {
    noFill();
    stroke(0, 0, 255);
    strokeWeight(4);
    rect(x_start, y_start + currentRow * cellSize, cols * cellSize, cellSize);
  }
}

void mouseCountMode(int buttonIndex) {
  int value = buttonIndex + 1;
  int correctCount = countEmptyInRow(currentRow);

  currentEmptyValue = value;
  if (value == correctCount) {
    currentEmptyColor = color(0);
    currentRow++;
    currentEmptyValue = -1;
    if (currentRow >= 9) {
      countMode = false;
      showAllEmpty = true;
    }
  } else {
    currentEmptyColor = color(255, 0, 0);
  }
}
