#!/bin/bash

# VPS服务器综合测试脚本


# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 测试结果文件
RESULT_FILE="test_result.txt"

# 清理函数
cleanup() {
    echo -e "\n${YELLOW}正在清理临时文件...${NC}"
    rm -f /tmp/test_*
    echo -e "${GREEN}清理完成${NC}"
}

# 信号处理
trap cleanup EXIT INT TERM

# 主菜单
show_menu() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}        VPS服务器综合测试脚本${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${YELLOW}1. 完整测试 (推荐)${NC}"
    echo -e "${YELLOW}2. 基础信息测试${NC}"
    echo -e "${YELLOW}3. 网络测试${NC}"
    echo -e "${YELLOW}4. 济南运营商测试${NC}"
    echo -e "${YELLOW}5. CPU性能测试${NC}"
    echo -e "${YELLOW}6. 磁盘IO测试${NC}"
    echo -e "${YELLOW}7. 流媒体解锁测试${NC}"
    echo -e "${YELLOW}8. 退出${NC}"
    echo -e "${CYAN}========================================${NC}"
}

# 基础信息测试
test_basic_info() {
    echo -e "\n${BLUE}=== 基础信息测试 ===${NC}"
    echo "测试时间: $(date)" >> $RESULT_FILE
    echo "=== 基础信息测试 ===" >> $RESULT_FILE
    
    # 系统信息
    echo -e "${GREEN}系统信息:${NC}"
    echo "操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "内核版本: $(uname -r)"
    echo "架构: $(uname -m)"
    echo "CPU核心数: $(nproc)"
    echo "内存大小: $(free -h | grep Mem | awk '{print $2}')"
    echo "磁盘空间: $(df -h / | tail -1 | awk '{print $2}')"
    
    # 写入结果文件
    cat << EOF >> $RESULT_FILE
操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
内核版本: $(uname -r)
架构: $(uname -m)
CPU核心数: $(nproc)
内存大小: $(free -h | grep Mem | awk '{print $2}')
磁盘空间: $(df -h / | tail -1 | awk '{print $2}')
EOF
}

# 济南运营商测试
test_jinan_operators() {
    echo -e "\n${BLUE}=== 济南运营商测试 ===${NC}"
    echo "=== 济南运营商测试 ===" >> $RESULT_FILE
    
    # 济南电信测试
    echo -e "${GREEN}测试济南电信连接...${NC}"
    echo "济南电信测试:" >> $RESULT_FILE
    
    # 使用ping测试济南电信
    if ping -c 4 202.102.128.68 > /dev/null 2>&1; then
        echo -e "${GREEN}济南电信: 连接正常${NC}"
        echo "济南电信: 连接正常" >> $RESULT_FILE
    else
        echo -e "${RED}济南电信: 连接失败${NC}"
        echo "济南电信: 连接失败" >> $RESULT_FILE
    fi
    
    # 济南联通测试
    echo -e "${GREEN}测试济南联通连接...${NC}"
    echo "济南联通测试:" >> $RESULT_FILE
    
    if ping -c 4 202.102.134.68 > /dev/null 2>&1; then
        echo -e "${GREEN}济南联通: 连接正常${NC}"
        echo "济南联通: 连接正常" >> $RESULT_FILE
    else
        echo -e "${RED}济南联通: 连接失败${NC}"
        echo "济南联通: 连接失败" >> $RESULT_FILE
    fi
    
    # 济南移动测试
    echo -e "${GREEN}测试济南移动连接...${NC}"
    echo "济南移动测试:" >> $RESULT_FILE
    
    if ping -c 4 211.137.96.205 > /dev/null 2>&1; then
        echo -e "${GREEN}济南移动: 连接正常${NC}"
        echo "济南移动: 连接正常" >> $RESULT_FILE
    else
        echo -e "${RED}济南移动: 连接失败${NC}"
        echo "济南移动: 连接失败" >> $RESULT_FILE
    fi
    
    # 详细网络测试
    echo -e "\n${GREEN}进行详细网络测试...${NC}"
    
    # 济南电信详细测试
    echo "济南电信详细测试:" >> $RESULT_FILE
    traceroute -m 10 202.102.128.68 2>/dev/null | head -5 >> $RESULT_FILE
    
    # 济南联通详细测试
    echo "济南联通详细测试:" >> $RESULT_FILE
    traceroute -m 10 202.102.134.68 2>/dev/null | head -5 >> $RESULT_FILE
    
    # 济南移动详细测试
    echo "济南移动详细测试:" >> $RESULT_FILE
    traceroute -m 10 211.137.96.205 2>/dev/null | head -5 >> $RESULT_FILE
}

