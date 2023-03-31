local domains = {}
local HALF_HOUR = 1800
local last_report = os.time()

local function timestamp()
    return os.date("%Y-%m-%d-%H-%M-%S")
end

function init(args)
    local needs = {}
    needs["protocol"] = "dns"
    return needs
end

function setup(args)
end

local function output_domains()
    local file = io.open(SCLogPath() .. "/" .. "domains_" .. timestamp(), "a")
    if file == nil then
        return
    end

    for domain, _ in pairs(domains) do
        file:write(domain .. "\n")
    end

    file:close()
end

function log(args)
    dns_query = DnsGetQueries();

    if dns_query ~= nil then
        for _, t in paris(dns_query) do
            rrname = t["rrname"]
            domains[rrname] = 1
        end
    end


    if os.time() - last_report > HALF_HOUR then
        if next(domains) ~= nil then
            output_domains()
            last_report = os.time()
            domains = {}
        end
    end
end

function deinit(args)
end
