%% announcement
%calculate the trajectory of free-flight missile
%output: trajectory curve and other parameters
%notice: all variables are set in international units
%
%author:Lu Jingyuan, Beihang Univ.
%2023-04-30
clear;
close all;
clc;

%% pre_def
GM=39860044e7; %gravitational constant of the earth
re=6371e3; %mean radius of the earth
%Burn-out Point&Reentry Point
%date below can be changed to yours
h0=90e3; %burn-out altitude
abs_v0=3950; %burn-out velocity
gam0=39*pi/180; %trajectory obliquity
he=75e3; %reentry altitude, also called 'Karman line'

%% basic_calculate
%initial state
delta_t = 2;
num=1000;
r=zeros(num,3);
v=zeros(num,3);
r(1,:)=[0,0,re+h0];
v(1,:)=[0,abs_v0*cos(gam0),abs_v0*sin(gam0)];
[i,asc,peri,ano,a,e] = rv2element(r(1,:),v(1,:)); % ano is a variable,others are constant
%loop
for p = 2:num
    E = Theta2E(ano,e);
    Et = fsolve(@(x)x-E-e*(sin(x)-sin(E))-sqrt(GM/(a)^3)*delta_t,[0,2*pi]);
    ano_temp = E2Theta(Et,e);
    ano=ano_temp(1);
    [r(p,:),v(p,:)]=element2rv(i,asc,peri,ano,a,e);
end

%% Parameter scanning
range = zeros(1,1+10/0.2);
count_gam=0;
for gam0 = 35*pi/180:0.2*pi/180:45*pi/180
    count_gam=count_gam+1;
    r(1,:)=[0,0,re+h0];
    v(1,:)=[0,abs_v0*cos(gam0),abs_v0*sin(gam0)];
    [i,asc,peri,ano,a,e] = rv2element(r(1,:),v(1,:)); % ano is a variable,others are constant
    for p = 2:num
        E = Theta2E(ano,e);
        Et = fsolve(@(x)x-E-e*(sin(x)-sin(E))-sqrt(GM/(a)^3)*delta_t,[0,2*pi]);
        ano_temp = E2Theta(Et,e);
        ano=ano_temp(1);
        [r(p,:),v(p,:)]=element2rv(i,asc,peri,ano,a,e);
        if norm(r(p,:))<norm(r(p-1,:)) && sqrt(r(p,2)^2+r(p,3)^2)-re<75e3
            range(1,count_gam) = acos(dot(r(1,:),r(p,:))/(norm(r(1,:))*norm(r(p,:))))*re; 
            break;
        end
    end  
end

%% plot
%trajectory curve
figure 
title('Trajectory Curve')
aplha=0:pi/40:2*pi;
xe=re*cos(aplha);
ye=re*sin(aplha);
plot(xe,ye,'-');%ground
hold on
axis equal

xa=(re+75e3)*cos(aplha);
ya=(re+75e3)*sin(aplha);
plot(xa,ya,'-');%reentry altitude
hold on

plot(r(1,2),r(1,3),'r*');
hold on
count=0;
for p = 2:num
    plot(r(p,2),r(p,3),'r*');
    hold on
    if  norm(r(p,:))<norm(r(p-1,:)) && sqrt(r(p,2)^2+r(p,3)^2)-re<75e3
        count = p;
        break; %through the reentry point
    end
end
saveas(gcf, 'TrajectoryCurve.jpg', 'jpg');

%range curve
figure
title('Missile Range varies with Gamma')
gam_scan=linspace(35,45,1+10/0.2);
plot(gam_scan,range);
saveas(gcf, 'RangeCurve.jpg', 'jpg');

%parameters
figure;
subplot(2,2,1);%altitude
title("Altitude");
for p = 1:count
    plot((p-1)*delta_t,norm(r(p,:)),'r*');
    hold on
end
subplot(2,2,2);%velocity
title("Velocity");
for p = 1:count
    plot((p-1)*delta_t,norm(v(p,:)),'r*');
    hold on
end
subplot(2,2,3);%gamma
title("Gamma");
for p = 1:count
    gam=(acos(dot(v(p,:),r(p,:))/(norm(v(p,:))*norm(r(p,:))))-(pi/2))*(180/pi);
    plot((p-1)*delta_t,gam,'r*');
    hold on
end
subplot(2,2,4);%phi
title("Phi");
zi=[0 0 1];
for p = 1:count
    gam=acos(dot(zi,r(p,:))/(norm(zi)*norm(r(p,:))))*(180/pi);
    plot((p-1)*delta_t,gam,'r*');
    hold on
end
saveas(gcf, 'ParametersCurve.jpg', 'jpg');
