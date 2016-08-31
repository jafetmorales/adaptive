% THIS IS AN ADAPTIVE FILTER IMPLEMENTATION
% THE FILTER CONVERGES TO THE LMS SOLUTION
clear all;
clc;
close all;

% FILTER ORDER
% IT IS POSSIBLE TO TRY TO APPROXIMATE A HIGHER ORDER FILTER WITH A LOWER
% ORDER (NUMBER OF COEFFICIENTS)
p=5;
% ADAPTATION STEP SIZE
mu=.01;

xi=(unidrnd(11,1,100)-6)';
h=[1/9 2/9 3/9 2/9 1/9]';
yt=conv(xi,h);

xpadded=zeros(length(xi)+2*(p-1),1);
xpadded(p:(p+length(xi)-1))=xi;

% % THIS IS MY OWN IMPLEMENTATION OF THE FILTERING THAT MATLAB DOES WHEN
% % DOING CONV(XI,H). IT GIVES THE EXACT SAME RESULTS!
% for n=p:length(xpadded)
%     x=xpadded(n:-1:(n-p+1));
%     n2=n-p+1;
%     y(n)=h'*x;
% end
% y=y(p:end);

% ESTIMATE THE FILTER BY USING AN ADAPTIVE FILTER
he=zeros(p,1);

for n=p:length(xpadded)
    x=xpadded(n:-1:(n-p+1));
    n2=n-p+1;
    d(n2)=yt(n2);
    ye(n2)=he'*x;
    e(n2)=d(n2)-ye(n2);
    
    he=he+mu*x*e(n2);
    heDebug(:,n2)=he;
end

% OUTPUT WHEN USING FINAL FILTER
yeff=conv(xi,he(:));

figure(1);
plot(1:50,xi(1:50),1:50,yt(1:50))
legend('input sequence x[n]','filtered with h[n]');
xlabel('time');
ylabel('amplitude');
title('original sequence and filtered sequence');
figure(2);
plot(1:100,yt(1:100),1:100,ye(1:100))
legend('filtered with h[n]','filtered with adaptive filter');
xlabel('time');
ylabel('amplitude');
title('filtered sequences');


% DISPLAY COEFFICIENT ADJUSTMENT CURVES
figure(4);plot(heDebug','linestyle','none','marker','.')
leg=legend('h[0]','h[1]','h[2]','h[3]','h[4]');
title('Filter adaptation curves');
xlabel('iteration');