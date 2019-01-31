%Berechnung des TCP aus den Gelenkswerten - Alexander Prutsch
%Info Messageboxen und Clear
uiwait(msgbox('---Berechnung des TCP bei Industrierobotern mit grafischer Darstellung--- -----------Komma als Punkt eingeben - Werte in Grad & Zentimeter----------','INFO'));
uiwait(msgbox('Beta=Drehwinkel l=Armteillänge a=Verschiebelänge Gamma=Verwindungswinkel','INFO'));
clear all
close all
clc 
v1=1;
v2=1;
while v1>0   %Schleife für mehrere Berechnungen
if v2>0      %Abfrage Anzahl der Armteile (nur bei '1. Berechnung' oder 'weitere Berechnung anderer Roboter')    
    prompt = {'Anzahl der Armteile des Roboters'};
    dlg_title = 'Eingabe';
    num_lines = 1;
    def = {'6'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    num = str2num(answer{:});
%Platzhalter Arrays
    b=zeros(1,num);
    l=zeros(1,num);
    a=zeros(1,num);
    y=zeros(1,num);
    m=zeros(4,4+num*4);
    m(1:4,1:4)=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
    v2=1;
end
if  v2>0 
    for i=1:num         %Schleife fuer Berechnung aller Gelenke ('1. Berechnung' oder 'weitere Berechnung anderer Roboter')      %Abfrage Gelenkswerte
    prompt = {'Beta','l','a','Gamma'};
    dlg_title = sprintf(['Gelenk' num2str(i)]);    num_lines = 1;
    def={'0', '0', '0', '0'};
    ant = inputdlg(prompt,dlg_title,num_lines,def);
    %Werte->Array
    b(1,i)=str2num(ant{1});
    l(1,i)=str2num(ant{2});
    a(1,i)=str2num(ant{3});
    y(1,i)=str2num(ant{4});
%Position des vorigen Koordinatensystem
    tcpt=m(1:4,i*4-3:i*4);
%Tansformationsmatrix
    mt=[cosd(b(1,i)),-sind(b(1,i))*cosd(y(1,i)),sind(b(1,i))*sind(y(1,i)),a(1,i)*cosd(b(1,i));sind(b(1,i)),cosd(b(1,i))*cosd(y(1,i)),-cosd(b(1,i))*sind(y(1,i)),a(1,i)*sind(b(1,i));0,sind(y(1,i)),cosd(y(1,i)),l(1,i);0,0,0,1];
    %Position nach Überführung
    TCP=tcpt*mt;
    %Postion->Array
    m(1:4,i*4+1:i*4+4)=TCP;
    TCP;
    end
else
for i=1:num         %Schleife fuer Abfrage und Berechnung aller Gelenke 
('weitere Berechnung gleicher Roboter')
    choice = questdlg(['Gelenk' num2str(i)], 'Abfrage', 'Änderung des Drehwinkel','Änderung der Schublänge','Keine Veränderung', 'Keine Veränderung');
    switch choice
        case 'Änderung des Drehwinkel'
        prompt = {'Drehwinkel'};
        dlg_title = 'Eingabe';
        num_lines = 1;
        def = {'0'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        b(1,i) = str2num(answer{:});
        tcpt=m(1:4,i*4-3:i*4);
        mt=[cosd(b(1,i)),-sind(b(1,i))*cosd(y(1,i)),sind(b(1,i))*sind(y(1,i)),a(1,i)*cosd(b(1,i));sind(b(1,i)),cosd(b(1,i))*cosd(y(1,i)),-cosd(b(1,i))*sind(y(1,i)),a(1,i)*sind(b(1,i));0,sind(y(1,i)),cosd(y(1,i)),l(1,i);0,0,0,1];
        TCP=tcpt*mt;
        m(1:4,i*4+1:i*4+4)=TCP;        
        case 'Änderung der Schublänge'
        prompt = {'Schublänge'};
        dlg_title = 'Eingabe';
        num_lines = 1;
        def = {'0'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        a(1,i) = str2num(answer{:});
        tcpt=m(1:4,i*4-3:i*4);
        mt=[cosd(b(1,i)),-sind(b(1,i))*cosd(y(1,i)),sind(b(1,i))*sind(y(1,i)),a(1,i)*cosd(b(1,i));sind(b(1,i)),cosd(b(1,i))*cosd(y(1,i)),-cosd(b(1,i))*sind(y(1,i)),a(1,i)*sind(b(1,i));0,sind(y(1,i)),cosd(y(1,i)),l(1,i);0,0,0,1];
        TCP=tcpt*mt;
        m(1:4,i*4+1:i*4+4)=TCP;
        case 'Keine Veränderung'
        tcpt=m(1:4,i*4-3:i*4);
        mt=[cosd(b(1,i)),- sind(b(1,i))*cosd(y(1,i)),sind(b(1,i))*sind(y(1,i)),a(1,i)*cosd(b(1,i));sind(b(1,i)),cosd(b(1,i))*cosd(y(1,i)),-cosd(b(1,i))*sind(y(1,i)),a(1,i)*sind(b(1,i));0,sind(y(1,i)),cosd(y(1,i)),l(1,i);0,0,0,1];
        TCP=tcpt*mt;
        m(1:4,i*4+1:i*4+4)=TCP;
end
end
end
%Ausgabe Text
TCP
uiwait(msgbox('TCP: MATLAB Hauptfenster', 'TCP Ausgabe'))
%Ausgabe Grafik
if v2<1         %Alte Werte bei 2. Berechnung
    kxa=kx;
    kya=ky;
    kza=kz;
    ktxa=ktx;
    ktya=kty;
    ktza=ktz;   
end
%Koordinaten bekommen
e=length(num);
kx=zeros(1:e,1);
ky=zeros(1:e,1);
kz=zeros(1:e,1);
for i=1:num
    kx(i+1,1)=m(1,4*i+4);
    ky(i+1,1)=m(2,4*i+4);
    kz(i+1,1)=m(3,4*i+4);
end
%Zeichnen
if v2>0         
%1. Berechnung
    ktx=kx(i+1,1);
    kty=ky(i+1,1);
    ktz=kz(i+1,1);  
    f=plot3(kx,ky,kz);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    movegui(f,[100,350]);
    text(ktx,kty,ktz,'TCP');
else
%Weitere Berechnung
    ktx=kx(i+1,1);
    kty=ky(i+1,1);
    ktz=kz(i+1,1);
    f=plot3(kx,ky,kz,'b',kxa,kya,kza,'r');
    %movegui(f,[100,350]);
    text(ktx,kty,ktz,'TCP');  
    text(ktxa,ktya,ktza,'TCP alt','Color','r') ;       
end
%Abrage nach weiter Berechnung
choice = questdlg('Weitere Berechnung?', 'Abfrage', 'Ja - gleicher Roboter','Ja - anderer Roboter','Nein','Nein');
switch choice
    case 'Ja - gleicher Roboter'
        v2=0;
    case 'Ja - anderer Roboter'
        v2=1;
    case 'Nein'
        disp('Ende des Programs')
        uiwait(msgbox('Ende des Programms'))
        v1=0;     
end
end