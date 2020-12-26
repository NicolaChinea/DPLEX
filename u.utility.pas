unit u.utility;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Objects
  , u.typeinfo
  ;

  procedure ByteArrayToFIle(const ByteArray: TRecArray; const FileName: string);
  function FIleToByteArray(const FileName: string): TRecArray;
  procedure CreateUDG;
  Procedure DrawMap(const aLivello: oRecLivello; Var rWMain: TRectangle; Const py, px: Integer);
  Function GetColor(Const nColor: Integer): TAlphaColor;
implementation

uses
   FMX.Graphics
   , u.Constant.Loc
   , CanvasHelper
   ;

Function GetColor(Const nColor: Integer): TAlphaColor;
begin
  case nColor of
    0: Result := TAlphaColorRec.Black;
    1: Result := TAlphaColorRec.Blue;
    2: Result := TAlphaColorRec.Green;
    3: Result := TAlphaColorRec.Cyan;
    4: Result := TAlphaColorRec.Red;
    5: Result := TAlphaColorRec.Magenta;
    6: Result := TAlphaColorRec.Brown;
    7: Result := TAlphaColorRec.White;
    8: Result := TAlphaColorRec.Grey;
    9: Result := TAlphaColorRec.Lightblue;
   10: Result := TAlphaColorRec.Lightgreen;
   11: Result := TAlphaColorRec.Lightcyan;
   12: Result := TAlphaColorRec.Red;
   13: Result := TAlphaColorRec.Lightcoral;
   14: Result := TAlphaColorRec.Yellow;
   15: Result := TAlphaColorRec.White;
  else
    Result := TAlphaColorRec.Black;
  end;
end;

procedure ByteArrayToFIle(const ByteArray: TRecArray; const FileName: string);
var Count : integer;
    F: FIle of Byte;
    pTemp: Pointer;
begin
  AssignFile( F, FileName );
  Rewrite(F);
  try
    Count := Length( ByteArray );
    pTemp := @ByteArray[0];
    BlockWrite(F, pTemp^, Count );
  finally
    CloseFile( F );
  end;
end;

function FIleToByteArray(const FileName: string): TRecArray;
var Count: integer;
    F: FIle of Byte;
    pTemp: Pointer;
begin
  AssignFile( F, FileName );
  Reset(F);
  try
    Count := FileSize( F );
    pTemp := @Result[0];
    BlockRead(f,pTemp^,count);
  finally
    CloseFile( F );
  end;
end;

procedure CreateUDG;
var bitdata: TBitmapData;
    i, x, y, h: Integer;
begin
  for h := 0 to CS_SPRITE do
  begin
    oSprite16[h] := TBitmap.Create;
    oSprite16[h].Width := CS_SPRITE_W;
    oSprite16[h].Height := CS_SPRITE_H;
    if (oSprite16[h].Map(TMapAccess.ReadWrite, bitdata)) then
    try
      i := 0;
      for y := 0 to CS_SPRITE_H - 1 do
        for x := 0 to CS_SPRITE_W - 1 do
        begin
          bitdata.SetPixel(x, y, aSprite[h][i]);
          inc(i);
        end;
    finally
      oSprite16[h].Unmap(bitdata);
    end;
  end;
//  oSprite16[0].SaveToFile('testnic.png');

end;

Procedure DrawMap(const aLivello: oRecLivello; Var rWMain: TRectangle; Const py, px: Integer);
Var _X, _Y: Integer;
begin
  _X := Trunc(sx + px / 2);
  _Y := Trunc(sy + py / 2);
  if aLivello.Mappa[_Y-1][_X-1] = CS_MAP_VUOTO then  {Vuoto}
    rWMain.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_NERO], py, px);

  if aLivello.Mappa[_Y-1][_X-1] = CS_MAP_MURA then {Muro}
    rWMain.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_MURA], py, px);

  if aLivello.Mappa[_Y-1][_X-1] = CS_MAP_FONDO then {Fondo}
    rWMain.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_FONDO], py, px);

  if aLivello.Mappa[_Y-1][_X-1] = CS_MAP_BOMBA then {bomba}
    rWMain.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_BOMBA], py, px);

  if aLivello.Mappa[_Y-1][_X-1] = CS_MAP_DIAMANTE then {Diamante}
    rWMain.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_DIAMANTE], py, px);
end;

end.
