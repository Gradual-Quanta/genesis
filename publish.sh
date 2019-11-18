#

#set -e
find . -name \*.\*~\* -delete
#curl -s https://www.genesis-block.ml | pandoc -t json | xjson blocks.29.c.1.1.c.4.c

echo "--- # ${0##*/}"
name=genesis
qm=$(ipfs add -Q -r _site)
bafy=$(ipfs cid base32 $qm)
echo "qm: $qm"
prv=$(ipfs files stat --hash /root/www/$name 2>/dev/null)
if [ "x$prv" = 'x' ]; then
prv=$qm
else
ipfs files rm -r /root/www/$name
fi
echo "prv: $prv"
ipfs files cp /ipfs/$qm /root/www/$name
ipfs files cp /ipfs/$prv /root/www/$name/prev
new=$(ipfs files stat --hash /root/www/$name 2>/dev/null)
tic=$(date +%s)
bot=$(echo $new | fullname)
echo "*bot: $bot"
sed -i -e "s/bot: .*/bot: $bot/" -e "s/tic: .*/tic: $tic/" -e "s/bafy: .*/bafy: $bafy/" _data/qm.yml
echo "new: $new"
echo " - $new" >> _data/qm.yml


JEKYLL_ENV production jekyll build
next=$(ipfs add -Q -r _site)
echo "next: $next"
ipfs config Gateway.RootRedirect /ipfs/$next
ssh serv01 "ipfs config Gateway.RootRedirect /ipfs/$next"
ipfs --offline name publish --key=genesis /ipfs/$next
echo "url: https://127.0.0.1:8080/ipns/$key"
bafy=$(ipfs cid base32 $qm)
echo "url: https://$baffy.cf-ipfs.com/"
key=$(ipfs key list -l | grep -w $name | cut -d' ' -f1)