# 网络测试
test_network() {
    echo -e "\n${BLUE}=== 网络测试 ===${NC}"
    echo "=== 网络测试 ===" >> $RESULT_FILE
    
    # IP信息
    echo -e "${GREEN}获取IP信息...${NC}"
    PUBLIC_IP=$(curl -s ipinfo.io/ip)
    echo "公网IP: $PUBLIC_IP"
    echo "公网IP: $PUBLIC_IP" >> $RESULT_FILE
    
    # 网络延迟测试
    echo -e "${GREEN}测试网络延迟...${NC}"
    echo "网络延迟测试:" >> $RESULT_FILE
    
    # 测试多个节点
    test_nodes=(
        "8.8.8.8:Google DNS"
        "1.1.1.1:Cloudflare DNS"
        "114.114.114.114:114 DNS"
        "223.5.5.5:阿里DNS"
    )
    
    for node in "${test_nodes[@]}"; do
        ip=$(echo $node | cut -d':' -f1)
        name=$(echo $node | cut -d':' -f2)
        echo -e "${YELLOW}测试 $name ($ip)...${NC}"
        ping_result=$(ping -c 3 $ip 2>/dev/null | grep "avg" | awk -F'/' '{print $5}')
        if [ ! -z "$ping_result" ]; then
            echo "$name: ${ping_result}ms"
            echo "$name: ${ping_result}ms" >> $RESULT_FILE
        else
            echo "$name: 超时"
            echo "$name: 超时" >> $RESULT_FILE
        fi
    done
}

# CPU性能测试
test_cpu() {
    echo -e "\n${BLUE}=== CPU性能测试 ===${NC}"
    echo "=== CPU性能测试 ===" >> $RESULT_FILE
    
    # CPU信息
    echo -e "${GREEN}CPU信息:${NC}"
    echo "CPU型号: $(lscpu | grep "Model name" | cut -d':' -f2 | xargs)"
    echo "CPU核心数: $(nproc)"
    echo "CPU频率: $(lscpu | grep "CPU MHz" | cut -d':' -f2 | xargs) MHz"
    
    echo "CPU型号: $(lscpu | grep "Model name" | cut -d':' -f2 | xargs)" >> $RESULT_FILE
    echo "CPU核心数: $(nproc)" >> $RESULT_FILE
    echo "CPU频率: $(lscpu | grep "CPU MHz" | cut -d':' -f2 | xargs) MHz" >> $RESULT_FILE
    
    # CPU性能测试
    echo -e "${GREEN}进行CPU性能测试...${NC}"
    echo "CPU性能测试:" >> $RESULT_FILE
    
    # 使用sysbench进行CPU测试
    if command -v sysbench > /dev/null 2>&1; then
        echo -e "${YELLOW}使用sysbench测试CPU性能...${NC}"
        sysbench cpu --cpu-max-prime=20000 --threads=$(nproc) run 2>/dev/null | grep "events per second" >> $RESULT_FILE
    else
        echo -e "${YELLOW}sysbench未安装，使用简单测试...${NC}"
        time_start=$(date +%s.%N)
        for i in {1..1000000}; do
            echo $i > /dev/null
        done
        time_end=$(date +%s.%N)
        time_diff=$(echo "$time_end - $time_start" | bc)
        echo "简单计算测试耗时: ${time_diff}秒" >> $RESULT_FILE
    fi
}

