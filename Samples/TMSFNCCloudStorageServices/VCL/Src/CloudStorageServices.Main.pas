unit CloudStorageServices.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  VCL.TMSFNCTypes,
  VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes,
  Vcl.StdCtrls,
  VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCCloudDemoListBox,
  Vcl.ExtCtrls,
  VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudStorageServices,
  VCL.TMSFNCCloudStorage,
  VCL.TMSFNCCloudBase,
  VCL.TMSFNCCloudBox,
  VCL.TMSFNCCloudDropBox,
  VCL.TMSFNCCloudGoogleDrive,
  VCL.TMSFNCCloudHubic,
  VCL.TMSFNCCloudMicrosoftOneDrive,
  VCL.TMSFNCCloudOAuth,
  VCL.TMSFNCCloudGoogle;

type
  TCloudStorageServicesMain = class(TForm)
    Panel1: TPanel;
    TMSFNCCloudDemoListBox1: TTMSFNCCloudDemoListBox;
    Panel2: TPanel;
    Label1: TLabel;
    lPath: TLabel;
    btRootFolder: TButton;
    btUp: TButton;
    btOpenFolder: TButton;
    edCreateFolder: TEdit;
    btCreateFolder: TButton;
    btDownload: TButton;
    btUpload: TButton;
    btDelete: TButton;
    Panel3: TPanel;
    edCallbackURL: TEdit;
    Label6: TLabel;
    edSecret: TEdit;
    Label5: TLabel;
    edClientID: TEdit;
    Label4: TLabel;
    Label2: TLabel;
    cbStorageService: TComboBox;
    btConnect: TButton;
    TMSFNCCloudStorageServices1: TTMSFNCCloudStorageServices;
    procedure FormCreate(Sender: TObject);
    procedure cbStorageServiceChange(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure TMSFNCCloudStorageServices1Connected(Sender: TObject);
    procedure TMSFNCCloudStorageServices1CreateFolder(Sender: TObject; const AFolder: TTMSFNCCloudItem;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1DeleteItem(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1GetFolderList(Sender: TObject; const AItems: TTMSFNCCloudItems;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1UploadFile(Sender: TObject; const AUploadItem: TTMSFNCCloudItem;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure btRootFolderClick(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure btOpenFolderClick(Sender: TObject);
    procedure btCreateFolderClick(Sender: TObject);
    procedure btDownloadClick(Sender: TObject);
    procedure btUploadClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
  private

  public
    FClientID: string;
    FSecret: string;
    FURL: string;
    FCurrentFolder: TTMSFNCCloudItem;
    procedure Refresh;
    procedure SelectService;
    procedure FillListBox(AItems: TTMSFNCCloudItems; AAddFolders, AAddFiles: Boolean);
  end;

var
  CloudStorageServicesMain: TCloudStorageServicesMain;

implementation

{$R *.dfm}

procedure TCloudStorageServicesMain.FormCreate(Sender: TObject);
begin
  FClientID := '';
  FSecret := '';
  FURL := '';

  Self.SelectService;
end;

procedure TCloudStorageServicesMain.SelectService;
var
  LPersistTokens: string;
begin
  LPersistTokens := TTMSFNCUtils.AddBackslash(TTMSFNCUtils.GetAppPath) + TMSFNCCloudStorageServices1.ClassName;

  TMSFNCCloudStorageServices1.Authentication.ClientID := FClientID;
  TMSFNCCloudStorageServices1.Authentication.Secret := FSecret;
  TMSFNCCloudStorageServices1.Authentication.CallBackURL := FURL;

  case cbStorageService.ItemIndex of
    0:
    begin
      TMSFNCCloudStorageServices1.Service := cssBox;
      TMSFNCCloudStorageServices1.PersistTokens.Key := LPersistTokens + 'Box.ini';
    end;
    1:
    begin;
      TMSFNCCloudStorageServices1.Service := cssDropBox;
      TMSFNCCloudStorageServices1.PersistTokens.Key := LPersistTokens + 'DropBox.ini';
    end;
    2:
    begin
      TMSFNCCloudStorageServices1.Service := cssGoogleDrive;
      TMSFNCCloudStorageServices1.PersistTokens.Key := LPersistTokens + 'GoogleDrive.ini';
    end;
    3:
    begin
      TMSFNCCloudStorageServices1.Service := cssMicrosoftOneDrive;
      TMSFNCCloudStorageServices1.PersistTokens.Key := LPersistTokens + 'OneDrive.ini';
    end;
    4:
    begin
      TMSFNCCloudStorageServices1.Service := cssHubic;
      TMSFNCCloudStorageServices1.PersistTokens.Key := LPersistTokens + 'Hubic.ini';
    end;
  end;

  edClientID.Text := TMSFNCCloudStorageServices1.Authentication.ClientID;
  edSecret.Text := TMSFNCCloudStorageServices1.Authentication.Secret;
  edCallbackURL.Text := TMSFNCCloudStorageServices1.Authentication.CallBackURL;

  TMSFNCCloudStorageServices1.Storage.LoadTokens;
end;

procedure TCloudStorageServicesMain.btConnectClick(Sender: TObject);
begin
  if (edClientID.Text = '') or (edSecret.Text = '') and (edCallbackURL.Text = '') then
    raise Exception.Create('Please fill in ClientID, Secret and CallbackURL');

  FClientID := edClientID.Text;
  FSecret := edSecret.Text;
  FURL := edCallbackURL.Text;

  Self.SelectService;
  TMSFNCCloudStorageServices1.Connect;
end;

procedure TCloudStorageServicesMain.btCreateFolderClick(Sender: TObject);
begin
  if edCreateFolder.Text <> '' then
    TMSFNCCloudStorageServices1.CreateFolder(FCurrentFolder, edCreateFolder.Text);
end;

procedure TCloudStorageServicesMain.btDeleteClick(Sender: TObject);
var
  LCloudItem: TTMSFNCCloudItem;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  LCloudItem := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;
  TMSFNCCloudStorageServices1.Delete(LCloudItem);
end;

procedure TCloudStorageServicesMain.btDownloadClick(Sender: TObject);
var
  LCloudItem: TTMSFNCCloudItem;
  LFileName: string;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  LCloudItem := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;
  LFileName := LCloudItem.FileName;
  TTMSFNCUtils.SaveFile(LFileName, '',
    procedure(const AFile: string; const AResult: Boolean)
    begin
      if not AResult then
        Exit;

      LFileName := AFile;
      TMSFNCCloudStorageServices1.Download(LCloudItem, LFileName);
    end);
end;

procedure TCloudStorageServicesMain.btOpenFolderClick(Sender: TObject);
var
  LCloudItem: TTMSFNCCloudItem;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  LCloudItem := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;

  if LCloudItem.ItemType = ciFolder then
  begin
    case TMSFNCCloudStorageServices1.Service of
      cssBox: FCurrentFolder := TTMSFNCCloudBoxItem.Create(nil);
      cssDropBox: FCurrentFolder := TTMSFNCCloudDropBoxItem.Create(nil);
      cssGoogleDrive: FCurrentFolder := TTMSFNCCloudGoogleDriveItem.Create(nil);
      cssHubic: FCurrentFolder := TTMSFNCCloudHubicItem.Create(nil);
      cssMicrosoftOneDrive: FCurrentFolder := TTMSFNCCloudMicrosoftOneDriveItem.Create(nil);
    end;

    FCurrentFolder.Assign(LCloudItem);
    lPath.Caption := lPath.Caption + '\' + LCloudItem.FileName;
    TMSFNCCloudStorageServices1.GetFolderListHierarchical(FCurrentFolder);
  end;
end;

procedure TCloudStorageServicesMain.btRootFolderClick(Sender: TObject);
begin
  FCurrentFolder := nil;
  TMSFNCCloudStorageServices1.GetFolderList;
end;

procedure TCloudStorageServicesMain.btUpClick(Sender: TObject);
  function LastIndexOf(const S: string; const Chr: Char): Integer;
  begin
    Result := 0;
    for var i := length(S) downto 1 do
    begin
      if S[i] = Chr then
      begin
        Result := i-1;
        break;
      end;
    end;
  end;
begin
  if Assigned(FCurrentFolder) and Assigned(FCurrentFolder.ParentFolder) then
  begin
    FCurrentFolder := FCurrentFolder.ParentFolder;
    lPath.Caption := Copy(lPath.Caption, 0, LastIndexOf(lPath.Caption, '\'));
    if lPath.Caption = '' then
      lPath.Caption := 'root';
    TMSFNCCloudStorageServices1.GetFolderListHierarchical(FCurrentFolder);
  end
  else
  begin
    FCurrentFolder := nil;
    lPath.Caption := 'root';
    TMSFNCCloudStorageServices1.GetFolderList;
  end;
end;

procedure TCloudStorageServicesMain.btUploadClick(Sender: TObject);
var
  LFileName: string;
begin
  TTMSFNCUtils.SelectFile(LFileName, '', '',
  procedure(const AFile: string; const AResult: Boolean)
  begin
    if not AResult then
      Exit;

    LFileName := AFile;
    TMSFNCCloudStorageServices1.Upload(FCurrentFolder, LFileName);
  end
  );
end;

procedure TCloudStorageServicesMain.cbStorageServiceChange(Sender: TObject);
begin
  Self.SelectService;
end;

procedure TCloudStorageServicesMain.Refresh;
begin
  FCurrentFolder := nil;
  TMSFNCCloudStorageServices1.GetFolderList;
end;

procedure TCloudStorageServicesMain.TMSFNCCloudStorageServices1Connected(Sender: TObject);
begin
  Self.Refresh;
end;

procedure TCloudStorageServicesMain.TMSFNCCloudStorageServices1CreateFolder(Sender: TObject; const AFolder: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  edCreateFolder.Text := '';
  TMSFNCCloudStorageServices1.GetFolderListHierarchical(FCurrentFolder);
end;

procedure TCloudStorageServicesMain.TMSFNCCloudStorageServices1DeleteItem(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  Self.Refresh;
end;

procedure TCloudStorageServicesMain.TMSFNCCloudStorageServices1GetFolderList(Sender: TObject; const AItems: TTMSFNCCloudItems;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  TMSFNCCloudDemoListBox1.BeginUpdate;
  TMSFNCCloudDemoListBox1.ItemIndex := -1;
  TMSFNCCloudDemoListBox1.Items.Clear;
  Self.FillListBox(AItems, True, False);
  Self.FillListBox(AItems, False, True);
  TMSFNCCloudDemoListBox1.EndUpdate;
end;

procedure TCloudStorageServicesMain.FillListBox(AItems: TTMSFNCCloudItems; AAddFolders, AAddFiles: Boolean);
var
  LType: string;
  LCloudItem: TTMSFNCCloudItem;
begin
  if not Assigned(AItems) then
    Exit;

  TMSFNCCloudDemoListBox1.BeginUpdate;
  for var I := 0 to AItems.Count - 1 do
  begin
    LCloudItem := AItems.Items[I];
    LType := LowerCase(StringReplace(ExtractFileExt(LCloudItem.FileName), '.', '', [rfReplaceAll]));
    if AItems.Items[I].ItemType = ciFolder then
      LType := 'folder'
    else if LType = '' then
      LType := 'file';

    if not TMSFNCCloudDemoListBox1.SupportsFileType(LType) then
      LType := 'file';

    if ((LCloudItem.ItemType = ciFolder) and AAddFolders) or ((LCloudItem.ItemType = ciFile) and AAddFiles) then
      TMSFNCCloudDemoListBox1.AddItem(AItems.Items[I].Filename, LType, LCloudItem);
  end;
  TMSFNCCloudDemoListBox1.EndUpdate;
end;

procedure TCloudStorageServicesMain.TMSFNCCloudStorageServices1UploadFile(Sender: TObject; const AUploadItem: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  TMSFNCCloudStorageServices1.GetFolderList;
end;

end.
