//By stalker1917   2002-2020
//LGPL License

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, MAth;

type
  //Tkar= array[1..4,1..9] of extended;
  TCards = record
   chislo:byte;{ �������-���}
   mast:byte; {����� ����� ����-�����}
   vidimost:boolean; {���� �� ����� ���� ��� ���������}
  end;

  TPodatel = object {�������� ����.
  ������ ������, ������, ����� � ������}
        soder:array[1..36] of TCards;
        Buf:TCards;  {���� ����� ��� ����}
        ColKart:byte;
    Procedure Pop(var popc:TCards);
    function rating(i:integer):integer;
  end;
  PPodatel = ^Tpodatel;
  TColoda = object(TPodatel)
    Procedure Init;
    Procedure Regen;
   end;
   TIgrok = object(TPodatel)
    beru:boolean;
    Procedure Dobor;
    Procedure Hodit(nomer:integer);
   end;
  TMashina = object(TPodatel)
  IMPULSE:array[0..36] of double; {������� ��� ������ ����� � 0 ��� ������-�������}
  Impulse2 : array[0..36] of Word; // �� ���� ��������� ������
  pogoni:byte;
    Procedure Dobor;
    Function Hodit:Integer;
    Procedure Bitsa;
    Function HodBit(Bits : Boolean; BeruFlag:Boolean=False):Integer;
   end;
  TStol = object(TPodatel)
     bito:boolean;{��� ����� ���� ��� �����, ��� ���� ��� ������?}
     NCX:Integer;{��������� ���������� � ����� �� �����}
     Procedure ViKlad(const Istochnik:TPodatel);
     procedure Regen;
   end;
  TVirtualGamer = object(TPodatel)
    TekStol,TekCol : PPodatel;
    Beruflag : Boolean;
    Function HodCheck(number:Integer):Boolean;
    Function HodCheckB(number:Integer):Boolean;
    Procedure Hod(number:Integer);
    Procedure Beru;
    Procedure Dobor;
    Function RandomHod(Stage:Boolean):Integer;
    Function NotRandomHod(Hodn:Integer; Stage: Boolean):Boolean;
    Procedure Hod_hod0(Hodn: Integer; Stage:Boolean);
    Function NaimHod(Stage: Boolean; Berserk: Boolean=False; Rmode : Boolean=False):Integer;
  end;
  Tpal = array[1..1024] of byte;
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  function vozm(nom:integer):boolean; // ���������� ����������� ����� �����.
  public
    { Public declarations }
  end;
Procedure Redraw(y,c:integer;pod:TPodatel; mh:boolean);
Procedure Pobeda(p:byte);
Procedure BitBer(var pod:TPodatel);
Procedure Sortirovka(var pod:TPodatel);
//Function GetElem:boolean;
var
  Form1: TForm1;
  karti:array[1..37] of TBitmap;   {������� ����}
  pallete:Tpal;
  col:array[1..256] of Tcolor absolute pallete;
  Prom:array[0..95,-1..70] of byte;
  kozir:byte; {���������� ������}
  panel:boolean;{������� �� ������ � ������}
  mash:boolean;{��� ����� ������� ��� ������?}
  beru:boolean;{����� ������ ����}
  Coloda:TColoda;
  Igrok:TIgrok;
  Mashina:TMashina;
  Stol:TStol;
  VColoda,VStol : TPodatel;
  VIgrok : Array[0..1] of TVirtualGamer;
  Vcoloda2 : TVirtualGamer;
  Pobito:TPodatel;
  //ver:Tver;
  Int,NewInt:array[1..23] of double;
  report:text;
  MaxOldH,MaxOldB : integer;
  MaxOldHK,MaxOldBK : integer;
{���- ���������, �.�. ����������� ������������. � ��� ���
��� ����������:
  6-14   ���� �����, �.� �� ���
  15-23 - ��� �������� ����
  5 - ��� ������.
  4 - ��� ������� ������
  1..3 - �������� �� ���������� ������
 }
  verotl:boolean;
  otkrKart:boolean;
  //elem:boolean;
  {
  ������� � ����� ������������ ����, ����� ����� ��������
  ��������.
  }
  bopod:boolean;
  GoodOpen : Boolean=False;

implementation

{$R *.dfm}

