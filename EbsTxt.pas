unit EbsTxt;
interface
uses Classes, EbsFonts, EbsConst, OwnedObject, EbsTypes, Generics.Collections,
  Strings, Bytes, SysUtils, BoolImage, Graphics;

//==============================================================================
type
  TEbsField = class(TOwnedObject)
  strict private
    FLeft, FTop: Word;

    procedure SetFrontSpace(const AValue: Word);
    procedure SetBackSpace(const AValue: Word);

  strict
  private
    procedure SetHeight(const Value: Word);
    procedure SetLeft(const Value: Word);
    procedure SetTop(const Value: Word);
    procedure SetWidth(const Value: Word); protected
    FFrontSpace: Word;
    FBackSpace: Word;
    FWidth, FHeight: Word;

    function ToSpecReg(const AByte: Byte): TEbsSpecReg;
    function GetDataSize(const ANameLen: Integer = 8): Integer; virtual; abstract;

  public
    procedure CopyTo(ADest: TObject); override;

    procedure Draw(AImg: TBoolImage; AFonts: TEbsFonts); overload; virtual;
    procedure Save(var AData: TArray<Byte>; const ANameLen: Integer); virtual;

    property Left: Word read FLeft write SetLeft;
    property Top: Word read FTop write SetTop;
    property Width: Word read FWidth write SetWidth;
    property Height: Word read FHeight write SetHeight;
    property FrontSpace: Word read FFrontSpace write SetFrontSpace;
    property BackSpace: Word read FBackSpace write SetBackSpace;

  end;

//------------------------------------------------------------------------------
  TEbsFields = class(TOwnedObject)
  strict private
    FItems: TObjectList<TEbsField>;

    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetItem(Index: Integer): TEbsField;

  private
    FTxtHeight: Byte;
    FFirstFieldLength: TBytes;
    function GetCount: Integer;
    procedure SetTxtHeight(const Value: Byte);

  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;

    function Clone(AOwner: TObject): TObject; override;
    procedure CopyTo(ADest: TObject); override;
    procedure SortByLeft;
    procedure SetFirstFieldLength(Value: TBytes);
    procedure SetLengthFieldLength(AArray: TBytes; ALength: Integer);

    procedure Save(var ADataQueue: TQueue<TArray<Byte>>; const ANameLen: Integer);
    procedure Draw(AImg: TBoolImage; AFonts: TEbsFonts); overload;

    procedure Clear;
    procedure Add(AField: TEbsField);

    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Items[Index: Integer]: TEbsField read GetItem; default;
    property Count: Integer read GetCount;
    property TxtHeight: Byte read FTxtHeight write SetTxtHeight;
    property FirstFieldLength: TBytes read FFirstFieldLength write SetFirstFieldLength;

  end;

//------------------------------------------------------------------------------
  TEbsTextField = class(TEbsField)
  strict private
    FFontId: Byte;
    FCharSpace: Byte;
    FMultiplicity: Byte;
    FCharRot: TEbsCharRot;
    FSpecReg: TEbsSpecReg;
    FWide: Boolean;
    FText: string;

    procedure SetCharSpace(AValue: Byte);
    procedure SetMultiplicity(AValue: Byte);
    function IsBold: Boolean;
    procedure SetBold(AValue: Boolean);
    procedure SetSpecReg(AValue: TEbsSpecReg);
    function GetAnsiContent: AnsiString;
    procedure Rotate(var AImg: TBoolImage; const ARot: TEbsCharRot);

  strict
  private
    procedure SetCharRot(const Value: TEbsCharRot);
    procedure SetFontId(const Value: Byte);
    procedure SetText(const Value: string);
    procedure SetWide(const Value: Boolean); protected
    function GetDataSize(const ANameLen: Integer = 8): Integer; override;

  public
    constructor Create(AOwner: TObject); override;

    procedure Save(var AData: TBytes; const ANameLen: Integer = 8); override;
    procedure CopyTo(ADest: TObject); override;
    function Clone(AOwner: TObject): TObject; override;
    procedure Draw(AImg: TBoolImage; AFonts: TEbsFonts); overload; override;

    property FontId: Byte read FFontId write SetFontId;
    property CharSpace: Byte read FCharSpace write SetCharSpace;
    property Multiplicity: Byte read FMultiplicity write SetMultiplicity;
    property CharRot: TEbsCharRot read FCharRot write SetCharRot;
    property SpecReg: TEbsSpecReg read FSpecReg write SetSpecReg;
    property Wide: Boolean read FWide write SetWide;
    property Text: string read FText write SetText;
    property AnsiContent: AnsiString read GetAnsiContent;
    property Bold: Boolean read IsBold write SetBold;

  end;

