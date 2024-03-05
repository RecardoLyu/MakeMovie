% ---------------------------------------------
%                     �����ַ�
% ---------------------------------------------
TotalFrame = 0;
for i = 1:size(frame_showfig_amount,2)
    TotalFrame = TotalFrame + frame_showfig_amount{i};
end
Font_Size_tl(1:TotalFrame)=18;%�����С

text_left{1}='LLS';%������widefield
tl_scale_x1{1}(1:TotalFrame) = 0.3;%x��1 ��ʾ���ұ�
tl_scale_x2{1}(1:TotalFrame) = 0.3;
tl_scale_y{1}(1:TotalFrame) = 0.05;%y��1 ��ʾ���±�
tl_color{1}=[255 255 255]/255;%��ɫ[255,0,255]����ɫ[0,255,0]����ɫ[255,255,255]

text_left{2}='Conv. LLS-SIM';%�ұߵ�convSIM
tl_scale_x1{2}(1:TotalFrame) = 0.9;
tl_scale_x2{2}(1:TotalFrame) = 0.9;
tl_scale_y{2}(1:TotalFrame) = 0.05;%��һ�����ֵ�����
tl_color{2}=[255,255,255]/255;%��ɫ[255,0,255]����ɫ[0,255,0]����ɫ[255,255,255]

text_left{3}='Conv. LLS-SIM';%��ߵ�convSIM
tl_scale_x1{3}(1:TotalFrame) = 0.3;
tl_scale_x2{3}(1:TotalFrame) = 0.3;
tl_scale_y{3}(1:TotalFrame) = 0.05;%��һ�����ֵ�����
tl_color{3}=[255,255,255]/255;%��ɫ[255,0,255]����ɫ[0,255,0]����ɫ[255,255,255]

text_left{4}='Iso. LLS-SIM';%����convSIM
tl_scale_x1{4}(1:TotalFrame) = 0.9;
tl_scale_x2{4}(1:TotalFrame) = 0.9;
tl_scale_y{4}(1:TotalFrame) = 0.05;%��һ�����ֵ�����
tl_color{4}=[255,255,255]/255;%��ɫ[255,0,255]����ɫ[0,255,0]����ɫ[255,255,255]

% ---------------------------------------------
%                     ʱ�����
% ---------------------------------------------
frame_speed(1) = [1/7];%�����ٶ�fps��2scyc=0.5fps������
frame_start = 0;%��ʼ������0����1������

frame_real(1:TotalFrame,1) = frame_start:1:(frame_start+TotalFrame-1);%��ʵ��֡��������

tp_scale_x(1:TotalFrame)=0.01;%x��1 ��ʾ���ұ�
tp_scale_y(1:TotalFrame)=0.06;%y��1 ��ʾ���±�

Font_Size_time(1:TotalFrame)=16;%�ַ���С
Font_name='SansSerif';%���壬����

% ---------------------------------------------
%                scalebar���
% ---------------------------------------------
x_scale(1:TotalFrame) = 0.93;%[0~1] in real image, Far left is 0 default 0.903
y_scale(1:TotalFrame) = 0.93;%[0~1] in real image, uppermost is 0 default 0.95

LineWidth(1:TotalFrame,1) = 3;%�߿���λpixel
pd_raw = 92.6 * 2/3;%
Font_Size_Sb(1:TotalFrame,1) = 16;%�����С
x_scale_offset(1) = 0;%������
x_scale_offset(5) = 0.005;%������
bar_color = 'w';%������
text_visible = 'down';%'off'= non text,'up' = show up,'down' = show down ������
text_offset = 25;%���ָ�bar�����Զ

% ---------------------------------------------
%                colorbar���
% ---------------------------------------------
ColorBar_width = 20; %colorbar�Ŀ��
ColorBar_height = 222; %colorbar�ĸ߶�
ColorBar_pos = [1020,750]; %colorbar��λ��

text_cb_fontsize = 10;

text_cb1 = '66s';%colorbar ����
text_cb_x1 = 0.49;
text_cb_y1 = 0.73;

text_cb2 = '0s';%colorbar ����
text_cb_x2 = 0.49;
text_cb_y2 = 0.95;
