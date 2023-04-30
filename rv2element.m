function [i,asc,peri,ano,a,e] = rv2element(r,v)
    % convert r and v to kepler orbit element
    % pre_def
    GM = 39860044e7;
    xi=[1,0,0];yi=[0,1,0];zi=[0,0,1];
    %
    H=cross(r,v);
    L=-(cross(H,v)+GM*(r/norm(r)));
    A=cross(zi,H);
    % 
    i=theta(H,zi);
    if i>pi/2
        i=pi-i;
    end
    % 
    if dot(A,xi)>=0
        asc=theta(A,xi);
    else
        asc=2*pi-theta(A,xi);
    end
    % 
    if dot(cross(A,L),H)>=0
        peri=theta(L,A);
    else
        peri=2*pi-theta(L,A);
    end
    % 
    if dot(cross(L,r),H)>=0
        ano=theta(L,r);
    else
        ano=2*pi-theta(L,r);
    end
    % 
    e=norm(L)/GM;
    p=norm(H)^2/GM;
    a=((p/(1+e))+(p/(1-e)))/2;
    % 
    while ano<0
        ano=ano+2*pi;
    end
    while ano>2*pi
        ano=ano-2*pi;
    end
    ano=ano(1);
end

%% sub_function
function y = theta(x1,x2) %calculate angle of vectors x1 and x2 
    y=acos(dot(x1,x2)/(norm(x1)*norm(x2)));
end