//------------------------------------------------------------------------------
  TEbsBarcodeField = class(TEbsField)
  strict private
    FBarcodeType: TEbsBarcodeType;
    FCorrection: Byte;
    FInverted: Boolean;
    FSignatured: Boolean;
    FMultiplicity: Byte;
    FSpecReg: TEbsSpecReg;
    FSmallSign: Boolean;
    FLargeSignSpace: Boolean;
    FPafal: Byte;
    FValue: string;

    procedure SetInverted(const AValue: Boolean);
    procedure SetLargeSignSpace(const AValue: Boolean);
    procedure SetCorrection(const AValue: Byte);
    procedure SetMultiplicity(const AValue: Byte);
    procedure SetSpecReg(const AValue: TEbsSpecReg);
    procedure SetPafal(const AValue: Byte);

    function ToByte(const ABarcodeType: TEbsBarcodeType): Byte;

  strict
  private
    procedure SetSignatured(const Value: Boolean);
    procedure SetSmallSign(const Value: Boolean);
    procedure SetValue(const Value: string);
  private
    procedure SetBarcodeType(const Value: TEbsBarcodeType); protected
    function GetDataSize(const ANameLen: Integer = 8): Integer; override;

  public
    procedure Save(var AData: TBytes; const ANameLen: Integer = 8); override;
    function Clone(AOwner: TObject): TObject; override;
    procedure CopyTo(ADest: TObject); override;

    property Value: string read FValue write SetValue;
    property Pafal: Byte read FPafal write SetPafal;
    property SpecReg: TEbsSpecReg read FSpecReg write SetSpecReg;
    property Multiplicity: Byte read FMultiplicity write SetMultiplicity;
    property Correction: Byte read FCorrection write SetCorrection;
    property LargeSignSpace: Boolean read FLargeSignSpace write SetLargeSignSpace;
    property Inverted: Boolean read FInverted write SetInverted;
    property SmallSign: Boolean read FSmallSign write SetSmallSign;
    property Signatured: Boolean read FSignatured write SetSignatured;
    property BarcodeType: TEbsBarcodeType read FBarcodeType write SetBarcodeType;
  end;

//------------------------------------------------------------------------------
  TEbsGraphicField = class(TEbsField)
  strict private
    FImage: TBoolImage;

    procedure SetContent(const AValue: TBoolImage);

  strict protected
    function GetDataSize(const ANameLen: Integer = 8): Integer; override;


  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;
    procedure CopyTo(ADest: TObject); override;
    function Clone(AOwner: TObject): TObject; override;
    procedure Draw(AImg: TBoolImage; AFonts: TEbsFonts); override;
    procedure Save(var AData: TBytes; const ANameLen: Integer = 8); override;

    property Image: TBoolImage read FImage write SetContent;

  end;

//------------------------------------------------------------------------------
  TEbsOtherTxtField = class(TEbsField)
  strict private
    FTextName: string;

  strict protected
    function GetDataSize(const ANameLen: Integer = 8): Integer; override;

  public
    procedure SetTextName(const Value: string);
    procedure CopyTo(ADest: TObject); override;
    function Clone(AOwner: TObject): TObject; override;
    procedure Save(var AData: TArray<Byte>; const ANameLen: Integer = 8); override;

    property TextName: string read FTextName write SetTextName;
  end;

//------------------------------------------------------------------------------
  TEbsTxt = class(TOwnedObject)
  strict private
    FFields: TEbsFields;
    FTxtName: string;
    FParName: string;

    procedure SetFields(AFields: TEbsFields);

  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;

    procedure CopyTo(ADest: TObject); override;
    function Clone(AOwner: TObject): TObject; override;

    property Fields: TEbsFields read FFields write SetFields;
    property TxtName: string read FTxtName write FTxtName;
    property ParName: string read FParName write FParName;


  end;

//==============================================================================
function ToByte(const ASpecReg: TEbsSpecReg): Byte;
function DecodeUniDate(const AContent: string; const ATime: TDateTime;
  const AShift: Integer; const ALang: TLanguage): string;

//==============================================================================
implementation
uses System.Types, DateUtils, Streams, BmpFile, Bmp1BitImage, Generics.Defaults,
  EbsFieldLeftComparer;

//==============================================================================
//=== TEbsField ================================================================
//==============================================================================
procedure TEbsField.SetFrontSpace(const AValue: Word);
begin
  if AValue <> FFrontSpace then
    if AValue <= 5000 then FFrontSpace := AValue else FFrontSpace := 5000;
end;

procedure TEbsField.SetHeight(const Value: Word);
begin
  FHeight := Value;
end;

procedure TEbsField.SetLeft(const Value: Word);
begin
  FLeft := Value;
end;

procedure TEbsField.SetTop(const Value: Word);
begin
  FTop := Value;
end;

procedure TEbsField.SetWidth(const Value: Word);
begin
  FWidth := Value;
end;

