CHD_models_v1:训练2000次的结果100 1 1
CHD_models_v2:训练2000次的结果10 0.1 0.1
CHD_models_v3:训练2000次的结果1 0.1 0.1
CHD_models_v4:训练2000次的结果1 1 1
DHD_models_v1:系数100 1 1
DHD_models_v2:系数1 0.1 0.1
DHD_models_v3:系数1 1 1
Centralized_models_v1：控制效果居然没有分布式控制好，reward参数还是需要调整一下
Centralized_models_v2：频率权重系数增大到20，依旧在震荡
Centralized_models_v3：将频率变化率的reward去掉，只有频率，将频率权重系数增加到100
Centralized_models_v4：将频率权重系数增加到200，看训练结果，感觉不太行，在增加训练次数，训练中间有凸起
Centralized_models_v5：直接将最后一个调节至所有H、D的和为零，但是效果不太行
Centralized_models_v6：通过平移缩放将机器训练输出的H、D保持在限幅值以内