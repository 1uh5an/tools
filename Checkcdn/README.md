# Checkcdn

检查是否存在cdn，参考自**[cdnCheck_go](https://github.com/damit5/cdnCheck_go)**，改用channel完成协程，修改输出，为配合AutoRecon.sh完成自动化。

# 免责声明

该工具仅用于安全自查检测

由于传播、利用此工具所提供的信息而造成的任何直接或者间接的后果及损失，均由使用者本人负责，作者不为此承担任何责任。

本人拥有对此工具的修改和解释权。未经网络安全部门及相关部门允许，不得善自使用本工具进行任何攻击活动，不得以任何方式将其用于商业目的。

# 用法

```
Usage:
  ./Checkcdn [flags]

  -as string
        所有域名和IP的映射关系，不保存置空即可
  -ni string
        无CDN IP保存地址，不保存置空即可
  -r string
        DNS服务器
  -t string
        需要扫描的文件
  -thread int
        并发数 (default 20)
```