//------------------------------------------------------------------------------
function TEbsField.ToSpecReg(const AByte: Byte): TEbsSpecReg;
begin
  case AByte of
    1:  Result := esrCountUp;
    2:  Result := esrCountDown;
    3:  Result := esrTime;
    4:  Result := esrDate;
    5:  Result := esrSpecChan;
    6:  Result := esrUniDate;
    7:  Result := esrDateOffset;
    8:  Result := esrDateOffset2;
    9:  Result := esrSysData;
    10: Result := esrMetrix;
    11: Result := esrUniCount;
    14: Result := esrTxt;
    15: Result := esrVar;
  else
    Result := esrNone;
  end;
end;

//------------------------------------------------------------------------------
procedure TEbsField.SetBackSpace(const AValue: Word);
begin
  if AValue <> FBackSpace then
    if AValue <= 5000 then FBackSpace := AValue else FBackSpace := 5000;
end;

//------------------------------------------------------------------------------
procedure TEbsField.Draw(AImg: TBoolImage; AFonts: TEbsFonts);
begin
  AImg.Height := FHeight;
  AImg.Width := FWidth;
end;

//------------------------------------------------------------------------------
procedure TEbsField.Save(var AData: TArray<Byte>; const ANameLen: Integer);
begin

  SetLength(AData, GetDataSize(ANameLen));

  AData[0] := EBS_OBJ_FIELD_BEGIN;
  AData[1] := Hi( FLeft );
  AData[2] := Lo( FLeft );
  AData[3] := Hi( FWidth );
  AData[4] := Lo( FWidth );
  AData[5] := Hi( FTop );
  AData[6] := Lo( FTop );
  AData[7] := Hi( FHeight );
  AData[8] := Lo( FHeight );

end;

//------------------------------------------------------------------------------
procedure TEbsField.CopyTo(ADest: TObject);
var
  ADestField: TEbsField;

begin
  if ADest is TEbsField then
  begin
    ADestField := ADest as TEbsField;
    ADestField.FLeft := FLeft;
    ADestField.FTop := FTop;
    ADestField.FFrontSpace := FFrontSpace;
    ADestField.FBackSpace := FBackSpace;
    ADestField.FWidth := FWidth;
    ADestField.FHeight := FHeight;
  end;

end;

//==============================================================================
{ TEbsTxtData =================================================================}
//==============================================================================
procedure TEbsFields.Add(AField: TEbsField);
begin
  FItems.Add(AField);
end;

//------------------------------------------------------------------------------
procedure TEbsFields.CopyTo(ADest: TObject);
var
  ADestFields: TEbsFields;
  AField: TEbsField;

begin
  inherited;

  if ADest is TEbsFields then
  begin
    ADestFields := ADest as TEbsFields;

    ADestFields.FItems.Clear;
    for AField in FItems do
      ADestFields.FItems.Add( AField.Clone(ADestFields) as TEbsField );

  end;
end;

//------------------------------------------------------------------------------
procedure TEbsFields.Clear;
begin
  FItems.Clear;
end;

//------------------------------------------------------------------------------
constructor TEbsFields.Create(AOwner: TObject);
begin
  inherited;
  FItems := TObjectList<TEbsField>.Create;
end;

//------------------------------------------------------------------------------
function TEbsFields.Clone(AOwner: TObject): TObject;
begin
  Result := TEbsFields.Create(AOwner);
  CopyTo(Result);
end;

//------------------------------------------------------------------------------
procedure TEbsFields.Draw(AImg: TBoolImage; AFonts: TEbsFonts);
var
  AField: TEbsField;
  AFieldImg: TBoolImage;

begin

  if (Width > 0) and (Height > 0) then
  begin
    AImg.Height := Height;
    AImg.Width := Width;

    AFieldImg := TBoolImage.Create(nil);
    try
      for AField in FItems do
      begin
        AField.Draw(AFieldImg, AFonts);
        AImg.OrArray(AField.Left, AField.Top, AFieldImg);
      end;

    finally
      FreeAndNil(AFieldImg);
    end;

  end;

end;

//------------------------------------------------------------------------------
function TEbsFields.GetWidth: Integer;
var
  ARight: Integer;
  AField: TEbsField;
begin
  Result := 0;
  for AField in FItems do
  begin
    ARight := AField.Left + AField.Width;
    if ARight > Result then Result := ARight;
  end;
end;

//------------------------------------------------------------------------------
function TEbsFields.GetCount: Integer;
begin
  Result := FItems.Count;
end;

//------------------------------------------------------------------------------
function TEbsFields.GetHeight: Integer;
var
  ABottom: Integer;
  AField: TEbsField;
begin
  Result := 0;
  for AField in FItems do
  begin
    ABottom := AField.Top + AField.Height;
    if ABottom > Result then Result := ABottom;
  end;
end;

