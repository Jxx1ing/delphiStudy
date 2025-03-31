program BPLTest;

uses
  Goldbach; // 引入BPL单元

begin
  // 直接调用BPL中的函数测试
  VerifyGoldbachConjecture(200); // 测试哥德巴赫到200

  WriteLn('测试完成！如果看到上面的输出，说明BPL调用成功');
  ReadLn;
end.
