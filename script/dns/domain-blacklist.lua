-- suricata domain 黑名单脚本
-- created by: Black5ugar
-- created time: 2021-12-20

-- 分割字符串
function split(s, c)
    local arr = {}
    string.gsub(s, '[^'..c..']+', function(w) table.insert(arr, w) end )
    return arr
end


-- suricata 初始化
function init (args)
    local needs = {}
    needs["dns.rrname"] = tostring(true)

    return needs
end

-- suricata 规则监测
function match (args)
    filename = "/etc/suricata/blacklist/domain-blacklist.lst"
    file = assert(io.open(filename, "r"))

    -- 定义一个二维数组
    -- 存放检测字段和参考来源
    local blacklist = {}
    local line = file:read()

    -- 把文件中存入黑名单
    while line do
        domains = split(line, ";")
        table.insert(blacklist, domains)
        line = file:read()
    end

    -- 关闭打开的文件
    file.close(file)

    domain = tostring(args["dns.rrname"])
    if #domain > 0 then
        for i = 1, #blacklist do
            if blacklist[i][1] == domain then
                return 1
            end
        end
    end
    return 0
end
