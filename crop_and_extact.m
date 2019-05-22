function [img_fourier, fground, C, P, I, height] = crop_and_extact(imgset, crop_area, descriptors_num)
%img_fourier is the Fourier descriptor
%fground is the area of shape
%C is the compactness of the region
%P is the perimeter of the region
%I is the irregularity of the region
%imgset is the input images
%crop_area is the size being cropped 

for img = 1: length(imgset)
    Img = imread(string(imgset(img)));
    img_cropped = imcrop(Img, crop_area);    
    
    %rgb to lab
    Img_lab = rgb2lab(img_cropped);
    %rgb to gray
    img_cropped = rgb2gray(img_cropped);

    %1st dimension is the light, 2nd and 3rd is the color
    Img1 = Img_lab(:, :, 1);
    Img2 = Img_lab(:, :, 2: 3);
    Img2 = reshape(Img2, numel(Img1), 2);
    %only classify gereen and not green
    classes = 2;
    [Idx, ~] = kmeans(Img2, classes, 'distance', 'sqEuclidean', 'Replicates', 2);
    
	img2_clr = reshape(Idx, length(Img1(:, 1, 1)), length(Img1(1, :, 1)));

    for i = 1: classes
        
        %different class set to white (255)
        img_cropped(find(img2_clr ~= i)) = 255;
        %same class set to black (0)
        img_cropped(find(img2_clr == i)) = 0;
        
        %judge whether the backgrund is the same class
        idx = (img2_clr(1, 1) == i);
        
        img_smbg(:, :, idx + 1) = img_cropped;
    end
    
    %choose background to be white, foreground to be black
    img_binary = img_smbg(:, :, 1);
    %imshow(img_temp)
    
    [row, col] = find(img_binary == 0);
    
    %fing the minimal pixel position of the foreground
    row_edgemin = min(row);
    row_edgemax = max(row);
    col_edgemin = min(col);
    col_edgemax = max(col);
    
    %height of people
    height = row_edgemin;
    
    %crop the image to be 25 pixels more in the left and right of the foreground
    crop_area2 = [col_edgemin - 25, 0, col_edgemax - col_edgemin + 50, crop_area(4)];
    img_crop_crop = imcrop(img_binary, crop_area2);
    
    for i = row_edgemin: size(img_crop_crop, 1)
        col = [];
        for j = 1: length(img_crop_crop(i, :))
            if img_crop_crop(i, j) == 0
                col = [col, j];
            end
        end
        leftedge = min (col);
        rightedge = max(col);
        img_crop_crop(i, leftedge: rightedge) = 0;
    end
    
    %get the contour of the shape
    img_contour = imcontour(img_crop_crop);
    A = 0;
    for i = 1: size(img_crop_crop, 1)
        for j = 1: size(img_crop_crop, 2)
            if img_crop_crop(i, j) ~= 255
                A = A + 1;
            end
        end
    end
    
    pixel_all = (crop_area(3) + 25 * 2) / 2 * crop_area(4) * 3;
    %area the of shape
    fground(img)=A / pixel_all;
    
    %perimeter
    P(img) = length(img_contour(1, :));
    
    % irregularity
    m1=mean(img_contour(1, :));
    m2=mean(img_contour(2, :));
    I0 = max((img_contour(1, :) - m1) .^ 2 + (img_contour(2, :) - m2) .^ 2);
    I(img) = pi .* I0 ./ fground(img);
    
    %compactness
    C(img)= 4 * pi * fground(img) / (P(img)^2);
    
    %make sure N is an even number in function 'fourierdescriptor'
    %Referencfe: https://stackoverrun.com/cn/q/2622411
    if mod(size(img_contour, 2), 2) ~= 0
        img_contour = [img_contour, img_contour(:, end)];
    end
    
    %Fourier descriptor
    %Referencfe: https://stackoverrun.com/cn/q/2622411
    descriptors = fourierdescriptor(img_contour');
    img_fourier(img, :) = getsignificativedescriptors(descriptors, descriptors_num);
end


end
