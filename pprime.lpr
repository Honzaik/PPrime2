program pprime;

uses
  DateUtils,
  SysUtils;

const
  MAX_DELKA = 400;
  MAX_DELKA_PRVOCISLA = 200;
  MAX_DELKA_PRVOCISLA_BIN = 665;
  MAX_DELKA_BIN = 1330;

type
  dlouheCislo = array [1..MAX_DELKA] of byte;
type
  dlouheCisloBin = array [1..MAX_DELKA_BIN] of boolean;
type
  cisloT = record
    cislo: dlouheCislo;
    delka: integer;
  end;

type
  cisloBin = record
    delka: integer;
    cislo: dlouheCisloBin;
  end;

type
  vysledekDeleni = record
    vysl: cisloT;
    zbytek: byte;
  end;


  procedure vypisCislo(c: cisloT);
  var
    i: integer;
  begin
    writeln;
    writeln('delka : ', c.delka);
    for i := 1 to c.delka do
      Write(c.cislo[i]);
    writeln;
    writeln;
  end;

  procedure vypisBin(c: cisloBin);
  var
    i: integer;
  begin
    writeln('delka : ', c.delka);
    for i := 1 to c.delka do
    begin
      if (c.cislo[i]) then
        Write(1)
      else
        Write(0);
    end;
    writeln;
  end;

  function generujPrvocislo(delka: byte): cisloT;
  var
    p: cisloT;
  var
    i: byte;
  var
    lichaCisla: array[1..5] of byte = (1, 3, 5, 7, 9);
  begin
    p.cislo[1] := Random(9) + 1;
    for i := 2 to delka do
    begin
      if (i <> delka) then
        p.cislo[i] := Random(10)
      else
        p.cislo[delka] := lichaCisla[Random(5) + 1];
    end;
    p.delka := delka;
    generujPrvocislo := p;
  end;

{
1 : c1>c2
0 : c1=c2
2 : c1<c2
}
  function porovnani(c1, c2: cisloT): byte;
  var
    i: integer;
  begin
    if (c1.delka > c2.delka) then
      porovnani := 1
    else
    begin
      if (c1.delka < c2.delka) then
        porovnani := 2
      else //stejna delka
      begin
        i := 1;
        while ((c1.cislo[i] = c2.cislo[i]) and (i <= MAX_DELKA)) do
          Inc(i);
        if (i = MAX_DELKA + 1) then
          porovnani := 0
        else
        begin
          if (c1.cislo[i] > c2.cislo[i]) then
            porovnani := 1
          else
            porovnani := 2;
        end;
      end;
    end;
  end;

  function otocBin(c: cisloBin): cisloBin;
  var
    zac, kon: integer;
  var
    temp: boolean;
  begin
    zac := 1;
    kon := c.delka;
    while (zac < kon) do
    begin
      temp := c.cislo[zac];
      c.cislo[zac] := c.cislo[kon];
      c.cislo[kon] := temp;
      Inc(zac);
      kon := kon - 1;
    end;
    otocBin := c;
  end;

