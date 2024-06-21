function image_processing_tool()
    % Create the main figure window
    hFig = figure('Name', 'Image Processing Tool', 'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none', 'Position', [100, 100, 800, 600]);

    % Create a panel for buttons
    hPanel = uipanel('Title', 'Options', 'Position', [0.02, 0.1, 0.2, 0.8]);

    % Axes for displaying the image
    hAxes = axes('Parent', hFig, 'Position', [0.3, 0.1, 0.65, 0.8]);

    % Initialize empty variables for the image
    original_img = [];
    processed_img = [];

    % Create buttons
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Open Image', 'Position', [20, 420, 100, 30], 'Callback', @open_image);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Grayscale', 'Position', [20, 380, 100, 30], 'Callback', @convert_grayscale);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Blur', 'Position', [20, 340, 100, 30], 'Callback', @blur_image);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Sharpen', 'Position', [20, 300, 100, 30], 'Callback', @sharpen_image);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Increase Contrast', 'Position', [20, 260, 100, 30], 'Callback', @increase_contrast);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Edge Detection', 'Position', [20, 220, 100, 30], 'Callback', @edge_detection);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Feature Detection', 'Position', [20, 180, 100, 30], 'Callback', @feature_detection);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Rotate 90°', 'Position', [20, 140, 100, 30], 'Callback', @rotate_image);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Mirror', 'Position', [20, 100, 100, 30], 'Callback', @mirror_image);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Reset', 'Position', [20, 60, 100, 30], 'Callback', @reset_image);
    uicontrol(hPanel, 'Style', 'pushbutton', 'String', 'Save', 'Position', [20, 20, 100, 30], 'Callback', @save_image);

    % Function to open an image
    function open_image(~, ~)
        [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
        if isequal(file, 0)
            return;
        end
        original_img = imread(fullfile(path, file));
        processed_img = original_img;
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function to convert to grayscale
    function convert_grayscale(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        processed_img = rgb2gray(processed_img);
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function to check if the image is grayscale
    function is_gray = check_if_gray()
        is_gray = size(processed_img, 3) == 1;
    end

    % Function to blur the image
    function blur_image(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        if ~check_if_gray()
            errordlg('Please convert the image to grayscale first.');
            return;
        end
        processed_img = imgaussfilt(processed_img, 2);
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function to sharpen the image
    function sharpen_image(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        if ~check_if_gray()
            errordlg('Please convert the image to grayscale first.');
            return;
        end
        processed_img = imsharpen(processed_img);
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function to increase contrast
    function increase_contrast(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        if ~check_if_gray()
            errordlg('Please convert the image to grayscale first.');
            return;
        end
        processed_img = imadjust(processed_img);
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function for edge detection
    function edge_detection(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        if ~check_if_gray()
            errordlg('Please convert the image to grayscale first.');
            return;
        end
        choice = questdlg('Choose an edge detection method:', 'Edge Detection', 'Sobel', 'Canny', 'Sobel');
        switch choice
            case 'Sobel'
                processed_img = edge(processed_img, 'sobel');
            case 'Canny'
                processed_img = edge(processed_img, 'canny');
        end
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function for feature detection
    function feature_detection(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        if ~check_if_gray()
            errordlg('Please convert the image to grayscale first.');
            return;
        end
        choice = questdlg('Choose a feature detection method:', 'Feature Detection', 'Harris', 'SIFT', 'Harris');
        switch choice
            case 'Harris'
                points = detectHarrisFeatures(processed_img);
            case 'SIFT'
                points = detectSURFFeatures(processed_img);
        end
        imshow(processed_img, 'Parent', hAxes); hold on;
        plot(points.selectStrongest(50));
        hold off;
    end

    % Function to rotate the image by 90 degrees
    function rotate_image(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        processed_img = imrotate(processed_img, 90);
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function to mirror the image
    function mirror_image(~, ~)
        if isempty(processed_img)
            errordlg('Please open an image first.');
            return;
        end
        processed_img = fliplr(processed_img);
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function to reset the image to the original
    function reset_image(~, ~)
        if isempty(original_img)
            errordlg('No image to reset.');
            return;
        end
        processed_img = original_img;
        imshow(processed_img, 'Parent', hAxes);
    end

    % Function to save the image
    function save_image(~, ~)
        if isempty(processed_img)
            errordlg('No image to save.');
            return;
        end
        [file, path] = uiputfile({'*.jpg', 'JPEG'; '*.png', 'PNG'; '*.bmp', 'BMP'}, 'Save Image');
        if isequal(file, 0)
            return;
        end
        imwrite(processed_img, fullfile(path, file));
    end
end