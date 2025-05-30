Unit gameLogic;

interface

Uses GraphABC;
Uses UI;
Uses gameInterface;
Uses mazeGenerator, mazeData;

const
  INF = integer.MaxValue;
  
var
  shortestPath: integer;

procedure game;
procedure gameForMazeFromFile;
procedure setupFinishForRandomGeneratedMap;
function dijkstra(sx, sy, fx, fy: integer): integer;

implementation

Type
  TPoint = record
    x, y: integer;
    end;
var
  gameFinished: boolean;
  playerPath: array of TPoint;
  playerPathCount: integer;
  prev: array[0..MAXWIDTH, 0..MAXHEIGHT] of TPoint; // массив предков
  w, h: integer;

/// Функция нахождения кратчайшего пути в лабиринте  
function dijkstra(sx, sy, fx, fy: integer): integer;
var
  dist: array[0..MAXWIDTH, 0..MAXHEIGHT] of integer; // массив расстояний
  visited: array[0..MAXWIDTH, 0..MAXHEIGHT] of boolean; // массив посещенных клеток
  i, j, u, v, minD: integer;
begin
  for i := 0 to width do
  begin
    for j := 0 to height do
    begin
      dist[i, j] := INF;
      prev[i, j].x := -1;
      prev[i, j].y := -1;
      visited[i, j] := false;
    end;
  end;
  dist[sx, sy] := 0;
  
  // поиск вершины с минимальным расстоянием
  repeat
    minD := INF;
    for i := 0 to width do
    begin
      for j := 0 to height do
      begin
        if (not visited[i, j]) and (dist[i, j] < minD) then
        begin
          minD := dist[i, j];
          u := i;
          v := j;
        end;
      end;
    end;
    
    // check up
    if (v > 0) and (maze[u, v - 1] <> 0) and (not visited[u, v - 1]) 
    and (dist[u, v - 1] > dist[u, v] + 1) then
    begin
      dist[u, v - 1] := dist[u, v] + 1;
      prev[u, v - 1].x := u;
      prev[u, v - 1].y := v;
    end;
    
    // check down
    if (v < height-1) and (maze[u, v + 1] <> 0) and (not visited[u, v + 1]) 
    and (dist[u, v + 1] > dist[u, v] + 1) then
    begin
      dist[u, v + 1] := dist[u, v] + 1;
      prev[u, v + 1].x := u;
      prev[u, v + 1].y := v;
    end;
    
    // check left
    if (u > 0) and (maze[u - 1, v] <> 0) and (not visited[u - 1, v]) 
    and (dist[u - 1, v] > dist[u, v] + 1) then
    begin
      dist[u - 1, v] := dist[u, v] + 1;
      prev[u - 1, v].x := u;
      prev[u - 1, v].y := v;
    end;
    
    // check right
    if (u < width-1) and (maze[u + 1, v] <> 0) and (not visited[u + 1, v]) 
    and (dist[u + 1, v] > dist[u, v] + 1) then
    begin
      dist[u + 1, v] := dist[u, v] + 1;
      prev[u + 1, v].x := u;
      prev[u + 1, v].y := v;
    end;
      
    // если доходим до финиша, то завешаем алгоритм
    if (u = fx) and (v = fy) then
      break;
    visited[u, v] := true;
    
  until minD = INF;
  
  dijkstra := dist[fx, fy];
end;

/// Процедура отрисовки кратчайшего пути из лабиринта
procedure drawShortestPath(sx, sy, fx, fy: integer; playerPath: array of TPoint);
var
  x, y: integer;
  tempX, tempY: integer;
  isInPlayerPath: boolean;
begin
  
  /// начинаем с финишной точки
  x := fx;
  y := fy;

  /// отмечаем финишную точку
  if (x > 0) and (x < width) and (y > 0) and (y < height) then
  begin
    SetBrushColor(clRed);
    FillRect(x * SIZE + offsetX, y * SIZE + offsetY, (x + 1) * SIZE + offsetX, (y + 1) * SIZE + offsetY);
  end;

  /// переходим к предыдущей точке и отмечаем ее
  while (prev[x, y].x <> -1) and (prev[x, y].y <> -1) do
  begin
    tempX := x;
    tempY := y;

    x := prev[tempX, tempY].x;
    y := prev[tempX, tempY].y;

    /// проверяем, есть ли текущая точка в пути игрока
    isInPlayerPath := false;
    for var i := 0 to High(playerPath) do
    begin
      if (playerPath[i].x = tempX) and (playerPath[i].y = tempY) then
      begin
        isInPlayerPath := true;
        Break;
      end;
    end;

    if (x > 0) and (x < width) and (y > 0) and (y < height) then
    begin
      if isInPlayerPath then
        SetBrushColor(clBlue)
      else
        SetBrushColor(clGreen);
      FillRect(x * SIZE + offsetX, y * SIZE + offsetY, (x + 1) * SIZE + offsetX, (y + 1) * SIZE + offsetY);
    end;
  end;

  /// отмечаем стартовую точку
  if (sx > 0) and (sx < width) and (sy > 0) and (sy < height) then
  begin
    SetBrushColor(clGreen);
    FillRect(sx * SIZE + offsetX, sy * SIZE + offsetY, (sx + 1) * SIZE + offsetX, (sy + 1) * SIZE + offsetY);
  end;

  /// отмечаем финишную точку еще раз, чтобы затереть стартовую точку игрока
  if (x > 0) and (x < width) and (y > 0) and (y < height) then
  begin
    SetBrushColor(clBlue);
    FillRect(x * SIZE + offsetX, y * SIZE + offsetY, (x + 1) * SIZE + offsetX, (y + 1) * SIZE + offsetY);
  end;