{
1 : c1>c2
0 : c1=c2
2 : c1<c2
}
  function porovnaniBin(c1, c2: cisloBin): byte;
  var
    i: integer;
  begin
    if (c1.delka > c2.delka) then
      porovnaniBin := 1
    else
    begin
      if (c1.delka < c2.delka) then
        porovnaniBin := 2
      else //stejna delka
      begin
        c1 := otocBin(c1);
        c2 := otocBin(c2);
        i := 1;
        while ((c1.cislo[i] = c2.cislo[i]) and (i <= MAX_DELKA_BIN)) do
          Inc(i);
        if (i = MAX_DELKA_BIN + 1) then
          porovnaniBin := 0
        else
        begin
          if (c1.cislo[i] > c2.cislo[i]) then
            porovnaniBin := 1
          else
            porovnaniBin := 2;
        end;
      end;
    end;
  end;


  procedure vynuluj(var c: cisloT);
  var
    i: integer;
  begin
    for i := 1 to MAX_DELKA do
    begin
      if (i > c.delka) then
        c.cislo[i] := 0;
    end;
  end;

  procedure vynulujBin(var c: cisloBin);
  var
    i: integer;
  begin
    for i := 1 to MAX_DELKA_BIN do
    begin
      if (i > c.delka) then
        c.cislo[i] := False;
    end;
  end;

  function generujNahodneCislo(horniHranice: cisloT): cisloT;
  var
    i: byte;
  var
    nahodneCislo: cisloT;
  begin
    repeat
      nahodneCislo.delka := Random(horniHranice.delka) + 1;
      nahodneCislo.cislo[1] := Random(9) + 1;
      for i := 2 to nahodneCislo.delka do
      begin
        nahodneCislo.cislo[i] := Random(10);
      end;
    until ((porovnani(horniHranice, nahodneCislo) = 1) and
        ((nahodneCislo.delka > 1) or (nahodneCislo.cislo[1] > 1))); //2<=n<hodniHranice
    generujNahodneCislo := nahodneCislo;
  end;

  function otocCislo(c: cisloT): cisloT;
  var
    zac, kon, temp: integer;
  begin
    zac := 1;
    kon := c.delka;
    while (zac < kon) do
    begin
      temp := c.cislo[zac];
      c.cislo[zac] := c.cislo[kon];
      c.cislo[kon] := temp;
      Inc(zac);
      kon := kon - 1;
    end;
    otocCislo := c;
  end;

  function vydelDvema(p: cisloT): vysledekDeleni;
  var
    i, j: integer;
  var
    akt: byte;
  var
    vysledek: vysledekDeleni;
  begin
    for i := 1 to MAX_DELKA_PRVOCISLA do
      vysledek.vysl.cislo[i] := 0;
    vysledek.zbytek := 0;
    j := 1;
    for i := 1 to p.delka do
    begin
      akt := vysledek.zbytek * 10 + p.cislo[i];
      if ((akt div 2) = 0) then
      begin
        vysledek.zbytek := akt;
        if (i > 1) then
        begin
          vysledek.vysl.cislo[j] := 0;
          Inc(j);
        end;
      end
      else
      begin
        vysledek.zbytek := akt mod 2;
        vysledek.vysl.cislo[j] := akt div 2;
        Inc(j);
      end;
    end;
    vysledek.vysl.delka := j - 1;
    vydelDvema := vysledek;
  end;

  function prevedDoBin(c: cisloT): cisloBin;
  var
    binaryNum: cisloBin;
  var
    tempBit: byte;
  begin
    c := otocCislo(c);
    binaryNum.delka := 0;
    vynulujBin(binaryNum);
    while ((c.cislo[1] <> 0) or (c.delka <> 0)) do
    begin
      tempBit := c.cislo[1] mod 2;
      Inc(binaryNum.delka);
      if (tempBit = 0) then
        binaryNum.cislo[binaryNum.delka] := False
      else
        binaryNum.cislo[binaryNum.delka] := True;

      c := otocCislo(vydelDvema(otocCislo(c)).vysl);
    end;
    prevedDoBin := binaryNum;
  end;

  function leftShift(c: cisloBin; positions: integer): cisloBin;
  var
    i: integer;
  begin
    if ((c.delka + positions) > MAX_DELKA_BIN) then
    begin
      writeln('CHYBA DELKA');
      exit;
    end;
    for i := c.delka downto 1 do
    begin
      c.cislo[i + positions] := c.cislo[i];
      c.cislo[i] := False;
    end;
    c.delka := c.delka + positions;
    leftShift := c;
  end;

  procedure leftShiftByOne(var c: cisloBin);
  var
    i: integer;
  begin
    if ((c.delka + 1) > MAX_DELKA_BIN) then
    begin
      writeln('CHYBA DELKA');
      exit;
    end;
    for i := c.delka downto 1 do
    begin
      c.cislo[i + 1] := c.cislo[i];
      c.cislo[i] := False;
    end;
    c.delka := c.delka + 1;
  end;

  function rightShift(c: cisloBin; positions: integer): cisloBin;
  var
    i: integer;
  begin
    for i := 1 to c.delka do
    begin
      if ((i - positions) < 1) then
        c.cislo[i] := False
      else
        c.cislo[i - positions] := c.cislo[i];
    end;
    if ((c.delka - positions) < 0) then
      c.delka := 0
    else
      c.delka := c.delka - positions;
    rightShift := c;
  end;

  procedure rightShiftByOne(var c: cisloBin);
  var
    i: integer;
  begin
    for i := 1 to c.delka do
    begin
      if ((i - 1) < 1) then
        c.cislo[i] := False
      else
        c.cislo[i - 1] := c.cislo[i];
    end;
    if ((c.delka - 1) < 0) then
      c.delka := 0
    else
      c.delka := c.delka - 1;
  end;

  function orBin(c1, c2: cisloBin): cisloBin;
  var
    vetsiDelka, i: integer;
  var
    vysl: cisloBin;
  begin
    if (c1.delka > c2.delka) then
      vetsiDelka := c1.delka
    else
      vetsiDelka := c2.delka;
    vysl.delka := vetsiDelka;
    for i := 1 to vetsiDelka do
    begin
      vysl.cislo[i] := c1.cislo[i] or c2.cislo[i];
    end;
    orBin := vysl;
  end;

  function xorBin(c1, c2: cisloBin): cisloBin;
  var
    vetsiDelka, i, posledniNenul: integer;
  var
    temp: boolean;
  var
    vysl: cisloBin;
  begin
    posledniNenul := 0;
    if (c1.delka > c2.delka) then
      vetsiDelka := c1.delka
    else
      vetsiDelka := c2.delka;
    for i := 1 to vetsiDelka do
    begin
      temp := c1.cislo[i] xor c2.cislo[i];
      vysl.cislo[i] := temp;
      if (temp = True) then
        posledniNenul := i;
    end;
    vysl.delka := posledniNenul;
    xorBin := vysl;
  end;

  function andBin(c1, c2: cisloBin): cisloBin;
  var
    vetsiDelka, i, posledniNenul: integer;
  var
    temp: boolean;
  var
    vysl: cisloBin;
  begin
    posledniNenul := 0;
    if (c1.delka > c2.delka) then
      vetsiDelka := c1.delka
    else
      vetsiDelka := c2.delka;
    for i := 1 to vetsiDelka do
    begin
      temp := c1.cislo[i] and c2.cislo[i];
      vysl.cislo[i] := temp;
      if (temp = True) then
        posledniNenul := i;
    end;
    vysl.delka := posledniNenul;
    andBin := vysl;
  end;

  function addBin(c1, c2: cisloBin): cisloBin;
  var
    partial, carry: cisloBin;
  begin
    vynulujBin(c1);
    vynulujBin(c2);
    repeat
      partial := xorBin(c1, c2);
      carry := leftShift(andBin(c1, c2), 1);
      c1 := partial;
      c2 := carry;
    until ((carry.delka < 2) and (carry.cislo[1] = False));
     {
    while ((carry.delka > 1) or (carry.cislo[1] <> false)) do
    begin
      carry := andBin(c1,c2);
      carry := leftShift(carry, 1);
      c1 := xorBin(c1, c2);
      c2 := carry;
    end;
    addBin := c1;}
    addBin := partial;
  end;

  function flip(c1: cisloBin; delka: integer): cisloBin;
  var
    i: integer;
  begin
    for i := 1 to delka do
      c1.cislo[i] := not c1.cislo[i];
    for i := (delka + 1) to MAX_DELKA_BIN do
      c1.cislo[i] := False;
    c1.delka := delka;
    flip := c1;
  end;

  function subBin(c1, c2: cisloBin): cisloBin;
  var
    jedna, mezi: cisloBin;
  var
    i: integer;
  begin
    jedna.delka := 0;
    vynulujBin(jedna);
    jedna.delka := 1;
    jedna.cislo[1] := True;
    vynulujBin(c2);
    mezi := addBin(c1, addBin(flip(c2, c1.delka), jedna));
    i := mezi.delka;
    while (mezi.cislo[i] <> True) and (i > 0) do
      i := i - 1;
    if (i > 0) then
      mezi.cislo[i] := False;
    while (mezi.cislo[i] <> True) and (i > 0) do
      i := i - 1;
    mezi.delka := i;
    subBin := mezi;
  end;

  function divBin(c1, c2: cisloBin): cisloBin;  // c1/c2
  var
    vysl, mult, scaledDivisor, remain: cisloBin;
  begin
    mult.delka := 1;
    vynulujBin(mult);
    mult.cislo[1] := True;
    vysl.delka := 0;
    vynulujBin(vysl);
    scaledDivisor := c2;
    remain := c1;
    while (porovnaniBin(c1, scaledDivisor) = 1) do
    begin
      leftShiftByOne(scaledDivisor);
      leftShiftByOne(mult);
    end;
    repeat
      if (porovnaniBin(remain, scaledDivisor) <> 2) then
      begin
        remain := subBin(remain, scaledDivisor);
        vysl := addBin(vysl, mult);
      end;
      rightShiftByOne(scaledDivisor);
      rightShiftByOne(mult);
    until ((mult.delka < 2) and (mult.cislo[1] = False));
    divBin := vysl;
  end;

  function modBin(c1, c2: cisloBin): cisloBin; // c1 mod c2
  var
    vysl, mult, scaledDivisor, remain: cisloBin;
  begin
    mult.delka := 1;
    vynulujBin(mult);
    mult.cislo[1] := True;
    vysl.delka := 0;
    vynulujBin(vysl);
    scaledDivisor := c2;
    remain := c1;
    while (porovnaniBin(c1, scaledDivisor) = 1) do
    begin
      leftShiftByOne(scaledDivisor);
      leftShiftByOne(mult);
    end;
    repeat
      if (porovnaniBin(remain, scaledDivisor) <> 2) then
      begin
        remain := subBin(remain, scaledDivisor);
        vysl := addBin(vysl, mult);
      end;
      rightShiftByOne(scaledDivisor);
      rightShiftByOne(mult);
    until ((mult.delka < 2) and (mult.cislo[1] = False));
    modBin := remain;
  end;

  function mult2Bin(c1, c2 : cisloBin) : cisloBin;
  var vysl, u : cisloBin;
  var i : integer;
  begin
    vysl.delka := 0;
    vynulujBin(vysl);
    u.delka := 0;
    vynuluj(u);
    for i := 1 to (c2.delka+1) do
    begin

    end;
  end;

  function multBin(c1, c2: cisloBin): cisloBin;
  var
    vysl: cisloBin;
  begin
    vysl.delka := 0;
    vynulujBin(vysl);
    while ((c1.delka > 1) or (c1.cislo[1] <> False)) do
    begin
      if (c1.cislo[1] = True) then
      begin
        vysl := addBin(vysl, c2);
      end;
      rightShiftByOne(c1);
      c2 := addBin(c2, c2);
    end;
    multBin := vysl;
  end;

  function modPowBin(base, exponent, modulus: cisloBin): cisloBin;
  var
    vysl, temp: cisloBin;
  begin
    vysl.delka := 0;
    vynulujBin(vysl);
    if ((modulus.delka = 1) and (modulus.cislo[1] = True)) then
    begin
      modPowBin := vysl;
      exit;
    end;
    vysl.delka := 1;
    vysl.cislo[1] := True;
    base := modBin(base, modulus);
    while ((exponent.delka > 1) or (exponent.cislo[1] = True)) do
    begin
      if (exponent.cislo[1] = True) then // exponent mod 2 = 1
      begin
        vysl := modBin(multBin(vysl, base), modulus);
      end;
      rightShiftByOne(exponent);
      base := modBin(multBin(base, base), modulus);
    end;
    modPowBin := vysl;
  end;

var
  pocetCifer, pocetPrvocisel, i: integer;
var
  p, nahodne, pMensi, d: cisloT;
var
  bin, binP, binNahodne, binD: cisloBin;
var
  dd: vysledekDeleni;
var
  FromTime, ToTime: TDateTime;
  DiffMinutes: integer;
begin
  Randomize;
  Write('Kolik cifer: ');
  readln(pocetCifer);
  Write('Kolik ruznych prvocisel: ');
  readln(pocetPrvocisel);
  p := generujPrvocislo(pocetCifer);
  vynuluj(p);
  vypisCislo(p);

  pMensi := p;
  pMensi.cislo[pMensi.delka] := pMensi.cislo[pMensi.delka] - 1;
  vynuluj(pMensi);
  nahodne := generujNahodneCislo(pMensi);
  vynuluj(nahodne);
  vypisCislo(nahodne);

  binP := prevedDoBin(p);
  vypisBin(otocBin(binP));
  binNahodne := prevedDoBin(nahodne);
  vypisBin(otocBin(binNahodne));

  d := vydelDvema(nahodne).vysl;
  binD := prevedDoBin(d);

  bin := modPowBin(binNahodne, binD, binP);
  vypisBin(otocBin(bin));
end.
