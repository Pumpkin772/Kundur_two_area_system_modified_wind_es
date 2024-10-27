%% Common parameters
clear;

w         =          1;
fB        =          50;                   
wB        =          2*pi*fB;



SynMach_in_gidx     =    [1 2 3];%The node number of the synchronous motor connected to the large power grid. 
                                    % Please arrange it in the order in the gen matrix.   
%  ���ܶ�Ӧ�Ľڵ�
EStorage_in_gidx     =   [12 13 14 15];
AggWind_in_gidx     =    [4;16];%The node number of the wind turbine connected to the large power grid. Please arrange it in the order in the gen matrix.

%  Single fan capacity 
AggSwgB           =    [2;2];%2MVA
%  Number of aggregate fans 
AggNN             =    [340;50];%a DFIG model represent 50 DFIGs
%  Rotor Speed of DFIG 
AggWr0            =    [0.9;0.9];%
%  Initial power of fan 
AggPwind_S   =    AggWr0.*...
    1.162.*AggWr0.^2;
AggPwind_A   =    AggPwind_S.*AggNN.*AggSwgB;




mpcdc =loadcasedc('P_DCdata');
mpcac =loadcase('P_ACdata');


[resultsac,resultsdc,converged]=powerflowcaculate(mpcac,mpcdc,AggPwind_A,AggWind_in_gidx,SynMach_in_gidx,EStorage_in_gidx);


  

if(converged~=1)
    error('�������㲻����')
end
clear converged

SgridB    =     resultsac.baseMVA;
SdcgridB  =     resultsdc.baseMVAdc;




%% AC network initialization 

fbranchac = resultsac.branch(1,:);  % Set up short line 

[ACgirdinit,opdata]=ACgrid_init(resultsac,resultsdc,fbranchac);
 



%% Synchronous motor initialization 
Geninit=Generator_init(opdata,SynMach_in_gidx);

%% DFIG initialization 
[Windinit,AVm0] = nWind_machine_init(opdata,AggWind_in_gidx,AggWr0,AggNN,AggSwgB);

%% ���ܱ任����ʼ��
[ESinit] = ESconverter_init(resultsac,EStorage_in_gidx);

%% ͨѶ��ʱ��ʼ��
DataDelay = ones(length(EStorage_in_gidx),2);%˫����ʱ�������෢�͵�������ʱ
DataDelay = 0.0*DataDelay;
save('parameterinit');