# 磁盘IO测试
test_disk_io() {
    echo -e "\n${BLUE}=== 磁盘IO测试 ===${NC}"
    echo "=== 磁盘IO测试 ===" >> $RESULT_FILE
    
    # 磁盘信息
    echo -e "${GREEN}磁盘信息:${NC}"
    df -h | grep -E '^/dev/' | while read line; do
        echo "$line"
        echo "$line" >> $RESULT_FILE
    done
    
    # IO测试
    echo -e "${GREEN}进行磁盘IO测试...${NC}"
    echo "磁盘IO测试:" >> $RESULT_FILE
    
    # 写入测试
    echo -e "${YELLOW}测试写入速度...${NC}"
    write_speed=$(dd if=/dev/zero of=/tmp/test_write bs=1M count=1024 2>&1 | grep "copied" | awk '{print $8, $9}')
    echo "写入速度: $write_speed"
    echo "写入速度: $write_speed" >> $RESULT_FILE
    
    # 读取测试
    echo -e "${YELLOW}测试读取速度...${NC}"
    read_speed=$(dd if=/tmp/test_write of=/dev/null bs=1M count=1024 2>&1 | grep "copied" | awk '{print $8, $9}')
    echo "读取速度: $read_speed"
    echo "读取速度: $read_speed" >> $RESULT_FILE
    
    # 清理测试文件
    rm -f /tmp/test_write
}

# 流媒体解锁测试
test_streaming() {
    echo -e "\n${BLUE}=== 流媒体解锁测试 ===${NC}"
    echo "=== 流媒体解锁测试 ===" >> $RESULT_FILE
    
    # Netflix测试
    echo -e "${GREEN}测试Netflix解锁...${NC}"
    netflix_result=$(curl -s --max-time 10 "https://www.netflix.com/title/70143836" | grep -o "Not Available" || echo "Available")
    echo "Netflix: $netflix_result"
    echo "Netflix: $netflix_result" >> $RESULT_FILE
    
    # YouTube测试
    echo -e "${GREEN}测试YouTube解锁...${NC}"
    youtube_result=$(curl -s --max-time 10 "https://www.youtube.com" | grep -o "YouTube" || echo "Blocked")
    echo "YouTube: $youtube_result"
    echo "YouTube: $youtube_result" >> $RESULT_FILE
    
    # 其他流媒体测试
    streaming_sites=(
        "https://www.hulu.com:Hulu"
        "https://www.disney.com:Disney+"
        "https://www.hbo.com:HBO"
    )
    
    for site in "${streaming_sites[@]}"; do
        url=$(echo $site | cut -d':' -f1)
        name=$(echo $site | cut -d':' -f2)
        echo -e "${YELLOW}测试 $name...${NC}"
        result=$(curl -s --max-time 5 "$url" | grep -o "title" || echo "Blocked")
        echo "$name: $result"
        echo "$name: $result" >> $RESULT_FILE
    done
}

# 完整测试
full_test() {
    echo -e "${PURPLE}开始完整测试...${NC}"
    echo "开始完整测试..." >> $RESULT_FILE
    
    test_basic_info
    test_network
    test_jinan_operators
    test_cpu
    test_disk_io
    test_streaming
    
    echo -e "\n${GREEN}=== 测试完成 ===${NC}"
    echo "测试完成时间: $(date)" >> $RESULT_FILE
    echo -e "${CYAN}测试结果已保存到: $RESULT_FILE${NC}"
}

# 主程序
main() {
    # 检查root权限
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}请使用root权限运行此脚本${NC}"
        exit 1
    fi
    
    # 清空结果文件
    > $RESULT_FILE
    
    while true; do
        show_menu
        read -p "请选择测试项目 (1-8): " choice
        
        case $choice in
            1)
                full_test
                ;;
            2)
                test_basic_info
                ;;
            3)
                test_network
                ;;
            4)
                test_jinan_operators
                ;;
            5)
                test_cpu
                ;;
            6)
                test_disk_io
                ;;
            7)
                test_streaming
                ;;
            8)
                echo -e "${GREEN}退出程序${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}无效选择，请重新输入${NC}"
                ;;
        esac
        
        echo -e "\n${YELLOW}按任意键继续...${NC}"
        read -n 1
        clear
    done
}

# 运行主程序
main