//------------------------------------------------------------------------------
function TEbsFields.GetItem(Index: Integer): TEbsField;
begin
  Result := FItems[Index];
end;

//------------------------------------------------------------------------------
procedure TEbsFields.Save(var ADataQueue: TQueue<TArray<Byte>>;
  const ANameLen: Integer);
var
  AFieldData: TArray<Byte>;
  AField: TEbsField;

begin
  {tworzymy bufory z zawartoœci¹ pól}
  ADataQueue.Clear;
  for AField in FItems do
  begin
    AField.Save(AFieldData, ANameLen);
    ADataQueue.Enqueue(AFieldData);
  end;

end;

//------------------------------------------------------------------------------
procedure TEbsFields.SetLengthFieldLength(AArray: TBytes; ALength: Integer);
begin
   SetLength(AArray,ALength);
end;

//------------------------------------------------------------------------------
procedure TEbsFields.SetFirstFieldLength(Value: TBytes);
begin
  FFirstFieldLength := Value;
end;

//------------------------------------------------------------------------------

procedure TEbsFields.SetTxtHeight(const Value: Byte);
begin
  FTxtHeight := Value;
end;

//------------------------------------------------------------------------------
procedure TEbsFields.SortByLeft;
var
  AComparer: IComparer<TEbsField>;
begin
  AComparer := TEbsFieldLeftComparer.Create;
  FItems.Sort(AComparer);
end;

//==============================================================================
//=== TEbsTextField ============================================================
//==============================================================================
procedure TEbsTextField.CopyTo(ADest: TObject);
var
  ADestField: TEbsTextField;

begin
  inherited;

  if ADest is TEbsTextField then
  begin
    ADestField := ADest as TEbsTextField;
    ADestField.FFontId := FFontId;
    ADestField.FCharSpace := FCharSpace;
    ADestField.FMultiplicity := FMultiplicity;
    ADestField.FCharRot := FCharRot;
    ADestField.FSpecReg := FSpecReg;
    ADestField.FWide := FWide;
    ADestField.FText := FText;
  end;

end;

//------------------------------------------------------------------------------
constructor TEbsTextField.Create(AOwner: TObject);
begin
  inherited;
  FMultiplicity := 1;
  FFontId := 1;
  FCharSpace := 1;
  FCharRot := ecrStd;
  FSpecReg := esrNone;
  FWide := false;
  FText := '';
end;

//------------------------------------------------------------------------------
function TEbsTextField.Clone(AOwner: TObject): TObject;
begin
  Result := TEbsTextField.Create(AOwner);
  CopyTo(Result);
end;

//------------------------------------------------------------------------------
procedure TEbsTextField.SetCharRot(const Value: TEbsCharRot);
begin
  FCharRot := Value;
end;

procedure TEbsTextField.SetCharSpace(AValue: Byte);
begin
  if AValue <> CharSpace then
    if AValue <= 45 then FCharSpace := AValue else FCharSpace := 45;
end;

procedure TEbsTextField.SetFontId(const Value: Byte);
begin
  FFontId := Value;
end;

//------------------------------------------------------------------------------
procedure TEbsTextField.SetMultiplicity(AValue: Byte);
begin
  if AValue <> FMultiplicity then
    if AValue <= 15 then FMultiplicity := AValue else FMultiplicity := 15;
end;

//------------------------------------------------------------------------------
function TEbsTextField.IsBold: Boolean;
begin
  Result := FMultiplicity = 0;
end;

//------------------------------------------------------------------------------
procedure TEbsTextField.SetBold(AValue: Boolean);
begin
  if AValue <> Bold then
    if AValue then FMultiplicity := 0 else FMultiplicity := 1;
end;

//------------------------------------------------------------------------------
procedure TEbsTextField.SetSpecReg(AValue: TEbsSpecReg);
begin
  if AValue <> FSpecReg then
    FSpecReg := AValue;

end;

procedure TEbsTextField.SetText(const Value: string);
begin
  FText := Value;
end;

procedure TEbsTextField.SetWide(const Value: Boolean);
begin
  FWide := Value;
end;

//------------------------------------------------------------------------------
function TEbsTextField.GetAnsiContent: AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i:=1 to Length(FText) do
    Result := Result + AnsiChar(ToEbsChar(FText[i]));
end;

//------------------------------------------------------------------------------
procedure TEbsTextField.Rotate(var AImg: TBoolImage; const ARot: TEbsCharRot);
begin
  if ARot <> ecrStd then
  begin
    case ARot of
      ecrRight:       AImg.Rotate90;
      ecrUpsideDown:  AImg.Rotate180;
      ecrLeft:        AImg.Rotate270;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TEbsTextField.Save(var AData: TBytes; const ANameLen: Integer = 8);
var
  i: Integer;

