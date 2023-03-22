for ips in {0..255}
do nmap 10.1.1.${ips} | grep $1 &
done

