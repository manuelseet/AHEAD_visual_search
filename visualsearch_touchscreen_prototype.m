% Clear the workspace
close all;
clearvars;
sca;
% Setup PTB with some default values
PsychDefaultSetup(2);
% Seed the random number generator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand "help rand" for more information
rand('seed', sum(100 * clock));
% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));
% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

Screen('Preference', 'SkipSyncTests', 1);
% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [], 32, 2);
% Flip to clear
Screen('Flip', window);
% Query the frame duration
ifi = Screen('GetFlipInterval', window);
%get Screen pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Set the text size
Screen('TextSize', window, 30);
% Query the maximum priority level
topPriorityLevel = MaxPriority(window);
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

% Interstimulus interval time in seconds and frames
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Numer of frames to wait before re-drawing
waitframes = 1;


%%%%%%%%Colour Details##########
green = [0 255 0];
red = [255 0 0];
maxrt = 15;

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

% Start Experiment Screen
Screen('TextSize', window, 80);
DrawFormattedText(window, 'X', 'center',screenYpixels*(0.2) ,red);
DrawFormattedText(window, 'When you see a red X, press it as quickly as you can!.\n\n But if it is absent, press the ABSENT button\n at the bottom right corner of the sceen. \n\nPress NEXT to start.',...
    'center', 'center', black);

nextdata = imread('next.jpg');
nextsize = size(nextdata);
next_loc = [screenXpixels-nextsize(2) screenYpixels-nextsize(1) screenXpixels screenYpixels];
nextPointer= Screen('MakeTexture', window, nextdata);
Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);

Screen('Flip', window);
WaitSecs(0.05);


while ~KbCheck
    [mx, my, buttons] =GetMouse(window); %alternate click loc
    if mx>=(next_loc(1)) && mx<=(next_loc(3)) && my>=(next_loc(2)) && my<=(next_loc(4))
        Screen('Flip', window); 
       break;
    end
end

WaitSecs(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%DRAW STIMULI%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('TextSize', window, 90);
Screen('TextFont',window,char('Arial'));
Screen('TextStyle', window, 1);

%make absent button

buffw = 80;

%-------------------------------------------------------%
%         CONJUNCTION 4
%-------------------------------------------------------%

%target present (Conj4)
for i = 1:2
    imagedata = imread('absent.jpg');
    imagesize = size(imagedata);
    absent_loc = [screenXpixels-imagesize(2) screenYpixels-imagesize(1) screenXpixels screenYpixels];
    TexturePointer = Screen('MakeTexture', window, imagedata);
    Screen('DrawTexture', window, TexturePointer,[0 0 imagesize(2),imagesize(1)],absent_loc);
   
    dxmin=buffw;
    dxmax= screenXpixels-buffw;
    dymin=buffw;
    dymax= absent_loc(2)-buffw;
    % two green objects (one x one o)
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    % one red  'O'
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);

    %one red 'X' (target)
    txmin=25;
    txmax= absent_loc(1);
    tymin=buffw;
    tymax= absent_loc(2);
    tx = round(txmin+rand()*(txmax-txmin));
    ty = round(tymin+rand()*(tymax-tymin));
    target = DrawFormattedText(window, 'X', tx,ty,red);
    % DrawFormattedText(window, 'X', screenXpixels * rand(),screenYpixels * rand(),'r');

    %show array
    Screen('Flip', window); tic;
    SetMouse(0,0,window);
    HideCursor;

    [mx, my, buttons] =GetMouse(window); %alternate click loc
    ShowCursor('Hand',window);

    while ~KbCheck %check keyboard has not been pressed
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(tx-buffw) && mx<=(tx+buffw) && my>=(ty-buffw) && my<=(ty+buffw)
            rt = toc;
            correctmsg = strcat('Correct. \nYour timing was: ', num2str(round(rt,2)),'s');
            DrawFormattedText(window, correctmsg , 'center','center',black);
            
            %next button
            Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
            SetMouse(0,0,window);
            HideCursor;             
            Screen('Flip', window); 
            break;
        end
        if mx>=(absent_loc(1)) && mx<=(absent_loc(3)) && my>=(absent_loc(2)) && my<=(absent_loc(4))
           rt = toc;
           incorrectmsg = 'Incorrect. Target was present.';
           DrawFormattedText(window, incorrectmsg , 'center','center',black);
           
           %next button
           Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
           SetMouse(0,0,window);
           HideCursor; 
           
           Screen('Flip', window); 
           break;
        end
    end
    WaitSecs(1);
    

    while ~KbCheck
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(next_loc(1)) && mx<=(next_loc(3)) && my>=(next_loc(2)) && my<=(next_loc(4))
            Screen('Flip', window); 
           break;
        end
    end

    WaitSecs(1);
    
