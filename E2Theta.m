function theta = E2Theta(E,e)
%     convert mean anomaly to true anomaly
    theta=2*atan(sqrt((1+e)/(1-e))*tan(E/2));
end