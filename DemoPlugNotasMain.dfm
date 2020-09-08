object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = mmoResposta
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Demonstra'#231#227'o Plug Notas NFe'
  ClientHeight = 594
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblResposta: TLabel
    Left = 8
    Top = 414
    Width = 125
    Height = 13
    Caption = 'Resposta das requisi'#231#245'es:'
  end
  object lblRespostaFormatada: TLabel
    Left = 432
    Top = 414
    Width = 102
    Height = 13
    Caption = 'Resposta formatada:'
  end
  object lblStatusCode: TLabel
    Left = 8
    Top = 573
    Width = 3
    Height = 13
  end
  object mmoResposta: TMemo
    Left = 8
    Top = 433
    Width = 272
    Height = 133
    Lines.Strings = (
      'As respostas das requisi'#231#245'es ficar'#227'o aqui.')
    TabOrder = 0
  end
  object pnlConfiguracoes: TPanel
    Left = 8
    Top = 8
    Width = 731
    Height = 89
    TabOrder = 3
    object lblAmbiente: TLabel
      Left = 16
      Top = 16
      Width = 49
      Height = 13
      Caption = 'Ambiente:'
    end
    object lblApiKey: TLabel
      Left = 184
      Top = 16
      Width = 207
      Height = 13
      Caption = 'x-api-key (Chave de Autentica'#231#227'o da API):'
    end
    object cbbAmbiente: TComboBox
      Left = 16
      Top = 35
      Width = 97
      Height = 21
      ItemIndex = 0
      TabOrder = 0
      Text = 'Sandbox'
      Items.Strings = (
        'Sandbox'
        'Produ'#231#227'o')
    end
    object edtApiKey: TEdit
      Left = 184
      Top = 35
      Width = 241
      Height = 21
      TabOrder = 1
      Text = '2da392a6-79d2-4304-a8b7-959572c7e44d'
    end
  end
  object pnlEnvioNota: TPanel
    Left = 8
    Top = 103
    Width = 731
    Height = 98
    TabOrder = 4
    object lblNota: TLabel
      Left = 16
      Top = 8
      Width = 71
      Height = 13
      Caption = 'JSON da Nota:'
    end
    object mmoJsonNota: TMemo
      Left = 16
      Top = 27
      Width = 545
      Height = 62
      Lines.Strings = (
        
          '[{"presencial":false,"consumidorFinal":true,"natureza":"OPERA'#199#195'O' +
          ' INTERNA","emitente":{"cpfCnpj":"08187168000160"},"destinatario"' +
          ':{"cpfCnpj":"08114280956","razaoSocial":"THIAGO RIBEIRO","email"' +
          ':"contato@tecnospeed.com.br","endereco":{"logradouro":"AVENIDA D' +
          'UQUE DE CAXIAS","numero":"882","bairro":"CENTRO","codigoCidade":' +
          '"4115200","descricaoCidade":"MARINGA","estado":"PR","cep":"87020' +
          '025"}},"itens":[{"codigo":"1","descricao":"Descri'#231#227'o do ITEM.","' +
          'ncm":"06029090","cest":"0123456","cfop":"5101","unidade":{"comer' +
          'cial":"M","tributavel":"M"},"quantidade":{"comercial":50,"tribut' +
          'avel":50},"valorUnitario":{"comercial":4.6,"tributavel":4.6},"va' +
          'lor":230,"valorDesconto":0,"valorFrete":0,"compoeTotal":true,"tr' +
          'ibutos":{"icms":{"origem":"0","cst":"40","baseCalculo":{"modalid' +
          'adeDeterminacao":"3","valor":0},"aliquota":0,"valor":0},"pis":{"' +
          'cst":"99","baseCalculo":{"valor":0,"quantidade":0},"aliquota":0,' +
          '"valor":0},"cofins":{"cst":"07","baseCalculo":{"valor":0},"aliqu' +
          'ota":0,"valor":0}}}],"pagamentos":[{"a'
        
          'Vista":true,"meio":"01","valor":230}],"responsavelTecnico":{"cpf' +
          'Cnpj":"08187168000160","nome":"Tecnospeed","email":"contato@tecn' +
          'ospeed.com.br","telefone":{"ddd":"44","numero":"30379500"}}}]')
      TabOrder = 0
      WordWrap = False
    end
    object btnEnviarNota: TButton
      Left = 592
      Top = 40
      Width = 105
      Height = 25
      Caption = 'Enviar Nota'
      TabOrder = 1
      OnClick = btnEnviarNotaClick
    end
  end
  object pnlConsultarNota: TPanel
    Left = 8
    Top = 207
    Width = 731
    Height = 82
    TabOrder = 5
    object lblIdNota: TLabel
      Left = 16
      Top = 8
      Width = 55
      Height = 13
      Caption = 'ID da nota:'
    end
    object btnConsultarNota: TButton
      Left = 592
      Top = 11
      Width = 105
      Height = 25
      Caption = 'Consultar Nota'
      TabOrder = 1
      OnClick = btnConsultarNotaClick
    end
    object edtIdNota: TEdit
      Left = 16
      Top = 27
      Width = 545
      Height = 21
      TabOrder = 0
    end
    object btnImprimirNota: TButton
      Left = 592
      Top = 42
      Width = 105
      Height = 25
      Caption = 'Imprimir Nota'
      TabOrder = 2
      OnClick = btnImprimirNotaClick
    end
  end
  object mmoJsonParseado: TMemo
    Left = 432
    Top = 433
    Width = 306
    Height = 133
    TabOrder = 2
  end
  object btnParsearJson: TButton
    Left = 294
    Top = 469
    Width = 121
    Height = 25
    Caption = '-- Parsear JSON ->'
    TabOrder = 1
    OnClick = btnParsearJsonClick
  end
  object pnlUploadCertificado: TPanel
    Left = 8
    Top = 295
    Width = 730
    Height = 113
    TabOrder = 6
    object lblCaminhoCertificado: TLabel
      Left = 16
      Top = 10
      Width = 144
      Height = 13
      Caption = 'Caminho do certificado digital:'
    end
    object lblSenhaCertificado: TLabel
      Left = 16
      Top = 58
      Width = 133
      Height = 13
      Caption = 'Senha do certificado digital:'
    end
    object btnSubirCertificado: TButton
      Left = 592
      Top = 41
      Width = 105
      Height = 25
      Caption = 'Upload Certificado'
      TabOrder = 0
      OnClick = btnSubirCertificadoClick
    end
    object edtCaminhoCertificado: TEdit
      Left = 16
      Top = 29
      Width = 489
      Height = 21
      TabOrder = 1
    end
    object edtSenhaCertificado: TEdit
      Left = 16
      Top = 77
      Width = 545
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
    object btnSelecionarCertificado: TButton
      Left = 511
      Top = 32
      Width = 50
      Height = 17
      Caption = '...'
      TabOrder = 3
      OnClick = btnSelecionarCertificadoClick
    end
  end
  object dlgSavePDF: TSaveDialog
    DefaultExt = 'pdf'
    Left = 696
    Top = 16
  end
  object dlgOpenSelecionarCertificado: TOpenDialog
    Filter = 'Certificado Digital|*.pfx|Certificado Digital|*.p12'
    Left = 696
    Top = 296
  end
end
