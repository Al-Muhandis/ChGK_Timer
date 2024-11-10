unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ComCtrls, ExtCtrls,
  RxTimeEdit, TimerFrame
  ;

type

  { TFrmMain }

  TFrmMain = class(TForm)
    FrmTimer: TFrameTimer;
    procedure FormCreate({%H-}Sender: TObject);
  public
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.lfm}


{ TFrmMain }

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FrmTimer.StartAudioFile:='min-start.wav';
  FrmTimer.AlertAudioFile:='min-alert.wav';
  FrmTimer.StopAudioFile:='min-stop.wav';
end;

end.

