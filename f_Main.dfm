object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 71
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SaveButton: TButton
    Left = 222
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 0
    OnClick = SaveButtonClick
  end
  object SourceEdit: TEdit
    Left = 8
    Top = 8
    Width = 289
    Height = 21
    TabOrder = 1
    Text = 'D:\test3.t03'
  end
  object Button1: TButton
    Left = 303
    Top = 8
    Width = 75
    Height = 21
    Caption = 'Open'
    TabOrder = 2
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = '|*.t03'
    Left = 128
    Top = 32
  end
end
