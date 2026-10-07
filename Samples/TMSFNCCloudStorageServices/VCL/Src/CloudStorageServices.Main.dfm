object CloudStorageServicesMain: TCloudStorageServicesMain
  Left = 0
  Top = 0
  Caption = 'TMS FNC Cloud Pack - TTMSFNCCloudStorageServices Demo'
  ClientHeight = 691
  ClientWidth = 662
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 129
    Width = 662
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 26
      Height = 13
      Caption = 'Path:'
    end
    object lPath: TLabel
      Left = 40
      Top = 14
      Width = 20
      Height = 13
      Caption = 'root'
    end
  end
  object TMSFNCCloudDemoListBox1: TTMSFNCCloudDemoListBox
    Left = 0
    Top = 170
    Width = 353
    Height = 521
    Align = alLeft
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 1
    Items = <>
  end
  object Panel2: TPanel
    Left = 353
    Top = 170
    Width = 309
    Height = 521
    Align = alClient
    TabOrder = 2
    object btRootFolder: TButton
      Left = 16
      Top = 16
      Width = 80
      Height = 25
      Caption = 'Root'
      TabOrder = 0
      OnClick = btRootFolderClick
    end
    object btUp: TButton
      Left = 112
      Top = 16
      Width = 80
      Height = 25
      Caption = 'Up'
      TabOrder = 1
      OnClick = btUpClick
    end
    object btOpenFolder: TButton
      Left = 208
      Top = 16
      Width = 80
      Height = 25
      Caption = 'Open Folder'
      TabOrder = 2
      OnClick = btOpenFolderClick
    end
    object edCreateFolder: TEdit
      Left = 16
      Top = 56
      Width = 176
      Height = 21
      TabOrder = 3
    end
    object btCreateFolder: TButton
      Left = 208
      Top = 54
      Width = 80
      Height = 25
      Caption = 'Create Folder'
      TabOrder = 4
      OnClick = btCreateFolderClick
    end
    object btDownload: TButton
      Left = 16
      Top = 94
      Width = 80
      Height = 25
      Caption = 'Download'
      TabOrder = 5
      OnClick = btDownloadClick
    end
    object btUpload: TButton
      Left = 112
      Top = 94
      Width = 80
      Height = 25
      Caption = 'Upload'
      TabOrder = 6
      OnClick = btUploadClick
    end
    object btDelete: TButton
      Left = 208
      Top = 94
      Width = 80
      Height = 25
      Caption = 'Delete'
      TabOrder = 7
      OnClick = btDeleteClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 662
    Height = 129
    Align = alTop
    TabOrder = 3
    object Label6: TLabel
      Left = 16
      Top = 99
      Width = 61
      Height = 13
      Caption = 'Callback URL'
    end
    object Label5: TLabel
      Left = 16
      Top = 72
      Width = 31
      Height = 13
      Caption = 'Secret'
    end
    object Label4: TLabel
      Left = 16
      Top = 45
      Width = 41
      Height = 13
      Caption = 'Client ID'
    end
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 39
      Height = 13
      Caption = 'Service:'
    end
    object edCallbackURL: TEdit
      Left = 80
      Top = 96
      Width = 361
      Height = 21
      TabOrder = 0
    end
    object edSecret: TEdit
      Left = 80
      Top = 69
      Width = 361
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object edClientID: TEdit
      Left = 80
      Top = 42
      Width = 361
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
    object cbStorageService: TComboBox
      Left = 79
      Top = 15
      Width = 278
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      OnChange = cbStorageServiceChange
    end
    object btConnect: TButton
      Left = 363
      Top = 11
      Width = 78
      Height = 25
      Caption = 'Connect'
      TabOrder = 4
      OnClick = btConnectClick
    end
    object TMSFNCCloudStorageServices1: TTMSFNCCloudStorageServices
      Left = 527
      Top = 59
      Width = 26
      Height = 26
      Visible = True
      PersistTokens.Section = 'TTMSFNCCloudGoogleDrive'
      PersistTokens.SaveClientID = True
      PersistTokens.SaveSecret = True
      PersistTokens.SaveKey = True
      PersistTokens.SaveCallBack = True
      Service = cssBox
      OnConnected = TMSFNCCloudStorageServices1Connected
      OnGetFolderList = TMSFNCCloudStorageServices1GetFolderList
      OnCreateFolder = TMSFNCCloudStorageServices1CreateFolder
      OnUploadFile = TMSFNCCloudStorageServices1UploadFile
      OnDeleteItem = TMSFNCCloudStorageServices1DeleteItem
    end
  end
end
