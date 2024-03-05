% v1 最初始版本

%%
close all;
clear, clc;
%%
test = [-3 10];%两个数字分别是段数和段内帧数，第一个数字大于1就进入test模式
image_write = 1;%1就保存图像数据
save_size = [1200 768];% 最终保存的图像大小，wh(xy)，空矩阵就表示原始大小
fps = 20;%播放速度
ColorMap = hot(256);
ReloadDataFlag = 1;

% section_all = [1 2 3 4];%这次计算需要计算那几个section，听从test
section_all = [1 2 3 4];%这次计算需要计算那几个section，听从test
%1是wf+con_SIM，然后wf逐渐扫描减少
%2是从Con_SIM逐渐扫出来一个DL-SIM，同时大图移动到左边
%3是左边逐渐显示出彩色框和细胞边界，右边显示出第一帧的结构
%4是DL-SIM一直播放,同时右侧显示subWindow和追踪轨迹

zoom_times = 1;
CropMode = 'c';%center模式：四个数字，前2定中心坐标，后2定ROI，数字也是image-J读取

MakeMovie_SetDataPath;
MakeMovie_DefineSection;
MakeMovie_DefineChar;

%% 数据读取,%用多少个文件，就读取多少个，减少用时。
if test(1)>0
    section_all=test(1);
    image_write=0;%不保存图像数据
end

if ReloadDataFlag == 1
    %确认需要的文件
    file_need_all_temp=[];
    frame_raw_end_all=[];
    for section_ii = section_all
        file_need_all_temp=[file_need_all_temp,file_need{section_ii}];
        frame_raw_end_all=[frame_raw_end_all,frame_raw_end{section_ii}];
    end
    file_need=unique(file_need_all_temp(1,:));
    
    %读取数据
    data = cell(3,1);
    for i = file_need
        data{i} = XxReadTiffSmallerThan4GB(filePath{i});
    end
end

%%
frame_save_num = 1;%最终保存的录像中，是第几张图
% frame_raw=1;%原始录像中是第多少张图
if isempty(save_size)==1
    save_size = [Ny,Nx];
end

