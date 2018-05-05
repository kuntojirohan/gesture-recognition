%***********************************************************************
% Program to control PPt using hand gesture
%***********************************************************************

clc                         % clear the command prompt
close all
fprintf('wait please\n');             % to print a string in command prompt
imaqreset                     % disconnect and delete all image aquisition objects
clear all                      % clear variable and functions from memory
vidobj = videoinput('winvideo',1);      % creates a video input object
set(vidobj,'ReturnedColorSpace','RGB');   % setting the properties of object
set(vidobj,'FramesPerTrigger',1);       
set(vidobj,'TriggerRepeat',inf);        
triggerconfig(vidobj,'manual');         
start(vidobj);
 
range=20;
fprintf('Bring Markers....\n');
delay(2000);
fprintf('Thresolding for RED Marker\n');
im = getsnapshot(vidobj);
[RD_M_R RD_M_G RD_M_B] = get_MY_THRESHOLDING(im);
delay(1000);
close all

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;


while(1)
    trigger(vidobj);                 % Manually initiate logging/sending for running object.
    im=getdata(vidobj);              % Return acquired data samples from engine to MATLAB workspace.
      
    [r c d]=size(im);
    output_image_r=zeros(r,c);         %image red
    
   %To Detect Red mark/tape
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>RD_M_R-range) && (im(i1,i2,1)<RD_M_R+range) && (im(i1,i2,2)>RD_M_G-range) && (im(i1,i2,2)<RD_M_G+range) && (im(i1,i2,3)>RD_M_B-range) && (im(i1,i2,3)<RD_M_B+range) )
            output_image_r(i1,i2)=1;
        end
    end
   end
   
      imshow(output_image_r);   % See the marker Position for Debugging
      [r_cent_r c_cent_r]=centroid1(output_image_r);
      disp([r_cent_r c_cent_r]);
          
% Java.awt.Robot class is used to take the control of mouse and keyboard.
% Once you get the control, you can do any type of operation
% related to mouse and keyboard through your java code.

%    mouse.mouseMove(0, 0);
    mouse.mouseMove((8.7*(160 - c_cent_r)),(6.2*r_cent_r));
    
    if(c_cent_r<10)         % for my laptop (120x160)
    mouse.mouseWheel(1);    %Jump To The Next Slide
    delay(500);
    
    elseif(c_cent_r>150)      % for my laptop (120x160)
    mouse.mouseWheel(-1);    %Jump To The Previous Slide
    delay(500);
    end
 end 
   
 

