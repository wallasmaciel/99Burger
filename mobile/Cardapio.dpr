program Cardapio;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  DM.Principal in 'DataModule\DM.Principal.pas' {DMPrincipal: TDataModule},
  uFunctions in 'Units\uFunctions.pas',
  uLoading in 'Units\uLoading.pas',
  Sacola in 'Sacola.pas' {FrmSacola};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.CreateForm(TFrmSacola, FrmSacola);
  Application.Run;
end.
