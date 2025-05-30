Unit windowOpenMazeFromFolder;

interface

Uses GraphABC, UI, workWithMazeInFolder, saveandLoadMaze, Window_Game, gameLogic, mazeData;

var
  drawWindowRedactorMaze: procedure();
  drawLastMaze: procedure();
  drawWindowListWithMazes: procedure(currentPage: integer);

const
  maxWidth = (Trunc(ScreenWidth / (size * 2)) - 2) * 2;
  maxHeight = (Trunc(ScreenHeight / (size * 2)) - Trunc(offsetY / (size + 1))) * 2;

procedure drawWindowOpenMazeFromFolder;
procedure findStartAndFinishForMazeFromFile();

implementation

/// Процедура нахождения старта и финиша 
/// в лабиринте из файла
procedure findStartAndFinishForMazeFromFile();
var
  x, y: integer;
begin
  for x := 0 to width do
  begin
    for y := 0 to height do
    begin
      if maze[x, y] = 2 then
      begin
        sx := x;
        sy := y;
      end;
      
      if maze[x, y] = 3 then
      begin
        fx := x;
        fy := y;
      end;
    end;
  end;
end;

/// Процедура отрисовки кнопки 'Старт'
procedure drawButtonStart();
var
  OK: Button;
begin
  OK := CreateButton(275, 250, 250, 80, 'Начать', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(OK);
end;

/// Процедура отрисовки ошибки при попытке 
/// сохранить некорректный редактируемый лабиринт
procedure drawButtonIsGoodMaze(text: string);
var
  isGoodMaze: Button;
begin
  isGoodMaze := CreateButton(175, 100, 450, 100, text, RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(isGoodMaze);
end;

/// Процедура для обработки нажатия на ЛКМ
procedure windowOpenMazeFromFolderOnMouseDown(x, y, mousebutton: integer);
begin
  if (mousebutton = 1) and (x > 250) and (x < 550) and 
  (y > 500) and (y < 550) then
  begin
    if isGame then
    begin
      fileName := '';
      isWritingFileName := False;
      drawWindowGameMode();
    end
    
    else if isRedactor then
    begin
      isWritingFileName := False;
      fileName := '';
      drawWindowRedactorMaze();
    end;
  end;
  
  if (mousebutton = 1) and (x > 275) and (x < 525) and 
  (y > 375) and (y < 455) then
  begin
    isWritingFileName := False;
    fileName := '';
    drawWindowListWithMazes(1);
  end;
    
  if (mousebutton = 1) and (x > 175) and 
  (x < 625) and (y > 100) and (y < 200) then
  begin  
    drawButtonInputFileName(fileName);
  end;
  
  if (mousebutton = 1) and (x > 275) and 
  (x < 525) and (y > 250) and (y < 330) then
  begin
    if FileExists(GetCurrentDir + '\Лабиринты\' + fileName) then
    begin
      isWritingFileName := False;
      loadMazeFromFile(fileName);
      if (width > maxWidth) or (height > maxHeight) then
      begin
        fileName := '';
        drawButtonIsGoodMaze('Лабиринт слишком большой'); 
      end
      else if isGame then
      begin
        findStartAndFinishForMazeFromFile();
        gameForMazeFromFile();
        isWritingFileName := False;
        fileName := '';
      end
      else if isRedactor then
      begin
        drawLastMaze();
        isWritingFileName := False;
        fileName := '';
      end;
    end
    
    else
    begin
      fileName := '';
      drawButtonIsGoodMaze('Такого лабиринта нет!');
    end;
  end; 
end;

/// Процедура отрисовки меню загрузки лабиринта из файла
procedure drawWindowOpenMazeFromFolder();
begin
  ClearWindow();
  NormalizeWindow();
  FillArea();
  isWritingFileName := True;
  drawButtonBack();
  drawButtonList();
  drawButtonStart();
  drawButtonFileName();
  OnMouseDown := windowOpenMazeFromFolderOnMouseDown;
  OnKeyDown := exitInputBox;
  OnKeyPress := fillInputBox;
end;  
end.