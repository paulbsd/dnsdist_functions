-- set multiple backend to improve performances

function createServer(data)
  if data.threads == nil
    then data.threads=4
  end
  local name = data.name
  for n=1,data.threads do
    data.name = string.format("%s %d",name,n)
    data.threads = nil
    newServer(data)
  end
end

createServer({name="main dns", address="192.168.1.100:53", pool={"slave"}, useClientSubnet=false, checkInterval=1, mustResolve=true, threads=4})
