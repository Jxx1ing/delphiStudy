unit uDoMain;

interface

type
  //��Ʒ��
  TProduct = class
  private
    //��Ʒ���
    FId: Integer;
    //��Ʒ����
    FName: String;
    //��Ʒ�Ƿ��Ѿ�������
    FIsConsumption: Boolean;
  public
    property id: Integer read FId write FId;
    property Name: String read FName write FName;
    property IsConsumption: Boolean read FIsConsumption write FIsConsumption;
  end;

implementation

end.