begin
  inherited;

  AData[9] := FFontId;

  AData[10] := FCharSpace shl 4;
  AData[10] := AData[10] or FMultiplicity;

  AData[11] := $00;
  if FWide then SetBit( AData[11], 5 );

  case FCharRot of
    ecrStd:         AData[11] := AData[11] or $00;
    ecrRight:       AData[11] := AData[11] or $01;
    ecrUpsideDown:  AData[11] := AData[11] or $02;
    ecrLeft:        AData[11] := AData[11] or $03;
  end;

  AData[12] := ToByte(FSpecReg);
  AData[13] := Hi(FFrontSpace);
  AData[14] := Lo(FFrontSpace);
  AData[15] := Hi(FBackSpace);
  AData[16] := Lo(FBackSpace);

  if FWide then

    for i:=1 to Length(FText) do
    begin
      AData[17+(i-1)*2] := Hi( Word( FText[i] ) );
      AData[18+(i-1)*2] := Lo( Word( FText[i] ) );
    end

  else

    for i:=1 to Length(FText) do
      AData[17+i-1] := ToEbsChar( FText[i] );

    AData[Length(AData)-1] := $0D;

end;

//------------------------------------------------------------------------------
function TEbsTextField.GetDataSize(const ANameLen: Integer = 8): Integer;
begin

  {rozmiar bufora}
  if FWide then Result := 18 + 2*( Length(FText) + 1 )
           else Result := 18 + Length(FText);

end;

//------------------------------------------------------------------------------
procedure TEbsTextField.Draw(AImg: TBoolImage; AFonts: TEbsFonts);
var
  AFont: TEbsFont;
  AChar: TEbsChar;
  ACharImg: TBoolImage;
  AX, ATextLen, i: Integer;

begin
  {sprawdzamy czy mamy czcionki}
  if not Assigned(AFonts) then
    raise Exception.Create('No Fonts!');

  {ustawiamy rozmiar pola i czyœcimy}
  AImg.Reset;

  inherited;

  {wybieramy czcionkê}
  AFont := AFonts.FontOfId(FFontId);
  if not Assigned(AFont) then Exit;
  if not AFont.Loaded then Exit;

    {wybieramy znaki}
    AX := FFrontSpace;
    ATextLen := Length(FText);
    if ATextLen < 1 then Exit;
    for i:=1 to Length(FText) do
    begin
      AChar := AFont.CharOfCode( ToEbsChar(FText[i]) );
      if not Assigned(AChar) then AChar := AFont.VicarialChar;
      if not Assigned(AChar) then Continue;

      {copy char to local image}
      ACharImg := TBoolImage.Create;
      try
        ACharImg.LoadFrom(AChar.Image);


        if Bold then ACharImg.BoldX;
        Rotate(ACharImg, FCharRot);

        {jeœli trzeba pogrubiæ - pogrubiamy, obracamy i multiplujemy}
        if FMultiplicity > 0 then ACharImg.MultiplyX(FMultiplicity);

        AImg.OrArray(AX, 0, ACharImg);
//        Draw(AImg, ACharImg, AX, 0);

        {mamy ju¿ znak wiêc wklejamy}
  //      ATempImg.Draw(AImage, AX, 0, True);
//        ACharHeight := Length(ACharImg);
//        if ACharHeight > 0 then ACharWidth := ACharImg[0] else ACharWidth := 0;
        AX := AX + ACharImg.Width + FCharSpace;

      finally
        FreeAndNil(ACharImg);
      end;

    end;

end;

//==============================================================================
//=== TEbsBarcodeField =========================================================
//==============================================================================
procedure TEbsBarcodeField.SetBarcodeType(const Value: TEbsBarcodeType);
begin
  FBarcodeType := Value;
end;

procedure TEbsBarcodeField.SetCorrection(const AValue: Byte);
begin
  if AValue <> FCorrection then
  begin
    if AValue > 3 then FCorrection := 3 else FCorrection := AValue;
    if FCorrection  >= FMultiplicity then FCorrection := FMultiplicity-1;
  end;
end;

//------------------------------------------------------------------------------
procedure TEbsBarcodeField.SetInverted(const AValue: Boolean);
begin
  FInverted := AValue;
end;

//------------------------------------------------------------------------------
procedure TEbsBarcodeField.SetLargeSignSpace(const AValue: Boolean);
begin
  FLargeSignSpace := AValue;
end;

//------------------------------------------------------------------------------
procedure TEbsBarcodeField.SetMultiplicity(const AValue: Byte);
begin
  if AValue <> FMultiplicity then
  begin
    if AValue < 1 then FMultiplicity := 1;
    if AValue > 16 then FMultiplicity := 16;
    if (AValue >= 1) and (AValue <=16) then FMultiplicity := AValue;
    if FCorrection >= FMultiplicity then FCorrection := FMultiplicity - 1;
  end;
end;

