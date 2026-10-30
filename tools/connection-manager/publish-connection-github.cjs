'use strict';
const fs=require('fs'),{execFileSync}=require('child_process'),path=require('path');
const file=path.join(__dirname,'server-config.json');
const cfg=JSON.parse(fs.readFileSync(path.join(__dirname,'connection.json'),'utf8'));
const body=fs.readFileSync(file,'utf8');
const [owner,repo]=cfg.github.repository.split('/'),branch=cfg.github.branch,target=cfg.github.path;
function hasGh(){try{execFileSync('gh',['--version'],{stdio:'ignore',windowsHide:true});return true}catch(_){return false}}
async function tokenMode(token){
 const h={Authorization:'Bearer '+token,Accept:'application/vnd.github+json','X-GitHub-Api-Version':'2022-11-28','User-Agent':'ICQ-Reborn-Host'};
 const url=`https://api.github.com/repos/${owner}/${repo}/contents/${target}?ref=${encodeURIComponent(branch)}`;
 const old=await fetch(url,{headers:h});if(!old.ok)throw Error('GitHub GET '+old.status);const meta=await old.json();
 const put=await fetch(`https://api.github.com/repos/${owner}/${repo}/contents/${target}`,{method:'PUT',headers:{...h,'Content-Type':'application/json'},body:JSON.stringify({message:'Update ICQ Reborn public server connection',content:Buffer.from(body).toString('base64'),sha:meta.sha,branch})});
 if(!put.ok)throw Error('GitHub PUT '+put.status+' '+await put.text());
}
(async()=>{try{
 if(process.env.GH_TOKEN){await tokenMode(process.env.GH_TOKEN);console.log('GitHub updated');return}
 if(!hasGh())throw Error('Не найден gh и не задан GH_TOKEN');
 const meta=JSON.parse(execFileSync('gh',['api',`repos/${owner}/${repo}/contents/${target}`,'-f',`ref=${branch}`],{encoding:'utf8',windowsHide:true}));
 const payload=JSON.stringify({message:'Update ICQ Reborn public server connection',content:Buffer.from(body).toString('base64'),sha:meta.sha,branch});
 execFileSync('gh',['api','--method','PUT',`repos/${owner}/${repo}/contents/${target}`,'--input','-'],{input:payload,stdio:['pipe','inherit','inherit'],windowsHide:true});
}catch(e){console.error(e.message);process.exit(1)}})();
