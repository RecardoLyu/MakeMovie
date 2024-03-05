%% 设定每个输入文件的路径

DataPath = 'G:\QCFile\MatlabWork\MakeMovie_isoLattice_Lifeact\Data\';
file_output=[DataPath '\Movie-section-' replace(num2str(section_all),'  ','-') '.tif'];

gamma = zeros(6,1);
filePath{1} = [DataPath 'WF_MIP.tif'];
inten_min{1}(1:2000) = 0;
inten_max{1}(1:2000) = 65535;
gamma(1) = 1;
RGB{1} = [1,1,1];%色

filePath{2} = [DataPath 'ConvLatticeSIM_MIP_gsFilter1.tif'];
inten_min{2}(1:2000) = 0;
inten_max{2}(1:2000) = 65535;
gamma(2) = 1;
RGB{2} = [1,1,1];%色

filePath{3} = [DataPath 'IsoLatticeSIM_MIP_Reg_Delete36.tif'];
inten_min{3}(1:2000) = 0;
inten_max{3}(1:2000) = 65535;
gamma(3) = 1;
RGB{3} = [1,1,1];%色