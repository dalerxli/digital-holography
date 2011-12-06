function ImHurst = HurstSup(Ejs,tq)

s1 = size(Ejs,1);
s2 = size(Ejs,2);

rank_s1 = floor(s1*3/8):floor(s1*5/8);
rank_s2 = floor(s2*3/8):floor(s2*5/8);

Ejsm = mean(Ejs(rank_s1,rank_s2,:),1);
Ejsm = mean(Ejsm,2);
Ejsm = Ejsm(:);

plot(Ejsm)
ini = input('Primera escala: ');
fin = input('Última escala: ');
escalas = floor(ini):floor(fin);

ImHurst = HurstIM(Ejs,escalas,tq);