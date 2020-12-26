unit CanvasHelper;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls
  ;
type
  TcanvasHelper = Class helper for Tcanvas
    Procedure Circle(Const ax, ay, ar: Integer; Const  aColor: TAlphaColor; Const aFill: Boolean = True);
    Procedure Block(Const awidth, aheight, ax, ay: Integer; Const  aColor: TAlphaColor; Const aFill: Boolean = True);
    procedure DrawText(const sText: String; Y1, X1: Single; Const Color, Background: TAlphaColor );
    Procedure DrawSprite(const oBmp: TBitmap; Y1, X1: Single; Const Color, background: TAlphaColor; lOver:Boolean = true);
    Procedure DrawSprite16(const oBmp: TBitmap; Y1, X1: Single);
  End;


implementation

{ TcanvasHelper }
Procedure TcanvasHelper.DrawSprite(const oBmp: TBitmap; Y1, X1: Single; Const Color, background: TAlphaColor; lOver:Boolean = true);
var mRect, mRectSource: TRectF;
  sWidth: Single;
  sHeight: Single;
  FB: TBrush;
  bitdata1: TBitmapData;
  y: Integer;
  x: Integer;
  oLocalBMP: TBitmap;
begin
  if assigned(Self) then
  begin
    oLocalBMP := TBitmap.Create;
    BeginScene();
    try
      oLocalBMP.Assign(oBmp);
      if (oBmp.Map(TMapAccess.ReadWrite, bitdata1)) then
      try
        for y := 0 to 8 do
          for x := 0 to 7 do
            if bitdata1.GetPixel(x, y) <> TAlphaColorRec.Alpha  then
              bitdata1.SetPixel(x, y, Color)
            else
            begin
              if background <> TAlphaColorRec.Alpha then
                bitdata1.SetPixel(x, y, background);
            end;
      finally
        oBmp.Unmap(bitdata1);
      end;

      Stroke.Kind := TBrushKind.None;
      StrokeThickness := 0;

      sWidth  := 8;
      sHeight := 9;

      X1 := (X1 * sWidth);
      Y1 := (Y1 * sHeight);

      mRect.Create(X1, Y1, X1 + sWidth, Y1 + sHeight);
      mRectSource.Create(0, 0, oBmp.Width, oBmp.Height);
      if not lOver then
      begin
        FB := TBrush.Create(TBrushKind.bkSolid, Background);
        FillRect(mrect,0,0,[],1,FB);
        FreeAndNil(FB);
      end;
      DrawBitmap(oBmp, mRectSource, mRect, 1.0);
    finally
      EndScene;
      oBmp.Assign(oLocalBMP);
      oLocalBMP.Free;
      oLocalBMP := Nil;
    end;
  end;
end;

procedure TcanvasHelper.DrawSprite16(const oBmp: TBitmap; Y1, X1: Single);
var mRect, mRectSource: TRectF;
  sWidth: Single;
  sHeight: Single;
begin
  if assigned(Self) then
  begin
    BeginScene();
    try
      Stroke.Kind := TBrushKind.None;
      StrokeThickness := 0;

      sWidth  := 8;
      sHeight := 8;

      X1 := (X1 * sWidth);
      Y1 := (Y1 * sHeight);

      mRect.Create(X1, Y1, X1 + 16, Y1 + 16);
      mRectSource.Create(0, 0, oBmp.Width, oBmp.Height);
      DrawBitmap(oBmp, mRectSource, mRect, 1.0);
    finally
      EndScene;
    end;
  end;

end;

procedure TcanvasHelper.DrawText(const sText: String; Y1, X1: Single; Const Color, Background: TAlphaColor );
var mRect: TRectF;
  sWidth: Single;
  sHeight: Single;
  FB: TBrush;
begin
  if assigned(Self) then begin
    BeginScene();
    try
      Font.Family := 'Arial';
      Font.size := 10;
      Font.Style := [TFontStyle.fsBold];
      Stroke.Kind := TBrushKind.None;
      StrokeThickness := 0;
      Fill.Color := Color;

      sWidth  := TextWidth('X');
      sHeight := TextHeight('X');

      sWidth  := sWidth * Length(sText);
      mRect.Create(X1, Y1, X1 + sWidth, Y1 + sHeight);

      FB := TBrush.Create(TBrushKind.bkSolid, Background);
      FillRect(mrect,0,0,[],1,FB);
      FreeAndNil(FB);
      FillText(mRect, sText, false, 1.0, [], TTextAlign.Leading, TTextAlign.Center);
    finally
      EndScene;
    end;
  end;
end;

procedure TcanvasHelper.Block(const awidth, aheight, ax, ay: Integer;
  const aColor: TAlphaColor; const aFill: Boolean);
var
  MyRect: TRectF;
  FB: TStrokeBrush;
begin
  MyRect := TRectF.Create(ax, ay, ax + awidth, ay + aheight);
  BeginScene;
  try
    Stroke.Kind := TBrushKind.None;
    Stroke.Thickness := 0;
    FB := TStrokeBrush.Create(TBrushKind.Solid, aColor);
    FB.DefaultColor := aColor;
    FB.Cap := TStrokeCap.Round;
    FB.Thickness := 1;

    try
      if aFill then
        FillRect(MyRect,0,0,[],1.0,FB)
      else
        DrawRect(MyRect,0,0,[],1.0,FB);
    finally
      FreeAndNil(FB);
    end;
  finally
    EndScene;
  end;

end;

procedure TcanvasHelper.Circle(const ax, ay, ar: Integer;
  const aColor: TAlphaColor; const aFill: Boolean);
var
  MyRect: TRectF;
  FB: TStrokeBrush;
begin
  MyRect := TRectF.Create(ax-ar, ay-ar, ax + ar, ay + ar);
  BeginScene;
  try
    Stroke.Kind := TBrushKind.None;
    Stroke.Thickness := 0;


    FB := TStrokeBrush.Create(TBrushKind.Solid, aColor);
    FB.DefaultColor := aColor;
    FB.Cap := TStrokeCap.Round;
    FB.Thickness := 1;

    try
      if aFill then
        FillEllipse(MyRect,1.0, FB)
      else
        DrawEllipse(MyRect,1.0, FB);

    finally
      FreeAndNil(FB);
    end;
  finally
    EndScene;
  end;
end;



end.
