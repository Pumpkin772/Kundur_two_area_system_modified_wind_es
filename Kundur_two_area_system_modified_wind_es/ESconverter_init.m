function [ESinit] = ESconverter_init(resultsac,EStorage_in_gidx)
       
w        =  1;

Lpr        =          [0.085;0.085;0.085;0.085];
Rpr        =          [0.002;0.002;0.002;0.002];

SvscBi     =          [100;100;100;100];

ESinit.Lpr    =    Lpr;
ESinit.Rpr    =    Rpr;
% ESinit.Vdcbase=    Vdcbase;
% ESinit.Vacbase=    Vacbase;
ESinit.SvscBi =    SvscBi;
%% 
%               23
%    VSC���   PLLPI
VSC_PLL_data=...
    [
    1          100,6000
    2          100,6000
    3          100,6000
    4          100,6000
    ];

ESinit.Kppll=VSC_PLL_data(:,2);
ESinit.Kipll=VSC_PLL_data(:,3);

%% 
%       1         2             34         56          78         9,10       11,12        13,14      15        16    17  18 
%    VSC���     PWMTo       d���ڻ�PI   q���ڻ�PI    d��VdcPI    d��PPI      q��VacPI      q��QPI  ����ϵ��  �´�ϵ�� �ֲ�ʽϵ�� �ֲ�ϵ��2 
VSC_Control_data=...
    [
    1       0.001       0.04,0.28   0.04,0.28    45,950     5.06,382.07     100,7000    -5.06,-150.00    100   200  0 0%
    2       0.001       0.04,0.28   0.04,0.28    45,950     5.06,382.07     100,7000    -5.06,-150.00     100   200  0 0%
    3       0.001       0.04,0.28   0.04,0.28    45,950     5.06,382.07     100,7000    -5.06,-150.00     100    200  0 0%
    4       0.001       0.04,0.28   0.04,0.28    45,950     5.06,382.07     100,7000    -5.06,-150.00     100    200  0 0%
    ];
% 4       0.001       0.04,0.28   0.04,0.28    25,950     5.06,382.07     100,7000    -5.06,-382.07    20,100     10,10;
%
ESinit.To     =          VSC_Control_data(:,2);

ESinit.KpId   =          VSC_Control_data(:,3);
ESinit.KiId   =          VSC_Control_data(:,4);

ESinit.KpIq   =          VSC_Control_data(:,5);
ESinit.KiIq   =          VSC_Control_data(:,6);

%
ESinit.KpP  =        VSC_Control_data(:,9);
ESinit.KiP  =        VSC_Control_data(:,10);

ESinit.Kpac =       VSC_Control_data(:,11);
ESinit.Kiac =       VSC_Control_data(:,12);

%  q-axis control  
ESinit.KpQ  =        VSC_Control_data(:,13);
ESinit.KiQ  =        VSC_Control_data(:,14);

ESinit.Kir  =       VSC_Control_data(:,15);
ESinit.Kdroop  =    VSC_Control_data(:,16);

ESinit.Kdistributed  =    VSC_Control_data(:,17);
ESinit.Kdistributed_d  =    VSC_Control_data(:,18);

% PCC_idx            =    ConvandBusdc{:,'Busac_I'};%
Angle_PCC          =    resultsac.bus{cellstr(string(EStorage_in_gidx)),9}*pi/180;



ESinit.P0          =    resultsac.gen{cellstr(string(EStorage_in_gidx)),2}./SvscBi;
ESinit.Q0          =    resultsac.gen{cellstr(string(EStorage_in_gidx)),3}./SvscBi;


S_inject_insystem      =    -(resultsac.gen{cellstr(string(EStorage_in_gidx)),2}+1j*resultsac.gen{cellstr(string(EStorage_in_gidx)),3})./SvscBi;
Amplitude_PCC          =    resultsac.bus{cellstr(string(EStorage_in_gidx)),8};

Usd0                =    Amplitude_PCC;
ESinit.Usd0         =    Usd0;

Usq0                =    zeros(size(EStorage_in_gidx,2),1);
Usdq0               =    Usd0+1j.*Usq0;   

Isdq0              =    conj(S_inject_insystem./Usdq0);
Isd0                =    real(Isdq0);
Isq0                =    imag(Isdq0);



Voltage_Phasor_PCC     =    resultsac.bus{cellstr(string(EStorage_in_gidx)),8}.*exp(1j*Angle_PCC);
Current_Phasor_to_PCC  =    conj(S_inject_insystem./Voltage_Phasor_PCC);

	    Ucd0        =    Usd0-Rpr.*Isd0+Lpr.*Isq0;
        Ucq0        =    Usq0-Rpr.*Isq0-Lpr.*Isd0;
        
%         Uc          =    sqrt(Ucd0.^2+Ucq0.^2);
        
    



ESinit.Dels_hvdc      =    Angle_PCC;
ESinit.Isx0        =    real(Current_Phasor_to_PCC);
ESinit.Isy0        =    imag(Current_Phasor_to_PCC);

ESinit.Ucd0        =    Ucd0;
ESinit.Ucq0        =    Ucq0;

ESinit.Md0         =    Usd0-Ucd0+w.*Lpr.*Isq0;
ESinit.Mq0         =    Usq0-Ucq0-w.*Lpr.*Isd0;
ESinit.Nd0         =    Isd0;
ESinit.Nq0         =    Isq0;
%% end

end








