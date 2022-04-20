
function images = loadImages(dir)
if ~isfolder(dir)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', dir);
    uiwait(warndlg(errorMessage));
    return;
end
imageDS = imageDatastore(dir,"FileExtensions",".png");
images = readall(imageDS);
end


function [window, xCenter, yCenter, black, white] = initScreen()
Screen('Preference', 'VisualDebuglevel', 3); %No PTB intro screen
Screen('Preference', 'SkipSyncTests', 1); %change to 0 in real experiment
PsychDefaultSetup(2); % call some default settings for setting up Psychtoolbox
screens = Screen('Screens');
screenNumber = max(screens) % - 1 for showing on other screen;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
green=[0,1,0];
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[screenXpixels, screenYpixels] = Screen('WindowSize', window); %get the size of the scrren in pixel
[xCenter, yCenter] = RectCenter(windowRect); % Get the centre coordinate of the window in pixels
% text preferences
s = Screen('TextSize', window, 30);
end

function waitForTimeOrEsc(timeToWait)
errID = 'myException:ESC';
msg = 'ESC called';
e = MException(errID,msg);
tStart = GetSecs;
% repeat until a valid key is pressed or we time out
timedOut = false;
while ~timedOut
    % check if a key is pressed
    % only keys specified in activeKeys are considered valid
    [ keyIsDown, keyTime, keyCode ] = KbCheck;
    if keyCode(KbName('ESCAPE')), throw(e)
    elseif((keyTime - tStart) >= timeToWait), timedOut = true;
    end
end
end

    function waitForMRI()
    t_pressed = false;
    DisableKeysForKbCheck([]);
    fprintf("waiting for next Tr cue from MRI...\?")
    while t_pressed == false
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(KbName('t'))
            t_pressed = true;
            fprintf("got t\n")
        end
        if keyCode(KbName('ESCAPE'))
            Screen('CloseAll');
            clear all
            return
        end
    end
    DisableKeysForKbCheck(KbName('t'));
    end
