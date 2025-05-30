Unit windowHelper;

interface

Uses GraphABC, UI;

procedure drawWindowHelper();

var
  drawMenu: procedure;

implementation

/// Процедура вывода правил игры
procedure rulesOfGame();
var
  x: integer;
begin
  SetFontSize(28);
  SetBrushColor(RGB(138, 149, 151));
  Line(0, 25, 800, 25);
  Line(0, 125, 800, 125);
  x := (800 - textwidth('Краткая справка по игре "Лабиринт"')) div 2;
  TextOut(x, 50, 'Краткая справка по игре "Лабиринт"');
  SetFontSize(16);
  TextOut(50, 135, 'Цель игры - найти выход из лабиринта, перемещаясь по клеткам и');
  TextOut(35, 165, 'избегая препятствий. Синяя клетка обозначает старт, а красная - финиш.');
  TextOut(35, 195, 'Можно открыть лабиринт из папки или же создать новый. Для того чтобы');
  TextOut(35, 225, 'перемещаться по лабиринту, используйте клавиши W A S D. По окончании');
  TextOut(35, 255, 'игры вы сможете сравнить свой путь с наикратчайшим!');
  TextOut(50, 285, 'В игре также есть редактор лабиринта, который позволяет создавать и');
  TextOut(35, 315, 'редактировать свои собственные лабиринты. Можно редактировать один');
  TextOut(35, 345, 'из имеющихся лабиринтов, сгенерировать новый или же создать');
  TextOut(35, 375, 'полностью пустой лабиринт!');
end;

/// Процедура отрисовки кнопки 'Выход'
procedure drawButtonExit();
var
  exite: Button;
begin
  exite := CreateButton(300, 500, 200, 50, 'Выход', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(exite);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопки
/// 'Выход'
procedure windowHelperOnMOuseDown(x, y, mousebutton: integer);
begin
  if (mousebutton = 1) and (x > 300) and (x < 500) 
  and (y > 500) and (y < 550) then
  begin
    ClearWindow();
    drawMenu();
  end;
end;

/// Процедура отрисовки справки
procedure drawWindowHelper();
begin
  fillArea();
  rulesOfGame();
  drawButtonExit();
  onMouseDown := windowHelperOnMOuseDown;
end;
end.