clear all;
snrdb = [0 :5 :20 ];
for k = 1 : length(snrdb)
    SNR=10^(snrdb(k)/10);
    ct=100;

    sum1=0;
    sum2=0;
    for i = 1 : ct
        %transmiter
        s1 = randsrc(1, 1, [3 1 -1 -3]);
        s2 = randsrc(1, 1, [3 1 -1 -3]);
        h1 = randn(1,1);
        h2 = randn(1,1);
        n1 = randn(1,1)/sqrt(SNR);
        n2 = randn(1,1)/sqrt(SNR);

        % observation
        y1 = h1 * s1 + h2 * s2 + n1; %first time
        y2 = h1 * s2 + h2 * (-s1) + n2; %first time
        %y3 = h1^2.1 * s + h2^2.1 * s + n;

        %combine
        xs1 = h1*y1 - h2*y2;
        xs2 = h2*y1+ h1*y2;
        %a rough estimation
        prio_est1 = xs1/(h1^2+h2^2);%first step of detection 
        prio_est2 =  xs2/(h1^2+h2^2);
        
        %refine our estimation 
         if prio_est1 > 2
            est1= 3;
        elseif prio_est1 < 2 && prio_est1 > 0
            est1 = 1;
        end    
        
        if prio_est1 < -2
            est1=-3;
        elseif prio_est1 < 0 && prio_est1 > -2
            est1= -1;
        end 
        
        if prio_est2 < -2
            est2=-3;
        elseif prio_est2 < 0 && prio_est2 > -2
            est2= -1;
        end 
        
        if prio_est2 > 2
            est2= 3;
        elseif prio_est2 < 2 && prio_est2 > 0
            est2 = 1;
        end 
        
        %we want to know the errors we made
        if est1 ~= s1
            sum1 = sum1+1;
        end
        if est2 ~= s2
            sum2 = sum2+1;
        end
    end

    p1(k)= sum1/ct;
    p2(k) = sum2/ct;
end
semilogy(snrdb,p1,snrdb,p2)