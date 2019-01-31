ax = axes('XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10 10]);
hold on
view(3);
grid on

clc
clear

P1=[5; 6; 7 ;1]

rotatex= inline('[1,0,0,0;0, cos(theta) -sin(theta),0;0, sin(theta), cos(theta),0;0,0,0,1]','theta')
rotatez= inline('[cos(theta),-sin(theta),0,0;  sin(theta), cos(theta),0 ,0;  0, 0, 1,0;   0,0,0,1]','theta')
translate=inline('[1,0,t_x;0,1,t_y;0,0, 1,t_y;]','t_x','t_y','t_z')



scatter3(P1(1), P1(2), P1(3),'*')    
Tges=rotatex(pi/2)*P1 
Tges=Tges'
scatter3(Tges(1), Tges(2), Tges(3),'+')    
    
drawnow


for i = 0:5
	i^2
end


xlabel('X Achse') 
ylabel('y Achse') 
zlabel('Z Achse')


quiver3(0,0,0,P1(1),P1(2),P1(3))
for r = 0:.01:pi/2
    
    Tges=rotatex(r)*P1 
    
    scatter3(Tges(1), Tges(2), Tges(3),'.')    
    drawnow
    
end
quiver3(0,0,0,Tges(1),Tges(2),Tges(3))
for r = 0:.01:pi
    
    Tges=rotatex(r)*P1 
    
    scatter3(Tges(1), Tges(2), Tges(3),'.')    
    drawnow
    
end


%------------- drawing the vectors------------
quiver3(0,0,0,P1(1),P1(2),P1(3))
hold on
quiver3(0,0,0,Tges(1),Tges(2),Tges(3))

%------------------------------------------- 
% weg 1 ist benutzung von ROT and TRANS matrixen und ihre multiplicaiton 
% weg 2 ist benugzung von allgemeine matrizen
% also wir zeigen erstmal weg 1: 
DH_Param1=inline('rotatez(phi_i)*translate(0,0,d_i)*translate(a_i,0,0)*rotate(alpha_i)','phi_i','d_i','a_i','alpha_i')

%%DH Param for from i-t to i or T(i-i,i)
DH_Param2=inline('[cos(phi_i), -sin(phi_i)*cos(alpha_i),sin(phi_i)*sin(alpha_i), a_i*cos(phi_i); sin(phi_i), cos(phi_i)*cos(alpha_i), -cos(phi_i)*sin(alpha_i),a_i*sin(phi_i);0,sin(alpha_i),cos(alpha_i), d_i; 0,0,0,1 ]','phi_i','d_i','a_i','alpha_i')


%% RTT Struktur (4.4.1 in skript) 
% gesucht: DH params for 0T1, 1T2, 2T3 und BTE 
% T is the transformation locating the end-link.
% n =3 weil wir drei armteile haben 
% weil Z0 und Z1 aufeinander liegen, wir nehmen d1=0
%d.h. 0T1 :
phi_1=pi/4
T_0_to_1=DH_Param2(phi_1,0,0,0)

phi_2=pi/2;
d2=10
T_1_to_2=DH_Param2(pi/2,d2,0,pi/2)

phi_3=0;
d_3=10 % movement along z axis r(t) in example
alpha_3=0
a_3=0;%movement along x axis
T_2_to_3=DH_Param2(phi_3,d_3,a_3, alpha_3)

% und jetzt transformation von basis zum effektor 
P0=[0;0;0;1]
scatter3(P0(1), P0(2), P0(3),'+')    

P1=T_0_to_1*P0;
scatter3(P1(1), P1(2), P1(3),'*')    

P2=T_0_to_1*T_1_to_2*P0;
scatter3(P2(1), P2(2), P2(3),'.')    

%effektor koordination
EK=T_0_to_1*T_1_to_2*T_2_to_3 * P0;


%% 
%%----------
%4.4.2 TRR Struktur 
%build a 2 dim array for DH-Param Table
%  i-1Ti  phi_i    d_i    a_i   alpha_i
%   0T1   0        z(t)   l1     0
%   1T2   phi_2(t) 0      l2     0     
%   2T3   phi_3(t) 0      l3     0

DHParams442=[0       , z(t)  ,l1   ,0; 
             phi_2(t), 0     ,l2   ,0;
             phi_3(t), 0     ,l3   ,0]


index=1;
T(index)=DH_Param2(DHParams442(index)(1),DHParams442(index)(2),DHParams442(index)(3),DHParams442(index)(4))

index=2
T(index)=DH_Param2(DHParams442(index)(1),DHParams442(index)(2),DHParams442(index)(3),DHParams442(index)(4))

index=3
T(index)=DH_Param2(DHParams442(index)(1),DHParams442(index)(2),DHParams442(index)(3),DHParams442(index)(4))
% und jetzt transformation von basis zum effektor 
P0=[0;0;0;1]
l1=l2=l3=1
phi_2(t)=phi_3(t)=pi/4
z(t)=5

scatter3(P0(1), P0(2), P0(3),'+')    

P1=T(1)*P0;
scatter3(P1(1), P1(2), P1(3),'*')    

P2=T(1)*T(2)*P0;
scatter3(P2(1), P2(2), P2(3),'.')    

%effektor koordination
EK=T(1)*T(2)*T(3)* P0;




%%%%%%%%%%%%%%%%
%4.5. RRRR Struktur
%
DHParams45=[ phi_1(t), l1    ,0    ,-pi/2; 
             phi_2(t), 0     ,l2   ,0;
             phi_3(t), 0     ,l3   ,0;
             phi_4(t), 0     ,l4   ,0]

index=1;
T(index)=DH_Param2(DHParams45(index)(1),DHParams45(index)(2),DHParams45(index)(3),DHParams45(index)(4))

index=2
T(index)=DH_Param2(DHParams45(index)(1),DHParams45(index)(2),DHParams45(index)(3),DHParams45(index)(4))

index=3
T(index)=DH_Param2(DHParams45(index)(1),DHParams45(index)(2),DHParams45(index)(3),DHParams45(index)(4))
% und jetzt transformation von basis zum effektor 
index=4
T(index)=DH_Param2(DHParams45(index)(1),DHParams45(index)(2),DHParams45(index)(3),DHParams45(index)(4))

P0=[0;0;0;1]
l1=l4=22.2
l2=l3=10

phi_1(t)=phi_2(t)=0
phi_3(t)=phi_4(t)=pi/2


scatter3(P0(1), P0(2), P0(3),'+')    

P1=T(1)*P0;
scatter3(P1(1), P1(2), P1(3),'*')    

P2=T(1)*T(2)*P0;
scatter3(P2(1), P2(2), P2(3),'.')    

P3=T(1)*T(2)*T(3)*P0;
scatter3(P3(1), P3(2), P3(3),'.')    


%effektor koordination
EK=T(1)*T(2)*T(3)*T(4)* P0;
scatter3(EK(1), EK(2), EK(3),'.')    

    



A=[4,5,6]
scatter3(4, 5, 6,'*')    
scatter3(A(1),A(2),A(3), '*')