// VirtualGamer
Function TVirtualGamer.HodCheck; //��� �������������
var i:Integer;
var flag: boolean;
begin
 // flag:=False;
  if Tekstol.ColKart=0 then  flag:= Number>0   //0- ��� ����
   //t:=1
  else
   begin
    if Number=0 then flag:=True
    else
    begin
    flag:=false;
    for i:=1 to TekStol.ColKart do
       if TekStol.soder[i].chislo=soder[Number].chislo then flag:=true;

    end;
    //t:=0;
   end;
  Result := Flag;
end;

Function TVirtualGamer.HodCheckB;
var
Flag:Boolean;
i: Integer;
begin
if Number=0 then flag:=True
Else
  begin
     if soder[Number].mast=Tekstol.soder[Tekstol.colkart].mast  then
         if  soder[Number].chislo<=Tekstol.soder[stol.ColKart].Chislo then
            flag:=false
         else flag:=true
        else
         if soder[Number].mast=Kozir then
          flag:=true
         else flag:=false;
  end;
Result := Flag;
end;

Procedure TVirtualGamer.Hod(number: Integer);  //���������� ���������� ����
//Var Buf:TCards;
begin
 // Buf := soder[Number];
  if Colkart<1 then exit;
  Inc(TekStol.ColKart);
  TekStol.soder[TekStol.ColKart] := soder[Number];
  if Number<Colkart then soder[Number] := soder[Colkart];
  Dec(Colkart);
end;

Procedure TVirtualGamer.Dobor; //������ ���� ������� �����
begin
  while (ColKart<6) and (TekCol.ColKart>0) do
   begin
     inc(ColKart);
     TekCol.Pop(soder[ColKart]);
   end;
end;

Procedure TVirtualGamer.Beru;
begin
   while TekStol.ColKart>0 do
   begin
     inc(ColKart);
     TekStol.Pop(soder[ColKart]);
   end;
end;

Function TVirtualGamer.RandomHod(Stage: Boolean):Integer;   // Stage True ��� ����, ��� �����, � �� ������!
var i:Word;
flag:Boolean;
begin
  repeat
   i:=min(Random(Colkart+1),ColKart); //����������� ��������, ����� �� ����� 0 , ����� Random(1)
   //flag:=false;
   if Stage then flag:=HodCheck(i)
            else flag:=HodCheckB(i);
  until flag;

  Hod_Hod0(i,Stage);
  result := i;
end;

Function TVirtualGamer.NaimHod; //����� �� ��������, � ���������� ������.
var i,mini,min,cen:Word;
flag:Boolean;
begin
  min := 1000;
  mini :=0;
  if Beruflag  then
    begin
      result := 0;
      exit;
    end;
  for I := 1 to Colkart do
   begin
      if Stage then flag:=HodCheck(i)
               else flag:=HodCheckB(i);
      if flag then
        if RMode then  cen:= Random(100) //� ������ �������� ����� ���� ����. �������
        else
          if Soder[i].mast=Kozir then cen:=10+Soder[i].chislo
                                 else cen:=Soder[i].chislo       //�������� ���� ������������ ���������.
      else cen := 1001;   //������ �� ������������ ���!
     if min>cen then
       begin
         min := cen;
         mini := i;
       end;
   end;
 if mini>0 then
   begin
     if Stage then flag:=HodCheck(0)   //��������� �������� �������� ����.
              else flag:=HodCheckB(0);
     if Flag and (not Berserk) and (Random(100)<33{10}) then mini:=0;    //���� ���. ���� ������ ������������ - �� �����!
   end;
 Hod_Hod0(mini,Stage);
 result := mini;
end;



Procedure TVirtualGamer.Hod_Hod0;
begin
 if Hodn=0 then
    if Stage then Dobor  //�����, �.�. ���� 0, �� ������ �� ������������.
    else
 else Hod(Hodn);
end;

Function TVirtualGamer.NotRandomHod;
var
flag:Boolean;
begin
//   flag:=false;
   if Stage then flag:=HodCheck(Hodn)
            else flag:=HodCheckB(Hodn);
  if flag then
    begin
      Hod_Hod0(Hodn,Stage);
      result := True;
    end
  else result:=False;
