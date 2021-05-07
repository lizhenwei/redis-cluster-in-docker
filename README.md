# redis-cluster集群docker版
<em>因为配置里的cluster-announce-ip不能用域名,只能用ip，在K8S里IP经常变，所以不能用K8S部署了</em>

## 前提：
机器上安装了docker和docker-compose
例如有192.168.0.94，192.168.0.95，192.168.0.96 三台机器。

## 使用方法：
1. 在每台机器上下载该代码，进入代码目录，运行shell命令,会根据IP地址更改配置文件，并且创建redis的docker应用：
```
# 在每台机器上输入该命令，注意替换IP地址
bash docker-init.sh 192.168.0.94
```
2. 在任意一台机器上通过redis-cli创建集群
```
# 在每台机器上输入该命令，注意替换IP地址
bash redis-init.sh 192.168.0.94 192.168.0.95 192.168.0.96
# 弹出来的提示直接输入yes
```
3. 完成之后执行命令，检查集群是否运行成功
```
#进入redis容器
docker exec -it redis-cluster bash
#检查集群是否运行成功
redis-cli -a 92F1q99f9CnrkAuwJPItdj8brqeMtN3r -p 7000 cluster nodes
```

## 3台机器默认无高可用功能，仅供测试代码与redis-cluster的兼容性
如果想要3台机器还要高可用，需要手动进入容器，通过`CLUSTER REPLICATE`命令调节master和slaver所处的容器，形成如下拓扑，使得具有repica关系的slaver和master不在同一个节点上
```

-------    -------    -------
|node1|    |node2|    |node3|
-------    -------    -------
master1    master2    master3   
slaver2    slaver3    slaver1

```
## python代码访问redis-cluster
安装redis-py-cluster
```
$ pip install redis-py-cluster
```
测试代码
```
>>> from rediscluster import RedisCluster

>>> # Requires at least one node for cluster discovery. Multiple nodes is recommended.
>>> startup_nodes = [{"host": "192.168.0.94", "port": "7000"}, {"host": "192.168.0.94", "port": "7001"},{"host": "192.168.0.95", "port": "7000"}, {"host": "192.168.0.95", "port": "7001"},{"host": "192.168.0.96", "port": "7000"}, {"host": "192.168.0.96", "port": "7001"}]
>>> rc = RedisCluster(startup_nodes=startup_nodes, decode_responses=True,password='92F1q99f9CnrkAuwJPItdj8brqeMtN3r')

>>> rc.set("foo", "bar")
True
>>> print(rc.get("foo"))
'bar'
```