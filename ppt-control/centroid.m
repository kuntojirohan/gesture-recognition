function [r_cent c_cent]=centroid1(arg)
[r_index c_index]=find(arg);
r_cent=mean(r_index);
c_cent=mean(c_index);