end;
{
����� ����������� �������� ���������� ������� ����. ����, ���� ����� ����, �� �� ��� ������� �� �����
}
Function VirtualGame(kk:Integer; PerIgrok:Boolean; Beruflag:Boolean=False):Integer;    //���� � ����� ������� ��� ����, �� ������.
var
Correct : Boolean;
Nhod,i : Integer;
RandMode : Boolean;
Bitoflag : Boolean;

begin
  //�������������
  VIgrok[0].TekStol := @Vstol;
  VIgrok[0].TekStol := @VColoda2;
  VIgrok[0].TekCol := @VColoda;
  VIgrok[1].TekStol := @Vstol;
  VIgrok[1].TekCol := @VColoda;
  VIgrok[0].ColKart := Igrok.ColKart;
  VIgrok[0].soder := Igrok.soder; // ��������� ����������� ����������� ��������
  VColoda.ColKart := 0;
  VColoda2.ColKart := Coloda.ColKart;
  VIgrok[1].ColKart := Mashina.ColKart;
  VIgrok[1].soder := Mashina.soder;
  VStol.ColKart := Stol.ColKart;
  VStol.soder := Stol.soder;
  VColoda2.soder := Coloda.soder;
  // ����� � ���� � ������ ������� � ������2
  //���� ������, ����� ��������� ������ ����� �� �������
  i:=1;
  VIgrok[Integer(PerIgrok)].Beruflag := Beruflag;
  VIgrok[Integer(not PerIgrok)].Beruflag  := False;

  repeat
  if VIgrok[0].soder[i].vidimost then  inc(i)
                                 else  VIgrok[0].Hod(i);
  until i>VIgrok[0].ColKart;

  VIgrok[0].TekStol := @Vstol;
  // ����� �������� ������������ �� ����� � ������
  VColoda2.TekStol := @VColoda;
  while VColoda.ColKart<Coloda.ColKart do VColoda2.Hod(Min(Random(VColoda2.ColKart)+1,VColoda2.ColKart));
  // ������� ��� ������
   //�� ������
  VColoda2.TekStol := @VIgrok[0];
  while VColoda2.ColKart>0  do VColoda2.Hod(VColoda2.ColKart);
  if VColoda.ColKart<4  then RandMode := True
                        else RandMode := False;

  //������ ���
  if (kk>0) and (VIgrok[1].Beruflag) then Correct:=False //���� ������� "����", �� ������ ������ �� �����!
  else Correct := VIgrok[1].NotRandomHod(kk,not PerIgrok);   // ���� ���� , �� ���� ����� ����� �� �����!
  if not Correct then
    begin
      result := -1;
      exit;
    end;
  Bitoflag :=False;
  if PerIgrok then
    if kk=0 then VIgrok[1].Beruflag := True
    else
  else
    if kk=0 then
      begin
        Bitoflag := True;
        Nhod := kk;
      end;

   //���� �� ��������� ���� � ������ �� ������� � ��������� ������.
   repeat
   //����� ������ ������ ����� �������, �� �� ��� ��� �������� �� �����!

   //��� ������
    // if {VColoda.ColKart<2}RandMode then Nhod:=VIgrok[Integer(not PerIgrok)].RandomHod(True)//����� ���� ���� � ������- ����� ��������� ����
    // else
     if (not Bitoflag) then Nhod:=VIgrok[Integer(not PerIgrok)].NaimHod(True,VColoda.ColKart<2,RandMode) //RandomHod(True);
     else  Bitoflag := False;
     //������ Stage, ���������
//���-�� ������ ����� �����, ���� ���� �� ������ , � ������ ���� PerIgrok=False
//����������  PerIgrok �� not PerIgrok
     if Nhod=0 then
       begin
         if VIgrok[Integer(PerIgrok)].Beruflag then
           begin
             VIgrok[Integer(PerIgrok)].Beru;
             VIgrok[Integer(PerIgrok)].Beruflag := False;
           end
         else
           begin
             VIgrok[Integer(PerIgrok)].Dobor;
             VIgrok[Integer(PerIgrok)].TekStol.ColKart := 0;
             PerIgrok := not PerIgrok;
           end;
       end
     else
       begin
         // ���� ���� �����, ��
         //if RandMode then Nhod := VIgrok[Integer(PerIgrok)].RandomHod(False)
         //else
         Nhod := VIgrok[Integer(PerIgrok)].NaimHod(False,VColoda.ColKart<2,Randmode);//RandomHod(False);
         if Nhod=0 then  VIgrok[Integer(PerIgrok)].Beruflag := True;//VIgrok[Integer(not PerIgrok)].Dobor;   // � ��� ����� ���� �� dobor, � ������ ������������
         //if Nhod=0 -������������� ����
       end;
