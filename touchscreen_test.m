clear all;
%Set up a full screen with cursor
Screen('Preference', 'SkipSyncTests', 1);
[EXPWIN, scr_rect] = Screen('OpenWindow', 0);
ShowCursor('CrossHair', EXPWIN);
%General variable setup
clicks = 0;
black = [1,0,0];
nchunk = 1; % Chunk number






  %main loop
while ~KbCheck %check keyboard has not been pressed
    [x, y, buttons] =GetMouse(EXPWIN); %alternate click loc
    if any(buttons)
        clicks = clicks+1;
        aoi_corners(nchunk, clicks, 1)= x;
        aoi_corners(nchunk, clicks, 2)= y;
        Screen('DrawDots', EXPWIN, [x, y], [10], black)
        Screen('Flip', EXPWIN, 0, 1)
        % wait until the mouse is released
        while(any(buttons))
            [~, ~, buttons] =GetMouse(EXPWIN);
           WaitSecs(.001); % wait 1 ms 
        end
    end  
end
sca;