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
    FAnswerTime: TTime;
    FAnswerTimer: Boolean;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FStartAudioFile: String;
    FStartTime: TDateTime;
    FStopAudioFile: String;
    FStopDone: Boolean;
    FStopTime: TTime;
    procedure DoStart;
    procedure DoStop;
    procedure PlayAudio(const aAudioFile: String);
  public
    property StartAudioFile: String read FStartAudioFile write FStartAudioFile;
    property AlertAudioFile: String read FAlertAudioFile write FAlertAudioFile;
    property StopAudioFile: String read FStopAudioFile write FStopAudioFile;
    property AlertTime: TTIme read FAlertTime;
    property StopTime: TTime read FStopTime;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property AnswerTimer: Boolean read FAnswerTimer write FAnswerTimer;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;       
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
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
  FAnswerTime:=FStopTime+1/SecsPerDay*15;
  FAlertDone:=False;
  FStopDone:=False;
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
  DoStart;
  BtnStop.Enabled:=True;
  BtnStart.Enabled:=False;
end;

procedure TFrameTimer.TmrStopTimer(Sender: TObject);
begin
  BtnStart.Enabled:=True;
  BtnStop.Enabled:=False;  
  DoStop;
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
  if (aTime>=FStopTime) and not FStopDone then
  begin             
    PlayAudio(FStopAudioFile);
    FStopDone:=True;
    if not AnswerTimer then
    begin
      Tmr.Enabled:=False;
      aTime:=FStopTime;
    end;
  end;
  if AnswerTimer and (aTime>=FAnswerTime) then
  begin               
    PlayAudio(FStopAudioFile);
    Tmr.Enabled:=False;
    aTime:=FStopTime;
  end;
  Edt.Text:=TimeToStopWatchStr(aTime);
end;

procedure TFrameTimer.DoStart;
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

procedure TFrameTimer.DoStop;
begin
  if Assigned(FOnStop) then
    FOnStop(Self);
end;

procedure TFrameTimer.PlayAudio(const aAudioFile: String);
begin
  PlySnd.PlayStyle:=psASync;
  PlySnd.SoundFile:=aAudioFile;
  PlySnd.Execute;
end;

end.

