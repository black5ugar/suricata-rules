# 域名黑名单检测脚本
suricata自带的黑名单检测不是很方便，于是做了如下Lua脚本  
suricata的lua脚本有两种形式
- 基于检测
- 基于写日志的  
**该脚本是基于检测的**，会生成alert输出在fast.json和eve.json里，而不是产生额外的输出

## 使用方法
- 首先新建一个domain-blacklist.lst黑名单文件

格式为：
```
<domain>;<reference>
```
每条记录占一行  

比如：
```
www.baidu.com;http://1231321.com
www.bing.cn;http://12312312.com
```

- 在lua脚本里修改黑名单的绝对（？）路径

```
filename = "/etc/suricata/blacklist/domain-blacklist.lst"
```

- 编写自己的规则

```
alert dns any any -> any any (msg:"CUSTOM: domain blacklist detected"; classtype:domainblacklist;lua:domain-blacklist.lua; sid:100000000;rev:1;)
``` 

lua 参数的默认位置是你的rules的默认存放位置，根据需要自行调整路径

- 重启suricata之后若有命中便可看到告警

```
[**] [1:100000000:1] CUSTOM: domain blacklist detected [**] [Classification: domain-blacklist-detected] [Priority: 1] {UDP} 123.123.123.123:123 -> 321.321.321.321:53
```