'use strict';
const fs=require('fs'),path=require('path');
const connectionFile=path.join(__dirname,'connection.json'),mirror=path.join(__dirname,'server-config.json');
function origin(v){const u=new URL(String(v||'').trim());if(!['http:','https:'].includes(u.protocol)||u.username||u.password||u.search||u.hash||!['','/'].includes(u.pathname))throw Error('Адрес должен быть вида http://IP:PORT или https://domain');return u.origin}
function atomic(file,data){const tmp=file+'.tmp';fs.writeFileSync(tmp,JSON.stringify(data,null,2)+'\n','utf8');fs.renameSync(tmp,file)}
const args=process.argv.slice(2);if(!args[0]){console.log('node set-public-server.cjs http://НОВЫЙ_IP:22007 [http://LAN_IP:22007]');process.exit(2)}
try{
 const c=JSON.parse(fs.readFileSync(connectionFile,'utf8')),publicBaseUrl=origin(args[0]),fallbacks=args.slice(1).filter(Boolean).map(origin);
 c.version=Math.max(3,Number(c.version)||3)+1;c.publicBaseUrl=publicBaseUrl;c.listenPort=Number(new URL(publicBaseUrl).port||(/^https:/i.test(publicBaseUrl)?443:80));if(fallbacks.length)c.fallbacks=fallbacks;
 atomic(connectionFile,c);atomic(mirror,{version:c.version,publicBaseUrl:c.publicBaseUrl,fallbacks:c.fallbacks||[],updatedAt:new Date().toISOString(),transport:'direct'});
 console.log('Готово: '+c.publicBaseUrl);
}catch(e){console.error('ERROR: '+e.message);process.exit(1)}
