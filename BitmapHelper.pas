unit BitmapHelper;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls
  ;
type
  TBitmapHelper = Class helper for TBitmap
    Procedure Pan(Const aValue: Integer);
    Procedure Scroll(Const aValue: Integer);
  End;

implementation


procedure TBitmapHelper.Pan(const aValue: Integer);
var
  MyRect: TRectF;
  x, y: Integer;
  oLocalBMP, newbmp: TBitmap;
  bitdata1, bitdata2: TBitmapData;
  nHeight: Integer;
  nWidth: Integer;
  nStart: Integer;
  nEnd: Integer;
begin
  if aValue = 0 then exit;

  oLocalBMP := TBitmap.Create;
  NewBMP := TBitmap.Create;
  try
    NewBMP.SetSize(Size);
    oLocalBMP.Assign(Self);
    Myrect := oLocalBMP.BoundsF;
    nHeight := Size.Height;
    nWidth := Size.Width;

    if aValue < 0 then
    begin
      nStart := aValue * -1;
      nEnd := (nWidth - 1); // - aValue  nHeight - 1;
    end
    else
    begin
      nStart := 0;
      nEnd := (nWidth - 1) - aValue;
    end;

    if (oLocalBMP.Map(TMapAccess.ReadWrite, bitdata1)) and
       (NewBMP.Map(TMapAccess.ReadWrite, bitdata2)) then
      try
        for x := nStart to nEnd do
          for y := 0 to (nHeight - 1) do
            bitdata2.SetPixel(x + aValue, y, bitdata1.GetPixel(x, y));
        finally
          oLocalbmp.Unmap(bitdata1);
          newbmp.Unmap(bitdata2);
        end;

    Canvas.BeginScene;
    Canvas.Clear(TAlphaColorRec.Black);
    Canvas.DrawBitmap(NewBMP,  Myrect,Myrect, 1.0);
    Canvas.EndScene;
  finally
    FreeAndNil(oLocalBMP);
    FreeAndNil(NewBMP);
  end;

end;

procedure TBitmapHelper.Scroll(const aValue: Integer);
var
  MyRect: TRectF;
  x, y: Integer;
  oLocalBMP, NewBMP: TBitmap;
  bitdata1, bitdata2: TBitmapData;
  nHeight: Integer;
  nWidth: Integer;
  nStart: Integer;
  nEnd: Integer;
begin
  if aValue = 0 then exit;

  oLocalBMP := TBitmap.Create;
  NewBMP := TBitmap.Create;
  try
    NewBMP.SetSize(Size);
    oLocalBMP.Assign(Self);
    Myrect := oLocalBMP.BoundsF;
    nHeight := Size.Height;
    nWidth := Size.Width;
    if aValue < 0 then
    begin
      nStart := aValue * -1;
      nEnd := nHeight - 1;
    end
    else
    begin
      nStart := 0;
      nEnd := (nHeight - 1) - aValue;
    end;

    if (oLocalBMP.Map(TMapAccess.ReadWrite, bitdata1)) and
       (NewBMP.Map(TMapAccess.ReadWrite, bitdata2)) then
      try
        for y := nStart to nEnd do
          for x := 0 to (nWidth - 1) do
            bitdata2.SetPixel(x, (y + AValue), bitdata1.GetPixel(x, y));
      finally
        oLocalbmp.Unmap(bitdata1);
        newbmp.Unmap(bitdata2);
      end;

    Canvas.BeginScene;
    try
      Canvas.Clear(TAlphaColorRec.Black);
      Canvas.DrawBitmap(NewBMP, Myrect, Myrect, 1.0);
    finally
      Canvas.EndScene;
    end;
  finally
    FreeAndNil(oLocalBMP);
    FreeAndNil(NewBMP);
  end;

end;

end.
