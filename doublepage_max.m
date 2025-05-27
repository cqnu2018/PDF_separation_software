clc; clear;
%*************参数配置开始*************/
pdf_input_dir = fullfile(pwd, '1_PDF_[原始]');       % PDF 原始文件目录
pdf_output_dir = fullfile(pwd, '2_黑彩分离_[结果]'); % 导出目录
pdf_output_control = 1;        % 是否导出 PDF
image_convert_control = 1;     % 是否将 PDF 转为图片
delete_control = 1;            % 是否删除中间图像
%*************参数配置结束*************/
% 检查输入输出(pdf_input_dir, 'dir')
if ~exist(pdf_input_dir, 'dir')
    mkdir(pdf_input_dir);
end
if ~exist(pdf_output_dir, 'dir')
    mkdir(pdf_output_dir);
end
% 检查注册码，从“注册码.txt”中读取license_code
license_file = fullfile(pwd, '注册码.txt');
if exist(license_file, 'file')
    fid = fopen(license_file, 'r');
    line = fgetl(fid);
    fclose(fid);
    if ischar(line)
        license_code = strtrim(line);
        fprintf('对已读取注册码：%s\n', license_code);
    else
        warning('️“注册码.txt” 内容为空，视为未注册。');
        license_code = '';
    end
else
    warning('未找到“注册码.txt”，视为未注册。');
    license_code = '';
end

% 获取所有 PDF 文件
pdfFiles = dir(fullfile(pdf_input_dir, '*.pdf'));
for k = 1:length(pdfFiles)
    pdfName = pdfFiles(k).name;
    [~, nameNoExt, ~] = fileparts(pdfName);
    disp(['====== 开始处理文件：', pdfName, ' ======']);
    % 路径配置
    pdfPath = fullfile(pdf_input_dir, pdfName);
    outputDir = fullfile(pdf_output_dir, nameNoExt);     % 每个 PDF 一个输出子文件夹
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    imgDir = fullfile(outputDir, 'gs_images');
    if ~exist(imgDir, 'dir')
        mkdir(imgDir);
    end
    process_single_pdf(pdfPath, outputDir, pdf_output_control, image_convert_control, delete_control,license_code);
end
disp('√所有PDF 文件处理完毕。');
