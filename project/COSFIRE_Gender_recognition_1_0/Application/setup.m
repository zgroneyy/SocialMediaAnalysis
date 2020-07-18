% First compile the relevant c functions
function setup

% First, compile the c-function called maxblurring_written_in_c.c
d = dir('../COSFIRE/maxblurring.*');
if isempty(d)
    mex ../COSFIRE/written_in_c_maxblurring.c -outdir ../COSFIRE -output maxblurring;
end

% And compile the libsvm Matlab scripts
run('../libsvm_3_21/matlab/make.m');
