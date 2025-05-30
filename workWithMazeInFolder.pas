Unit workWithMazeInFolder;

interface

Uses GraphABC;
Uses UI, Window_Game;

procedure drawButtonBack();
procedure drawButtonList();
procedure drawbuttonFileName();
procedure drawButtonInputFileName(text: string);
procedure fillInputBox(ch: char);
procedure exitInputBox(key: integer);

var
  isWritingFileName: boolean;
  fileName, textFileName: string;
  isGoodMaze: boolean;

implementation

/// Процедура отрисовки кнопки 'Назад'
procedure drawButtonBack();
var
  back: Button;
begin
  back := CreateButton(250, 500, 300, 50, 'Назад', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(back);
end;

/// Процедура отрисовки кнопки 'Список лабиринтов'
procedure drawButtonList();
var
  list: Button;
begin
  list := CreateButton(275, 375, 250, 80, 'Список лабиринтов', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(list);
end;

/// Процедура отрисовки кнопки 'Введите имя лабиринта'
procedure drawbuttonFileName();
var
  fileName: Button;
begin
  fileName := CreateButton(175, 100, 450, 100, 'Введите имя лабиринта:', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(fileName);
end;

/// Процедура обновления кнопки 'Введите имя лабиринта'
procedure drawButtonInputFileName(text: string);
var
  inputFileName: Button;
  cl: Color;
begin
  if isWritingFileName then
    cl := RGB(200, 200, 0)
  else
    cl := RGB(0, 102, 51);
  inputFileName := CreateButton(175, 100, 450, 100, text, cl, RGB(24, 21, 19), 20);
  drawButton(inputFileName);
end;

/// Процедура заполнения поля с именем лабиринта 
procedure fillInputBox(ch: char);
var
  textFileName: string;
begin
  if (isWritingFileName = True) then
  begin
    if (Length(fileName) < 10) and ((ch in ['a'..'z']) 
    or (ch in ['A'..'Z']) or (ch in ['0'..'9'])) then
    begin
      textFileName += fileName + ch;
      drawButtonInputFileName(textFileName);
      fileName := textFileName;
    end;
  end;
end;

/// Процедура удаления символа из поля ввода, конец ввода
procedure exitInputBox(key: integer);
begin
  if (isWritingFileName = True) then
  begin
    if (key = VK_Back) then
    begin
      Delete(fileName, length(fileName), 1);
      drawButtonInputFileName(fileName);
    end;
    if (key = VK_Enter) then
    begin
      isWritingFileName := False;
    end;
  end;
end;
end.