for section_ii = section_all    
    if test(1) > 0
        section_ii = test(1);
    end
    
    %确定crop信息
    if numel(crop_info_temp{section_ii}) == 8 %表示两行
        crop_info=zeros(frame_showfig_amount{section_ii},4);
        for ii=1:4
            crop_info(:,ii)=linspace(crop_info_temp{section_ii}(1,ii),crop_info_temp{section_ii}(2,ii),frame_showfig_amount{section_ii});
        end   
    else
        crop_info = zeros(TotalFrame,4);
        for ii=1:4
            crop_info(:,ii) = crop_info_temp{section_ii}(:,ii);
        end
    end
    
    for frame_showfig = 1:frame_showfig_amount{section_ii}
        disp(['section',num2str(section_ii),' fig',num2str(frame_showfig)])
        if test(1)>0
            frame_showfig = test(2);
        end
        
        if frame_showfig_amount{section_ii}==1
            frame_raw = frame_raw_begin{section_ii};
        else
            frame_raw = interp1([1 frame_showfig_amount{section_ii}],[frame_raw_begin{section_ii} frame_raw_end{section_ii}],frame_showfig);
        end
        frame_raw = round(frame_raw);
        % -----------------------------------------------------------
        % Section1 : wf刷成convSIM
        % -----------------------------------------------------------
        if section_ii==1
            
            wf_data_adjust = imgintensity_cut(data{1}(:,:,frame_raw),inten_min{1}(frame_raw),inten_max{1}(frame_raw),gamma(1),1);%灰度分布0-1
            wf_data_adjust = img_crop(wf_data_adjust,crop_info(frame_showfig,:),CropMode,1);

            SIM_data_adjust = imgintensity_cut(data{2}(:,:,frame_raw),inten_min{2}(frame_raw),inten_max{2}(frame_raw),gamma(2),1);%灰度分布0-1
            SIM_data_adjust = img_crop(SIM_data_adjust,crop_info(frame_showfig,:),CropMode,1);
            
            line_x = interp1([1 frame_showfig_amount{section_ii}],[line_endpoint1{section_ii}(1) 1],frame_showfig);
            line_x = round(line_x);
            
            data_adjust = wf_data_adjust;
            data_adjust(:,1:line_x) = wf_data_adjust(:,1:line_x);
            data_adjust(:,line_x:end) = SIM_data_adjust(:,line_x:end);
            [Ny, Nx] = size(data_adjust);
            data_color = ColorMap(floor(data_adjust(:)*255)+1,:);
            data_color = reshape(data_color,[Ny,Nx,3]);
            data_color(:,line_x:line_x+lindwidth_p{section_ii}-1,:) = 1;
            data_color = imresize(data_color,[save_size(2) save_size(1)],'bicubic');
            
        % -----------------------------------------------------------
        % Section2 : convSIM刷成isoSIM
        % -----------------------------------------------------------
        elseif section_ii == 2
            SIM_data_adjust = imgintensity_cut(data{2}(:,:,frame_raw),inten_min{2}(frame_raw),inten_max{2}(frame_raw),gamma(2),1);%灰度分布0-1
            SIM_data_adjust = img_crop(SIM_data_adjust,crop_info(frame_showfig,:),CropMode,1);
            
            iso_data_adjust = imgintensity_cut(data{3}(:,:,frame_raw),inten_min{3}(frame_raw),inten_max{3}(frame_raw),gamma(3),1);%灰度分布0-1
            iso_data_adjust = img_crop(iso_data_adjust,crop_info(frame_showfig,:),CropMode,1);
            
            line_x = interp1([1 frame_showfig_amount{section_ii}],[line_endpoint1{section_ii}(1) 1],frame_showfig);
            line_x = round(line_x);
            
            data_adjust = SIM_data_adjust;
            data_adjust(:,1:line_x) = SIM_data_adjust(:,1:line_x);
            data_adjust(:,line_x:end) = iso_data_adjust(:,line_x:end);
            [Ny, Nx] = size(data_adjust);
            data_color = ColorMap(floor(data_adjust(:)*255)+1,:);
            data_color = reshape(data_color,[Ny,Nx,3]);
            data_color(:,line_x:line_x+lindwidth_p{section_ii}-1,:) = 1;
            
            
        % -----------------------------------------------------------
        % Section3 : zoom in
        % -----------------------------------------------------------
        elseif section_ii == 3 %DL-SIM一直播放同时小窗追踪

            iso_data_adjust = imgintensity_cut(data{3}(:,:,frame_raw),inten_min{3}(frame_raw),inten_max{3}(frame_raw),gamma(3),1);%灰度分布0-1            
            [Ny, Nx] = size(iso_data_adjust);
            data_color = ColorMap(floor(iso_data_adjust(:)*255)+1,:);
            data_color = reshape(data_color,[Ny,Nx,3]);
            
            x1 = round(rect_pos(1) - rect_pos(3)/2);
            y1 = round(rect_pos(2) - rect_pos(4)/2) + 1;
            data_color = insertShape(data_color, 'Rectangle', [x1, y1, rect_pos(3), rect_pos(4)], 'Color', 'w', 'LineWidth', 1);
            data_color = img_crop(data_color,crop_info(frame_showfig,:),CropMode,1);
 
        % -----------------------------------------------------------
        % Section4 : 小窗持续播放
        % -----------------------------------------------------------
        elseif section_ii == 4 %DL-SIM一直播放同时小窗追踪
            
            iso_data_adjust = imgintensity_cut(data{3}(:,:,frame_raw),inten_min{3}(frame_raw),inten_max{3}(frame_raw),gamma(3),1);%灰度分布0-1
            iso_data_adjust = img_crop(iso_data_adjust,crop_info(frame_showfig,:),CropMode,1);
            if frame_raw == 1
                ref = imhist(iso_data_adjust,1024);
            else
                iso_data_adjust = histeq(iso_data_adjust,ref);
            end
            
            [Ny, Nx] = size(iso_data_adjust);
            data_color = ColorMap(floor(iso_data_adjust(:)*255)+1,:);
            data_color = reshape(data_color,[Ny,Nx,3]);
            
        end
        
        [Ny, ~] = size(data_color);
        pd = pd_raw * Ny / save_size(2);
        data_color = imresize(data_color,[save_size(2) save_size(1)],'bicubic');
        [Ny, Nx, ~] = size(data_color);
        
        % 展示最初图像
        figure(frame_showfig)
        imshow(uint8(data_color*255),[],'Border','tight','InitialMagnification',100)%
