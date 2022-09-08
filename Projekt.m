clc;
clear all;
close all;

%Ustawienia%

%Glowne
center=0.3;                                                                     %Odleglosc od boku brzegu do centrum silnika
ms=3;                                                                           %Ilosc faz
p=3;                                                                            %Ilosc par biegunow
Pn=90000;                                                                       %Moc znamionowa
Un=985;                                                                         %Napiecie znamionowe
Usph=Un/sqrt(3);                                                                %Napiecie fazowe
I=33;                                                                           %Prad podany na silnik
pp=8;                                                                           %Przekroj przewodow uzwojenia w mm^2
fs=50;                                                                          %Czestotliwosc pradu
s=linspace(0.002,0.02,10);                                                      %Wartosci poslizgu dla ktorych wykonywane beda obliczenia
nsN=1000;                                                                       %Predkosc obrotowa synchroniczna
wsN=nsN*pi/30;                                                                  %Predkosc katowa synchroniczna
mu0=4*pi*1e-7;                                                                  %Przenikalnosc magnetyczna prozni
mur=1616;                                                                       %Przenikalnosc wzgledna materialu na stojan / wirnik
sig=58e6;                                                                       %Konduktywnosc miedzi w S/m
J=4;                                                                            %Gestosc pradu
Bdsmax=1.8;                                                                     %Najwyzsza indukcja magnetyczna stojana
Bys=1.4;                                                                        %Indukcja magnetyczna zlobka stojana
Bdrmax=1.9;                                                                     %Najwyzsza indukcja magnetyczna wirnika
Byr=1.5;                                                                        %Indukcja magnetyczna zlobka wirnika
msize=100;                                                                      %Wspolczynnik siatki

%Wspolczynniki
kH=1.65;                                                                        %Wspolczynnik wniosu walu
kd=1.372;                                                                       %Wspolczynnik srednic
ksin=pi/(2*sqrt(2));                                                            %Wspolczynnik ksztaltu sinusoidy
kE=0.985-0.005*p;                                                               %Wspolczynnik napiec wejscie / faza
kWS=0.96;                                                                       %Wspolczynnik zwojowy
kQ=0.2;                                                                         %Wspolczynnik zapelnienia zlobka
kdP=0.9;                                                                        %Wspolczynnik tlumienia pola wirnika
K=1.4;                                                                          %Wspolczynnik wydluzenia polaczenia czolowego
ae=0.715;                                                                       %Wspolczynnik rozkladu pola w szczelinie
sigmadelta0=0.0115;                                                             %Wspolczynnik rozproszenia szczelinowego

%Wymiary
H=0.315;                                                                        %Wnios walu
le=0.56;                                                                        %Dlugosc efektywna
rse=H*kH/2;                                                                     %Promien zewnetrzny stojana
r=rse/kd;                                                                       %Promien wewnetrzny stojana
rw=r/3;                                                                         %Promien walu
delta=(r/600)*(1+9/(2*p));                                                      %Szerokosc szczeliny

%Parametry - Zlobek
qs=3;                                                                           %Ilosc zlobkow na biegun / faze
Qs=2*p*ms*qs;                                                                   %Ilosc zlobkow stojana
Qr=68;                                                                          %Ilosc zlobkow wirnika
taups=pi/p;                                                                     %Podzialka biegunowa
ts=2*pi*r/Qs;                                                                   %Podzialka zlobkowa stojana
bqs=0.5*ts;                                                                     %Szerokosc zlobka stojana
tr=2*pi*r/Qr;                                                                   %Podzialka zlobkowa wirnika
bqr=0.5*tr;                                                                     %Szerokosc zlobka wirnika

%Stojan - Zlobek
bs1=bqs/2;                                                                      %Szerokosc bazy zlobka
hs1=0.003;                                                                      %Wysokosc bazy zlobka
hs2=0.007;                                                                      %Wysokosc wyciecia bazowego zlobka
hs3=0.05;                                                                       %Odleglosc wciecie-szczyt zlobka
ds2=bqs;                                                                        %Srednica gornego luku

%Wirnik - Zlobek
br1=bqr/5;                                                                      %Szerokosc bazy zlobka
hr0=0.04;                                                                       %Odleglosc od centrow zaokraglenia a luku
hr1=0.003;                                                                      %Wysokosc bazy zlobka
dr1=bqr/2;                                                                      %Promien gornego zaokraglenia
dr2=bqr;                                                                        %Promien dolnego luku

