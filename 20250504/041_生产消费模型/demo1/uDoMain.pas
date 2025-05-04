unit uDoMain;

interface

type
  //产品类
  TProduct = class
  private
    //产品编号
    FId: Integer;
    //产品名称
    FName: String;
    //产品是否已经被消费
    FIsConsumption: Boolean;
  public
    property id: Integer read FId write FId;
    property Name: String read FName write FName;
    property IsConsumption: Boolean read FIsConsumption write FIsConsumption;
  end;

implementation

end.
