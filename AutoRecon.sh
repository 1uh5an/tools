#!/bin/bash


for i in $(cat $1)
do
  ./assetfinder --subs-only $i > Asset_Monitoring/$i.assetfinder.txt &

  ./subfinder -d $i -all -silent > Asset_Monitoring/$i.subfinder.txt &
  
  curl -s https://crt.sh/?Identity=%.$i | grep ">*.$i" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<^[\*]*[\.]*$i" | sort -u | awk 'NF' | sed '/*./d' > Asset_Monitoring/$i.crt.txt &
  
  wait
  
  cat Asset_Monitoring/$i.assetfinder.txt >> Asset_Monitoring/$i.subfinder.txt

  cat Asset_Monitoring/$i.crt.txt >> Asset_Monitoring/$i.subfinder.txt
  
  count=$(cat Asset_Monitoring/$i.subfinder.txt | sort -u | wc -l)
  
  if [ "$count" -lt "2" ]; then
    echo $i >> nosubdomain.txtls
    rm -f Asset_Monitoring/$i.*
    continue
  fi

  flags=$(./wildcard -t $i)

  if [ "$flags" -eq "0" ]; then
    if [ "$count" -ge "100" ]; then
      ./ksubdomain enum -b 10M -d $i -f 20w_subdomain.txt -r gnresolvers --skip-wild --od -o Asset_Monitoring/$i.ksubdomain.txt

      cat Asset_Monitoring/$i.ksubdomain.txt >> Asset_Monitoring/$i.subfinder.txt
    fi
  fi
  
  cat Asset_Monitoring/$i.subfinder.txt | sort -u  > Asset_Monitoring/$i.txt
  
  ./dnsx -l Asset_Monitoring/$i.txt -t 200 -r gnresolvers -silent >> Asset_Monitoring/$i.dnsx.txt
  
  ./Checkcdn -r resolvers -t Asset_Monitoring/$i.dnsx.txt -thread 100 -as nocdn/$i.domain_ip_all.txt -ni nocdn/$i.nocdnip_all.txt
  
  cat nocdn/$i.domain_ip_all.txt | sort -u > nocdn/$i.domain_ip.txt

  cat nocdn/$i.nocdnip_all.txt | sort -u > nocdn/$i.nocdnip.txt

  rm -f nocdn/$i.domain_ip_all.txt

  rm -f nocdn/$i.nocdnip_all.txt

  ./naabu -list nocdn/$i.nocdnip.txt -c 1000 -top-ports 1000 -ep 80 -stats -o nocdn/$i.ip_port_all.txt
  
  cat nocdn/$i.ip_port_all.txt |sort -u > nocdn/$i.ip_port.txt

  rm -f nocdn/$i.ip_port_all.txt

  ./port_replace.sh nocdn/$i.ip_port.txt nocdn/$i.domain_ip.txt nocdn/$i.domain_port.txt
  
  cat nocdn/$i.domain_port.txt >> Asset_Monitoring/$i.dnsx.txt
  
  cat Asset_Monitoring/$i.dnsx.txt | sort -u >> Asset_Monitoring/$1.txtls
  
  cat nocdn/$i.domain_ip.txt >> nocdn/$1.domain_ip.txtls

  cat nocdn/$i.nocdnip.txt >> nocdn/$1.nocdnip.txtls

  cat nocdn/$i.ip_port.txt >> nocdn/$1.ip_port.txtls

  rm -f Asset_Monitoring/$i.*

  rm -f nocdn/$i.*
  
done
