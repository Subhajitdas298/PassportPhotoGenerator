function BB = smart_face_detect(I, level)
% face detection

FDetect = vision.CascadeObjectDetector( ...
    'ClassificationModel','FrontalFaceLBP', ...
    'MinSize',[round(size(I, 1)/10), round(size(I, 2)/10)]);

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

if level >= 1
    % applying extra eye detection filtering for valid human face detection
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    BBEye=step(EyeDetect,I);
    
    BBNew = [[],[]];
    
    s = 1;
    for i = 1:size(BB,1)
        for j = 1: size(BBEye, 1)
            if BBEye(j, 1) >= BB(i, 1) && ...
                    BBEye(j, 2) >= BB(i, 2) && ...
                    BBEye(j, 1) + BBEye(j, 3) <= BB(i, 1) + BB(i, 3) && ...
                    BBEye(j, 2) + BBEye(j, 4) <= BB(i, 2) + BB(i, 4)
                
                BBNew(s,:) = BB(i, :);
                s = s + 1;
                
                break;
            end
        end
    end
    
    BB = BBNew;
end

end