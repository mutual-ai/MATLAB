function [y,y1,y2, int1_out, int2_out, pint1, pint2]=fisherInfo(x,l1,l2,sig,int_vec, pint, pixelizeversion)
showim=0;
sig1=sig(1); sig2=sig(2);
int1_vec=int_vec(1,:);
int2_vec=int_vec(2,:);
pint1=pint(1,:);
pint2=pint(2,:);
% % % x=[-15:.01:25];

% % % % positions
% % % l1=0;
% % % l2=[0:.1:4,5.5, 7];

% % % sigma
% % sig1=1;
% % sig2=1;

lint1=length(int1_vec);
lint2=length(int2_vec);

% distribution of the intensities

% % % probfunction = 'exponential';

y=zeros(1,length(l2));
for ind_dist=1:length(l2)
    for ind_int1=1:lint1
        int1=int1_vec(ind_int1);
        for ind_int2=1:lint2
            int2=int2_vec(ind_int2); 
            p1 = pint1(ind_int1);
            p2 = pint2(ind_int2);
            f1=makeGauss(x,l1,sig1);
            f2=makeGauss(x,l2(ind_dist),sig2);
            %             y(ind_dist,ind_int2)=gFREMfunction(x,f1,f2, int1, int2,showim);            
            if and(int1==0, int2==0)
                y(ind_dist)=0;
            else
                y(ind_dist)=y(ind_dist)+p1*p2*gFREMfunction(x,f1,f2, int1, int2,showim, pixelizeversion);
                y(ind_dist)=y(ind_dist)+p1*p2*gFREMfunctionInd(x,f1,f2, int1, int2,showim, pixelizeversion);
            end
            if showim
                ylim([0,int1/(sqrt(2*pi)*sig1)+int2/(sqrt(2*pi)*sig2)])
                vline2(sig1*.61*2*pi/sqrt(2),'k--',{'Raleigh'}); % [Zhang et al., 2007]
                vline2(sig1*.47*2*pi/sqrt(2),'k--'); % [Zhang et al., 2007]
            end
            
        end
        y1(ind_int2)=gFREMfunction(x,f1,f2,int1,0);
        y2(ind_int2)=gFREMfunction(x,f1,f2,0,int2);
%         l{jj}=num2str(['int [' num2str([int1 int2]) ']']);
    end
end
int1_out=int1_vec; 
int2_out=int2_vec;
% % % l=[];
% plotdistance
