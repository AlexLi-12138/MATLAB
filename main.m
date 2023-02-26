%%-------------------------------------------------------------------------
%%2022.07.15
%%read data from test.out
%%https://blog.csdn.net/a386115360/article/details/106811557
%%主要运用的函数：strncmp   strfind
%%-------------------------------------------------------------------------
clear;close all
%%  OpenFile
file_name = '.\v_m-1.out';
fid = fopen(file_name); % Open File fid是文件的标号，用于之后的提取
item = 0; flag2=0;
while 1
    tline = fgetl(fid);
    if feof(fid)    %%最后一行会跳出循环
        break;
    end
    %% 提取每一大块的信息
    if strncmp(tline,' ********** VOLUME- AND MASS-BALANCES',37)
        item = item + 1;
    end
    %%提取time
%     if contains(tline,'THE TIME IS  ')        %%筛 seconds
%         temp = strfind(tline,'THE TIME IS  ');
%         data(item).time = tline(temp+13:temp+23);
%     end
    if contains(tline,'THE TIME IS  ')        %%筛 days
        temp = strfind(tline,'OR');
        flag2 =1;
        data(item).time = tline(temp+4:temp+14);
    end
    %%用flag来判断是否是 Balances for entire system
    if contains(tline,'Balances for')   %%第一层，经过 Balances for 时将 flag 赋值为0
        flag = 0;
    end
    if contains(tline,'Balances for entire system')    %%第二层，经过 Balances for entire system 时将 flag 再次赋值为1
        flag =1;
    end
    %%提取GasPhase
    if flag & contains(tline,'GAS PHASE')
        temp = strfind(tline,'GAS PHASE');
        data(item).GasPhase_water = tline(temp+13:temp+26);
        data(item).GasPhase_salt = tline(temp+28:temp+41);
        data(item).GasPhase_CO2 = tline(temp+43:temp+56);
    end
    %%提取AQUEOUS
    if flag & contains(tline,'AQUEOUS')
        temp = strfind(tline,'AQUEOUS');
        data(item).Aqueous_water = tline(temp+13:temp+26);
        data(item).Aqueous_salt = tline(temp+28:temp+41);
        data(item).Aqueous_CO2 = tline(temp+43:temp+56);
    end
    %%提取Solid salt
    if flag & contains(tline,'SOLID SALT')
        temp = strfind(tline,'SOLID SALT');
        data(item).SolidSalt_water = tline(temp+13:temp+26);
        data(item).SolidSalt_salt = tline(temp+28:temp+41);
        data(item).SolidSalt_CO2 = tline(temp+43:temp+56);
    end
    %% 退出循环
%     if flag2
%         if str2num(data(item).time)==36525
%             break
%         end
%     end
end
disp('=============Finished reading all data!=============')
% disp(item)   %% 显示有多少组数据
%% 保存到 excel 中
time = str2num(cat(1,data.time));
GasPhase_water = str2num(cat(1,data.GasPhase_water));    GasPhase_salt = str2num(cat(1,data.GasPhase_salt));   GasPhase_CO2 = str2num(cat(1,data.GasPhase_CO2));    
Aqueous_water = str2num(cat(1,data.Aqueous_water));  Aqueous_salt = str2num(cat(1,data.Aqueous_salt));    Aqueous_CO2 = str2num(cat(1,data.Aqueous_CO2));
SolidSalt_water = str2num(cat(1,data.SolidSalt_water));  SolidSalt_salt = str2num(cat(1,data.SolidSalt_salt));    SolidSalt_CO2 = str2num(cat(1,data.SolidSalt_CO2));
final_data = [time GasPhase_water GasPhase_salt GasPhase_CO2 Aqueous_water Aqueous_salt Aqueous_CO2 SolidSalt_water SolidSalt_salt SolidSalt_CO2];

final_data2 = final_data(find(final_data(:,1)==0|final_data(:,1)==365.25),:);

xlswrite('.\sample.xlsx',final_data2,1,'A3')
disp('=============Successfully Saved Filed=============')




