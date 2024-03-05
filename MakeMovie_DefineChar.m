% ---------------------------------------------
%                     定义字符
% ---------------------------------------------
TotalFrame = 0;
for i = 1:size(frame_showfig_amount,2)
    TotalFrame = TotalFrame + frame_showfig_amount{i};
end
Font_Size_tl(1:TotalFrame)=18;%字体大小

text_left{1}='LLS';%不动的widefield
tl_scale_x1{1}(1:TotalFrame) = 0.3;%x的1 表示最右边
tl_scale_x2{1}(1:TotalFrame) = 0.3;
tl_scale_y{1}(1:TotalFrame) = 0.05;%y的1 表示最下边
tl_color{1}=[255 255 255]/255;%紫色[255,0,255]；绿色[0,255,0]；灰色[255,255,255]

text_left{2}='Conv. LLS-SIM';%右边的convSIM
tl_scale_x1{2}(1:TotalFrame) = 0.9;
tl_scale_x2{2}(1:TotalFrame) = 0.9;
tl_scale_y{2}(1:TotalFrame) = 0.05;%第一段文字的坐标
tl_color{2}=[255,255,255]/255;%紫色[255,0,255]；绿色[0,255,0]；灰色[255,255,255]

text_left{3}='Conv. LLS-SIM';%左边的convSIM
tl_scale_x1{3}(1:TotalFrame) = 0.3;
tl_scale_x2{3}(1:TotalFrame) = 0.3;
tl_scale_y{3}(1:TotalFrame) = 0.05;%第一段文字的坐标
tl_color{3}=[255,255,255]/255;%紫色[255,0,255]；绿色[0,255,0]；灰色[255,255,255]

text_left{4}='Iso. LLS-SIM';%动的convSIM
tl_scale_x1{4}(1:TotalFrame) = 0.9;
tl_scale_x2{4}(1:TotalFrame) = 0.9;
tl_scale_y{4}(1:TotalFrame) = 0.05;%第一段文字的坐标
tl_color{4}=[255,255,255]/255;%紫色[255,0,255]；绿色[0,255,0]；灰色[255,255,255]

% ---------------------------------------------
%                     时间参数
% ---------------------------------------------
frame_speed(1) = [1/7];%拍摄速度fps，2scyc=0.5fps，不管
frame_start = 0;%起始张数是0还是1，不管

frame_real(1:TotalFrame,1) = frame_start:1:(frame_start+TotalFrame-1);%真实的帧数，不管

tp_scale_x(1:TotalFrame)=0.01;%x的1 表示最右边
tp_scale_y(1:TotalFrame)=0.06;%y的1 表示最下边

Font_Size_time(1:TotalFrame)=16;%字符大小
Font_name='SansSerif';%字体，不管

% ---------------------------------------------
%                scalebar相关
% ---------------------------------------------
x_scale(1:TotalFrame) = 0.93;%[0~1] in real image, Far left is 0 default 0.903
y_scale(1:TotalFrame) = 0.93;%[0~1] in real image, uppermost is 0 default 0.95

LineWidth(1:TotalFrame,1) = 3;%线宽，单位pixel
pd_raw = 92.6 * 2/3;%
Font_Size_Sb(1:TotalFrame,1) = 16;%字体大小
x_scale_offset(1) = 0;%，不管
x_scale_offset(5) = 0.005;%，不管
bar_color = 'w';%，不管
text_visible = 'down';%'off'= non text,'up' = show up,'down' = show down ，不管
text_offset = 25;%文字跟bar间隔多远

% ---------------------------------------------
%                colorbar相关
% ---------------------------------------------
ColorBar_width = 20; %colorbar的宽度
ColorBar_height = 222; %colorbar的高度
ColorBar_pos = [1020,750]; %colorbar的位置

text_cb_fontsize = 10;

text_cb1 = '66s';%colorbar 上限
text_cb_x1 = 0.49;
text_cb_y1 = 0.73;

text_cb2 = '0s';%colorbar 上限
text_cb_x2 = 0.49;
text_cb_y2 = 0.95;
