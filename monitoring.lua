-- monitoring checks for dnsdist

function mainHealthCheck(qname, qtype, qclass, dh)
  dh:setCD(true)
  return newDNSName("ns0.paulbsd.com."), DNSQType.A, qclass
end

function cdnHealthCheck(qname, qtype, qclass, dh)
  dh:setCD(true)
  return newDNSName("cdn.paulbsd.com."), DNSQType.A, qclass
end

newServer({name="main dns", address="192.168.1.110:53", pool={"master"}, useClientSubnet=false, checkInterval=1, checkFunction=mainHealthCheck, mustResolve=true})
newServer({name="main geodns", address="192.168.1.110:9053", pool={"gdns"}, useClientSubnet=true, checkFunction=cdnHealthCheck, mustResolve=true})
