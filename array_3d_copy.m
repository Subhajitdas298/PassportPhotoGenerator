function arr = array_3d_copy(oarr, inarr, x, y, z)
% Function to copy one smaller dimension 3d array to another

    r = size(inarr, 1);
    c = size(inarr, 2);
    d = size(inarr, 3);
    
    arr = oarr;
    arr(x:x+r-1, y:y+c-1, z:z+d-1) = inarr;
end