unit UI;

interface

uses GraphABC;

type
  ButtonSize = record
    x: integer;
    y: integer;
    w: integer;
    h: integer;
  end;
  
  Button = record
    size: ButtonSize;
    text: string;
    bruhColor: color;
    fontColor: color;
    fontsize: integer;
  end;

function CreateButton(x, y, w, h: integer; text: string; bruhColor: color; fontColor: color; fontsize: integer): Button; 
procedure FillArea();

procedure drawButton(button: Button);

implementation

/// Процедура заполнения фона окна
procedure FillArea();
begin
  FloodFill(0, 0, RGB(138, 149, 151));
end;

/// Функция кастомизации кнопки
function CreateButton(x, y, w, h: integer; text: string; bruhColor: color; fontColor: color; fontsize: integer): Button; 
begin
  result.size.x := x;
  result.size.y := y;
  result.size.w := w;
  result.size.h := h;
  result.text := text;
  result.bruhColor := bruhColor;
  result.fontColor := fontColor;
  result.fontsize := fontsize;
end;

/// Процедура отрисовки кнопки. x, y - начальные значения по x и y. w, h - отрезки отрисовки по оси x, y.
procedure DrawButton(button: Button);
var
  textW: integer;
var
  textH: integer;
begin
  SetBrushColor(button.bruhColor);
  SetFontColor(button.fontColor);
  SetFontSize(button.fontSize);
  Rectangle(button.size.x, button.size.y, button.size.x + button.size.w, button.size.y + button.size.h);
  textW := TextWidth(button.text);
  textH := TextHeight(button.text);
  TextOut(button.size.x + trunc(button.size.w * 0.5 - textW * 0.5),
          button.size.y + trunc(button.size.h * 0.5 - textH * 0.5),
          button.text);        
end;
end.