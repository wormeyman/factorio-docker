# Factorio-异星工厂 [![Build Status](https://travis-ci.org/factoriotools/factorio-docker.svg?branch=master)](https://travis-ci.org/factoriotools/factorio-docker) ![Updater status](https://img.shields.io/endpoint?label=Updater%20status&logo=a&url=https%3A%2F%2Fhealthchecks.supersandro.de%2Fbadge%2F1a0a7698-445d-4e54-9e4b-f61a1544e01f%2FBO8VukOA%2Fmaintainer.shields) [![Docker Version](https://images.microbadger.com/badges/version/factoriotools/factorio.svg)](https://hub.docker.com/r/factoriotools/factorio/) [![Docker Pulls](https://img.shields.io/docker/pulls/factoriotools/factorio.svg?maxAge=600)](https://hub.docker.com/r/factoriotools/factorio/) [![Docker Stars](https://img.shields.io/docker/stars/factoriotools/factorio.svg?maxAge=600)](https://hub.docker.com/r/factoriotools/factorio/) [![Microbadger Layers](https://images.microbadger.com/badges/image/factoriotools/factorio.svg)](https://microbadger.com/images/factoriotools/factorio "Get your own image badge on microbadger.com")

* `1.1.25`, `1.1`, `latest`, `stable` [(1.1/Dockerfile)](https://github.com/factoriotools/factorio-docker/blob/master/1.1/Dockerfile)
* `1.0.0`, `1.0` [(1.0/Dockerfile)](https://github.com/factoriotools/factorio-docker/blob/master/1.0/Dockerfile)
* `0.18.47`, `0.18` [(0.18/Dockerfile)](https://github.com/factoriotools/factorio-docker/blob/master/0.18/Dockerfile)
* `0.17.79`, `0.17` [(0.17/Dockerfile)](https://github.com/factoriotools/factorio-docker/blob/master/0.17/Dockerfile)
* `0.16.51`, `0.16` [(0.16/Dockerfile)](https://github.com/factoriotools/factorio-docker/blob/master/0.16/Dockerfile)
* `0.15.40`, `0.15` [(0.15/Dockerfile)](https://github.com/factoriotools/factorio-docker/blob/master/0.15/Dockerfile)
* `0.14.23`, `0.14` [(0.14/Dockerfile)](https://github.com/factoriotools/factorio-docker/blob/master/0.14/Dockerfile)

## 标签描述

* `latest` - 最新版本 (可能含有实验性功能).
* `stable` - 最新的稳定版本 [factorio.com](https://www.factorio.com).
* `0.x`    - 某个分支上的最新版本
* `0.x.y` - 具体的版本
* `0.x-z` - 在该版本上的增量更新

## 什么是 Facotrio？

> 摘录自 [steam factorio 页面](https://store.steampowered.com/app/427520/Factorio/)

「异星工厂」Factorio 是一款建造工业生产流水线并保持其高效运转的游戏。

在游戏中，你可以抠矿、搞科研、盖工厂、建设自动生产流水线，同时还要与异星虫子们互相伤害。

你将从一无所有艰辛起步。挥斧砍树，抡镐抠矿，手搓机械臂和传送带，然而像这样一直搞下去并没有什么卵用。因此，你需要高效的大规模发电厂，庞大的石油化工体系，壮观的全自动化产业链，以及替你东奔西走的机器人大队，让你成为物资储备丰盈工业帝国的真正操控者！

然而，总有一群刁民想害你。这个星球上的土著虫群对你在自家后院里瞎折腾的行为很不爽，总有一天这群刁民会联合起来找你麻烦。因此，你要制造武器、建立防御、准备镇压，让它们知道谁才是真正的主宰者。

你可以在多人游戏中加入不同的阵营，在大触们的带领下与朋友们分工协作， 一起建设恢弘无比的工业园区。

Factorio的模组支持吸引了全世界的设计师参与到对游戏的完善和革新中来，从优化调整到游戏辅助，甚至对游戏的彻底翻新，日新月异的模组将为你不断提供新的乐趣。
除了游戏核心的自由模式和沙盒模式之外，任务包还提供了更多不同形式的游戏挑战，这已经作为一个免费的DLC提供给玩家了。

对随机生成的地图不满意？不满足于原生游戏任务？这都不是事儿。通过内置的地图编辑器，你可以任意修改地图，配置地形、建筑、敌人等各种元素。如果你是大触，还可以添加自定义脚本，让你的游戏更具独创性、更加阴吹思婷！

**注意**：这个仓库仅包含游戏服务端. 游戏本体可以在 [factorio.com](factorio.com)、 [Steam](https://store.steampowered.com/app/427520/Factorio/)、[GOG.com](https://www.gog.com/game/factorio) 和 [Humble Bundle](https://www.humblebundle.com/store/factorio) 上找到。

## 使用方法

### 快速入门

运行服务端以在指定目录下生成必要的配置文件以及存档，`/opt/factorio` 也许是一个不错的选择。

```shell
sudo mkdir -p /opt/factorio
sudo chown 845:845 /opt/factorio
sudo docker run -d \
  -p 34197:34197/udp \
  -p 27015:27015/tcp \
  -v /opt/factorio:/factorio \
  --name factorio \
  --restart=always \
  factoriotools/factorio
```

这样一来， 服务端会使用 `/opt/factorio/saves` 中最新的存档进行游戏。

你一定想知道上面那些咒语是什么意思：

* `-d` - 以守护进程方式运行 ("detached")。
* `-p` - 暴露宿主机 (host) 某些端口。
* `-v` - 将宿主机中 `/opt/factorio` 目录挂载到docker容器的 `/factorio` 目录。
* `--restart` - 在宿主重启或服务端运行崩溃后重启服务端。
* `--name` - 将docker容器命名为 "factorio" (否则docker会给他随机起一个搞怪名字)。

`chown` 命令用来更改服务端所在目录的所有权用户以及用户组，为了安全起见我们并不希望游戏直接在root用户权限下运行，因此将用户id更改为845，从而服务端允许该用户在目录中进行读、写、运行操作。

查看日志以搞清楚发生了什么。

```shell
docker logs factorio
```

停止docker容器 (服务端)。

```shell
docker stop factorio
```

在运行过服务端之后可以在 `/opt/factorio/config` 目录中找到 `server-settings.json` 文件，修改改文件以定制你自己的服务端。

```shell
docker start factorio
```

现在试试连接服务端。如果没有正常运行的话请按照上面步骤查看日志。

### Console-终端

为了运行在服务端终端中运行命令，需要通过 `-it` 参数在交互模式下启动服务端。通过 `docker attach` 连接终端从而可以输入命令。

```shell
docker run -d -it \
  --name factorio \
  factoriotools/factorio
  
docker attach factorio
```

### 升级服务端

在升级服务端之前请务必**备份存档**，在客户端（也就是你的游戏中）备份存档相当容易（保存就好）。

请确保在启动服务端时使用了 `-v` 参数，从而服务端将会把存档写在你指定的挂在目录中。`docker rm` 命令会彻底删除运行 facotrio 服务端的容器，也同时会删除容器的整个文件系统实例，因此如果没有挂载外部目录的话，存档也会被删除哦。

```shell
docker stop factorio
docker rm factorio
docker pull factoriotools/factorio
```

然后就像前面说的那样启动服务端，大概一分钟后新的服务端就已经在运行中啦，并且存档和设置还和原来一样！

### 存档

在第一次运行服务端的时候，服务端会根据 `/opt/factorio/config` 目录中的 `map-gen-settings.json` 和 `map-settings.json` 配置文件的内容，在 `/opt/factorio/saves` 目录下会生成一张新地图（存档）`_autosave1.zip`。之后如果在停掉之后再次运行，服务端会载入最新的存档。

如果想要运行一个旧存档，你需要停止运行中的服务端，并且运行一个命令 `touch oldsave.zip`。 这会重置其日期，然后重新启动服务端。或者你可以通过删除所有其他存档只留下想要运行的存档来完成同样的目的。

如果想生成一个新的存档，你需要停止运行中的服务端，然后删除所有的存档再启动服务端就好。

#### 在运行命令中直接指定存档（需要 0.17.79-2+ 版本）

你可以在启动服务端时通过设置一个特殊的环境变量来载入一个特定的存档：

设置 `SAVE_NAME` 为 `saves` 中你想运行的存档名，去掉 `.zip` 后缀：

```shell
sudo docker run -d \
  -p 34197:34197/udp \
  -p 27015:27015/tcp \
  -v /opt/factorio:/factorio \
  -e LOAD_LATEST_SAVE=false \
  -e SAVE_NAME=replaceme \
  --name factorio \
  --restart=always \
  factoriotools/factorio
```

若要生成一个新存档，设置 `GENERATE_NEW_SAVE=true`，同时指定存档名 `SAVE_NAME`：

```shell
sudo docker run -d \
  -p 34197:34197/udp \
  -p 27015:27015/tcp \
  -v /opt/factorio:/factorio \
  -e LOAD_LATEST_SAVE=false \
  -e GENERATE_NEW_SAVE=true \
  -e SAVE_NAME=replaceme \
  --name factorio \
  --restart=always \
  factoriotools/factorio
```

### Mods-模组

