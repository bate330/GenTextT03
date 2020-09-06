unit f_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, EbsT03Saver, EbsT03Loader;

type
  TForm3 = class(TForm)
    SaveButton: TButton;
    SourceEdit: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Saver: TEbsT03Saver;
    Loader: TEbsT03Loader;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation uses EbsTxt;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  OpenDialog1.Execute;
  SourceEdit.Text := OpenDialog1.FileName;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Saver:=TEbsT03Saver.Create;
  Loader:=TEbsT03Loader.Create;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  Saver.Free;
  Loader.Free;
end;

procedure TForm3.SaveButtonClick(Sender: TObject);
var
  ATxt: TEbsTxt;
  FileName: string;
begin
  ATxt := TEbsTxt.Create(nil);
  try
      FileName := SourceEdit.Text;
      Loader.LoadFromFile(FileName, ATxt);
      FileName := 'D:\OutputFile.t03';
      Saver.SaveToFile(ATxt,FileName);
  finally
    ATxt.Free;
  end;

end;

end.
