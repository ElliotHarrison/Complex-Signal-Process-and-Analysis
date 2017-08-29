clear all;
snrdb = [0 :5 :20 ];

% Iterate through the signal to noise data ratio matrix.
for k = 1 : length(snrdb)
    SNR=10^(snrdb(k)/10);
    ct=100;

    sum1=0;
    sum2=0;

% Create upperbound of data analysis iterations and initialize two random data modulation ranges.
    for i = 1 : ct
        % Transmitter.
        s1 = randsrc(1, 1, [3 1 -1 -3]);
        s2 = randsrc(1, 1, [3 1 -1 -3]);
        h1 = randn(1,1); % Create two channels for data and timecode transfer.
        h2 = randn(1,1);
        n1 = randn(1,1)/sqrt(SNR); % Create first time transfer noise.
        n2 = randn(1,1)/sqrt(SNR); % Create noise on transfer of time code.

        % Observation.
        y1 = h1 * s1 + h2 * s2 + n1; % First time without time code
        y2 = h1 * s2 + h2 * (-s1) + n2; % First time with time code
       
        % Combine the two datasets.
        xs1 = h1*y1 - h2*y2;
        xs2 = h2*y1+ h1*y2;
        
        % Rough estimation.
        prio_est1 = xs1/(h1^2+h2^2);%first step of detection 
        prio_est2 =  xs2/(h1^2+h2^2);
        
        % Refine our estimation against sub modulative bands.
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
        
        % We want to know the errors we made
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
semilogy(snrdb,p1,snrdb,p2) % Plot transfer lifetime on semiology