%Wielkosci zalezne - Zlobek
rr=r-delta;                                                                     %Promien wirinika
hqs=hs1+hs2+hs3;                                                                %Wysokosc zlobka stojana
hqr=2.98*hr1+dr1/2+hr0+dr2/2;                                                   %Wysokosc zlobka wirnika
ksk=Qr*(sin(pi*p/Qr))/(pi*p);                                                   %Wspolczynnik skosu zlobkow
ksz=1-0.15*bs1/ts;                                                              %Wspolczynnik wplywu szczerbiny
kphi=2*sin(pi*p/Qr);                                                            %Wspolczynnik fazowy wirnika
kcs=(ts+10*delta)/(ts+10*delta-bs1);                                            %Wspolczynnik Cartera stojana
kcr=(tr+10*delta)/(tr+10*delta-br1);                                            %Wspolczynnik Cartera wirnika
kc=kcs*kcr;                                                                     %Wspolczynnik Cartera
lambdadelta=0.906*ts*sigmadelta0*ksz*kdP*((qs*kWS)^2)/(delta*kc);               %Wspolczynnik przewodnosci rozproszenia szczelinowego
hys=(2*rse-2*r-2*hqs)/2;                                                        %Wysokosc magnetyczna stojana
lys=pi*(2*rse-hys)/(2*p);                                                       %Dlugosc magnetyczna stojana
hyr=(2*rr-2*rw)/2*hqr;                                                          %Wysokosc magnetyczna wirnika
lyr=pi*(2*rw-2*hyr)/(2*p);                                                      %Dlugosc magnetyczna wirnika
Ss1=bs1*hs1;
Ss2=(hs2-hs1)*(bs1+1.5*bs1)/2;
Ss3=(hs3-hs2)*(1.5*bs1+ds2)/2;
Ss4=(pi*(ds2/2)^2)/2;
Ss=Ss1+Ss2+Ss3+Ss4;                                                             %Pole powierzchni zlobka stojana
z=round(1000000*Ss*0.6/pp);                                                     %Ilosc zwojow w zlobku
Rs=2*le/(sig*Ss);                                                               %Rezystancja stojana

%Wielkosci rysunkowe - Zlobek
salpha=asin((bs1/2)/r);                                                         %Odchylenie od pionu przy ktorym promien stojana spotyka poczatek zlobka
sypoint=center+r*cos(salpha);                                                   %Wspolrzedna y poczatku zlobka stojana
ralpha=asin((bs1/2)/rr);                                                        %Odchylenie od pionu przy ktorym promien wirnika spotyka poczatek zlobka
rypoint=center+rr*cos(ralpha);                                                  %Wspolrzedna y poczatku zlobka wirnika



%FEMM%
openfemm();                                                                     %Otwarcie FEMM
newdocument(0);                                                                 %Otwarcie nowego problemu magnetycznego
mi_probdef(fs,'meters','planar',1.e-8,le,30);                                   %Definicja problemu
smartmesh(0);                                                                   %'Smart' Mesh generuje BARDZO gesta siatke



%Zlobki

%Stojan
par=10;                                                                         %Pozwoli na zredukowanie rozmiaru siatki, mozna go zastosowac na wszystkich malych lukach
mi_drawline(       center-bs1/2,         sypoint+hs1,
                   center-3*bs1/4,       sypoint+hs2);
mi_drawline(       center-3*bs1/4,       sypoint+hs2,
                   center-ds2/2,         sypoint+hs3);
mi_drawarc(        center+ds2/2,         sypoint+hs3,
                   center-ds2/2,         sypoint+hs3,180,par);
mi_drawline(       center+ds2/2,         sypoint+hs3,
                   center+3*bs1/4,       sypoint+hs2);
mi_drawline(       center+3*bs1/4,       sypoint+hs2,
                   center+bs1/2,         sypoint+hs1);
mi_drawline(       center-bs1/2,         sypoint,
                   center-bs1/2,         sypoint+hs1);
mi_drawline(       center+bs1/2,         sypoint,
                   center+bs1/2,         sypoint+hs1);
mi_addmaterial('Winding',1,1,0,0,sig*0.6,0,0,1,0,0,0);
mi_addblocklabel(  1.001*center,         center+r+8*hs1);
mi_selectlabel(    1.001*center,         center+r+8*hs1);
mi_setblockprop('Winding',1,1,0,0,0,0);
mi_clearselected();

%Wirnik
mi_drawline(       center-br1/2,         rypoint-hr1,
                   center-dr1/2,         rypoint-1.98*hr1);
mi_drawline(       center-dr1/2,         rypoint-1.98*hr1,
                   center-dr2/2,         rypoint-1.98*hr1-hr0);
mi_drawarc(        center-dr2/2,         rypoint-1.98*hr1-hr0,
                   center+dr2/2,         rypoint-1.98*hr1-hr0,180,par);
