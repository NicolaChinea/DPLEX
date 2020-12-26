program DPlex;

uses
  System.StartUpCopy,
  FMX.Forms,
  u.main in 'u.main.pas' {FMain},
  CanvasHelper in 'CanvasHelper.pas',
  BitmapHelper in 'BitmapHelper.pas',
  u.Constant.Loc in 'u.Constant.Loc.pas',
  u.utility in 'u.utility.pas',
  u.typeinfo in 'u.typeinfo.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
