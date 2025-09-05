# VPS服务器综合测试脚本

## 功能特性

- 基础系统信息测试
- 网络连接测试  
- CPU性能测试
- 磁盘IO测试
- 流媒体解锁测试
- 济南运营商专项测试

## 使用方法

```bash
# 下载脚本
wget https://raw.githubusercontent.com/您的用户名/rongheguai/main/vps_test_clean.sh

# 赋予执行权限
chmod +x vps_test_clean.sh

# 运行脚本
sudo ./vps_test_clean.sh
```

## 测试项目

1. 完整测试 (推荐)
2. 基础信息测试
3. 网络测试
4. 济南运营商测试
5. CPU性能测试
6. 磁盘IO测试
7. 流媒体解锁测试

## 济南运营商测试

- 济南电信连接测试
- 济南联通连接测试
- 济南移动连接测试
- 包含ping测试和路由追踪

## 测试结果

测试结果将保存在 `test_result.txt` 文件中。

## 注意事项

- 需要root权限运行
- 建议在screen或tmux中执行
- 测试过程中请保持网络连接稳定
