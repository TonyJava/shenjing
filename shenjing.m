n=10;
s=sqrt(0.43*n+0.12+2.54*n+0.77+0.35)+0.51;
count=0;delta=1;
%定义训练样本
%p为输入矢量 2005年-2012年数据
p=[6977.93 24647 11356.6 9772.5 1496.92 4279.65 89.84 95.97 9194 0.6068;...
7973.37 28534 13469.77 11585.82 1618.27	5271.991 100.28 111.16 9442 0.63;...
9294.26	33272 16004.61 14076.83	1707.98	6341.86	117.78 130.22 9660 0.6314;...
10868.67 37638 18502.2 16321.46 1790.97	6849.688 134.77 125.56 9893 0.6337;...
12933.12 39436 19419.7 18052.59	1855.73	6110.941 86.04 119.81 10130	0.634;...
15623.7	44736 23014.53 20711.55 1948.06	7848.961 151.59 187.08 10441 0.6618;...
17069.2	50807 26447.38 24097.7 2006.92 9134.673	177.79 202.12 10505	0.665;...
18751.47 54095 27700.97	26519.69 2037.88 9840.205 195.18 282.05 10594 0.674];
%t为目标矢量
t=[2673.5356 2991.0529 3393.0057 3504.8229 3609.4029 4060.1257 4399.0168 4619.4102 4830.1315];

N=length(tt);
t=tt;p=pp';
while(abs(delta)>0.03)   %预测误差精度设置，为3%
%premnmx函数用于将网络的输入数据或输出数据进行归一化，归一化后的数据将分布在[-1,1]区间内
% 2005年-2012年数据为训练测试网络数据
[pn,minp,maxp,tn,mint,maxt]=premnmx(p(:,1:8),t(1:8));
dx=ones(n,1)*[-1,1];
%初始化BP神经网络
net=newff(dx,[10,1],{'tansig','purelin'},'traingdx'),
net.trainParam.show=1000;%每次循环1000次
net.trainParam.Lr=0.05;  %神经网络学习率
net.trainParam.epoch=50000; %最大循环50000次
net.trainParam.goals=1e-4;  %期望目标误差最小值
[net,tr]=train(net,pn,tn);   %对网络进行反复训练
an=sim(net,pn);  %对神经网络进行仿真
a=postmnmx(an,mint,maxt);%进行反归一化还原成原始的数据
pnewn=tramnmx(p(:,9:11),minp,maxp);%进行同样的归一化变换
anewn=sim(net,pnewn);  %进行仿真
anew=postmnmx(anewn,mint,maxt); %进行反归一化还原成原始的数据
delta=(anew(1)-t(9))/t(9);  %检验训练的神经网络，以2013年为检验网络数据
count=count+1;
end
plot([2013:2015],anew,[2005:2013],t);  %输出2013年-2015年预测值