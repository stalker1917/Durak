object Form1: TForm1
  Left = 213
  Top = 110
  Cursor = crHandPoint
  Caption = #1048#1075#1088#1072': "'#1044#1091#1088#1072#1082'"'
  ClientHeight = 444
  ClientWidth = 777
  Color = clGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormActivate
  OnShow = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 609
    Height = 321
    Alignment = taCenter
    AutoSize = False
    Caption = #1055#1086#1079#1076#1088#1072#1074#1083#1103#1077#1084' '#1042#1099' '#1087#1086#1073#1077#1076#1080#1083#1080'!'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -48
    Font.Name = 'Times New Roman'
    Font.Style = [fsItalic]
    ParentFont = False
    Layout = tlCenter
    Visible = False
  end
  object Label2: TLabel
    Left = 392
    Top = 280
    Width = 65
    Height = 13
    Caption = #1042#1077#1088#1086#1103#1090#1085#1086#1089#1090#1100
    Color = clCaptionText
    ParentColor = False
    Visible = False
  end
  object Label3: TLabel
    Left = 256
    Top = 136
    Width = 50
    Height = 24
    Caption = #1041#1077#1088#1091'!'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clYellow
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Visible = False
  end
  object Button1: TButton
    Left = 704
    Top = 336
    Width = 75
    Height = 25
    Caption = #1057#1076#1072#1090#1100' '#1082#1072#1088#1090#1099
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 704
    Top = 400
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 704
    Top = 368
    Width = 75
    Height = 25
    Caption = #1041#1080#1090#1086
    TabOrder = 2
    Visible = False
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 704
    Top = 368
    Width = 75
    Height = 25
    Caption = #1041#1077#1088#1091'!'
    TabOrder = 3
    Visible = False
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 304
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = #1054#1090#1083#1072#1076#1082#1072
    Visible = False
  end
end
