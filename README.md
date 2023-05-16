# prnu_block_weigh
 能提取 PRNU，比较待测视频是否是出自某摄像头

|                 文件                 |                  功能                   |
| :----------------------------------: | :-------------------------------------: |
|             algorithm1.m             |    输入一张图片，返回其 prnu 噪声图     |
|        GenAnscombe_forward.m         |          广义 Anscombe 正变换           |
|             cplxdual2D.m             |            二叉树复小波变换             |
|             ILS_LNorm.m              |     基于全局优化的递归最小二乘滤波      |
|            icplxdual2D.m             |               小波逆变换                |
| GenAnscombe_inverse_exact_unbiased.m |               GAT 逆变换                |
|              Extract.sh              | 利用 ffmpeg 命令批量处理视频变成 ibp 帧 |
|                Exp3.m                |      批量鉴定视频是否来自参考设备       |
|                Exp4.m                |    Exp3.m 的分块版，可自定义块的数量    |
|                EXP5.m                |         Exp4.m的0.8i0.2p加权版          |



