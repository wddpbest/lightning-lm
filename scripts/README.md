# lightning-lm Scripts

在 `scripts` 目录执行：

1. `python3 -m pip install numpy laspy pypcd4`：安装转换依赖。
2. `python3 convert_tile_map.py input.las ../data/new_map`：旋转 LAS 地图并按 100 米分块，保留颜色。
3. `python3 convert_tile_map.py input.pcd ../data/new_map`：转换 PCD 地图，与上一条二选一。

输出目录需不存在；生成 `index.txt` 和分块 PCD，默认起始位姿为原点、单位旋转。