mi_drawline(       center+dr2/2,         rypoint-1.98*hr1-hr0,
                   center+dr1/2,         rypoint-1.98*hr1);
mi_drawline(       center+dr1/2,         rypoint-1.98*hr1,
                   center+br1/2,         rypoint-hr1);
mi_drawline(       center-br1/2,         rypoint-hr1,
                   center+br1/2,         rypoint-hr1);
mi_addmaterial('Aluminum',1,1,0,0,34.45,0);
mi_addblocklabel(  1.001*center,         rypoint-8*hr1);
mi_selectlabel(    1.001*center,         rypoint-8*hr1);
mi_setblockprop('Aluminum',1,1,0,0,0,0);
mi_clearselected();

%Grupowanie
mi_selectrectangle(center+ds2,           sypoint+hs3,
                   center-ds2,           sypoint+hs1,
                   4);
mi_selectsegment(  center+ds2,           sypoint+hs1/2);
mi_selectsegment(  center-ds2,           sypoint+hs1/2);
mi_setgroup(1);
mi_selectrectangle(center+2*dr2,         rypoint-2*hr0,
                   center-2*dr2,         rypoint,
                   4);
mi_setgroup(2);

%Kopiowanie zlobkow
mi_selectgroup(1);
mi_moverotate(   center,                 center,
                 -90/Qs);
mi_selectgroup(1);
mi_copyrotate2(  center,                 center,
                 -360/Qs,                Qs,
                 4);
mi_selectgroup(2);
mi_moverotate(   center,                 center,
                 -180/Qs);
mi_selectgroup(2);
mi_copyrotate2(  center,                 center,
                 -360/Qr,                Qr,
                 4);

%Stojan

%Zewnetrzny okrag
mi_drawarc(        center+rse,           center,
                   center,               center+rse,
                   90,                   1);
mi_zoomnatural();                                                               %Przyblizenie na uklad

%Wewnetrzny okrag
mi_drawarc(        center+r,             center,
                   center,               center+r,
                   90,                   1);
mi_drawarc(        center,               center+r,
                   center-r,             center,
                   90,                   1);
mi_drawarc(        center-r,             center,
                   center,               center-r,
                   90,                   1);
mi_drawarc(        center,               center-r,
                   center+r,             center,
                   90,                   1);

%Wirnik

%Zewnetrzny okrag
mi_drawarc(        center+rr,            center,
                   center,               center+rr,
                   90,                   1);

%Wal
mi_drawarc(        center+rw,            center,
                   center,               center+rw,
                   90,                   1);

%Warunek brzegowy
mi_addboundprop('Zero',0,0,0,0,0,0,0,0,0);                                      %Ustalenie wartosci brzegowej
mi_selectarcsegment(center+rw/2,          center+rw/2);
mi_selectarcsegment(center+rse,           center+rse);
mi_setarcsegmentprop(1,'Zero',0,0);                                             %Dla duzych promieni luk jest traktowany jak wielokat, dlatego kat miedzy fragmentami musi byc 1
mi_clearselected();

%Kopiowanie cwierci
mi_selectarcsegment(center,              center+rw);
mi_selectarcsegment(center,              center+rr);
mi_selectarcsegment(center,              center+rse);
mi_setgroup(3);
mi_selectgroup(3);
mi_copyrotate2(    center,               center,
                   90,                   4,
                   4);
mi_zoomnatural();
                 
%Dodanie pozostalych materialow
mi_getmaterial('Air');
mi_addblocklabel(1.001*center,           center+rr+delta/2);
mi_selectlabel(  1.001*center,           center+rr+delta/2);
mi_setblockprop('Air',0,msize,0,0,0,0);
mi_clearselected();
mi_getmaterial('M-36 Steel');
mi_addblocklabel(center,                 center);
mi_addblocklabel(1.001*center,           center+3*rw/2);
mi_addblocklabel(1.001*center,           center+5*rr/4);
mi_selectlabel(  center,                 center);
mi_selectlabel(  1.001*center,           center+3*rw/2);
mi_selectlabel(  1.001*center,           center+5*rr/4);
mi_setblockprop('M-36 Steel',0,msize,0,0,0,0);
mi_clearselected();

%Dodanie pradow trojfazowych
mi_addcircprop('pA',I,1);
mi_addcircprop('pB',I*(-0.5+i*sqrt(3)/2),1);
mi_addcircprop('pC',I*(-0.5-i*sqrt(3)/2),1);
mi_addcircprop('mA',-I,1);
mi_addcircprop('mB',-I*(-0.5+i*sqrt(3)/2),1);
mi_addcircprop('mC',-I*(-0.5-i*sqrt(3)/2),1);

