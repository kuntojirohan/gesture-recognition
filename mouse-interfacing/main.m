%***********************************************************************************
% Program to control Mouse Pointer & Clicks using hand Gesture
%************************************************************************************

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
delay(300);

fprintf('Thresolding for YELLOW Marker\n');
%im = getsnapshot(vidobj);
[YL_M_R YL_M_G YL_M_B] = get_MY_THRESHOLDING(im);
delay(300);
close all

    import java.awt.Robot;
    import java.awt.event.*;
    mouse = Robot;

while(1)
    trigger(vidobj);                 % Manually initiate logging/sending for running object.
    im=getdata(vidobj);              % Return acquired data samples from engine to MATLAB workspace.
      
    [r c d]=size(im);
    output_image_r=zeros(r,c);          %image red
   % output_image_g=zeros(r,c);         %image green
    output_image_y=zeros(r,c);          %image Yellow
    A=0;

    
   %To Detect Red mark/tape
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>RD_M_R-range) && (im(i1,i2,1)<RD_M_R+range) && (im(i1,i2,2)>RD_M_G-range) && (im(i1,i2,2)<RD_M_G+range) && (im(i1,i2,3)>RD_M_B-range) && (im(i1,i2,3)<RD_M_B+range) )
            output_image_r(i1,i2)=1;
        end
    end
   end
   
       imshow(output_image_r);   % To see the marker Position for Debugging
       [r_cent_r c_cent_r]=centroid1(output_image_r);
      disp([r_cent_r c_cent_r]);
       
     
     
   %To Detect Yellow mark/tape
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>YL_M_R-range) && (im(i1,i2,1)<YL_M_R+range) && (im(i1,i2,2)>YL_M_G-range) && (im(i1,i2,2)<YL_M_G+range) && (im(i1,i2,3)>YL_M_B-range) && (im(i1,i2,3)<YL_M_B+range) )
            output_image_y(i1,i2)=1;
        end
    end
   end
   
    
      [r_cent_y c_cent_y]=centroid1(output_image_y);
     disp([r_cent_y c_cent_y]);
           
     r = sqrt( ((r_cent_r)-(r_cent_y)).^2 + ((c_cent_r)-(c_cent_y)).^2 ); %To Find Distance Between Two Centroid
     disp(r);
     
    mouse.mouseMove(0, 0);
    mouse.mouseMove(((8.2)*(160 - c_cent_r)),(6.7*(r_cent_r)));    %To Expand The Area Of Cursor Movement 
       
    if(r<50)
    mouse.mousePress(InputEvent.BUTTON3_MASK);          %Right Click
    mouse.mouseRelease(InputEvent.BUTTON3_MASK);
    delay(500)
    end
end
    
   
 

