%***********************************************************************
% Program to control media player using hand gesture
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
fprintf('Bring Markers....\n');          % to print a string in command prompt
delay(2000);

fprintf('Thresolding for GREEN Marker\n');
im = getsnapshot(vidobj);           % taking a snapshot
fprintf('Resolution is ');
size(im)                       % to print the resolution of image in command prompt
[GR_M_R GR_M_G GR_M_B] = get_MY_THRESHOLDING(im);
delay(300);
close all;


%===================Opening media player==============

m=figure;
% h = actxcontrol('progid') creates an ActiveX® control in a figure window.
% The programmatic identifier (progid) for the control determines the type of control created.
% (See the documentation provided by the control vendor to get this string.)
% The returned object, h, represents the default interface for the control.
h=actxcontrol('WMPlayer.OCX.7', [0 0 500 550], m);

% uigetfile displays a modal dialog box that lists files in the current directory
% and enables the user to select or type the name of a file to be opened.
% If the filename is valid and if the file exists, uigetfile returns the filename when the user clicks Open.
[filename pathname] = uigetfile('*.*','Please select a file');
h.URL=[pathname filename];
h.controls.play;
i=0;j=0;
set(h.settings,'volume',i);     % Setting volume of media player
figure;
i=0;

while(1)
       
    trigger(vidobj);                 % Manually initiate logging/sending for running object.
    im=getdata(vidobj);              % Return acquired data samples from engine to MATLAB workspace.
      
    [r c d]=size(im);
%   output_image_r=zeros(r,c);          %image red
    output_image_g=zeros(r,c);          %image green
%   output_image_y=zeros(r,c);          %image Yellow
 
    
    %To Detect Green mark/tape
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>GR_M_R-range) && (im(i1,i2,1)<GR_M_R+range) && (im(i1,i2,2)>GR_M_G-range) && (im(i1,i2,2)<GR_M_G+range) && (im(i1,i2,3)>GR_M_B-range) && (im(i1,i2,3)<GR_M_B+range) )
            output_image_g(i1,i2)=1;
        end
    end
   end
   
   imshow(output_image_g);
   
      [r_cent_g c_cent_g]=centroid1(output_image_g);        % to find centre of marker
      total_pix=sum(sum(output_image_g));               % to find total no. of pixels of marker
      %disp(tatal_pix);
      
   if (total_pix>500)
       h.controls.pause;
       disp('Media Paused');
   elseif (c_cent_g>(90))   % My camera resolution = 120*160
            disp('Volume Up');
            i=i+3;
            h.controls.play;
   elseif (c_cent_g<(70))   % My camera resolution = 120*160
            disp('Volume Down');
            i=i-3;
            h.controls.play;
   else
            h.controls.play;
            disp('Playing');
   end
     if(i<2)            % to restrict min. volume as 2
         i=2;
     end
 set(h.settings,'volume',i);     %Depending on i, Volume will increase or decrease
end
   
 

