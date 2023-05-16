function img = pict_rotate(img)
if size(img, 1) > size(img, 2)
    img(:,:,1)';
    img(:,:,2)';
    img(:,:,3)';
end