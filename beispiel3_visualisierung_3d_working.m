ax = axes('XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10 10]);
hold on
view(3);
grid on

clc
clear

P1=[5; 6; 7 ;1]

rotatex= inline('[1,0,0,0;0, cos(theta) -sin(theta),0;0, sin(theta), cos(theta),0;0,0,0,1]','theta')
translate=inline('[1,0,0,tx;0,1,0,ty;0,0, 1,tz;0,0,0,1]','tx','ty','tz')

scatter3(P1(1), P1(2), P1(3),'*')    
Tges=translate(4,0,0)*rotatex(pi/2)*P1 
%Tges=Tges'
scatter3(Tges(1), Tges(2), Tges(3),'+')    
 
drawnow


ZP1=P1;
%rotation
for r = 0:.01:pi/2
    
    ZP1=rotatex(r)*P1 %Zwischenpunkt
    
    scatter3(ZP1(1), ZP1(2), ZP1(3),'.')    
    drawnow
    
end

ZP2=ZP1
%translation
for t = 0:.1:4
    
    ZP2=translate(t,0,0)*ZP1 %Zwischenpunkt
    
    scatter3(ZP2(1), ZP2(2), ZP2(3),'*')    
    drawnow
    
end



%------------- drawing the vectors------------
hold on
quiver3(0,0,0,P1(1),P1(2),P1(3)) %start point

quiver3(0,0,0,ZP1(1),ZP1(2),ZP1(3)) % zwischen pint 1 -- man sieht hier 90 Grad



quiver3(0,0,0,Tges(1),Tges(2),Tges(3)) % final point

%------------------------------------------- 