end

%target absent (Conj4)
for j = 1:2
    Screen('DrawTexture', window, TexturePointer,[0 0 imagesize(2),imagesize(1)],absent_loc);
    
    dxmin=buffw;
    dxmax= screenXpixels-buffw;
    dymin=buffw;
    dymax= absent_loc(2)-buffw;
    % two green 'x'
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    % one red  'O'
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    %one distractor red 'o' (no target)
    txmin=buffw;
    txmax= absent_loc(1);
    tymin=buffw;
    tymax= absent_loc(2);
    tx = round(txmin+rand()*(txmax-txmin));
    ty = round(tymin+rand()*(tymax-tymin));
    target = DrawFormattedText(window, 'O', tx,ty,red);
    % DrawFormattedText(window, 'X', screenXpixels * rand(),screenYpixels * rand(),'r');

    %show array
    Screen('Flip', window); tic;
    SetMouse(0,0,window);
    HideCursor;

    [max, may, buttons] =GetMouse(window); %alternate click loc
    ShowCursor('Hand',window);

    
    while ~KbCheck %check keyboard has not been pressed
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(absent_loc(1)) && mx<=(absent_loc(3)) && my>=(absent_loc(2)) && my<=(absent_loc(4))
           rt = toc;
           abmsg = strcat('Correct. There was no target. \nYour timing was: ', num2str(round(rt,2)),'s');
           DrawFormattedText(window, abmsg , 'center','center',black);
           
           %next button
           Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
           SetMouse(0,0,window);
           HideCursor; 
           
           Screen('Flip', window); 
           break;
        end
    end
    WaitSecs(1);
    

    while ~KbCheck
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(next_loc(1)) && mx<=(next_loc(3)) && my>=(next_loc(2)) && my<=(next_loc(4))
            Screen('Flip', window); 
           break;
        end
    end

    WaitSecs(1);

end

%-------------------------------------------------------%
%         CONJUNCTION 8
%-------------------------------------------------------%

%target present (Conj8)
for i = 1:2
    imagedata = imread('absent.jpg');
    imagesize = size(imagedata);
    absent_loc = [screenXpixels-imagesize(2) screenYpixels-imagesize(1) screenXpixels screenYpixels];
    TexturePointer = Screen('MakeTexture', window, imagedata);
    Screen('DrawTexture', window, TexturePointer,[0 0 imagesize(2),imagesize(1)],absent_loc);
   
    dxmin=buffw;
    dxmax= screenXpixels-buffw;
    dymin=buffw;
    dymax= absent_loc(2)-buffw;
    % five green objects (one x one o)
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    % two red  'O'
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);

    %one red 'X' (target)
    txmin=25;
    txmax= absent_loc(1);
    tymin=buffw;
    tymax= absent_loc(2);
    tx = round(txmin+rand()*(txmax-txmin));
    ty = round(tymin+rand()*(tymax-tymin));
    target = DrawFormattedText(window, 'X', tx,ty,red);
    % DrawFormattedText(window, 'X', screenXpixels * rand(),screenYpixels * rand(),'r');

    %show array
    Screen('Flip', window); tic;
    SetMouse(0,0,window);
    HideCursor;

    [mx, my, buttons] =GetMouse(window); %alternate click loc
    ShowCursor('Hand',window);

    while ~KbCheck %check keyboard has not been pressed
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(tx-buffw) && mx<=(tx+buffw) && my>=(ty-buffw) && my<=(ty+buffw)
            rt = toc;
            correctmsg = strcat('Correct. \nYour timing was: ', num2str(round(rt,2)),'s');
            DrawFormattedText(window, correctmsg , 'center','center',black);
            
            %next button
            Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
            SetMouse(0,0,window);
            HideCursor; 
                       
            Screen('Flip', window); 
            break;
        end
        if mx>=(absent_loc(1)) && mx<=(absent_loc(3)) && my>=(absent_loc(2)) && my<=(absent_loc(4))
           rt = toc;
           incorrectmsg = 'Incorrect. Target was present.';
           DrawFormattedText(window, incorrectmsg , 'center','center',black);
           
           %next button
           Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
           SetMouse(0,0,window);
           HideCursor; 
           
           Screen('Flip', window); 
           break;
        end
    end
    WaitSecs(1);
    

    while ~KbCheck
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(next_loc(1)) && mx<=(next_loc(3)) && my>=(next_loc(2)) && my<=(next_loc(4))
            Screen('Flip', window); 
           break;
        end
    end

    WaitSecs(1);