end;

/// Отрисовка пункта неоптимальности пути игрока
function countPersentResult(): string;
begin
  countPersentResult := IntToStr(Round((playerPathCount - shortestPath) / shortestPath * 100));
end;

/// Процедура обработки нажатия клавиши
procedure movingOnKeyDown(key: integer);
var
  dir: integer;
begin
  if (not gameFinished) then
  begin  
    dir := maze[w, h];
    if (key = VK_W) then
    begin
      if (maze[w, h - 1] <> 0) then
      begin
        SetBrushColor(clYellow);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        dir := maze[w, h - 1];
        h := h - 1;
        SetBrushColor(clBlue);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        playerPathCount += 1;
      end;
    end
    else if (key = VK_A) then
    begin
      if (maze[w - 1, h] <> 0) then
      begin
        SetBrushColor(clYellow);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        dir := maze[w - 1, h];
        w := w - 1;
        SetBrushColor(clBlue);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        playerPathCount += 1;
      end;
    end
    else if (key = VK_S) then
    begin
      if (maze[w, h + 1] <> 0) then
      begin
        SetBrushColor(clYellow);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        dir := maze[w, h + 1];
        h := h + 1;
        SetBrushColor(clBlue);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        playerPathCount += 1;
      end;
    end
    else if (key = VK_D) then
    begin
      if (maze[w + 1, h] <> 0) then
      begin
        SetBrushColor(clYellow);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        dir := maze[w + 1, h];
        w := w + 1;
        SetBrushColor(clBlue);
        FillRect(w * Size + offsetX, h * Size + offsetY, (w + 1) * Size + offsetX, (h + 1) * Size + offsetY);
        playerPathCount += 1;
      end;
    end;  
    Str(playerPathCount, strPlayerPath);
    gameInterface.drawButtonCounter(concat('Ходов: ', strPlayerPath));
    if (w = fx) and (h = fy) then
    begin
      Str(shortestPath, strShortestPath);
      strPersentResult := countPersentResult;
      finalGame();
      drawShortestPath(sx, sy, fx, fy, playerPath); // отрисовка кратчайшего пути
      gameFinished := true;
    end;
  end;
end;

/// Процедура установки финиша для генерируемого лабиринта
procedure setupFinishForRandomGeneratedMap();
var
  maxCell: integer;
  i,j:integer;
begin
  maxCell := -1;
  for i := 1 to WIDTH-1 do
  begin
    for j := 1 to HEIGHT-1 do
    begin
      if (maze[i, j] >= maxCell) and (
              (maze[i - 1, j] + maze[i + 1, j] + maze[i, j + 1] = 0) or 
              (maze[i - 1, j] + maze[i + 1, j] + maze[i, j - 1] = 0) or 
              (maze[i - 1, j] + maze[i, j - 1] + maze[i, j + 1] = 0) or 
              (maze[i + 1, j] + maze[i, j - 1] + maze[i, j + 1] = 0)) then        
      begin
        fx := i;
        fy := j;
        maxCell := maze[i, j];
      end;
    end;
  end;
end;

/// Процедура, реализующая логику игры для
/// лабиринта, загружаемого из файла
procedure gameForMazeFromFile();
begin
  playerPathCount := 0;
  drawGameInterface(); /// отрисовка кнопок в окне игры
  drawMaze(); /// отрисовка лабиринта
  drawMazeStart(fx, fy);
  drawMazeFinish(sx, sy);
  drawMazeGrid();
  w := sx;
  h := sy;
  shortestPath := dijkstra(sx, sy, fx, fy); /// кратчайший путь (его длина)
  OnKeyDown := movingOnKeyDown;
  gameFinished := false;
end;

/// Процедура, реализующая логику игры для
/// генерируемого лабиринта
procedure game();
begin
  playerPathCount := 0;
  drawGameInterface(); /// отрисовка кнопок в окне игры
  generateMaze();
  setupFinishForRandomGeneratedMap();
  drawMaze(); /// отрисовка лабиринта
  drawMazeGrid();
  drawMazeStart(fx, fy);
  drawMazeFinish(sx, sy);
  w := sx;
  h := sy;
  shortestPath := dijkstra(sx, sy, fx, fy); /// кратчайший путь (его длина)
  OnKeyDown := movingOnKeyDown;
  gameFinished := false;
end;
end.