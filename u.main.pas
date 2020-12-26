unit u.main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, u.Constant.Loc,
  FMX.Objects, CanvasHelper, u.utility, u.typeinfo, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, BitmapHelper;

type
  TFMain = class(TForm)
    rMessaggi: TRectangle;
    rScreen: TRectangle;
    Timer1: TTimer;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Memo2: TMemo;
    rManu: TRectangle;
    rLogo: TRectangle;
    rMenu1: TRectangle;
    rbtLoad: TRectangle;
    Text3: TText;
    rbtNew: TRectangle;
    ttNew: TText;
    rbtSave: TRectangle;
    Text2: TText;
    Rectangle3: TRectangle;
    Text4: TText;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ttNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Text3Click(Sender: TObject);
  private
    nIndex: Integer;
    nColor: Integer;
    level, old, runde: Integer;
    procedure MovePlayer;
    procedure Spinta;
    procedure scp;
    procedure TestMap;
    procedure Punteggio;
    Procedure Game;
    procedure Caduta(const ey, ex: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

procedure TFMain.Button1Click(Sender: TObject);
Var orec: oRecLivello;
  T: File of oRecLivello;
  i: Integer;
  s: string;
  j: Integer;
  MyArray : TRecArray absolute orec; // overlays the same memory locations
begin
  oRec.Livello := 1;
  oRec.Diamond := 66;
  oRec.SY := 10;
  oRec.SX := 3;
  oRec.RY := 18;
  oRec.RX := 12;
  oRec.nTime := 200;
  for i := 0 to memo1.Lines.Count - 1 do
  begin
    s := memo1.Lines[i];
    for j := 1 to length(s) do
      oRec.Mappa[i][j-1] := s[j];
  end;

  ByteArrayToFIle(MyArray,'livelli\Livello_1.lev');

end;

procedure TFMain.Button2Click(Sender: TObject);
Var oBmp: TBitmap;
    bitdata1: TBitmapData;
    nTemp, x, y: Integer;
    oColor: TAlphaColor;
    sTemp: String;
begin
  oBmp := TBitmap.CreateFromFile('Dia1.png');
  if (oBmp.Map(TMapAccess.ReadWrite, bitdata1)) then
  try
    for y:= 0 to oBmp.Height -1 do
    begin
      sTemp := '';
      for x:= 0 to oBmp.Width -1 do
      begin
         oColor := bitdata1.GetPixel(x, y);
         nTemp := Integer(oColor);

         sTemp := sTemp + '$'+ IntToHex(nTemp, 8) + ',';
      end;
      Memo2.Lines.Add(sTemp);
    end;
  finally
    oBmp.Unmap(bitdata1);
    FreeAndNil(oBmp);
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  CreateUDG;
end;

procedure TFMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to CS_SPRITE do
    FreeAndNil(oSprite16[i]);
end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  ply := 0;
  plx := 0;
  if key = 39 then  //Right
    plx := 1;

  if key = 37 then //Left
    plx := -1;

  if key = 40 then //down
    ply := 1;

  if key = 38 then  //up
    ply := -1;

  MovePlayer;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  nIndex := 1;
  nColor := 1;
end;

procedure TFMain.Game;
begin

end;

procedure TFMain.Text3Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFMain.Timer1Timer(Sender: TObject);
Var I: Integer;
begin
  rMessaggi.Fill.Bitmap.Bitmap.Canvas.DrawText(CS_MESSAGGIO[nIndex], 16, (nIndex*8) + 2, GetColor(nColor), TAlphaColorRec.Black);
  if CS_MESSAGGIO[nIndex] <> ' ' then
    nColor := ncolor + 1;
  if nColor > 15 then nColor := 1;
  nIndex := nIndex + 1;
  if nIndex > Length(CS_MESSAGGIO) then
    nIndex := 1;
end;

procedure TFMain.scp;
Var tx, ty: Integer;
begin
  oRecLevel.Mappa[ly - 1][lx + plx - 1] := 'F';
  oRecLevel.Mappa[ly - 1][lx - 1] := ' ';
  ty := ly - sy;
  tx := (lx + plx) - sx;
  if (ty>-1) and (ty<19)and (tx>-1)and (tx<39) then
    rScreen.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[1], ty*2, tx*2);
  Caduta(ly, lx + plx);
END;

Procedure TFMain.Caduta (Const ey, ex: Integer);
Var eey, eex: Integer;
    tey, tex: Integer;
    esx, esy: Integer;
    fl, gmo: Boolean;
begin
  eey := ey + 1;
  eex := ex;
  gmo := False;
  fl := False;
  repeat
    eey := eey - 1;
    tey := eey;
    tex := eex;
    if oRecLevel.Mappa[eey-1][eex-1] <> 'F' THEN
      break;
    repeat
      if oRecLevel.Mappa[tey+1-1][tex-1] <> ' ' then
        Break;
      if oRecLevel.Mappa[tey+2-1][tex-1] = 'R' then
      begin
        oRecLevel.Mappa[tey+2-1][tex-1] := ' ';
        gmo := True;
      end;
      esy := tey - sy;
      esx := tex - sx;
      if (esy>-1) and (esy<10) and (esx>-1) and (esx<20) then
        rScreen.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_NERO], esy*2, esx*2);
      oRecLevel.Mappa[tey-1][tex-1] := ' ';
      tey := tey+1;
      oRecLevel.Mappa[tey-1][tex-1] := 'F';
      esy := tey - sy;
      esx := tex - sx;
      IF (esy>-1) and (esy<10) and (esx>-1) and (esx<20) then
        rScreen.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[1], esy*2, esx*2);
      fl := True;
    until False;