end

%target absent (Conj4)
for j = 1:2
    Screen('DrawTexture', window, TexturePointer,[0 0 imagesize(2),imagesize(1)],absent_loc);
    
    dxmin=buffw;
    dxmax= screenXpixels-buffw;
    dymin=buffw;
    dymax= absent_loc(2)-buffw;
    % five green objects (one x one o)
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    % two red  'O'
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    %one distractor red 'o' (no target)
    txmin=buffw;
    txmax= absent_loc(1);
    tymin=buffw;
    tymax= absent_loc(2);
    tx = round(txmin+rand()*(txmax-txmin));
    ty = round(tymin+rand()*(tymax-tymin));
    target = DrawFormattedText(window, 'O', tx,ty,red);
    % DrawFormattedText(window, 'X', screenXpixels * rand(),screenYpixels * rand(),'r');

    %show array
    Screen('Flip', window); tic;
    SetMouse(0,0,window);
    HideCursor;

    [max, may, buttons] =GetMouse(window); %alternate click loc
    ShowCursor('Hand',window);

    while ~KbCheck %check keyboard has not been pressed
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(absent_loc(1)) && mx<=(absent_loc(3)) && my>=(absent_loc(2)) && my<=(absent_loc(4))
           rt = toc;
           abmsg = strcat('Correct. There was no target. \nYour timing was: ', num2str(round(rt,2)),'s');
           DrawFormattedText(window, abmsg , 'center','center',black);
           
           %next button
           Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
           SetMouse(0,0,window);
           HideCursor; 
           
           Screen('Flip', window); 
           break;
        end
    end
    WaitSecs(1);
    

    while ~KbCheck
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(next_loc(1)) && mx<=(next_loc(3)) && my>=(next_loc(2)) && my<=(next_loc(4))
            Screen('Flip', window); 
           break;
        end
    end

    WaitSecs(1);
end

%-------------------------------------------------------%
%         CONJUNCTION 16
%-------------------------------------------------------%

