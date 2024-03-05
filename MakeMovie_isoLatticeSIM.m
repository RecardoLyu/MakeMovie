% v1 ���ʼ�汾

%%
close all;
clear, clc;
%%
test = [-3 10];%�������ֱַ��Ƕ����Ͷ���֡������һ�����ִ���1�ͽ���testģʽ
image_write = 1;%1�ͱ���ͼ������
save_size = [1200 768];% ���ձ����ͼ���С��wh(xy)���վ���ͱ�ʾԭʼ��С
fps = 20;%�����ٶ�
ColorMap = hot(256);
ReloadDataFlag = 1;

% section_all = [1 2 3 4];%��μ�����Ҫ�����Ǽ���section������test
section_all = [1 2 3 4];%��μ�����Ҫ�����Ǽ���section������test
%1��wf+con_SIM��Ȼ��wf��ɨ�����
%2�Ǵ�Con_SIM��ɨ����һ��DL-SIM��ͬʱ��ͼ�ƶ������
%3���������ʾ����ɫ���ϸ���߽磬�ұ���ʾ����һ֡�Ľṹ
%4��DL-SIMһֱ����,ͬʱ�Ҳ���ʾsubWindow��׷�ٹ켣

zoom_times = 1;
CropMode = 'c';%centerģʽ���ĸ����֣�ǰ2���������꣬��2��ROI������Ҳ��image-J��ȡ

MakeMovie_SetDataPath;
MakeMovie_DefineSection;
MakeMovie_DefineChar;

%% ���ݶ�ȡ,%�ö��ٸ��ļ����Ͷ�ȡ���ٸ���������ʱ��
if test(1)>0
    section_all=test(1);
    image_write=0;%������ͼ������
end

if ReloadDataFlag == 1
    %ȷ����Ҫ���ļ�
    file_need_all_temp=[];
    frame_raw_end_all=[];
    for section_ii = section_all
        file_need_all_temp=[file_need_all_temp,file_need{section_ii}];
        frame_raw_end_all=[frame_raw_end_all,frame_raw_end{section_ii}];
    end
    file_need=unique(file_need_all_temp(1,:));
    
    %��ȡ����
    data = cell(3,1);
    for i = file_need
        data{i} = XxReadTiffSmallerThan4GB(filePath{i});
    end
end

%%
frame_save_num = 1;%���ձ����¼���У��ǵڼ���ͼ
% frame_raw=1;%ԭʼ¼�����ǵڶ�����ͼ
if isempty(save_size)==1
    save_size = [Ny,Nx];
end

