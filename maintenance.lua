-- those functions are useful when doing maintenance on backend servers
-- example:
-- showServersStatus('server name') -- matching by mattern the server name
-- setMaintenance('server name', 'DOWN') -- set servers matching pattern down

function load_snippet(filename)
  f = io.open(filename,"r")
  code = f:read("a*")
  bc,e = load(code)
  pcall(bc)
end

function getServersByPattern(pattern)
  local servers = {}
  for _,server in pairs(getServers()) do
    if string.match(server.name, pattern) then
      table.insert(servers,server)
    end
  end
  return servers
end

function showServersStatus(pattern)
  local servers = getServersByPattern(pattern)
  for _,server in pairs(servers) do
    show(string.format("%s, current status: %s", server.name, getStatusStr(server)))
  end
end

function setMaintenance(pattern,state)
  if state == nil then
    show("default state is set to UP")
    state = "UP"
  end
  local servers = getServersByPattern(pattern)
  for _,server in pairs(servers) do
    show(string.format("set %s to status: %s",server.name, state))
    if state == "UP" then server:setUp()
    elseif state == "DOWN" then server:setDown() end
  end
end

function getStatusStr(server)
  if server:isUp() then
    return "UP"
  end
  return "DOWN"
end