%target present (Conj16)
for i = 1:2
    imagedata = imread('absent.jpg');
    imagesize = size(imagedata);
    absent_loc = [screenXpixels-imagesize(2) screenYpixels-imagesize(1) screenXpixels screenYpixels];
    TexturePointer = Screen('MakeTexture', window, imagedata);
    Screen('DrawTexture', window, TexturePointer,[0 0 imagesize(2),imagesize(1)],absent_loc);
   
    dxmin=buffw;
    dxmax= screenXpixels-buffw;
    dymin=buffw;
    dymax= absent_loc(2)-buffw;
    % five green objects (one x one o)
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    % two red  'O'
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    
    %one red 'X' (target)
    txmin=25;
    txmax= absent_loc(1);
    tymin=buffw;
    tymax= absent_loc(2);
    tx = round(txmin+rand()*(txmax-txmin));
    ty = round(tymin+rand()*(tymax-tymin));
    target = DrawFormattedText(window, 'X', tx,ty,red);
    % DrawFormattedText(window, 'X', screenXpixels * rand(),screenYpixels * rand(),'r');

    %show array
    Screen('Flip', window); tic;
    SetMouse(0,0,window);
    HideCursor;

    [mx, my, buttons] =GetMouse(window); %alternate click loc
    ShowCursor('Hand',window);

        while ~KbCheck %check keyboard has not been pressed
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(tx-buffw) && mx<=(tx+buffw) && my>=(ty-buffw) && my<=(ty+buffw)
            rt = toc;
            correctmsg = strcat('Correct. \nYour timing was: ', num2str(round(rt,2)),'s');
            DrawFormattedText(window, correctmsg , 'center','center',black);
            
            %next button
            Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
            SetMouse(0,0,window);
            HideCursor; 
                       
            Screen('Flip', window); 
            break;
        end
        if mx>=(absent_loc(1)) && mx<=(absent_loc(3)) && my>=(absent_loc(2)) && my<=(absent_loc(4))
           rt = toc;
           incorrectmsg = 'Incorrect. Target was present.';
           DrawFormattedText(window, incorrectmsg , 'center','center',black);
           
           %next button
           Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
           SetMouse(0,0,window);
           HideCursor; 
           
           Screen('Flip', window); 
           break;
        end
    end
    WaitSecs(1);
    

    while ~KbCheck
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(next_loc(1)) && mx<=(next_loc(3)) && my>=(next_loc(2)) && my<=(next_loc(4))
            Screen('Flip', window); 
           break;
        end
    end

    WaitSecs(1);


end

%target absent (Conj16)
for j = 1:2
    Screen('DrawTexture', window, TexturePointer,[0 0 imagesize(2),imagesize(1)],absent_loc);
    
    dxmin=buffw;
    dxmax= screenXpixels-buffw;
    dymin=buffw;
    dymax= absent_loc(2)-buffw;
    % five green objects (one x one o)
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'X', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),green);
    % two red  'O'
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    DrawFormattedText(window, 'O', (round(dxmin+rand()*(dxmax-dxmin))),(round(dymin+rand()*(dymax-dymin))),red);
    
    %one distractor red 'o' (no target)
    txmin=buffw;
    txmax= absent_loc(1);
    tymin=buffw;
    tymax= absent_loc(2);
    tx = round(txmin+rand()*(txmax-txmin));
    ty = round(tymin+rand()*(tymax-tymin));
    target = DrawFormattedText(window, 'O', tx,ty,red);
    % DrawFormattedText(window, 'X', screenXpixels * rand(),screenYpixels * rand(),'r');

    %show array
    Screen('Flip', window); tic;
    SetMouse(0,0,window);
    HideCursor;

    [max, may, buttons] =GetMouse(window); %alternate click loc
    ShowCursor('Hand',window);

    while ~KbCheck %check keyboard has not been pressed
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(absent_loc(1)) && mx<=(absent_loc(3)) && my>=(absent_loc(2)) && my<=(absent_loc(4))
           rt = toc;
           abmsg = strcat('Correct. There was no target. \nYour timing was: ', num2str(round(rt,2)),'s');
           DrawFormattedText(window, abmsg , 'center','center',black);
           
           %next button
           Screen('DrawTexture', window, nextPointer,[0 0 nextsize(2),nextsize(1)],next_loc);
           SetMouse(0,0,window);
           HideCursor; 
           
           Screen('Flip', window); 
           break;
        end
    end
    WaitSecs(1);
    

    while ~KbCheck
        [mx, my, buttons] =GetMouse(window); %alternate click loc
        if mx>=(next_loc(1)) && mx<=(next_loc(3)) && my>=(next_loc(2)) && my<=(next_loc(4))
            Screen('Flip', window); 
           break;
        end
    end

    WaitSecs(1);

end

textmessage = 'End of the experiment';
DrawFormattedText (window, textmessage, 'center', 'center');
Screen('Flip',window);
WaitSecs (3.0);

%}

sca;