//------------------------------------------------------------------------------
procedure TEbsBarcodeField.SetSignatured(const Value: Boolean);
begin
  FSignatured := Value;
end;

procedure TEbsBarcodeField.SetSmallSign(const Value: Boolean);
begin
  FSmallSign := Value;
end;

procedure TEbsBarcodeField.SetSpecReg(const AValue: TEbsSpecReg);
begin
  if AValue <> FSpecReg then
    if (AValue = esrNone) or
       (AValue = esrCountUp) or
       (AValue = esrCountDown) or
       (AValue = esrMetrix) then FSpecReg := AValue;
end;

procedure TEbsBarcodeField.SetValue(const Value: string);
begin
  FValue := Value;
end;

//------------------------------------------------------------------------------
procedure TEbsBarcodeField.SetPafal(const AValue: Byte);
begin
  if AValue <> FPafal then
    if AValue <= 31 then FPafal := AValue else FPafal := 31;
end;

//------------------------------------------------------------------------------
procedure TEbsBarcodeField.CopyTo(ADest: TObject);
var
  ADestBarcode: TEbsBarcodeField;

begin
  inherited;

  if ADest is TEbsBarcodeField then
  begin
    ADestBarcode := ADest as TEbsBarcodeField;
    ADestBarcode.FBarcodeType := FBarcodeType;
    ADestBarcode.FCorrection := FCorrection;
    ADestBarcode.FInverted := FInverted;
    ADestBarcode.FSignatured := FSignatured;
    ADestBarcode.FMultiplicity := FMultiplicity;
    ADestBarcode.FSpecReg := FSpecReg;
    ADestBarcode.FSmallSign := FSmallSign;
    ADestBarcode.FLargeSignSpace := FLargeSignSpace;
    ADestBarcode.FPafal := FPafal;
    ADestBarcode.FValue := FValue;
  end;

end;

//------------------------------------------------------------------------------
function TEbsBarcodeField.Clone(AOwner: TObject): TObject;
begin
  Result := TEbsBarcodeField.Create(AOwner);
  CopyTo(Result);
end;

//------------------------------------------------------------------------------
function TEbsBarcodeField.GetDataSize(const ANameLen: Integer = 8): Integer;
begin
  Result := 19 + Length(FValue);
end;

//------------------------------------------------------------------------------
procedure TEbsBarcodeField.Save(var AData: TBytes; const ANameLen: Integer = 8);
var
  AByte: Byte;
  i: Integer;

begin

  inherited;

  AData[9] := ToByte(FBarcodeType);

  {korekcja szerokoœci rz¹dków, Inwersja, Podpis, Krotnoœæ}
  AByte := fCorrection shl 6;
  SetBit(AByte, 5, FInverted);
  SetBit(AByte, 4, FSignatured);
  AByte := AByte or FMultiplicity;
  AData[10] := AByte;

  {odstêpy pocz¹tkowy i koñcowy i przepisujemy wysokosc podtekstu}
  AData[11] := Hi(FFrontSpace);
  AData[12] := Lo(FFrontSpace);
  AData[13] := Hi(FBackSpace);
  AData[14] := Lo(FBackSpace);
  AData[15] := FHeight;

  {rejestr specjalny}
  AData[16] := EbsTxt.ToByte(FSpecReg);

  {wysokoœæ podpisu, odstêp podpisu, pafal}
  AByte := $00;
  SetBit(AByte, 7, FSmallSign);
  SetBit(AByte, 6, FLargeSignSpace);
  AByte := AByte or FPafal;
  AData[17] := AByte;

  {dane dodatkowe}
//  if Assigned(ExtData) then ExtData.Save(AData);

  {wartoœæ kodu}
  for i:=1 to Length(FValue) do AData[18+i-1] := ToEbsChar(FValue[i]);
  AData[18+Length(FValue)] := $0D;

end;


//------------------------------------------------------------------------------
function TEbsBarcodeField.ToByte(const ABarcodeType: TEbsBarcodeType): Byte;
begin
  case aBarcodeType of
    ebtCode25Datalogic:     Result := $E0;
    ebtCode253Bars:         Result := $E1;
    ebtCode255Bars:         Result := $E2;
    ebtCode25Interleaved:   Result := $E3;
    ebtCodeAlpha39:         Result := $E4;
    ebtEan8:                Result := $E5;
    ebtEan13:               Result := $E6;
    ebtItf8:                Result := $E7;
    ebtItf14:               Result := $E8;
    ebtCode128B:            Result := $E9;
    ebtCode128:             Result := $EA;
    ebtEan128:              Result := $EB;
    ebtEcc200:              Result := $EC;
  else
    Result := $E0;
  end;
end;

//==============================================================================
//=== TEbsGraphicField =========================================================
//==============================================================================
constructor TEbsGraphicField.Create(AOwner: TObject);
begin
  inherited;
  FImage := TBoolImage.Create(Self);
