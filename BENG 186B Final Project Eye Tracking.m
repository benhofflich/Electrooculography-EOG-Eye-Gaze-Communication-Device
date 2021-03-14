a = arduino('COM3','MEGA2560');

%% Calibration
% Some initialization for sample values
t=[]; vH=[]; vV=[]; restH=[]; restV=[]; ii=0;

%Parameters that control the sampling (could have been parameters in the
%  function call - up to the next programmer
numSec=20;  % length in seconds of the sampling
samptime=0.02;  %intersample interval in seconds

% now we begin the sampling -- length of time, determined by numSec
%                           -
%                           -- resolution is 10 bits, 0 to 1023.
ii=0;
t0=tic;                         % tic is the absolute computer time
while (toc(t0)<=numSec)  
    % toc(t0) returns elapsed time from t0 in secs
    t1 = tic;
    ii = ii+1;                    % sample timing controlled by Arduino sketch
    tt = toc(t0);   % this generates time in milliseconds
    
    vvH = readVoltage(a,'A0');  % this is the voltage input
    vvV = readVoltage(a,'A1');  %Adjust pin inputs
    
    t=[t tt];                   % appending the new time to the vector
    vH=[vH vvH];                % appending the new voltage to the vector   
    vV=[vV vvV];
                                % voltage came from  pin A0,A1 --  defined 
                                % in the Arduino sketch, not here 
                                % we must know what type of variable Arduino 
                                % is sending ( % d, %f, %s, etc.)
    
    clc                            
    if(tt < numSec/5)
        disp('look straight');
        restH = [restH vvH];
        restV = [restV vvV];
    elseif (tt < 2*numSec/5)
        disp('look left for 2 seconds then straight');
    elseif (tt < 3*numSec/5)
        disp('look right for 2 seconds then straight');
    elseif (tt < 4*numSec/5)
        disp('look up for 2 seconds then straight');
    elseif (tt < numSec)
        disp('look down for 2 seconds then straight');
    end
        
    
    while (toc(t1)<=samptime);
        b=2;                    % just stalling until ready for next sample
    end
end
% very important -- close the port

cla
figure(1)                         % open up a new figure
subplot(2,1,1)
plot(t,vH,'*r')
hold
plot(t,vH,'g')
title('Horizontal EOG Measurement');
xlabel('time (ms)');
ylabel('voltage (V)');

subplot(2,1,2)
plot(t,vV,'*r')
hold
plot(t,vV,'g')
title('Vertical EOG Measurement');
xlabel('time (ms)');
ylabel('voltage (V)');

zeroH = mean(restH);
zeroV = mean(restV);
sensitivity = 0.5;

horizontalInt = (round(length(vH)/5)):(round(3*length(vH)/5));
verticalInt = (round(3*length(vH)/5)):(round(length(vH)));

hMinima = islocalmin(vH(horizontalInt));
hMaxima = islocalmax(vH(horizontalInt));
vMinima = islocalmin(vV(verticalInt));
vMaxima = islocalmax(vV(verticalInt));
leftPeaks = sort(vH(hMaxima));
rightPeaks = sort(vH(hMinima));
upPeaks = sort(vV(hMaxima));
downPeaks = sort(vV(hMinima));

lowerH = rightPeaks(2);
lowerHThresh = sensitivity*(lowerH-zeroH)+zeroH;
upperH = leftPeaks(end-1);
upperHThresh = sensitivity*(upperH-zeroH)+zeroH;
lowerV = downPeaks(2);
lowerVThresh = sensitivity*(lowerV-zeroV)+zeroV;
upperV = upPeaks(end-1);
upperVThresh = sensitivity*(upperH-zeroV)+zeroV;

disp([zeroH lowerH upperH; zeroV lowerV upperV]);
disp([zeroH lowerHThresh upperHThresh; zeroV lowerVThresh upperVThresh]);

%% Eye Tracking
%Creates Grid Graphic
x = 0;
y = 0;
figure(2)
c = color([3 3],[x,y]);

% Some initialization for sample values
t=[]; vH=[]; vV=[]; ii=0;

%Parameters that control the sampling (could have been parameters in the
%  function call - up to the next programmer
numSec=20;  % length in seconds of the sampling
samptime=0.01;  %intersample interval in seconds

% now we begin the sampling -- length of time, determined by numSec
%                           -
%                           -- resolution is 10 bits, 0 to 1023.
ii=0;
t0=tic;                         % tic is the absolute computer time
while (toc(t0)<=numSec)  
    % toc(t0) returns elapsed time from t0 in secs
    t1 = tic;
    ii = ii+1;                    % sample timing controlled by Arduino sketch
    tt = toc(t0);   % this generates time in milliseconds
    
    vvH = readVoltage(a,'A0');  % this is the voltage input
    vvV = readVoltage(a,'A1');  % Adjust pin inputs
    
    %Horizontal Movement
    if vvH > upperHThresh       %Look Left
        if x == 0 & xrest        %Eye centered
            x = -1;
        elseif x == 1           %Correcting to center
            x = 0;
        end
        xrest = false;
    elseif vvH < lowerHThresh   %Look Right
        if x == 0 & xrest        %Eye centered
            x = 1;
        elseif x == -1          %Correcting to center
            x = 0;
        end
        xrest = false;
    else
        if x == 0
            xrest = true;
        end
    end
    
    %Vertical Movement
    if vvV > upperVThresh       %Look Up
        if y == 0 & yrest       %Eye centered
            y = -1;
        elseif y == 1           %Correcting to center
            y = 0;
        end
        yrest = false;
    elseif vvV < lowerVThresh   %Look Down
        if y == 0 & yrest       %Eye centered
            y = 1;
        elseif y == -1          %Correcting to center
            y = 0;
        end
        yrest = false;
    else
        if y == 0
            yrest = true;
        end
    end
    
    c = color([3 3],[x,y]);
    pause(0.1);
    
    t=[t tt];                   % appending the new time to the vector
    vH=[vH vvH];                % appending the new voltage to the vector   
    vV=[vV vvV];
                                % voltage came from  pin A0,A1 --  defined 
                                % in the Arduino sketch, not here 
                                % we must know what type of variable Arduino 
                                % is sending ( % d, %f, %s, etc.)
    while (toc(t1)<=samptime);
        b=2;                    % just stalling until ready for next sample
    end
end

figure(3)                         % open up a new figure
subplot(2,1,1)
plot(t,vH,'*r')
hold
plot(t,vH,'g')
title('Horizontal EOG Measurement');
xlabel('time (ms)');
ylabel('voltage (V)');

subplot(2,1,2)
plot(t,vV,'*r')
hold
plot(t,vV,'g')
title('Vertical EOG Measurement');
xlabel('time (ms)');
ylabel('voltage (V)');
