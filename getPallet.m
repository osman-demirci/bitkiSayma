clear all;
close all;
clc;

dataYolu = fullfile('data', '*.jpg');
okunanResimler = dir(dataYolu);
resimAdlari = {okunanResimler.name};
resimSayisi = numel(resimAdlari);

for im=1:resimSayisi;
    IC = imread(fullfile('data', resimAdlari{im}));
    secenek=1;
    durma=0;
    secIslem=1;
    while durma==0;
        CI = IC(1:size(IC,1)/2,1:size(IC,2)/2,:);
        for i=1:size(CI,1);
            for k=1:size(CI,2);
                if secenek==1;
                    if CI(i,k,1)<125 && CI(i,k,2)<125 && CI(i,k,3)<125;
                        CI(i,k,1)=10;
                        CI(i,k,2)=10;
                        CI(i,k,3)=10;
                    else
                        CI(i,k,1)=255;
                        CI(i,k,2)=255;
                        CI(i,k,3)=255;
                    end
                elseif secenek==2;
                    if CI(i,k,1)<105 && CI(i,k,2)<105 && CI(i,k,3)<105;
                        CI(i,k,1)=10;
                        CI(i,k,2)=10;
                        CI(i,k,3)=10;
                    else
                        CI(i,k,1)=255;
                        CI(i,k,2)=255;
                        CI(i,k,3)=255;
                    end

                elseif secenek==3;
                    if CI(i,k,1)<100 && CI(i,k,2)<100 && CI(i,k,3)<100;
                        CI(i,k,1)=10;
                        CI(i,k,2)=10;
                        CI(i,k,3)=10;
                    else
                        CI(i,k,1)=255;
                        CI(i,k,2)=255;
                        CI(i,k,3)=255;
                    end
                elseif secenek==4;
                    if CI(i,k,1)<90 && CI(i,k,2)<90 && CI(i,k,3)<90;
                        CI(i,k,1)=10;
                        CI(i,k,2)=10;
                        CI(i,k,3)=10;
                    else
                        CI(i,k,1)=255;
                        CI(i,k,2)=255;
                        CI(i,k,3)=255;
                    end
                end
            end
        end

        I=im2bw(CI);
        str = strel('square',6);
        I = imerode(I,str);
        I= bwareaopen(~I,100);
        I= bwareaopen(~I,100);
        refBul=0;
        izin1=0;
        for i=1:size(I,2);
            for k=1:size(I,1);
                if I(k,i)==0 && izin1==0;

                    dongu=0;
                    pikselHesapla=0;
                    c=0;
                    izin=0;
                    while dongu==0;
                        if I(k+c,i+10)==0 && izin==0; 
                            c=c+1;
                        elseif I(k+c,i+10)==1 && izin==0;
                            izin=1;
                            c=c-1;
                        elseif I(k+c,i+10)==0 && izin==1;
                            pikselHesapla = pikselHesapla + 1;
                            c=c-1;
                        elseif I(k+c,i+10)==1 && izin==1;
                            m0=k+(c+1);
                            izin=2;
                            dongu=1;
                        end
                    end

                    m0=m0 + round(pikselHesapla/3);
                    n0=i+ round(pikselHesapla/3);
                    izin3=0;
                    for s=n0:size(I,2);
                        if I(m0,s)==1 && izin3==0;
                            izin3=1;
                        elseif I(m0,s)==0 && izin3==1;
                            refBul=1;
                            izin3=2;
                        end
                    end

                    izin3=0;
                    mt=m0;
                    if refBul==0;
                        for t=mt:size(I,1);
                            if I(t,n0)==1 && izin3==0;
                                refKareOlcu=t-mt;
                                refBul=1;
                                mH=refKareOlcu*(3);
                                mH=round(mH)-1;
                                m0=m0+mH;
                                izin3=1;
                                refBul=2;
                            end
                        end
                    end

                    izin2=0;
                    if refBul==1;
                        for p=n0:size(I,2);
                            if I(m0,p)==1 && izin2==0;
                                izin2=1;
                            elseif I(m0,p)==0 && izin2==1;
                                mBaslangic=p;
                                izin2=2;
                            elseif I(m0,p)==1 && izin2==2;
                                mBitis=p;
                                izin2=3;
                            end
                        end
                    end

                    izin2=0;
                    if refBul==2;
                        for p=n0:size(I,2);
                            if I(m0,p)==0 && izin2==0;
                                mBaslangic=p;
                                izin2=1;
                            elseif I(m0,p)==1 && izin2==1;
                                mBitis=p;
                                izin2=2;
                            end
                        end
                    end

                    izin1=1;
                end
            end
        end

        kaymaOlcu=(mBitis-mBaslangic)/2;
        kaymaOlcu=round(kaymaOlcu);
        izin1=0;

        for i=n0:size(I,2);
            if I(m0,i)==1 && izin1==0;
                izin1=1;
            elseif I(m0,i)==0 && izin1==1;
                izin1=2;
            elseif I(m0,i)==1 && izin1==2;
                n1=i-kaymaOlcu;
                izin1=3;
            elseif I(m0,i)==0 && izin1==3;
                izin1=4;
            elseif I(m0,i)==1 && izin1==4;
                izin1=5;
            elseif I(m0,i)==0 && izin1==5;
                izin1=6;
            elseif I(m0,i)==1 && izin1==6;
                n01=i+kaymaOlcu;
                izin1=7;
            elseif I(m0,i)==0 && izin1==7;
                izin1=8;
            elseif I(m0,i)==1 && izin1==8;
                izin1=9;
            elseif I(m0,i)==0 && izin1==9;
                izin1=10;
            elseif I(m0,i)==1 && izin1==10;
                izin1=11;
            elseif I(m0,i)==0 && izin1==11;
                izin1=12;
            elseif I(m0,i)==1 && izin1==12;
                izin1=13;
            elseif I(m0,i)==0 && izin1==13;
                n3=i+kaymaOlcu;
                izin1=14;
            end
        end

        if izin1==14;
            durma=1;
        else
            secIslem=secIslem+1;
        end

        if secIslem==2;
            secenek=2;
        elseif secIslem==3;
            secenek=3;
        elseif secIslem==4;
            secenek=4;
        end
    end

    izin1=0;
    i=m0;

    while izin1<3;
        if I(i,n01)==0 && izin1==0;
            izin1=1;
        elseif I(i,n01)==1 && izin1==1;
            izin1=2;
        elseif I(i,n01)==0 && izin1==2;
            m1=i-kaymaOlcu;
            izin1=3;
        end
        i=i-1;
    end

    izin1=0;
    i=m0;
    while izin1<6;
        if I(i,n01)==0 && izin1==0;
            izin1=1;
        elseif I(i,n01)==1 && izin1==1;
            izin1=2;
        elseif I(i,n01)==1 && izin1==2;
            izin1=3;
        elseif I(i,n01)==0 && izin1==3;
            izin1=4;
        elseif I(i,n01)==1 && izin1==4;
            izin1=5;
        elseif I(i,n01)==0 && izin1==5;
            m2=i+kaymaOlcu;
            izin1=6;
        end
        i=i+1;
    end

    CIP =IC(m1:m2, n1:n3,:);
    CIP = imresize (CIP, [400 600]);
    imwrite(CIP, fullfile('paletler', resimAdlari{im}))
end
%Palet bulma son
