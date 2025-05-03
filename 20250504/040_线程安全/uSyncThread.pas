unit uSyncThread;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs;

type
  TWorkingThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    procedure Work();
  end;

var
  i: Integer;   //ȫ�ֱ��������ʹ����ڴ�
  CriticalSection: TCriticalSection; //ȫ��һ���ٽ���

implementation

uses
  Unit1;

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TWork.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ TWork }

procedure TWorkingThread.Execute;
//var
//  i: Integer;   //�ֲ�����
begin
  { Place thread code here }
{
  while True do
  begin
    //Form1.lblContent.Caption := i.ToString;
    Form1.mmo1.Lines.add('�̱߳��:' + Self.ThreadID.ToString + ',   ' + i.ToString);
    if i = 10 then
    begin
      Exit;
    end;
    Inc(i);
    Self.Sleep(100);
  end;
}
{
  FreeOnTerminate := True;
  Self.Synchronize(work);
}
  FreeOnTerminate := True;
  CriticalSection.enter; //����
  Work();
  CriticalSection.leave; //����
end;

procedure TWorkingThread.Work;
begin
  while True do
  begin
    //Form1.lblContent.Caption := i.ToString;
    Form1.mmo1.Lines.add('�̱߳��:' + Self.ThreadID.ToString + ',   ' + i.ToString);
    if i = 10 then
    begin
      Exit;
    end;
    Inc(i);
    Self.Sleep(100);
  end;
end;



initialization
  CriticalSection := TCriticalSection.Create;

finalization
  CriticalSection.Free;


end.

