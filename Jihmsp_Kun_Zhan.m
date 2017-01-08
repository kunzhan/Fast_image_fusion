function F = Jihmsp_Kun_Zhan(IA,IB)
%   The code was written by Kun Zhan, Jicai Teng
%   $Revision: 1.0.0.0 $  $Date: 2014/03/09 $ 17:43:28 $

%   Reference:
%   Kun Zhan, Jicai Teng, Qiaoqiao Li and Jinhui Shi,
%   A Novel Explicit Multi-focus Image Fusion Method,
%   Journal of Information Hiding and Multimedia Signal Processing, 
%   Vol. 6, No. 3, pp. 600-612, May 2015.

    IA = im2double(IA);
    IB = im2double(IB);
    MpA = Focus_Measure(IA);
    MpB = Focus_Measure(IB);
    D = double(MpA > MpB);
    Db = Majority_Filter(D,8);
    Db = Majority_Filter(Db,7);
    w = ones(8);
    Dp = kron(Db,w);
    r = 8; eps = 0.03; 
    D2 = guidedfilter(IA, Dp, r, eps);
    Fs = D2.*IA+(1-D2).*IB;
    F = uint8(double(Fs)*255);
end
function Mp = Focus_Measure(I)
    xj = padarray(I,[1 1],'symmetric');
    EOL = conv2(xj,[1  4  1;4 -20 4;1  4  1]./6,'valid');
    E_2 = EOL.*EOL;
    FM = conv2(E_2,ones(8),'valid');
    Mp = FM(1:8:end,1:8:end);
end
function Db = Majority_Filter(D,l)
    D = D - 0.5;
    w = ones(l);
    D = conv2(D, w, 'same');
    D = conv2(D, w, 'same');
    Db = D > 0;
end
function q = guidedfilter(I, p, r, eps)
%   GUIDEDFILTER   O(1) time implementation of guided filter.
%
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps

[hei, wid] = size(I);
N = boxfilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = boxfilter(I, r) ./ N;
mean_p = boxfilter(p, r) ./ N;
mean_Ip = boxfilter(I.*p, r) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;

a = cov_Ip ./ (var_I + eps); % Eqn. (5) in the paper;
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

q = mean_a .* I + mean_b; % Eqn. (8) in the paper;
end
function imDst = boxfilter(imSrc, r)

%   BOXFILTER   O(1) time box filtering using cumulative sum
%
%   - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
%   - Running time independent of r; 
%   - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
%   - But much faster.

[hei, wid] = size(imSrc);
imDst = zeros(size(imSrc));

%cumulative sum over Y axis
imCum = cumsum(imSrc, 1);
%difference over Y axis
imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
imDst(r+2:hei-r, :) = imCum(2*r+2:hei, :) - imCum(1:hei-2*r-1, :);
imDst(hei-r+1:hei, :) = repmat(imCum(hei, :), [r, 1]) - imCum(hei-2*r:hei-r-1, :);

%cumulative sum over X axis
imCum = cumsum(imDst, 2);
%difference over Y axis
imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
imDst(:, r+2:wid-r) = imCum(:, 2*r+2:wid) - imCum(:, 1:wid-2*r-1);
imDst(:, wid-r+1:wid) = repmat(imCum(:, wid), [1, r]) - imCum(:, wid-2*r:wid-r-1);
end