until  (VColoda.ColKart = 0)  and  ((VIgrok[0].ColKart=0) or (VIgrok[1].ColKart=0));
//   Correct :=True;
  //���������� ����
  if VIgrok[1].ColKart<VIgrok[0].ColKart then result:=2 //2 ���� �� ������
  else if VIgrok[1].ColKart=VIgrok[0].ColKart then result:=1 //1 ���� �� �����
                                              else result:=0;
end;



//-----------------------------------------------
{���������}
{���������� �����}
Procedure VivodKarti(vc:TCards; x,y:integer);
 begin
  Form1.Canvas.Draw(x,y,karti[(vc.mast-1)+4*(vc.chislo-1)+1]);
 end;
Procedure VivodOblojki(x,y:integer);
 begin
  Form1.Canvas.Draw(x,y,karti[37]);
 end;

//�������� ����
procedure TPodatel.Pop(var popc:TCards);
 begin
  popc:=soder[ColKart];
  ColKart:=ColKart-1;
 end;
function TPodatel.Rating; {��� ���������� ���� �� ������}
 begin
  if i=0 then rating:=9*(buf.mast)+buf.chislo
  else
   rating:=9*(soder[i].mast)+soder[i].chislo;
 end;
//������
procedure TColoda.Regen;
var fs:TRect; i:integer;
 begin
  fs.Top:=200;
  fs.Left:=590;
  fs.Right:=780;
  fs.Bottom:=310;
  form1.Canvas.FillRect(fs);
If colKart>0 then
begin
VivodKarti(soder[1],590,200);
 For i:=0 to (colkart div 4) do VivodOblojki(693+i,200+i);
end;
end;
Procedure TColoda.Init;
var a1:array[1..36] of integer;
    a2:array[1..36] of byte;
i,j,maxn:Integer;
 begin
  Randomize;
   for i:=1 to 36 do  a1[i]:=Random(2000000000)+1;
   for i:=1 to 36 do
    begin
     maxn:=1;
      for j:=2 to 36 do if a1[maxn]<a1[j] then maxn:=j;
     a2[i]:=maxn;
     a1[maxn]:=0;
    end;
   for i:=1 to 36 do
    begin
     soder[i].mast:=((a2[i]-1) mod 4)+1;
     soder[i].chislo:=((a2[i]-1) div 4)+1;
     soder[i].vidimost:=False;
    end;
   soder[1].vidimost:=True;
  regen;
 ColKart:=36;
 end;
//�����
procedure TIgrok.Dobor;
var i:integer;
 begin
  if Colkart<6 then
   begin
    for i:=1 to 6-ColKart do
     begin
      if Coloda.ColKart=0 then break
       else
        begin
         ColKart:=ColKart+1;
         Coloda.Pop(Soder[ColKart]);
        end;
     end;
  // ver.posledobor;
   end;
  sortirovka(igrok);
  redraw(330,ColKart,igrok,false);
 end;
