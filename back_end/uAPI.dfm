object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 259
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poPrintToFit
  OnCreate = FormCreate
  DesignSize = (
    570
    259)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 152
    Height = 13
    Caption = 'Dados de conex'#227'o com o banco'
  end
  object LabelNomeBanco: TLabel
    Left = 8
    Top = 37
    Width = 74
    Height = 13
    Caption = 'Nome do banco'
  end
  object LabelUsuario: TLabel
    Left = 200
    Top = 37
    Width = 36
    Height = 13
    Caption = 'Usu'#225'rio'
  end
  object LabelSenha: TLabel
    Left = 416
    Top = 37
    Width = 30
    Height = 13
    Caption = 'Senha'
  end
  object LabelHost: TLabel
    Left = 80
    Top = 117
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object LabelPorta: TLabel
    Left = 325
    Top = 117
    Width = 26
    Height = 13
    Caption = 'Porta'
  end
  object EditNomeBanco: TEdit
    Left = 8
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EditUsuario: TEdit
    Left = 200
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object EditSenha: TEdit
    Left = 416
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object EditHost: TEdit
    Left = 80
    Top = 136
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object EditPorta: TEdit
    Left = 325
    Top = 136
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object ButtonIniciar: TButton
    Left = 232
    Top = 192
    Width = 75
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Iniciar'
    TabOrder = 5
    OnClick = ButtonIniciarClick
  end
  object ButtonParar: TButton
    Left = 232
    Top = 223
    Width = 75
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Parar'
    TabOrder = 6
  end
end