end;

//------------------------------------------------------------------------------
function TEbsGraphicField.Clone(AOwner: TObject): TObject;
begin
  Result := TEbsGraphicField.Create(AOwner);
  CopyTo(Result);
end;
//------------------------------------------------------------------------------

procedure TEbsGraphicField.CopyTo(ADest: TObject);
var
  ADestGraphic: TEbsGraphicField;

begin
  inherited;

  if ADest is TEbsGraphicField then
  begin
    ADestGraphic := ADest as TEbsGraphicField;
    ADestGraphic.Image := FImage;
  end;

end;

//------------------------------------------------------------------------------
function TEbsGraphicField.GetDataSize(const ANameLen: Integer = 8): Integer;
var
  aBpc, ABytes: Integer;

begin
  {obliczamy na ilu bajtach zapisywana bêdzie kolumna}
  aBpc := FImage.Height div 8;
  if (FImage.Height mod 8) > 0 then aBpc := aBpc + 1;

  {obliczamy ile bajtów potrzeba do zapisu grafiki}
  aBytes := FImage.Width * aBpc;

  {ustalamy rozmiar bufora}
  Result := 17 + ABytes;

end;

//------------------------------------------------------------------------------
procedure TEbsGraphicField.Save(var aData: TArray<Byte>; const ANameLen: Integer = 8);
var
  aByte: Byte;
  aBpc, i, j, ABytes, Y, X: Integer;

begin
  inherited;
  aData[9] := $FE;
  aData[10] := FImage.Height;
  aData[11] := (FImage.Width shr 8) and $FF;
  aData[12] := FImage.Width and $FF;

  AData[13] := Hi(FFrontSpace);
  AData[14] := Lo(FFrontSpace);
  AData[15] := Hi(FBackSpace);
  AData[16] := Lo(FBackSpace);

  aBpc := Image.Height div 8;
  if (Image.Height mod 8) > 0 then aBpc := aBpc + 1;
  aBytes := Image.Width * aBpc;

  {zapisujemy piksele}
  for i:=0 to aBytes-1 do
  begin

    aByte := $00;
    X := i div aBpc;
    for j:=0 to 7 do
    begin

      Y := (i mod aBpc)*8 + (8 - (8*aBpc - Image.Height)) - j - 1;
      if (Y >= Image.Height) or (Y < 0) then Continue;

      {uzupe³niamy obrazek}
      SetBit( aByte, j, FImage[X,Y] );

    end;

    aData[17 + i] := aByte;

  end;

end;

//------------------------------------------------------------------------------
procedure TEbsGraphicField.SetContent(const AValue: TBoolImage);
begin
  AValue.CopyTo(FImage);
end;
//------------------------------------------------------------------------------
destructor TEbsGraphicField.Destroy;
begin
  FreeAndNil(FImage);
  inherited;
end;

//------------------------------------------------------------------------------
procedure TEbsGraphicField.Draw(AImg: TBoolImage; AFonts: TEbsFonts);
begin
  inherited;
  AImg.OrArray(FFrontSpace, 0, FImage);
end;

//------------------------------------------------------------------------------
destructor TEbsFields.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;


//==============================================================================
//=== TEbsOtherTxtField ========================================================
//==============================================================================
procedure TEbsOtherTxtField.CopyTo(ADest: TObject);
begin
  inherited;
  if ADest is TEbsOtherTxtField then
    (ADest as TEbsOtherTxtField).FTextName := FTextName;
end;

//------------------------------------------------------------------------------
function TEbsOtherTxtField.Clone(AOwner: TObject): TObject;
begin
  Result := TEbsOtherTxtField.Create(AOwner);
  CopyTo(Result);
end;

//------------------------------------------------------------------------------
function TEbsOtherTxtField.GetDataSize(const ANameLen: Integer = 8): Integer;
begin
  Result := 15 + ANameLen;
end;

//------------------------------------------------------------------------------
procedure TEbsOtherTxtField.Save(var AData: TArray<Byte>; const ANameLen: Integer);
var
  i: Integer;

begin

  inherited;
  AData[9] := $FF;

  AData[11] := Hi(FFrontSpace);
  AData[12] := Lo(FFrontSpace);
  AData[13] := Hi(FBackSpace);
  AData[14] := Lo(FBackSpace);

  for i:=0 to ANameLen-1 do
    if i < Length(FTextName) then
      AData[15+i] := ToEbsChar( FTextName[i+1] )
    else
      AData[15+i] := $00;

end;

//------------------------------------------------------------------------------

procedure TEbsOtherTxtField.SetTextName(const Value: string);
begin
  FTextName := Value;
end;

//==============================================================================
//=== TEbsTxt ==================================================================
//==============================================================================
function TEbsTxt.Clone(AOwner: TObject): TObject;
begin
  Result := TEbsTxt.Create(AOwner);
  CopyTo(Result);
