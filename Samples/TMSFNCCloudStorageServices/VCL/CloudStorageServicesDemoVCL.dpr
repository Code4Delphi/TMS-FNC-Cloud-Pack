program CloudStorageServicesDemoVCL;

uses
  Vcl.Forms,
  CloudStorageServices.Main in 'Src\CloudStorageServices.Main.pas' {CloudStorageServicesMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCloudStorageServicesMain, CloudStorageServicesMain);
  Application.Run;
end.
