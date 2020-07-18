function output = applyCOSFIRE(inputImage,operator,tuple)

% Apply the given COSFIRE operator to the the inputImage
%
% VERSION 01/07/2012
% CREATED BY: George Azzopardi and Nicolai Petkov, University of Groningen,
%             Johann Bernoulli Institute for Mathematics and Computer Science, Intelligent Systems
%
% If you use this script please cite the following paper:
%   George Azzopardi and Nicolai Petkov, "Trainable COSFIRE filters for
%   keypoint detection and pattern recognition", IEEE Transactions on Pattern 
%   Analysis and Machine Intelligence, 2012, DOI: 10.1109/TPAMI.2012.106

% First compute the responses for tuples with unqiue set of values of
% parameters (lambda, theta, rho, phi=0). This is done for efficiency purposes.
% The response for any given value of phi can then be computed by
% appropriate shifting.
if nargin == 2
    tuple  = computeTuples(inputImage,operator);
end

% Apply the igven operator in a reflection-, rotation-, and scale-invariant mode
cosfirefun   = @(inputImage,operator,tuple) computeCOSFIRE(inputImage,operator,tuple);                                                  
scalefun     = @(inputImage,operator,tuple) scaleInvariantCOSFIRE(inputImage,operator,tuple,cosfirefun);
rotationfun  = @(inputImage,operator,tuple) rotationInvariantCOSFIRE(inputImage,operator,tuple,scalefun);
output       = reflectionInvariantCOSFIRE(inputImage,operator,tuple,rotationfun);                     

% Suppress values that are less than a fraction t3 of the maximum
output(output < operator.params.COSFIRE.t3 * max(output(:))) = 0; 

function output = reflectionInvariantCOSFIRE(inputImage,operator,tuple,funCOSFIRE)

% Apply the given COSFIRE filter 
output = feval(funCOSFIRE,inputImage,operator,tuple);

if operator.params.invariance.reflection == 1
    % Create a COSFIRE operator which is selective for a reflected version (about
    % the y-axis) of the prototype pattern to which the given COSFIRE operator is
    % selective for.
    reflectionDetector = operator;
    
    if operator.params.inputfilter.symmetric == 1
        reflectionDetector.tuples(2,:) = mod(pi - reflectionDetector.tuples(2,:),pi);
    else
        reflectionDetector.tuples(2,:) = mod(pi - reflectionDetector.tuples(2,:),2*pi);
    end
    reflectionDetector.tuples(4,:) = mod(pi - reflectionDetector.tuples(4,:),2*pi);
    
    % Apply the new filter to the inputImage
    reflectionoutput = feval(funCOSFIRE,inputImage,reflectionDetector,tuple);

    % Take the maximum value of the output of the two COSFIRE filters
    output = max(output,reflectionoutput);
end

function output = rotationInvariantCOSFIRE(inputImage,operator,tuple,funCOSFIRE)

output = zeros(size(inputImage));
rotateDetector = operator;
    
for psiindex = 1:length(operator.params.invariance.rotation.psilist)       
    % Create a COSFIRE operator which is selective for a rotated version of the 
    % prototype pattern to which the given operator is selective for. This
    % is achieved by shifting the values of parameters (theta,rho) of every
    % tuple by a given psi value
    
    if operator.params.inputfilter.symmetric == 1
        rotateDetector.tuples(2,:) = mod(operator.tuples(2,:) + operator.params.invariance.rotation.psilist(psiindex),pi);
    else
        rotateDetector.tuples(2,:) = mod(operator.tuples(2,:) + operator.params.invariance.rotation.psilist(psiindex),2*pi);
    end
    rotateDetector.tuples(4,:) = operator.tuples(4,:) + operator.params.invariance.rotation.psilist(psiindex);            

    % Compute the output of the new COSFIRE filter for the given psi value
    rotoutput = feval(funCOSFIRE,inputImage,rotateDetector,tuple);    
    
    % Take the maximum over the COSFIRE outputs for all given values of psi
    output = max(rotoutput,output);        
end

function output = scaleInvariantCOSFIRE(inputImage,operator,tuple,funCOSFIRE)

output = zeros(size(inputImage));
scaleDetector = operator;

for upsilonindex = 1:length(operator.params.invariance.scale.upsilonlist)
    % Create a COSFIRE operator which is selective for a scaled version of the 
    % prototype pattern to which the given operator is selective for. This
    % is achieved by scaling the values of parameters (lambda,rho) of every
    % tuple by a given upsilon value
        
    scaleDetector.tuples(1,:) = operator.tuples(1,:) * operator.params.invariance.scale.upsilonlist(upsilonindex);   
    scaleDetector.tuples(3,:) = operator.tuples(3,:) * operator.params.invariance.scale.upsilonlist(upsilonindex);
        
    % Compute the output of the new COSFIRE filter for the given psi value
    scaleoutput = feval(funCOSFIRE,inputImage,scaleDetector,tuple);
    
    % Take the maximum over the COSFIRE outputs for all given values of upsilon
    output = max(output,scaleoutput);
end

function output = computeCOSFIRE(inputImage,operator,tuple)       
% Compute the output of the given COSFIRE operator to the inputImage.

operator.tuples = round(operator.tuples * 10000) / 10000;       
sz = size(inputImage);
output = ones(sz);
ntuples = size(operator.tuples,2);

% Loop through all tuples of the COSFIRE operator
for sindex = 1:ntuples              
    % Convert the polar-coordinate shift vector (rho,phi) to image coordinates
    [col row] = pol2cart(operator.tuples(4,sindex),operator.tuples(3,sindex));  
    
    % Retrieve the tuple response from the hashtable
    hashkey = getHashkey(operator.tuples(1:3,sindex)');            
    tupleresponse = tuple.hashtable(hashkey);
    
    % Shift the tupleresponse appropriately
    tupleoutput = imshift(tupleresponse,fix(row),-fix(col));
    
    % This step is done for efficiency purposes. In case the multiplcation
    % of the responses of a subset of tuples produce a zero response, then
    % its useless to continue the loop because the final result will
    % anyways be zero.
    output = output .* tupleoutput;    
    if ~any(output(:))
        output = zeros(sz);
        return;
    end    
end

if strcmp(operator.params.COSFIRE.outputfunction, 'weightedgeometricmean')
    % Compute the COSFIRE output using weighted geometric mean
    tupleweightsigma = sqrt(-max(operator.tuples(3,:))^2/(2*log(operator.params.COSFIRE.mintupleweight)));
    tupleweight      = exp(-(operator.tuples(3,:).^2)./(2*tupleweightsigma*tupleweightsigma));    
    output           = output .^ (1/sum(tupleweight));    
else
    output = output .^ (1/ntuples);
    % Other pixel-wise functions can be used
end