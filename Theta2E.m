function [E] = Theta2E(theta,e)
%     convert true anomaly to mean anomaly
    E=2*atan(sqrt((1-e)/(1+e))*tan(theta/2));
end