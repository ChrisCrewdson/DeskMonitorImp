const FEED_ID = "1767602852";
const API_KEY = "oj6bHIVarZMhcZrfyekLtFZviDmamTzHBVaXSfkIOwIZ2wEb";

function send_xively(body) {
  local xively_url = "https://api.xively.com/v2/feeds/" + FEED_ID + ".csv";
  //server.log("xively_url: " + xively_url);
  //server.log("body: " + body);
  
  //add headers
  local req = http.put(
    xively_url, {
      "X-ApiKey":API_KEY, 
      "Content-Type":"text/csv", 
      "User-Agent":"Xively-Imp-Lib/1.0"}, 
    body);
  local res = req.sendsync();
  if(res.statuscode != 200) {
      server.log("error sending message: "+res.body);
  }
}
  
device.on("data", function(body) {
    server.log("device on");
    send_xively(body);
});