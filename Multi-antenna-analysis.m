clear all;
snrdb = [0  10  20  30];

% Iterate through the signal to noise data ratio matrix.
for k = 1 : length(snrdb)
    SNR=10^(snrdb(k)/10);
    ct=10000;

    sum1=0;
    sum2=0;
    
% Create and define upperbound of data analysis iterations and initialize diverse antenna modulation range.    
    for i = 1 : ct
        s = randsrc(1, 1, [-1 1]);
        h1 = randn(1,1); % Create three channels (antenna's) for data passthrough.
        h2 = randn(1,1);
        h3 = randn(1,1);
        n = randn(1,1)/sqrt(SNR); % Generate random AWGN noise.
        
% Receive data observations on signal plus noise.
        y1 = h1 * s+ h2 * s + n;
        y2 = abs(h1) * s + abs(h2) * s + abs(h3) * s + n;
        
% Detect data using prior estimates of observation output.
        prio_est1 = y1/(h1+h2); % first step of detection 
        prio_est2 = y2/(abs(h1)  + abs(h2) + abs(h3));

% Refine the prior estimates, with a conditional check of datasum condition from input to output.            
        est1 = sign(prio_est1); % second step
        est2 = sign(prio_est2);

        if est1 ~= s
            sum1 = sum1+1;
        end
        if est2 ~= s
            sum2 = sum2+1;
        end
    end

    p1(k)= sum1/ct; 
    p2(k) = sum2/ct;
end
semilogy(snrdb,p1,snrdb,p2) % Plot transfer lifetime on semiology
