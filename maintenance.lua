-- those functions are useful when doing maintenance on backend servers
-- example:
-- showServersStatus('server name') -- matching by mattern the server name
-- setMaintenance('server name', 'DOWN') -- set servers matching pattern down

function load_snippet(filename)
  local f, err = io.open(filename,"r")
  if err ~= nil then
    show(string.format("error loading file %s",filename))
    return
  end
  local code = f:read("a*")
  local bc, err = load(code)
  if err ~= nil then
    show(string.format("error loading code from file %s",filename))
    return
  end
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
  local states = {["FORCEUP"]=true, ["AUTO"]=true, ["DOWN"]=true}
  if state == nil or not states[state] then
    show("please define a state (FORCEUP, AUTO, DOWN)")
    return
  end
  local servers = getServersByPattern(pattern)
  for _,server in pairs(servers) do
    show(string.format("set %s to status: %s",server.name, state))
    if state == "FORCEUP" then server:setUp()
    elseif state == "AUTO" then server:setAuto()
    elseif state == "DOWN" then server:setDown()
    end
  end
end

function getStatusStr(server)
  if server:isUp() then
    return "UP"
  end
  return "DOWN"
end
