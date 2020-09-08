unit DemoPlugNotasMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdHTTP, IdSSLOpenSSL, StrUtils, ExtCtrls, IdMultipartFormData,
  superobject;

type
  TPlugException = class(Exception);

  TForm1 = class(TForm)
    cbbAmbiente: TComboBox;
    btnEnviarNota: TButton;
    mmoJsonNota: TMemo;
    mmoResposta: TMemo;
    pnlConfiguracoes: TPanel;
    lblAmbiente: TLabel;
    pnlEnvioNota: TPanel;
    lblNota: TLabel;
    lblResposta: TLabel;
    pnlConsultarNota: TPanel;
    lblIdNota: TLabel;
    btnConsultarNota: TButton;
    edtIdNota: TEdit;
    edtApiKey: TEdit;
    lblApiKey: TLabel;
    mmoJsonParseado: TMemo;
    btnParsearJson: TButton;
    lblRespostaFormatada: TLabel;
    btnImprimirNota: TButton;
    dlgSavePDF: TSaveDialog;
    btnSubirCertificado: TButton;
    dlgOpenSelecionarCertificado: TOpenDialog;
    pnlUploadCertificado: TPanel;
    edtCaminhoCertificado: TEdit;
    edtSenhaCertificado: TEdit;
    lblCaminhoCertificado: TLabel;
    lblSenhaCertificado: TLabel;
    btnSelecionarCertificado: TButton;
    lblStatusCode: TLabel;
    procedure btnEnviarNotaClick(Sender: TObject);
    procedure btnConsultarNotaClick(Sender: TObject);
    procedure btnImprimirNotaClick(Sender: TObject);
    procedure btnSubirCertificadoClick(Sender: TObject);
    procedure btnSelecionarCertificadoClick(Sender: TObject);
    procedure btnParsearJsonClick(Sender: TObject);
  private
    { Private declarations }
    procedure Requisicao(const aOperacao: string);
    procedure EnviarNota(const aIndy: TIdHTTP; const aBody: TStrings; const aResponse: TMemoryStream);
    procedure ConsultarNota(const aIndy: TIdHTTP; const aResponse: TMemoryStream);
    procedure ImprimirNota(const aIndy: TIdHTTP; const aResponse: TMemoryStream);
    procedure UploadCertificado(const aIndy: TIdHTTP; const aFormData: TIdMultiPartFormDataStream; const aResponse: TMemoryStream);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  urls : array[0..1] of string = ('https://api.sandbox.plugnotas.com.br', 'https://api.plugnotas.com.br');

implementation

{$R *.dfm}

procedure TForm1.btnConsultarNotaClick(Sender: TObject);
begin
  Requisicao('consultar');
end;

procedure TForm1.btnEnviarNotaClick(Sender: TObject);
begin
  Requisicao('enviar');
end;

procedure TForm1.btnImprimirNotaClick(Sender: TObject);
begin
  Requisicao('imprimir');
  mmoResposta.Lines.Text := 'Arquivo PDF ' + dlgSavePDF.FileName + ' salvo com sucesso.';
end;

