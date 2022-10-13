function [FNN] = f_fnn(x,tao,mmax,rtol,atol)
%x : time series
%tao : time delay
%mmax : maximum embedding dimension
%reference:M. B. Kennel, R. Brown, and H. D. I. Abarbanel, Determining
%embedding dimension for phase-space reconstruction using a geometrical 
%construction, Phys. Rev. A 45, 3403 (1992). 
%author:"Merve Kizilkaya"
%rtol=15
%atol=2;
N=length(x);
Ra=std(x,1);

for m=1:mmax
   % fprintf('Current Dim = %d\n', m);
%     M=N-m*tao; 
%     Y=psr_deneme(x,m,tao,M);    
    M=N-(m-1)*tao;         
    Y=psr_deneme(x,m,tao);    
    
%     [r,c]=size(Y);
%     fprintf('R = %d, C= %d\n', r, c)    
    
    tfnn(m,1)=0; 
    %tfnn = zeros(m,1);% updated by PKT
    %size(Y)
    for n=1:M        
        y0=ones(M,1)*Y(n,:);
        distance=sqrt(sum((Y-y0).^2,2));
        [neardis nearpos]=sort(distance);
                
        D=abs(Y(n,m)-Y(nearpos(2),m)); % 동등  %D=abs(x(n+m*tao)-x(nearpos(2)+m*tao));
        R=sqrt(D.^2+neardis(2).^2);
        if D/neardis(2) > rtol || R/Ra > atol
             tfnn(m,1)=tfnn(m,1)+1;
        end

    end
end

FNN=(tfnn./tfnn(1,1))*100;
% figure
% plot(1:length(FNN),FNN)
% grid on;
% title('Minimum embedding dimension with false nearest neighbours')
% xlabel('Embedding dimension')
% ylabel('The percentage of false nearest neighbours')

function Y=psr_deneme(x,m,tao,npoint)
%Phase space reconstruction
%x : time series 
%m : embedding dimension
%tao : time delay
%npoint : total number of reconstructed vectors
%Y : M x m matrix
% author:"Merve Kizilkaya"
N=length(x);
if nargin == 4
    M=npoint;
else
    M=N-(m-1)*tao;
end

Y=zeros(M,m); 
%si = [1:tao:m*tao];
for i=1:m
    Y(:,i)=x((1:M)+(i-1)*tao)';
     %Y(:,i)=x(si(1,i):si(1,i)+M-1,1);
end