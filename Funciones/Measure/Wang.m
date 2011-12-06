function [Q,CC,LD,CD,imgQ] = Wang(A,B,w)

sQ = size(A)-[w-1 w-1];
imgQ = zeros(sQ);
imgCC = zeros(sQ);
imgLD = zeros(sQ);
imgCD = zeros(sQ);

h = waitbar(0,'Procesando Q');
for kf = 1:sQ(1)
    for kc = 1:sQ(2)
        if nargout > 1
            [imgQ(kf,kc) imgCC(kf,kc) imgLD(kf,kc) imgCD(kf,kc)] = LittleWang(A(kf:kf+w-1),B(kf:kf+w-1));
        else
            imgQ(kf,kc) = LittleWang(A(kf:kf+w-1),B(kf:kf+w-1));
        end
    end
    waitbar(kf/sQ(1));pause(0.1)
end
close(h)

Q = mean2(imgQ);
CC = mean2(imgCC);
LD = mean2(imgLD);
CD = mean2(imgCD);