procedure TForm1.btnParsearJsonClick(Sender: TObject);
var
  _json: ISuperObject;

  procedure formatarRespostaEnvioSucesso;
  var
    _document:ISuperObject;
  begin
    mmoJsonParseado.Lines.Clear;
    mmoJsonParseado.Lines.Add('Mensagem: ' + _json['message'].AsString);
    mmoJsonParseado.Lines.Add('Protocolo: ' + _json['protocol'].AsString);
    for _document in _json['documents'] do
    begin
      edtIdNota.Text := _document.S['id'];
      mmoJsonParseado.Lines.Add('Id da Nota: ' + _document.S['id']);
      mmoJsonParseado.Lines.Add('--------------------------------');
    end;
  end;

  procedure formatarRespostaConsultaSucesso;
  var
    _document:ISuperObject;
  begin
    mmoJsonParseado.Lines.Clear;
    for _document in _json do
    begin
      edtIdNota.Text := _document.S['id'];
      mmoJsonParseado.Lines.Add('Id da Nota: ' + _document.S['id']);
      mmoJsonParseado.Lines.Add('Data de emissão: ' + _document.S['emissao']);
      mmoJsonParseado.Lines.Add('Situação: ' + _document.S['status']);
      mmoJsonParseado.Lines.Add('Data de autorização: ' + _document.S['dataAutorizacao']);
      mmoJsonParseado.Lines.Add('Valor: ' + _document.S['valor']);
      mmoJsonParseado.Lines.Add('--------------------------------');
    end;
  end;

  procedure formatarRespostaErro;
  begin
    mmoJsonParseado.Lines.Clear;
    mmoJsonParseado.Lines.Add('Mensagem: ' + _json['error.message'].AsString);
    mmoJsonParseado.Lines.Add('Dados do erro: ' + _json['error.data'].AsString);
  end;

  procedure formatarRespostaCertificadoSucesso;
  begin
    mmoJsonParseado.Lines.Clear;
    mmoJsonParseado.Lines.Add('Mensagem: ' + _json['message'].AsString);
    mmoJsonParseado.Lines.Add('Dados do certificado: ' + _json['data'].AsString);
  end;

