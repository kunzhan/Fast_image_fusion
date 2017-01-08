%   The code was written by Kun Zhan, Jicai Teng
%   $Revision: 1.0.0.0 $  $Date: 2014/03/09 $ 17:43:28 $

%   Reference:
%   Kun Zhan, Jicai Teng, Qiaoqiao Li and Jinhui Shi,
%   A Novel Explicit Multi-focus Image Fusion Method,
%   Journal of Information Hiding and Multimedia Signal Processing, 
%   Vol. 6, No. 3, pp. 600-612, May 2015.
clear;
addpath(genpath(pwd));
% --------------------------------------------------------------------------
Image='disk';
% a=131:230;b=91:190;
I1 = imread('disk1.gif');
I2 = imread('disk2.gif');
% Ir = imread('diskR.gif');


% Image='lab';
% % a=67:166; b=448:547;
% I1 = imread('lab1.gif');
% I2 = imread('lab2.gif');


% Image='clock';
% % a=16:115;b=170:269;
% I1 = imread('uhr1_g.jpg');
% I2 = imread('uhr2_g.jpg');

% Image='pepsi';
% I1 = imread('pepsi1.gif');
% I2 = imread('pepsi2.gif');
% % a=17:116;b=401:500;

% if isequal(Image,'clock')
%     I22 = I1(a,b);
% else
%     I22 = I2(a,b);
% end
% imwrite(I22,strcat(Image,'_part.jpg'))

I_1 = double(I1);
I_2 = double(I2);
%% fuse images
If = Jihmsp_Kun_Zhan(I1,I2);    mtd='GIF';
% If = uint8(fuse_con(I_1,I_2,6,[3 9],3)); mtd='LAP'; 
% If = uint8(fuse_sih(I_1,I_2,4,[3 3],3)); mtd='SIW';


Q_ABF = Qp_ABF(I1,I2,If)
figure,imshow([I1 I2 If])