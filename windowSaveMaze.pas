Unit windowSaveMaze;

interface

Uses GraphABC, UI, gameLogic, redactorMaze, mazeData, saveAndLoadMaze, workWithMazeInFolder;

var
  drawRedactor: procedure();
  
procedure drawWindowSaveMaze();

implementation

/// Процедура отрисовки кнопки 'Ошибка: нет старта или финиша!'
procedure drawbuttonWarningNoControlPoints();
var
  noControlPoints: Button;
begin
  noControlPoints := CreateButton(175, 100, 450, 100, 'Ошибка: нет старта или финиша!', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(noControlPoints);
end;

/// Процедура отрисовки кнопки 'Ошибка: нет выхода из лабиринта!'
procedure drawButtonErrorNoName();
var
  warningNoWay: Button;
begin
  warningNoWay := CreateButton(175, 100, 450, 100, 'Ошибка: имя не может быть пустым!', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(warningNoWay);
end;

/// Процедура отрисовки кнопки 'Ошибка: нет выхода из лабиринта!'
procedure drawButtonWarningNoWay();
var
  warningNoWay: Button;
begin
  warningNoWay := CreateButton(175, 100, 450, 100, 'Ошибка: нет выхода из лабиринта!', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(warningNoWay);
end;

/// Процедура отрисовки кнопки 'Сохранить'
procedure drawButtonSave();
var
  OK: Button;
begin
  OK := CreateButton(275, 250, 250, 80, 'Сохранить', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(OK);
end;

/// Процедура отрисовки кнопки, сообщающей
/// об успешности сохранения лабиринта
procedure drawButtonIsMazeSaved(text: string);
var
  IsMazeSaved: Button;
begin
  IsMazeSaved := CreateButton(175, 100, 450, 100, text, RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(IsMazeSaved);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопки
procedure windowSaveMazeOnMouseDown(x, y, mousebutton: integer);
begin
  if (mousebutton = 1) and (x > 275) and (x < 525) and 
  (y > 425) and (y < 505) then
  begin
    isGoodMaze := False;
    fileName := '';
    isWritingFileName := False; 
    drawLastMaze();
  end;
  if (mousebutton = 1) and isGoodMaze and (x > 175) and 
  (x < 625) and (y > 100) and (y < 200) then
  begin
    isWritingFileName := True;  
    drawButtonInputFileName(fileName);
  end;
  if (mousebutton = 1) and isGoodMaze and (x > 275) and 
  (x < 525) and (y > 250) and (y < 330) then
  begin
    if fileName = '' then
    begin
      SetBrushColor(RGB(138, 149, 151));
      FillRect(275, 250, 525, 330);
      drawButtonErrorNoName();
    end
    else if not(FileExists(GetCurrentDir + '\Лабиринты\' + fileName)) then
    begin
      saveMazeToFile(fileName);
      fileName := '';
      isGoodMaze := False;
      SetBrushColor(RGB(138, 149, 151));
      FillRect(275, 250, 525, 330);
      drawButtonIsMazeSaved('Лабиринт успешно сохранён!');
    end
    else
    begin
      fileName := '';
      drawButtonIsMazeSaved('Лабиринт с таким именем уже есть');
    end;
  end; 
end;

/// Процедура отрисовки меню сохранения лабиринта
procedure drawWindowSaveMaze();
begin
  ClearWindow();
  NormalizeWindow();
  FillArea();
  drawButtonBack();
  OnMouseDown := windowSaveMazeOnMouseDown;
  OnKeyDown := exitInputBox;
  OnKeyPress := fillInputBox;
  
  if ((not isSetStart) or (not isSetFinish)) then
  begin
    drawbuttonWarningNoControlPoints();
  end
  
  else if not(isWayinMaze) then
  begin
    drawbuttonWarningNoWay();
  end
    
  else
  begin
    isGoodMaze := True;
    drawButtonFileName();
    drawButtonSave();
  end;
end;  
end.