program ProjectSaver;

uses
  Vcl.Forms,
  f_Main in 'f_Main.pas' {Form3},
  EbsT03Saver in 'EbsT03Saver.pas',
  EbsT03Loader in 'EbsT03Loader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