Procedure TIgrok.Hodit(nomer:integer);
 begin
 if not igrok.beru then write(report,'�����:',#13,#10);
  buf:=soder[ColKart];
  soder[ColKart]:=soder[nomer];
  soder[nomer]:=buf;
  stol.ViKlad(Igrok);
  sortirovka(Self);
  redraw(330,ColKart,Igrok,false);
  If mash then mashina.Hodit
  else mashina.Bitsa;
 end;
//������
procedure TMashina.Dobor;
var i:integer;
 begin
  if colkart<6 then
   begin
    for i:=1 to 6-ColKart do
     begin
      if Coloda.ColKart=0 then break
       else
        begin
         ColKart:=ColKart+1;
         Coloda.Pop(Soder[ColKart]);
        end;
     end;
   end;
  redraw(30,ColKart,Mashina,not otkrkart);
 end;
Function TMashina.HodBit;
var i,j,max,MaxZn,MaxHk, {MaxOld,} TekHK : integer;
ImpulsR: Array of integer;
ImpulsR2 : Array of Double;
MaxZnReal: Double;
begin
 SetLength(ImpulsR,ColKart+1);
   SetLength(ImpulsR2,ColKart+1);
   max:=0;
   MaxZn:=0;
   MaxZnReal := 0;
   MaxHk := 0;
  for i := 0 to ColKart do
  begin
    ImpulsR[i] := 0;
    for j := 0 to 3999 do    //999 - ��� �����, 3999 ������� �����������.
      begin
        ImpulsR[i]:= ImpulsR[i]+VirtualGame(i,Bits,Beruflag);
        if ImpulsR[i]<0 then break;
      end;
  if i=0 then  if bits then TekHk := 5
                       else TekHk := 4
    else
      if Mashina.soder[i].mast=Kozir then TekHk := 14+Mashina.soder[i].chislo
                                     else TekHk := 5+Mashina.soder[i].chislo;
   if (TekHk>23) or (TekHk<1) then
    TekHk := 3;


   if Coloda.ColKart<4{99}{4} then   ImpulsR2[i]:=ImpulsR[i]
   else
   if ImpulsR[i]>0 then ImpulsR2[i] := ImpulsR[i]-0.7*NewInt[TekHk] //������ ����. ���������, ����� ������� ����������� ����. ��������
                   else ImpulsR2[i] := -20000;
    if MaxZn<ImpulsR[i] then
     begin
       MaxZn := ImpulsR[i];
       //max:=i;
     end;
   if MaxZnReal<ImpulsR2[i] then
     begin
       MaxZnReal := ImpulsR2[i];
       max:=i;
       MaxHk := TekHk;
     end;
  end;
  if (bits) and (Coloda.ColKart>=4{4}) then     //������-�� ��������� ��� ����� ����� � ��� �� �������.
   if MaxOldB>0 then     //������� ����������� �������� �� ��������� ������������
    begin
      if MaxOldB>MaxZn then  NewInt[MaxOldBk] := NewInt[MaxOldBk] + 1  // (MaxOldB-MaxZn)/10
                       else  NewInt[MaxOldBk] := NewInt[MaxOldBk] - 1;
    end
    else
  else
  if MaxOldH>0 then
    begin
      if MaxOldH>MaxZn then  NewInt[MaxOldHk] := NewInt[MaxOldHk] + 1
                       else  NewInt[MaxOldHk] := NewInt[MaxOldHk] - 1;
    end;


  if Bits then
  begin
     MaxOldBk := MaxHk;
     MaxOldB := MaxZn;
  end
  else
  begin
    MaxOldHk := MaxHk;
    MaxOldH := MaxZn;
  end;
  result := max;
end;

Function TMashina.Hodit; //������ �����
var {i,j,t,MaxZn,MaxHk, TekHK,}max:integer; //rkk:extended; flag:boolean;
 begin
  write(report,'������:( ���� � ������-:',colkart,#13,#10);
//���� ������ �������� ����+������� ������ ���. �����+������� ��������
  if (Stol.ColKart=12)  or (Igrok.ColKart=0) then
  begin
  mash:=false;
  Bitber(Pobito);
  exit;
  end;

  Max := Hodbit(false,Igrok.beru);
  result := max;
  if max=0 then
   If Igrok.beru then exit
   else
    begin
     mash:=false;
     BitBer(Pobito);
    end
  else
   begin
    buf:=soder[ColKart];
    soder[ColKart]:=soder[max];
    soder[max]:=buf;
    stol.ViKlad(Mashina);
    redraw(30,ColKart,Mashina,not otkrkart);
   end;
 end;
Procedure TMashina.Bitsa;
var  i,max:integer;  flag:boolean;
 begin
   write(report,'������:',#13,#10);
  // bopod:=false;


  Max := Hodbit(True,beru);
  If max=0 then
   begin
    beru:=true;
    Form1.label3.Visible:=True;
    form1.Button3.Caption:='����!';
    end
  // end
  else   // ������ ���� ����� � �� ����
   begin
    flag:=true;
    for i:=1 to stol.colkart do
     if stol.soder[i].chislo=soder[max].chislo then flag:=false;
    buf:=soder[ColKart];
    soder[ColKart]:=soder[max];
    soder[max]:=buf;
    stol.ViKlad(Mashina);
    redraw(30,ColKart,Mashina,not otkrkart);
    //vesob;
   end;
 end;

//��������� ����
procedure TStol.Regen;
Var I:Integer;
 begin
  bito:=false;
  NCX:=-63;
  If ColKart>0 then
   for i:=1 to ColKart do
    begin
      If bito=false then
    begin
     bito:=true;
     NCX:=NCX+68;
    end
   else
    begin
     bito:=false;
     NCX:=NCX+23;
    end;
      VivodKarti(soder[i],NCX,200);
    end;
 end;
Procedure TStol.Viklad(const Istochnik:TPodatel);
 begin
    ColKart:=ColKart+1;
   Istochnik.Pop(soder[ColKart]);
   soder[colKart].vidimost:=true;
   Regen;
   write(report,soder[colkart].chislo+5,'-',
   soder[colkart].mast,#13,#10);
 end;

//������ ���������
{
Function GetElem:boolean;
 var i,j,k,pogoni:byte; chk,chk1:byte; // ����� �������  � ������
 pris,koz,vsa:boolean; //�������: � ������ ���� ����� ���� �����, ��� ������, ����� ����
 begin
   pogoni:=0;
   chk:=0;
   for i:=1 to igrok.ColKart do
     if igrok.soder[i].mast=kozir then chk:=chk+1;
   for i:=1 to 9 do
    begin
      chk1:=chk;
      vsa:=false;
      koz:=false;
      pris:=false;
      for j:=1 to Mashina.ColKart do
       begin
        if mashina.soder[j].chislo=i then
         begin
          if  mashina.soder[j].mast=kozir then
           begin
            vsa:=false;
              for k:=1 to igrok.ColKart do
               if (igrok.soder[k].mast=mashina.soder[j].mast) and
             (igrok.soder[k].chislo>mashina.soder[j].chislo) then
               koz:=true;
             if koz=false then vsa:=true;
           end
          else
           begin
            vsa:=true;
            for k:=1 to igrok.ColKart do
             if (igrok.soder[k].mast=mashina.soder[j].mast) and
              (igrok.soder[k].chislo>mashina.soder[j].chislo) then
                vsa:=false;
            if vsa then
             begin
              if chk1>0 then
               begin
                chk1:=chk1-1;
                vsa:=false;
               end;
             end;
           end;
          Pris:=true;
         end;
        if vsa or koz then break;
       end;
      if (not vsa) and (pris)  then
       begin
        if pogoni=0 then pogoni:=i
        else
         begin
          Getelem:=false;
          exit;
         end;
       end;
    end;
  mashina.pogoni:=pogoni;
  Getelem:=true;
 end;
 }
Procedure Redraw(y,c:integer;pod:TPodatel;mh:boolean);
var fs:TRect; i:integer;
 begin
  fs.Top:=y;
  fs.Left:=1;
  fs.Right:=600;
  fs.Bottom:=y+100;
  form1.Canvas.FillRect(fs);
 If mh
  then
    begin
    for i:=1 to c do
    vivodOblojki(20+(500 div c)*(i-1),y);
    end
  else
  for i:=1 to c do
    vivodkarti(pod.soder[i],20+(500 div c)*(i-1),y);
 end;
procedure NachHod;{�������� ���}
var i:integer; pob:byte;{����� ��� �������}
begin
  write(report,'������ ����( ���� � ������-:',mashina.colkart,#13,#10);
 pob:=0;
 beru:=false;
 igrok.beru:=false;
 Form1.label3.Visible:=false;
 form1.Button3.Caption:='����!';
 if mash then
  begin
   Mashina.Dobor;
   Igrok.Dobor;
   form1.Button3.Visible:=False;
   form1.Button4.Visible:=True;
  end
 else
  begin
   Igrok.Dobor;
   Mashina.Dobor;
   form1.Button3.Visible:=True;
   form1.Button4.Visible:=False;
  end;
  stol.bito:=false;
  stol.NCX:=-83;
  redraw(200,0,Stol,true);
  coloda.Regen;
 // If (coloda.colkart=0) and (mash) then elem:=Getelem;
  If igrok.colkart=0 then pob:=pob or 1;
  If mashina.colkart=0 then   pob:=pob or 2;
  If pob>0 then begin pobeda(pob); exit; end;
 //if elem then write(report,'������ ��������� � ������������ �����',#13,#10);
 if mash then
  //if elem then  mashina.Element
  {else} mashina.hodit;
end;
Procedure Sortirovka;{C��������� ����}
var i,j:integer;  bf2:Tcards;
 begin
   for i:=1 to pod.ColKart do
    begin
     pod.Buf:=pod.soder[i];
     for j:=i+1 to pod.colKart  do
      begin
       if pod.rating(j)<pod.rating(0)
        then
         begin
          bf2:=pod.buf;
          pod.Buf:=pod.soder[j];
          pod.soder[j]:=Bf2;
         end;
      end;
     pod.soder[i]:=pod.Buf;
    end;
 end;
Procedure BitBer(var pod:TPodatel);
var i,j:integer;
 begin
  if stol.ColKart>0 then
   begin
    j:=Stol.ColKart;
    for i:=1 to j do stol.Pop(pod.soder[i+pod.colKart]);
    pod.ColKart:=pod.ColKart+j;
    NachHod;
   end;
 end;
Procedure Pobeda(p:byte);
var
i:integer;
begin
 case p of
  1:
  begin
   form1.Label1.Caption:='����������� �� ����������!';
   form1.Label1.Font.Color:=clred;
   mash:=false;
    for i:=1 to Mashina.ColKart do
     begin
       Stol.ColKart:=1;
       Mashina.Pop(stol.soder[1]);
      // vesob;
       Stol.ColKart:=0;
     end;
  end;
  2:
  begin
   form1.Label1.Caption:='���,�� ���������...';
   form1.Label1.Font.Color:=clblue;
   mash:=true;
    for i:=1 to Igrok.ColKart do
     begin
       Stol.ColKart:=1;
       Igrok.Pop(stol.soder[1]);
      // vesob;
       Stol.ColKart:=0;
     end;
  end;
   else
    begin
     form1.Label1.Caption:='�����!';
     form1.Label1.Font.Color:=clwhite;
     stol.ColKart:=0;
    end;
  end;


 form1.Label1.Visible:=true;
 panel:=false;
 form1.Button3.Visible:=false;
 form1.Button4.Visible:=false;
end;

{�������� ��������}
procedure TForm1.FormCreate(Sender: TObject);
var fil:file; i,x,y:integer; t:byte;
begin
 otkrKart:=false;
 panel:=false;
 mash:=false;
 assignfile(fil,'Cards.crd');
 reset(fil,1);
 blockread(fil,pallete,1024);
 {form2.Show;
 form2.Label1.Visible:=true;}
  for i:=1 to 37 do
   begin
    karti[i]:=TBitmap.Create;
    karti[i].Height:=96;
    karti[i].Width:=71;
    If EOF(fil) then break;
    blockread(fil,prom,72*96);
     for y:=0 to 95 do
      for x:=-1 to 70 do
       begin
         t:=prom[y,x];
        if x<>71 then karti[i].Canvas.Pixels[x,95-y]:=pallete[t*4+1]+$100*pallete[t*4+2]+$10000*pallete[t*4+3];
       end;
    {form2.ProgressBar1.Position:=i-1;}
   end;
  {form2.Close;}
 closefile(fil);
 assignfile(fil,'Durak2.ini');
 reset(fil,8);
 blockread(fil,int,23);
 //NewInt:=Int;
 for I := 1 to 23 do  NewInt[i]:=Int[i];

 closefile(fil);
 assignfile(report,'report.txt');
 rewrite(report);
 GoodOpen := True;
end;

procedure TForm1.Button1Click(Sender: TObject);  {����� �����}
begin
  label1.visible:=false;
  //ELEM:=FALSE;
  //VsInt[5]:=7;
  panel:=true;
  Coloda.Init;
  kozir:=coloda.soder[1].mast;
  Igrok.ColKart:=0;
  Mashina.ColKart:=0;
  //Ver.Init;
  write(report,'������ ����:',#13,#10);
  MaxOldB := -1;
  MaxOldH := -1;
  NachHod;

end;
function TForm1.vozm;
var
flag:boolean; t:integer;
 begin
    if mash then
    begin
     if Igrok.soder[nom].mast=stol.soder[stol.colkart].mast  then
         if  Igrok.soder[nom].chislo<=stol.soder[stol.ColKart].Chislo then
            flag:=false
         else flag:=true
        else
         if igrok.soder[nom].mast=Kozir then
          flag:=true
         else flag:=false;
    end
   else
    begin
     if stol.ColKart=0 then
      flag:=true
     else
      begin
       flag:=false;
        for t:=1 to Stol.ColKart do
         if Stol.soder[t].chislo=Igrok.soder[nom].chislo then flag:=true;
      end;
   end;
  vozm:=flag;
 end;
procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var flag:boolean; nom:integer;
begin
 If (x>20) and (y>330) and (x<600) and (panel=true) and(igrok.ColKart>0) then
  begin
    nom:=(x-20) div (500 div Igrok.ColKart)+1;
    if nom>igrok.ColKart then nom:=igrok.ColKart;
     flag:=vozm(nom);
   if flag then Igrok.Hodit(nom);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 form1.Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 if stol.ColKart=0 then exit;
 if beru then BitBer(Mashina) else
 begin
 mash:=true;
 BitBer(Pobito);
 end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var i:Integer; flag:boolean;
begin
 write(report,'����� ��������',#13,#10);
  //vesob;
 flag:=false;
 for i:=1 to Igrok.ColKart do
  begin
     if Igrok.soder[i].mast=stol.soder[stol.colkart].mast  then
         if  Igrok.soder[i].chislo<=stol.soder[stol.ColKart].Chislo then
            flag:=flag
         else flag:=true
        else
         if igrok.soder[i].mast=Kozir then
          flag:=true
         else flag:=flag;
  end;

 igrok.beru:=true;
 while Mashina.Hodit>0 do; //������ ���� , ��� � �����.
 Bitber(igrok);
end;

procedure TForm1.FormActivate(Sender: TObject);    //��� ������������
begin
 if otkrkart then redraw(30,Mashina.ColKart,Mashina,false) else redraw(30,Mashina.ColKart,Mashina,true);
redraw(330,Igrok.ColKart,Igrok,false);
coloda.Regen;
stol.Regen;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
// var flag:boolean;
begin

 case key of
  '1': If igrok.ColKart>=1 then if vozm(1) then Igrok.Hodit(1);
  '2': If igrok.ColKart>=2 then if vozm(2) then Igrok.Hodit(2);
  '3': If igrok.ColKart>=3 then if vozm(3) then Igrok.Hodit(3);
  '4': If igrok.ColKart>=4 then if vozm(4) then Igrok.Hodit(4);
  '5': If igrok.ColKart>=5 then if vozm(5) then Igrok.Hodit(5);
  '6': If igrok.ColKart>=6 then if vozm(6) then Igrok.Hodit(6);
  '7': If igrok.ColKart>=7 then if vozm(7) then Igrok.Hodit(7);
  '8': If igrok.ColKart>=8 then if vozm(8) then Igrok.Hodit(8);
  '9': If igrok.ColKart>=9 then if vozm(9) then Igrok.Hodit(9);
  #5: form1.Edit1.Visible:= not form1.Edit1.Visible; //Ctrl+e -���������� ������
  #23:
  begin
   verotl:=not verotl; //Ctrl+w ���������� ����������� ��� ������ �����
   form1.Label1.Visible:=False;
  end;
  #15:
   begin
    otkrKart:=not otkrKart;   {Ctrl+o ��������� ����� �����}
   end;
  #18:
    form1.FormActivate(Form1); {Ctrl+r ��������� �����}
  else form1.Edit1.Text:=inttostr(ord(key));  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var pa,mst,chl:word;
begin
  if verotl then
 begin
 pa:=(x-20) div (500 div Igrok.ColKart)+1;
 If (x>20) and (y>330) and (x<600) and (panel=true) and(igrok.ColKart>0) then
   begin
     form1.Label2.Top:=y-20;
     form1.label2.Left:=x+5;
     mst:=igrok.soder[pa].mast;
     chl:=igrok.soder[pa].chislo;
 end
 else
  if (x>600) and (y<330) and (y<200) then
   begin
     form1.Label2.Top:=y-20;
     form1.label2.Left:=x-50;
    form1.Label2.Caption:=Inttostr(Coloda.ColKart)+' ���� ��������';
     form1.Label2.Visible:=true;
   end
  else


  form1.Label2.Visible:=false;
 end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var fil:file of double;
i:Integer;
begin
 if GoodOpen then
   begin
     closefile(report);
     assignfile(fil,'Durak2.ini');
     rewrite(fil);
     blockwrite(fil,Newint,23);  //��� extended �� �������!
     closefile(fil);
   end;
end;

end.
