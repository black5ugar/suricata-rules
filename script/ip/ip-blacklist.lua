-- suricata ip 黑名单脚本
-- created by: Black5ugar
-- created time: 2021-12-22

-- 分割字符串
function split(s, c)
    local arr = {}
    string.gsub(s, '[^'..c..']+', function(w) table.insert(arr, w) end )
    return arr
end


-- suricata 初始化
function init (args)
    local needs = {}
    needs["packet"] = tostring(true)

    return needs
end

-- suricata 规则监测
function match (args)
    filename = "/var/lib/suricata/reputation/ip-blacklist.lst"
    file = assert(io.open(filename, "r"))

    -- 定义一个二维数组
    -- 存放检测字段和参考来源
    local blacklist = {}
    local line = file:read()

    -- 把文件中存入黑名单
    while line do
        ips = split(line, ";")
        table.insert(blacklist, ips)
        line = file:read()
    end

    -- 关闭打开的文件
    file.close(file)

    ipver, srcip, dstip, proto, sp, dp = SCPacketTuple()
    for i = 1, #blacklist do
        if blacklist[i][1] == scrip or  blacklist[i][1] == dstip then
            return 1
        end
    end
    return 0
end