%         set(gcf,'position',[300,50, save_size(1), save_size(2)]);%w h
        % 标记时间
        for time_num = 1
            text(tp_scale_x(frame_showfig)*Nx*zoom_times,tp_scale_y(frame_showfig)*Ny*zoom_times,{['Time = ',num2str(frame_real(frame_raw-frame_raw_begin{1}+1,time_num)/frame_speed(time_num),'%.2f sec')];['Frame = ',num2str(frame_real(frame_raw-frame_raw_begin{1}+1))]},'color',bar_color,'FontName',Font_name,'FontSize',Font_Size_time(frame_showfig),'FontWeight','bold')
            hold on
        end 
        
        for Sbar_num = 1
            % 标记scale_bar
            Scale_bar(pd,length{section_ii}(frame_showfig,Sbar_num),LineWidth(frame_showfig,Sbar_num),Nx*zoom_times,Ny*zoom_times,(x_scale(frame_showfig)+x_scale_offset(Sbar_num)),y_scale(frame_showfig),bar_color,text_visible,Font_name,Font_Size_Sb(frame_showfig,Sbar_num),text_offset)%自创子函数
            hold on
        end
        
        % 标记文字
        for Char_temp=1:numel(section_char{section_ii}(:,1)) %显示所有需要显示的文字
            Char_ii=section_char{section_ii}(Char_temp,1);%当前需要显示那段文字
            if frame_showfig >= section_char{section_ii}(Char_temp,2) && frame_showfig <= section_char{section_ii}(Char_temp,3)%表示这个文字在这个帧数可以显示
                text_x_ratio = interp1([1 frame_showfig_amount{section_ii}], [tl_scale_x1{Char_ii}(frame_showfig) tl_scale_x2{Char_ii}(frame_showfig)], frame_showfig);
                text_x = text_x_ratio * Nx * zoom_times;
                text_y = tl_scale_y{Char_ii}(frame_showfig) * Ny * zoom_times;
                text(text_x,text_y,text_left{Char_ii},'color',tl_color{Char_ii},'FontName',Font_name,'FontSize',Font_Size_tl(frame_showfig),'FontWeight','bold','HorizontalAlignment','center')
                hold on
            end
        end
        
        if test(1)>0, break; end
        
        if image_write==1
            %get(gcf,'Position')
            frame=getframe(gcf);
            %frame_save=rgb2gray(frame.cdata);
            frame_save=frame.cdata;
            
            [Nx,Ny,~,~]=size(frame_save);
            tif_info_struct.ImageLength=Nx; %y dim
            tif_info_struct.ImageWidth=Ny;  %x dim
            tif_info_struct.Photometric=Tiff.Photometric.RGB;
            tif_info_struct.BitsPerSample=8;%8
            tif_info_struct.SamplesPerPixel=3;%3
            tif_info_struct.SampleFormat=Tiff.SampleFormat.UInt;
            tif_info_struct.PlanarConfiguration=Tiff.PlanarConfiguration.Chunky;
            %tif_info_struct.Compression=Tiff.Compression.PackBits;
            tif_info_struct.Compression=Tiff.Compression.None;
            
            if frame_save_num==1
                tif_info_temp=Tiff(file_output,'w8');
                tif_info_temp.setTag(tif_info_struct);%赋值头文件
                tif_info_temp.write(frame_save);
                for save_11=1:first_frame_stop*fps-1
                    tif_info_temp=Tiff(file_output,'a');
                    tif_info_temp.setTag(tif_info_struct);%赋值头文件
                    tif_info_temp.write(frame_save);
                end
                close(figure(frame_showfig));
                tif_info_temp.close;
            else
                tif_info_temp=Tiff(file_output,'a');
                tif_info_temp.setTag(tif_info_struct);%赋值头文件
                tif_info_temp.write(frame_save);
                close(figure(frame_showfig));
                tif_info_temp.close;
            end
            frame_save_num=frame_save_num+1;
        end      
        
    end
    
end