//      IF fl = 1 THEN BEEP 2800,56,11,-3556,-5,0,12,3
  until False;
//4294  IF gmo THEN gmo=0: gameover
End;

Procedure TFMain.Spinta;
begin
  if oRecLevel.Mappa[ly-1][lx+plx-1] = ' ' then
  begin
    scp;
    exit;
  end;
  ry := ry-ply;
  rx := rx-plx;
End;

Procedure TFMain.Punteggio;
begin
//5104  AT#0,1,12: PRINT#0;ldia;" "
//5106  AT#0,1,25: PRINT#0;score
//5108  AT#0,1,38: PRINT#0;time-(DATE-atime);" "
End;


procedure TFMain.TestMap;
var
  y, x: Integer;
begin
  ly := ry+ply;
  lx := rx+plx;
  CheckSpinta := False;
  IF oRecLevel.Mappa[ly-1][lx-1] = CS_MAP_MURA then
  begin
    ply :=0;
    plx :=0; // GO TO 3900
  end
  else if oRecLevel.Mappa[ly-1][lx-1] = CS_MAP_FONDO then
  begin
   score := score+1;
   Punteggio;
   oRecLevel.Mappa[ly-1][lx-1] := CS_MAP_VUOTO;
   // BEEP 150,100
  end
  else if oRecLevel.Mappa[ly-1][lx-1] = CS_MAP_DIAMANTE then
  begin
     ldia := ldia - 1;
     score :=score + 10;
     Punteggio;
     oRecLevel.Mappa[ly-1][lx-1] := CS_MAP_VUOTO;
     // BEEP 350,0,20,150,2,0,0,0
  end;
//  if oRecLevel.Mappa[ly-1][lx-1]='F' then
//    CheckSpinta := true;
  CheckSpinta := oRecLevel.Mappa[ly-1][lx-1] = CS_MAP_BOMBA;
  ry := ry + ply;
  rx := rx + plx;
  if rx - sx = 0 then
  begin
    rScreen.Fill.Bitmap.Bitmap.Pan(16);
    sx := sx-1;
    y := 0;
    while y <= 18 do
    begin
      DrawMap(oRecLevel, rScreen, y, 0);
      inc(y, 2);
    end;
  end;
  if rx-sx = 19 then
  begin
    rScreen.Fill.Bitmap.Bitmap.Pan(-16);
    sx := sx+1;
    y := 0;
    while y <= 18 do
    begin
      DrawMap(oRecLevel, rScreen, y, 38);
      inc(y, 2);
    end;
  end;
  if ry-sy=0 then
  begin
    rScreen.Fill.Bitmap.Bitmap.scroll(16);
    sy := sy-1;
    x := 0;
    while x<=38 do
    begin
      DrawMap(oRecLevel, rScreen, 0, x);
      inc(x, 2);
    end;
  end;
  if ry-sy = 9 then
  begin
    rScreen.Fill.Bitmap.Bitmap.scroll(-16);
    sy := sy + 1;
    x := 0;
    while x<=38 do
    begin
      DrawMap(oRecLevel, rScreen, 18, x);
      inc(x, 2);
    end;
  end;
End;

procedure TFMain.MovePlayer;
var tsy: Integer;
    tsx: Integer;
begin
  tsy := (ry - sy) * 2;
  tsx := (rx - sx) * 2;
  rScreen.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_NERO], tsy, tsx);
  oRecLevel.Mappa[ry - 1][rx - 1] := ' ';
  TestMap;
  if CheckSpinta then
  begin
    CheckSpinta := False;
    Spinta;
  end;
  tsy := (ry-sy)*2;
  tsx := (rx-sx)*2;
  rScreen.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_PLAYER], tsy, tsx);
  oRecLevel.Mappa[ry-1][rx-1] := 'R';
  if oRecLevel.Mappa[ry-1-ply-1][rx-plx-1] ='F' then
    Caduta(ry-1-ply,rx-plx);

//1522  IF ldia=0 THEN next_level

END;

procedure TFMain.ttNewClick(Sender: TObject);
var
  y: Integer;
  x: Integer;
  MyArray : TRecArray absolute oRecLevel;
begin
  rScreen.Fill.Bitmap.Bitmap.SetSize(CS_WIDTH, CS_HEIGHT);
  Timer1.Enabled := False;
  y := 0;
  x := 0;
  ply := 0;
  plx := 0;
  MyArray:=filetobytearray('livelli\Livello_1.lev');
  Sx := oRecLevel.SX;
  Sy := oRecLevel.SY;
  Rx := oRecLevel.RX;
  Ry := oRecLevel.RY;
  While y <= 18 do
  begin
    x := 0;
    While x <= 38 do
    begin
      DrawMap(oRecLevel, rScreen, y, x);
      inc(x, 2);
    end;
    inc(y, 2);
  end;
  rScreen.Fill.Bitmap.Bitmap.Canvas.DrawSprite16(oSprite16[CS_PLAYER], (ry-sy)*2, (rx-sx)*2);
end;

end.