%Przypisanie pradow do zlobkow
for i=0:Qs/(2*ms*p)
  k=2*ms*p*i;
  for l=0:2*ms*p
    ang(l+1)=90-90/Qs-360*(k+l)/Qs;
    xn(l+1)=1.001*center+(r+8*hs1)*cosd(ang(l+1));
    yn(l+1)=center+(r+8*hs1)*sind(ang(l+1));
    mi_selectlabel(xn(l+1),yn(l+1));
    if l+1<=p
      mi_setblockprop('Winding',1,1,'pA',0,0,z);
    elseif l+1<=2*p
      mi_setblockprop('Winding',1,1,'mC',0,0,z);
    elseif l+1<=3*p
      mi_setblockprop('Winding',1,1,'pB',0,0,z);
    elseif l+1<=4*p
      mi_setblockprop('Winding',1,1,'mA',0,0,z);
    elseif l+1<=5*p
      mi_setblockprop('Winding',1,1,'pC',0,0,z);
    else
      mi_setblockprop('Winding',1,1,'mB',0,0,z);
    endif
    mi_clearselected();
  endfor
endfor
 
mi_zoomnatural();
mi_saveas('Projekt_68Qr.fem');                                                 %Zapis projektu



%Obliczenia

%Petla analizy
for i=1:10
  mi_probdef(s(i)*fs,'meters','planar',1.e-8,le,30);                            %Analiza wykonana dla wszystkich wartosci czestotliwosci s*fs
  mi_analyze();
  mi_loadsolution();
  Aprop=mo_getcircuitproperties('pA');                                          %Zdobycie wlasnosci fazy A
  Lr(i)=2*real(Aprop(3)/Aprop(1));                                              %Wyznaczenie indukcyjnosci zastepczej
  Li(i)=2*imag(Aprop(3)/Aprop(1));                                              %Aprop(3) - Strumien skojarzony z faza A, Aprop(1) - Prad fazy a
endfor

%Wyznaczenie parametrow zastepczych
m=[(s*2*pi*fs)',(Li.*((s*2*pi*fs).^2))'];                                       %Macierz m z rownania macierzowego
b=-Li';                                                                         %Wektor b z rownania macierzowego
c=(m'*m)\(m'*b);                                                                %Wyznaczenie macierzy c z rownania macierzowego
tau=sqrt(c(2));                                                                 %Parametr pomocniczy tau
Lm=c(1)/tau;                                                                    %Indukcyjnosc magnesujaca
Xm=2*pi*fs*Lm;                                                                  %Reaktancja magnesujaca
Rrp=Lm/tau;                                                                     %Rezystancja wirnika (odniesiona, bez poslizgu)
Ls=mean(Lr-Lm./(1+(tau*s*2*pi*fs).^2));                                         %Indukcyjnosc stojana
Xs=2*pi*fs*Ls;                                                                  %Rektancja stojana

%Charakterystyki poslizgowe
s=linspace(0.001,1,1000);                                                       %Dla charakterystyk potrzebny rozszerzony przedzial poslizgu
for i=1:1000
  Zwe(i)=Rs+j*Xs+(j*Xm*Rrp/s(i))/(j*Xm+Rrp/s(i));                               %Impedancja wejsciowa
  Is(i)=Usph/Zwe(i);                                                            %Rzeczywisty prad stojana
  Isrms(i)=abs(Is(i));                                                          %Wartosc RMS rzeczywistego pradu
  cosphi(i)=cos(angle(Is(i)));                                                  %Wspolczynnik mocy
  Um(i)=Usph-Rs*Is(i)-j*Xs*Is(i);                                               %Napiecie na Rr'/s w schemacie zastepczym
  Irp(i)=Um(i)/(Rrp/s(i));                                                      %Prad schematu zastepczego
  Irprms(i)=abs(Irp(i));                                                        %Wartosc RMS pradu zastepczego
  M(i)=(3*p*Rrp*(Irprms(i)^2))/(s(i)*2*pi*fs);                                  %Moment obrotowy wirnika
endfor

%Wykres
figure();
subplot(3,1,1);                                                                 %Stworzenie nowego podwykresu
plot(s,Isrms,'r');                                                              %Wykres pradu stojana RMS
xlabel('s [ - ]');
ylabel('I_s_R_M_S [ A ]');
hold on;
subplot(3,1,2);
plot(s,M,'g');                                                                  %Charakterystyka mechaniczna
xlabel('s [ - ]');
ylabel('M [ Nm ]');
subplot(3,1,3);
plot(s,cosphi,'b');                                                             %Wykres wspolczynnika mocy
xlabel('s [ - ]');
ylabel('cos(\phi) [ - ]');

save data_68Qr.m *                                                             %Zapis wszystkich zmiennych do pliku .m aby nie powtarzac obliczen