end;

//------------------------------------------------------------------------------
procedure TEbsTxt.CopyTo(ADest: TObject);
var
  ADestTxt: TEbsTxt;
begin
  if ADest is TEbsTxt then
  begin
    ADestTxt := ADest as TEbsTxt;

    ADestTxt.FTxtName := FTxtName;
    ADestTxt.FParName := FParName;

    if Assigned(ADestTxt.FFields) then FreeAndNil(ADestTxt.FFields);
    if Assigned(FFields) then ADestTxt.FFields := FFields.Clone(ADestTxt) as TEbsFields;

  end;
end;

//------------------------------------------------------------------------------
constructor TEbsTxt.Create(AOwner: TObject);
begin
  inherited;
  FFields := nil;
end;

//------------------------------------------------------------------------------
destructor TEbsTxt.Destroy;
begin
  if Assigned(FFields) then FreeAndNil(FFields);
  inherited;
end;

//------------------------------------------------------------------------------

procedure TEbsTxt.SetFields(AFields: TEbsFields);
begin
  if Assigned(FFields) then FreeAndNil(FFields);
  FFields := AFields;
end;


function ToByte(const ASpecReg: TEbsSpecReg): Byte;
begin
  case ASpecReg of
    esrNone:        Result := 0;
    esrCountUp:     Result := 1;
    esrCountDown:   Result := 2;
    esrTime:        Result := 3;
    esrDate:        Result := 4;
    esrSpecChan:    Result := 5;
    esrUniDate:     Result := 6;
    esrDateOffset:  Result := 7;
    esrDateOffset2: Result := 8;
    esrSysData:     Result := 9;
    esrMetrix:      Result := 10;
    esrUniCount:    Result := 11;
    esrTxt:         Result := 14;
    esrVar:         Result := 15;
  else
    Result := 0;
  end;
end;

//------------------------------------------------------------------------------
function DecodeUniDate(const AContent: string; const ATime: TDateTime;
  const AShift: Integer; const ALang: TLanguage): string;
var
  i: Integer;
  AStr : string;

begin
  if AShift < 1 then
    raise Exception.Create('Shift must be > 0.');

  if AShift > 9 then
    raise Exception.Create('Shift must be < 10.');

  Result := AContent;
  for i:=1 to Length(Result) do
  begin
    if Result[i] = 'D' then Result[i] := IntToStr(DayOf(ATime) div 10)[1];
    if Result[i] = 'A' then Result[i] := IntToStr(DayOf(ATime) mod 10)[1];
    if Result[i] = 'M' then Result[i] := IntToStr(MonthOf(ATime) div 10)[1];
    if Result[i] = 'O' then Result[i] := IntToStr(MonthOf(ATime) mod 10)[1];
    if Result[i] = 'Y' then Result[i] := IntToStr(YearOf(ATime) div 10)[3];
    if Result[i] = 'E' then Result[i] := IntToStr(YearOf(ATime) mod 10)[1];
    if Result[i] = 'W' then Result[i] := IntToStr(WeekOf(ATime) div 10)[1];
    if Result[i] = 'K' then Result[i] := IntToStr(WeekOf(ATime) mod 10)[1];
    if Result[i] = 'P' then Result[i] := IntToStr(DayOfTheYear(ATime) div 100)[1];

    if Result[i] = 'Q' then
    begin
      AStr := IntToStr(DayOfTheYear(ATime) div 10);
      Result := AStr[Length(AStr)];
    end;

    if Result[i] = 'S' then Result[i] := IntToStr(DayOfTheYear(ATime) mod 10)[1];
    if Result[i] = 'N' then Result[i] := IntToStr(DayOfTheWeek(ATime))[1];

    if Result[i] = 'F' then Result[i] := GetShortMonth(ATime, ALang)[1];
    if Result[i] = 'G' then Result[i] := GetShortMonth(ATime, ALang)[2];
    if Result[i] = 'H' then Result[i] := GetShortMonth(ATime, ALang)[3];

    if Result[i] = 'Z' then Result[i] := IntToStr(AShift)[1];

    if Result[i] = 'B' then Result[i] := IntToStr(HourOf(ATime) div 10)[1];
    if Result[i] = 'C' then Result[i] := IntToStr(HourOf(ATime) mod 10)[1];
    if Result[i] = 'I' then Result[i] := IntToStr(MinuteOf(ATime) div 10)[1];
    if Result[i] = 'J' then Result[i] := IntToStr(MinuteOf(ATime) mod 10)[1];

    if Result[i] = 'T' then Result[i] := IntToStr(SecondOf(ATime) div 10)[1];
    if Result[i] = 'U' then Result[i] := IntToStr(SecondOf(ATime) mod 10)[1];

  end;
end;

//==============================================================================





end.
