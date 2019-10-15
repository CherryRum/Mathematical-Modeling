tic
sheet_1 = xlsread('1111.xlsx','附件1');
sheet_2 = xlsread('1111.xlsx','附件2');%初始化数据

houdu = [0.6 10 3.6 5.6];
time_end = 3600;%终止时间
Tem_r = sheet_2(:,2);%获取右边界温度
kappa = sheet_1(:,3);
step_t = 0.001;
step_x = 0.0002;
step_x_10000 = step_x*1000;
houdu = [0.6 6 3.6 5];
max_hou = sum(houdu)
num_x = ceil(max_hou/step_x_10000)-1
xishu = [];
for i = 1:4
    xishu(i) = fix(houdu(i)/step_x_10000)-1;
end
k = sheet_1(:,5);
k_lisan = horzcat(ones(1,(xishu(1)))*k(1),k(1)+k(2),ones(1,(xishu(2)))*k(2), k(2)+k(3),ones(1,(xishu(3)))*k(3),k(3)+k(4),ones(1,(xishu(4)))*k(4));

t_raw = 0:time_end;
U_r1 = Tem_r(1:time_end+1);
t = 0:step_t:time_end;
U_r1 = interp1(t_raw,U_r1,t);
U = zeros(int64(time_end/step_t)+1,num_x+1);
U(:,1) = ones(1,int64(time_end/step_t)+1)*(num_x-1);
U(1,2:num_x)=37;

for i=1:1:time_end/step_t
    temp = U(i,3:num_x+1) + U(i,1:num_x-1) - U(i,2:num_x)*2;%
    id_temp = find(temp<0);
    temp(id_temp) = 0;
    U(i+1,2:num_x) = U(i,2:num_x) + k_lisan.*step_t./(step_x*step_x).*temp;
    U(i+1,[4,34,52]) = [(kappa(2)*U(i+1,3)+kappa(1)*U(i+1,5))/(kappa(2)+kappa(1)),(kappa(3)*U(i+1,33)+kappa(2)*U(i+1,35))/(kappa(3)+kappa(2)),(kappa(4)*U(i+1,51)+kappa(3)*U(i+1,53))/(kappa(4)+kappa(3))];
end

x = (1:num_x+1)*0.2;
y = 0:time_end;
U = U(y*1000+1,:);
[X,Y] = meshgrid(x,y);
figure
% xlabel('X');ylabel('Y');zlabel('Z')
mesh(X,Y,U)
% contourf(X,Y,U,'LineStyle','none')

colorbar
%save('U_x_t.mat','U')

toc