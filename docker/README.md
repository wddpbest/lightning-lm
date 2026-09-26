# lightning-lm Docker

在 `docker` 目录依次执行：

1. `docker build -t lightning-lm:dev .`：构建包含 ROS 2 和依赖库的镜像。
2. `bash build_lightning.sh`：在容器内编译 lightning 源码。
3. `docker compose up`：启动容器并运行在线定位程序 `run_loc_online`。
