unit TimerFrame;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, uplaysound;

type

  { TFrameTimer }

  TFrameTimer = class(TFrame)
    BtnStart: TButton;
    BtnStop: TButton;
    Edt: TEdit;
    PlySnd: Tplaysound;
    Tmr: TTimer;
    procedure BtnStartClick({%H-}Sender: TObject);
    procedure BtnStopClick({%H-}Sender: TObject);
    procedure TmrStartTimer({%H-}Sender: TObject);
    procedure TmrStopTimer({%H-}Sender: TObject);
    procedure TmrTimer({%H-}Sender: TObject);
  private
    FAlertAudioFile: String;
    FAlertDone: Boolean;
    FAlertTime: TTime;
    FStartAudioFile: String;
    FStartTime: TDateTime;
    FStopAudioFile: String;
    FStopTime: TTime;
    procedure PlayAudio(const aAudioFile: String);
  public
    property StartAudioFile: String read FStartAudioFile write FStartAudioFile;
    property AlertAudioFile: String read FAlertAudioFile write FAlertAudioFile;
    property StopAudioFile: String read FStopAudioFile write FStopAudioFile;
    property AlertTime: TTIme read FAlertTime;
    property StopTime: TTime read FStopTime;
  end;

implementation

{$R *.lfm}

function TimeToStopWatchStr(aTime: TTime): String;
begin
  DateTimeToString(Result, 'nn:ss', aTime);
end;

{ TFrameTimer }

procedure TFrameTimer.BtnStartClick(Sender: TObject);
begin
  Edt.Text:=TimeToStopWatchStr(0);;

  FStartTime:=Now;
  FStopTime:=1/SecsPerDay*60;
  FAlertTime:=1/SecsPerDay*50;
  FAlertDone:=False;
  PlayAudio(FStartAudioFile); 
  Tmr.Enabled:=True;
end;

procedure TFrameTimer.BtnStopClick(Sender: TObject);
begin
  Tmr.Enabled:=False;
  PlySnd.StopSound;
end;

procedure TFrameTimer.TmrStartTimer(Sender: TObject);
begin
  BtnStop.Enabled:=True;
  BtnStart.Enabled:=False;
end;

procedure TFrameTimer.TmrStopTimer(Sender: TObject);
begin
  BtnStart.Enabled:=True;
  BtnStop.Enabled:=False;
end;

procedure TFrameTimer.TmrTimer(Sender: TObject);
var
  aTime: TDateTime;
begin
  aTime:=Now-FStartTime;
  if (aTime>=FAlertTime) and not FAlertDone then
  begin
    FAlertDone:=True;
    PlayAudio(FAlertAudioFile);
  end;
  if aTime>=FStopTime then
  begin
    Tmr.Enabled:=False;
    aTime:=FStopTime;
    PlayAudio(FStopAudioFile);
  end;
  Edt.Text:=TimeToStopWatchStr(aTime);
end;

procedure TFrameTimer.PlayAudio(const aAudioFile: String);
begin
  PlySnd.PlayStyle:=psASync;
  PlySnd.SoundFile:=aAudioFile;
  PlySnd.Execute;
end;

end.
