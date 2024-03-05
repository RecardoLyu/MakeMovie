%% 定义每个部分都有哪些效果以及相关参数

% -----------------------------------------------------------
% Section1 : wf+con_SIM，然后wf逐渐扫描减少
% -----------------------------------------------------------
first_frame_stop = 1;%第一张停多少秒。
file_need{1} = [1 2];%展示文件编号
frame_raw_begin{1} = 1;%这个规定了时间原点
frame_raw_end{1} = 1;%原始数据是那几张？
frame_showfig_amount{1} = 5*fps; %对应要产生多少张图，比上面的张数多的话，会自动匹配
section_char{1} = [1 1 0.6*frame_showfig_amount{1};
                   2 0.2*frame_showfig_amount{1} frame_showfig_amount{1}];%%第一段展示那几个字符,字符在后面几行123，每一行是一种，每一行的后两个数字是这个文字出现在fig多少张
line_endpoint1{1} = [1200,0];%这个坐标决定了横线还是竖线模式，横线模式第一个数字必然是0，竖线模式第二个数字必然是0
lindwidth_p{1} = 1;%中间线的线宽
crop_info_temp{1} = [603 384 1200 768];%行表示保持这个crop状态，两行为首位中间状态自动插值。side模式：直接从image-J读的四个参数(起始列，起始行，总列数，总行数)
length{1}(1:frame_showfig_amount{1}+1e2,1) = 3000;%scale_bar长度nm

% -----------------------------------------------------------
% Section2 : 从ConvSIM逐渐扫出来一个DL-SIM，同时大图移动到左边
% -----------------------------------------------------------
file_need{2} = [2 3];%展示文件编号
frame_raw_begin{2} = 1;
frame_raw_end{2} = 1;%原始数据是那几张？
frame_showfig_amount{2} = 5*fps; %对应要产生多少张图，比上面的张数多的话，会自动匹配
section_char{2} = [3 1 0.6*frame_showfig_amount{2};
                   4 0.2*frame_showfig_amount{2} frame_showfig_amount{2}];%%第一段展示那几个字符,字符在后面几行123，每一行是一种，每一行的后两个数字是这个文字出现在fig多少张
lindwidth_p{2} = 1;%中间线的线宽
line_endpoint1{2} = [1200,0];%这个坐标决定了横线还是竖线模式，横线模式第一个数字必然是0，竖线模式第二个数字必然是0
crop_info_temp{2} = [603 384 1200 768];%行表示保持这个crop状态，两行为首位中间状态自动插值。side模式：直接从image-J读的四个参数(起始列，起始行，总列数，总行数)
length{2}(1:frame_showfig_amount{2}+1e2,1) = 3000;%scale_bar长度nm

% -----------------------------------------------------------
% Section3 : DL-SIM zoom in 到一个小区域
% ----------------------------------------------------------- 
file_need{3} = [3];%展示文件编号，第一行是Lamp1，第二行是Rab11
frame_raw_begin{3} = 1;
frame_raw_end{3} = 1;%
frame_showfig_amount{3} = 3 * fps; %对应要产生多少张图
section_char{3} = [4 1 frame_showfig_amount{3}];%第一段展示那几个字符,字符在后面几行123，每一行是一种，每一行的后两个数字是这个文字出现在fig多少张
crop_info_temp{3} = [603 384 1200 768; 785 160 500 320];%行表示保持这个crop状态，两行为首位中间状态自动插值。side模式：直接从image-J读的四个参数(起始列，起始行，总列数，总行数)
rect_pos = crop_info_temp{3}(2,:);
% length{3}(1:frame_showfig_amount{3},1) = 3000;%scale_bar长度nm
length{3} = round_arbit(linspace(3000,1500,frame_showfig_amount{3}+1)',500);

% -----------------------------------------------------------
% Section4 : DL-SIM一直播放
% ----------------------------------------------------------- 
file_need{4} = [3];%展示文件编号，第一行是Lamp1，第二行是Rab11
frame_raw_begin{4} = frame_raw_end{3};
frame_raw_end{4} = 99;%
frame_showfig_amount{4} = 3 * (frame_raw_end{4}-frame_raw_begin{4}+1); %对应要产生多少张图
section_char{4} = [4 1 frame_showfig_amount{3}];%第一段展示那几个字符,字符在后面几行123，每一行是一种，每一行的后两个数字是这个文字出现在fig多少张
crop_info_temp{4} = [785 160 500 320];%行表示保持这个crop状态，两行为首位中间状态自动插值。side模式：直接从image-J读的四个参数(起始列，起始行，总列数，总行数)
length{4}(1:frame_showfig_amount{4}+1e2,1) = 1500;%scale_bar长度nm
