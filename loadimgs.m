function img_files = loadimgs(img_path)

imgset = imageDatastore(img_path, 'Includesubfolders', true, 'FileExtensions', '.jpg', 'LabelSource', 'foldernames');
img_files = imgset.Files;
end
