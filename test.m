% 读取视频文件  
videoFile = 'path/to/your/video.avi';  
video = videoread(videoFile);

% 初始化光流场计算  
[H, W] = size(video);  
flow = calculateOpticalFlow(video, 'Harris', 'Gray');

% 设定跟踪阈值  
threshold = 100;

% 遍历视频帧并进行目标检测和跟踪  
for frameIdx = 1:length(video)  
    % 提取当前帧的光流场  
    flowFrame = flow(frameIdx);  
      
    % 应用阈值处理  
    _, flowMask = im2bw(double(flowFrame), threshold);  
      
    % 查找轮廓  
    contours = bwcontours(flowMask);  
      
    % 初始化跟踪目标列表  
    objectTracks = cell(1, 1);  
      
    % 遍历每个轮廓并进行跟踪  
    for contourIdx = 1:length(contours)  
        % 获取轮廓边界框  
        bbox = bbox(contours(contourIdx));  
          
        % 初始化跟踪对象  
        track = [bbox, frameIdx];  
          
        % 检查是否需要继续跟踪  
        if ismember(track, objectTracks, 'trackIdx')  
            % 更新跟踪对象的位置和时间  
            track(end+1) = [bbox, frameIdx];  
        else  
            % 将新对象加入跟踪列表  
            objectTracks{end+1} = track;  
        end  
    end  
      
    % 显示当前帧和跟踪结果  
    imshow(video(frameIdx));  
    hold on;  
    for i = 1:length(objectTracks)  
        % 画出跟踪对象的边界框  
        rectangle('Position', objectTracks{i}(1:2), 'EdgeColor', 'g', 'LineWidth', 2);  
    end  
     hold off;  
      
    % 暂停一下，以便观察  
    pause(0.1);  
end

% 保存跟踪结果为视频文件  
outputFile = 'path/to/output/video.avi';  
videoWriter = v422write(outputFile, video.Fnum, video.Fscale, video.Frames);  
for frameIdx = 1:length(video)  
    % 将帧和跟踪结果写入新视频  
    videoWriter(frameIdx) = video(frameIdx);  
    for i = 1:length(objectTracks)  
        % 画出跟踪对象的边界框  
        rectangle('Position', objectTracks{i}(1:2), 'EdgeColor', 'g', 'LineWidth', 2);  
    end  
end  
videoWriter.Close();  
