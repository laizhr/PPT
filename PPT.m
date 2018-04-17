function [daily_port]=PPT(close_price,data,tplus1,daily_port, win_size)
%{
This function is the main code for the Peak Price Tracking (PPT)[1]
system. It aggressively tracks the increasing power of different assets
such that the better performing assets will receive more investment.

For any usage of this function, the following papers should be cited as
reference:

[1] Zhao-Rong Lai, Dao-Qing Dai, Chuan-Xian Ren, and Ke-Kun Huang. ¡°A peak price tracking 
based learning system for portfolio selection¡±, 
IEEE Transactions on Neural Networks and Learning Systems, 2017. Accepted.
[2] Zhao-Rong Lai, Dao-Qing Dai, Chuan-Xian Ren, and Ke-Kun Huang.  ¡°Radial basis functions 
with adaptive input and composite trend representation for portfolio selection¡±, 
IEEE Transactions on Neural Networks and Learning Systems, 2018. Accepted.
[3] Pei-Yi Yang, Zhao-Rong Lai*, Xiaotian Wu, Liangda Fang. ¡°Trend Representation 
Based Log-density Regularization System for Portfolio Optimization¡±,  
Pattern Recognition, vol. 76, pp. 14-24, Apr. 2018.

At the same time, it is encouraged to cite the following papers with previous related works:

[4] J. Duchi, S. Shalev-Shwartz, Y. Singer, and T. Chandra, ¡°Efficient
projections onto the \ell_1-ball for learning in high dimensions,¡± in
Proceedings of the International Conference on Machine Learning (ICML 2008), 2008.
[5] B. Li, D. Sahoo, and S. C. H. Hoi. Olps: a toolbox for on-line portfolio selection.
Journal of Machine Learning Research, 17, 2016.


Inputs:
close_price               -close price sequences
data                      -data with price relative sequences
tplus1                    -t+1
daily_port                -selected portfolio at time t
win_size                  -window size


Output:
daily_port                -selected portfolio at time t+1

%}
epsilon=100; %a parameter that controls the update step size


nstk=size(data,2);

if tplus1<win_size+1
    x_tplus1=data(tplus1,:);
else
   closebefore=close_price((tplus1-win_size+1):(tplus1),:);
   closepredict=max(closebefore);
   x_tplus1 = closepredict./close_price(tplus1,:);
end

onesd=ones(nstk,1);
x_tplus1_cent=(eye(nstk)-onesd*onesd'/nstk)*x_tplus1';

if norm(x_tplus1_cent)~=0
daily_port = daily_port+ epsilon*x_tplus1_cent/norm(x_tplus1_cent);
end

daily_port = simplex_projection_selfnorm2(daily_port,1);

end
