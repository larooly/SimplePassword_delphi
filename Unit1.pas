unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit4: TEdit;
    Button2: TButton;
    Button3: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Button4: TButton;
    Edit7: TEdit;
    Edit8: TEdit;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
//////////////////가져옴///////////////
///////////////////////////////////////
function TransNamugi(a : integer): String;
var
  lis : String;
begin
  lis:='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  Result:= Copy(lis,a+1,1);
end;

function Chan10tob(a , b : integer):String;
var
  ar2 : String;
  x,y : integer;
begin
  ar2:='';
  while true do
  begin
    x := a div b;//정수 나누기
    y := a mod b;//나머지
    if a=0 then
    begin
      Result:= ar2;
      break;
    end
    else
    begin
      ar2 := TransNamugi(y)+ar2;
      a:=x;
    end;
  end;
end;

///////////무언가->10//////////////
function TransChar(a : String): integer;
var
  lis : String;
begin
  lis := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  Result := Pos(a,lis)-1;
end;

function dodo2(a,b : Int64): int64;
var
  i : Integer;
  c: Int64;
begin
  C:=1;
  for i:=0 to b-1 do
  begin
    c:=c*a;
  end;
  Result:= C;
end;
//숫자가 커질수있으니 주의
function ChanStringto10(a : String ; b : integer):Int64;
var
  sum : int64;
  i : integer;
begin
  sum := 0;
  for i :=1 to length(a) do
  begin
    sum := sum + dodo2(b,length(a)-i)*TransChar(a[i]);
  end;
  Result := sum;
end;
///////////////////////20.03.30////////////////////
///////////////////////////////////////////////////
function Sha256ToBase62(a : String): String;
var
  total , mid ,tran62 : String;
  i , tran10 : integer;
begin
  for i := 1 to (length(a) div 4) do
  begin
    mid := copy(a,(i-1)*4+1,4); //4자리씩 짜른게들감
    tran10 := ChanStringto10(mid,16);
    tran62 := Chan10tob(tran10,62);
    //여기서 만약 자릿수가 모자르면
    while length(tran62)<3 do
    begin
      tran62 := '0'+tran62;
    end;
    //무언가 한후
    total := total+tran62;
  end;
  Result := total;
end;

function Base62ToSha256(a : String): String;//거꾸로
var
  total , mid ,tran16 : String;
  i , tran10 : integer;
begin
  for i := 1 to (length(a) div 3) do
  begin
    mid := copy(a,(i-1)*3+1,3); //3자리씩 짜른게들감
    tran10 := ChanStringto10(mid,62);
    tran16 := Chan10tob(tran10,16);
    //여기서 만약 자릿수가 모자르면
    while length(tran16)<4 do
    begin
      tran16 := '0'+tran16;
    end;
    //무언가 한후
    total := total+tran16;
  end;
  Result := total;
end;

/////////////////////////////////////////////
/////////////번외편//////////////////////////
function UpSha256ToBase62(a : String): String;
var
  total , mid ,tran62 , tail : String;
  i ,j, tran10 , tail10: integer;
begin
  total := '';
  for i := 1 to (length(a) div 4) do
  begin
    mid := copy(a,(i-1)*4+1,4); //4자리씩 짜른게들감
    tran10 := ChanStringto10(mid,16);
    tran62 := Chan10tob(tran10,62);
    //여기서 만약 자릿수가 모자르면
    while length(tran62)<3 do
    begin
      tran62 := '0'+tran62;
    end;
    //무언가 한후
    total := total+tran62;
  end;
  if (Length(a) mod 4) <> 0 then //어차피 이건 맨뒤만 작용한다.
  begin
    tail := copy(a,((Length(a) div 4)*4)+1,Length(a) mod 4); //맨뒤 나머지
    for i := 1 to Length(a) mod 4 do
    begin
      if tail[i] = '0' then
      begin
        total := total+'0';//공간 맟 추 기
      end
      else
      begin
        break;//앞자리 0만 맟춰라
      end;
    end;
    tail10 := ChanStringto10(tail,16);
    tail := Chan10tob(tail10,62);
    total := total+tail;
  end;
  Result := total;
end;

function UpBase62ToSha256(a : String): String;//거꾸로
var
  total , mid ,tran16 , tail: String;
  i , j , lentail , tran10 : integer;
begin
  for i := 1 to ((length(a)-1) div 3) do //여기까지는 동일하게 해도됨
  begin  //자릿수때매 숫자더러워진것
    mid := copy(a,(i-1)*3+1,3); //3자리씩 짜른게들감
    tran10 := ChanStringto10(mid,62);
    tran16 := Chan10tob(tran10,16);
    //여기서 만약 자릿수가 모자르면
    while length(tran16)<4 do
    begin
      tran16 := '0'+tran16;
    end;
    total := total+tran16;
  end;
  //맨뒤무조건3자리든 아니든 잡아서 처리해야한다.
  //자릿수가 3자리가 나오기도 하니까 생각을 바꿔야한다.
  if (length(a) mod 3) = 0 then
  begin
    lentail := 3;
    //copy(a,((length(a) div 3))*3-2,lentail); 이제이걸바꾸면 됨
    tail := copy(a,((length(a) div 3))*3-2,lentail);
    //앞자리에 0있는거처리
    for i := 1 to lentail do
    begin
      if tail[i] = '0' then
      begin
        total := total+'0';//공간 맟 추 기
      end
      else
      begin
        break;//앞자리 0만 맟춰라
      end;
    end;

    j := ChanStringto10(tail,62);
    tail := Chan10tob(j,16);

    total := total+ tail;
  end
  else //남은게3의배수가 아니면
  begin
    lentail := (length(a) mod 3);
    tail := copy(a,((length(a) div 3))*3+1,lentail);
    for i := 1 to lentail do
    begin
      if tail[i] = '0' then
      begin
        total := total+'0';//공간 맟 추 기
      end
      else
      begin
        break;//앞자리 0만 맟춰라
      end;
    end;
    j := ChanStringto10(tail,62);
    tail := Chan10tob(j,16);
    total := total+ tail; //맨마지막3자리든2자리든가져와
  end;

  Result := total;
end;


////////////나머지도처리하기////////////////
////////////////////////////////////////////




///////여기서부터는 보이는부분////////////
procedure TForm1.Button1Click(Sender: TObject);
begin
  //일단 텍스트로 바꾸어 넣자
  Edit3.Text := Sha256ToBase62(Edit2.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Edit1.Text :=edit3.Text;
  Edit4.Text:=Base62ToSha256(Edit1.Text);
  if Edit2.Text = Edit4.Text then
  begin
    Label12.Caption := 'Same!';
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit4.Text:=Base62ToSha256(Edit1.Text);
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  Label10.Caption := inttostr(length(Edit2.Text));
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  Label11.Caption := inttostr(length(Edit1.Text));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Edit6.Text := UpSha256ToBase62(Edit5.Text);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Edit8.Text := UpBase62ToSha256(Edit7.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Edit7.Text :=edit6.Text;
  Edit8.Text:=UpBase62ToSha256(Edit7.Text);
  if Edit5.Text = Edit8.Text then
  begin
    Label24.Caption := 'Same!';
  end;
end;

procedure TForm1.Edit5Change(Sender: TObject);
begin
   Label22.Caption := IntToStr(length(Edit5.Text));
end;

procedure TForm1.Edit7Change(Sender: TObject);
begin
   Label23.Caption := IntToStr(length(Edit7.Text));
end;

end.