for section_ii = section_all    
    if test(1) > 0
        section_ii = test(1);
    end
    
    %ȷ��crop��Ϣ
    if numel(crop_info_temp{section_ii}) == 8 %��ʾ����
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
        % Section1 : wfˢ��convSIM
        % -----------------------------------------------------------
        if section_ii==1
            
            wf_data_adjust = imgintensity_cut(data{1}(:,:,frame_raw),inten_min{1}(frame_raw),inten_max{1}(frame_raw),gamma(1),1);%�Ҷȷֲ�0-1
            wf_data_adjust = img_crop(wf_data_adjust,crop_info(frame_showfig,:),CropMode,1);

            SIM_data_adjust = imgintensity_cut(data{2}(:,:,frame_raw),inten_min{2}(frame_raw),inten_max{2}(frame_raw),gamma(2),1);%�Ҷȷֲ�0-1
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
        % Section2 : convSIMˢ��isoSIM
        % -----------------------------------------------------------
        elseif section_ii == 2
            SIM_data_adjust = imgintensity_cut(data{2}(:,:,frame_raw),inten_min{2}(frame_raw),inten_max{2}(frame_raw),gamma(2),1);%�Ҷȷֲ�0-1
            SIM_data_adjust = img_crop(SIM_data_adjust,crop_info(frame_showfig,:),CropMode,1);
            
            iso_data_adjust = imgintensity_cut(data{3}(:,:,frame_raw),inten_min{3}(frame_raw),inten_max{3}(frame_raw),gamma(3),1);%�Ҷȷֲ�0-1
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
        elseif section_ii == 3 %DL-SIMһֱ����ͬʱС��׷��

            iso_data_adjust = imgintensity_cut(data{3}(:,:,frame_raw),inten_min{3}(frame_raw),inten_max{3}(frame_raw),gamma(3),1);%�Ҷȷֲ�0-1            
            [Ny, Nx] = size(iso_data_adjust);
            data_color = ColorMap(floor(iso_data_adjust(:)*255)+1,:);
            data_color = reshape(data_color,[Ny,Nx,3]);
            
            x1 = round(rect_pos(1) - rect_pos(3)/2);
            y1 = round(rect_pos(2) - rect_pos(4)/2) + 1;
            data_color = insertShape(data_color, 'Rectangle', [x1, y1, rect_pos(3), rect_pos(4)], 'Color', 'w', 'LineWidth', 1);
            data_color = img_crop(data_color,crop_info(frame_showfig,:),CropMode,1);
 
        % -----------------------------------------------------------
        % Section4 : С����������
        % -----------------------------------------------------------
        elseif section_ii == 4 %DL-SIMһֱ����ͬʱС��׷��
            
            iso_data_adjust = imgintensity_cut(data{3}(:,:,frame_raw),inten_min{3}(frame_raw),inten_max{3}(frame_raw),gamma(3),1);%�Ҷȷֲ�0-1
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
        
        % չʾ���ͼ��
        figure(frame_showfig)
        imshow(uint8(data_color*255),[],'Border','tight','InitialMagnification',100)%
%         set(gcf,'position',[300,50, save_size(1), save_size(2)]);%w h
        % ���ʱ��
        for time_num = 1
            text(tp_scale_x(frame_showfig)*Nx*zoom_times,tp_scale_y(frame_showfig)*Ny*zoom_times,{['Time = ',num2str(frame_real(frame_raw-frame_raw_begin{1}+1,time_num)/frame_speed(time_num),'%.2f sec')];['Frame = ',num2str(frame_real(frame_raw-frame_raw_begin{1}+1))]},'color',bar_color,'FontName',Font_name,'FontSize',Font_Size_time(frame_showfig),'FontWeight','bold')
            hold on
        end 
        
        for Sbar_num = 1
            % ���scale_bar
            Scale_bar(pd,length{section_ii}(frame_showfig,Sbar_num),LineWidth(frame_showfig,Sbar_num),Nx*zoom_times,Ny*zoom_times,(x_scale(frame_showfig)+x_scale_offset(Sbar_num)),y_scale(frame_showfig),bar_color,text_visible,Font_name,Font_Size_Sb(frame_showfig,Sbar_num),text_offset)%�Դ��Ӻ���
            hold on
        end
        
        % �������
        for Char_temp=1:numel(section_char{section_ii}(:,1)) %��ʾ������Ҫ��ʾ������
            Char_ii=section_char{section_ii}(Char_temp,1);%��ǰ��Ҫ��ʾ�Ƕ�����
            if frame_showfig >= section_char{section_ii}(Char_temp,2) && frame_showfig <= section_char{section_ii}(Char_temp,3)%��ʾ������������֡��������ʾ
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
                tif_info_temp.setTag(tif_info_struct);%��ֵͷ�ļ�
                tif_info_temp.write(frame_save);
                for save_11=1:first_frame_stop*fps-1
                    tif_info_temp=Tiff(file_output,'a');
                    tif_info_temp.setTag(tif_info_struct);%��ֵͷ�ļ�
                    tif_info_temp.write(frame_save);
                end
                close(figure(frame_showfig));
                tif_info_temp.close;
            else
                tif_info_temp=Tiff(file_output,'a');
                tif_info_temp.setTag(tif_info_struct);%��ֵͷ�ļ�
                tif_info_temp.write(frame_save);
                close(figure(frame_showfig));
                tif_info_temp.close;
            end
            frame_save_num=frame_save_num+1;
        end      
        
    end
    
end