begin
  try
    _json := SO(Trim(AnsiReplaceText(mmoResposta.Lines.Text, #13#10, '')));
    try
      if _json['error'] <> nil then
      begin
        formatarRespostaErro;
        exit;
      end;

      if _json['documents'] <> nil then
      begin
        formatarRespostaEnvioSucesso;
        exit;
      end;

      if AnsiStartsStr('[', mmoResposta.Lines.Text) then
      begin
        formatarRespostaConsultaSucesso;
        exit;
      end;

      if _json['message'] <> nil then
      begin
        formatarRespostaCertificadoSucesso;
        exit;
      end;
    finally
      _json.Clear(True);
      _json := nil;
    end;
  except on E: Exception do
    raise Exception.Create('Erro ao carregar o JSON: ' + E.Message);
  end;
end;

procedure TForm1.btnSelecionarCertificadoClick(Sender: TObject);
begin
  if dlgOpenSelecionarCertificado.Execute then
  begin
    edtCaminhoCertificado.Text := dlgOpenSelecionarCertificado.FileName;
  end;
end;

procedure TForm1.btnSubirCertificadoClick(Sender: TObject);
begin
  Requisicao('upload');
end;

procedure TForm1.ConsultarNota(const aIndy: TIdHTTP; const aResponse: TMemoryStream);
begin
  aIndy.Request.ContentType := 'application/json';

  if Trim(edtIdNota.Text) = EmptyStr then
    raise TPlugException.Create('ID da nota deve ser preenchido na consulta.');

  aIndy.Get(urls[cbbAmbiente.ItemIndex] + '/nfe/' + edtIdNota.Text + '/resumo', aResponse);
end;

procedure TForm1.EnviarNota(const aIndy: TIdHTTP; const aBody: TStrings; const aResponse: TMemoryStream);
begin
  if Trim(mmoJsonNota.Lines.Text) = EmptyStr then
    raise TPlugException.Create('JSON da nota deve ser preenchido no envio.');

  aIndy.Request.ContentType := 'application/json';

  aBody.Text := AnsiReplaceText(mmoJsonNota.Lines.Text, #13#10, '');
  aIndy.Post(urls[cbbAmbiente.ItemIndex] + '/nfe', aBody, aResponse);
end;

procedure TForm1.ImprimirNota(const aIndy: TIdHTTP;
  const aResponse: TMemoryStream);
var
  resposta : string;
begin
  aIndy.Request.ContentType := 'application/json';

  if Trim(edtIdNota.Text) = EmptyStr then
    raise TPlugException.Create('ID da nota deve ser preenchido na impressão.');

   aIndy.Get(urls[cbbAmbiente.ItemIndex] + '/nfe/' + edtIdNota.Text + '/pdf', aResponse);

   dlgSavePDF.FileName := edtIdNota.Text;
   if (dlgSavePDF.Execute()) then
    aResponse.SaveToFile(dlgSavePDF.FileName);

   aResponse.Clear;
end;

procedure TForm1.Requisicao(const aOperacao: string);
var
  _idHttp : TIdHTTP;
  _body : TStrings;
  _SSLHandler : TIdSSLIOHandlerSocketOpenSSL;
  _response: TMemoryStream;
  _formData : TIdMultiPartFormDataStream;
begin
  lblStatusCode.font.Color := clBlack;
  lblStatusCode.Caption := '';

  _idHttp := TIdHTTP.Create;
  _SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  _body := TStringList.Create;
  _response := TMemoryStream.Create;
  _formData := TIdMultiPartFormDataStream.Create;
  try
    _idHttp.IOHandler :=  _SSLHandler;
    _idHttp.HandleRedirects := True;
    _idHttp.Request.Clear;
    _idHttp.ProtocolVersion := pv1_1;
    _idHttp.HandleRedirects := true;
    _idHttp.ConnectTimeout := 15000;

    _idHttp.Request.AcceptEncoding := 'gzip, deflate, br';
    _idHttp.Request.Connection := 'keep-alive';
    _idHttp.Request.Accept := '*/*';

    if TRim(edtApiKey.Text) = EmptyStr then
      raise TPlugException.Create('Chave de autenticação deve ser preenchida.');

    _idHttp.Request.CustomHeaders.AddValue('x-api-key', edtApiKey.Text);

    try
      if aOperacao = 'enviar' then
        EnviarNota(_idHttp, _body, _response);

      if aOperacao = 'consultar' then
        ConsultarNota(_idHttp, _response);

      if aOperacao = 'imprimir' then
        ImprimirNota(_idHttp, _response);

      if aOperacao = 'upload' then
        UploadCertificado(_idHttp, _formData, _response);
    except
      on e: TPlugException do
      begin
        raise;
      end;

      on e: EIdHTTPProtocolException  do
      begin
        mmoResposta.Lines.Clear;
        lblStatusCode.font.Color := clRed;
        lblStatusCode.Caption := _idHttp.ResponseText;
        mmoResposta.Lines.Add(e.ErrorMessage);
        Exit;
      end;

      on e: exception do
      begin
        mmoResposta.Lines.Clear;
        lblStatusCode.font.Color := clRed;
        lblStatusCode.Caption := _idHttp.ResponseText;
        mmoResposta.Lines.Text := _idHttp.ResponseText;
        Exit;
      end;
    end;

    lblStatusCode.font.Color := clGreen;
    lblStatusCode.Caption := _idHttp.ResponseText;
    _response.Position := 0;
    mmoResposta.Lines.LoadFromStream(_response);
  finally
    _response.Free;
    _body.Free;
    _formData.Free;
    _SSLHandler.Free;
    _idHttp.Free;
  end;
end;

procedure TForm1.UploadCertificado(const aIndy: TIdHTTP; const aFormData: TIdMultiPartFormDataStream;  const aResponse: TMemoryStream);
begin
  if edtCaminhoCertificado.Text = EmptyStr then
    raise TPlugException.Create('Caminho do certificado digital está vazio.');

  if edtSenhaCertificado.Text = EmptyStr then
    raise TPlugException.Create('Senha do certificado digital está vazia.');

  if not FileExists(edtCaminhoCertificado.Text) then
    raise TPlugException.Create('Arquivo do certificado digital não encontrado.');

  aFormData.AddFile('arquivo', edtCaminhoCertificado.Text, 'application/x-pkcs12');
  aFormData.AddFormField('senha', edtSenhaCertificado.Text);

  aIndy.Post(urls[cbbAmbiente.ItemIndex] + '/certificado', aFormData, aResponse);
end;

end.
