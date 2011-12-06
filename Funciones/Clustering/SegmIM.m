function SegmIM(IM,cl)

close all
v = IM(:);

[n xout] = hist(v,500);

N = length(v);

idx = kmeans(v,cl);

figure, bar(xout,n);
hold on;

for i = 1:cl
    medias(i) = mean(v(idx==i));
    vars(i) = var(v(idx==i));
    priori(i) = sum(idx==i);
    g(i,1:500) = exp(-(xout-medias(i)).^2/2/vars(i));
    ind = find(xout >= medias(i),1,'first');
    g(i,1:500) = g(i,1:500) * n(ind);
    hold on
    plot(xout,g(i,:),'linewidth',2)
    IM(idx==i) = medias(i);
end
figure
imagesc(IM)
colormap('hot')