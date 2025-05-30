Unit startScreen;

interface

Uses GraphABC;
Uses menu, UI;

procedure drawStartScreen();

implementation

/// При нажатии на любую клавишу переходим в меню
procedure AnyKeyStartScreen(key: integer);
begin
  clearWindow();
  drawMenu();
end;

///Отрисовка начального экрана
procedure drawStartScreen();
var
  textsize: integer;
  centerX: integer;
begin
  SetWindowTitle('Лабиринт');
  SetWindowWidth(800);
  SetWindowHeight(600);
  CenterWindow();
  OnKeyDown := AnyKeyStartScreen;
  fillArea();
  LockDrawing();
  SetFontColor(clBlack);
  SetFontSize(52);
  SetBrushColor(RGB(138, 149, 151));
  SetFontStyle(fsBold);
  textsize := TextWidth('Лабиринт');
  centerX := (800 - textSize) div 2;
  TextOut(centerX, 150, 'Лабиринт');
  SetFontStyle(fsNormal);
  SetFontSize(20);
  textsize := TextWidth('Нажмите любую клавишу для продолжения');
  centerX := (800 - textSize) div 2;
  TextOut(centerX, 425, 'Нажмите любую клавишу для продолжения');
  SetFontSize(20);
  textsize := TextWidth('Игру разработал: Манохин Никита студент группы 2413');
  centerX := (800 - textSize) div 2;
  TextOut(centerX, 550, 'Игру разработал: Манохин Никита студент группы 2413');
  UnlockDrawing();
end;
end.