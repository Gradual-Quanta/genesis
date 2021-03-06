#

#set -e
find . -name \*~1 -delete
#curl -s https://www.genesis-block.ml | pandoc -t json | xjson blocks.29.c.1.1.c.4.c

name=genesis
#domain=genesis.tk
domain=genesis-block.ml
export IPFS_PATH=/media/IPFS/LEDGER

echo "--- # ${0##*/}"

n=$(cat _data/n.yml | xyml n)
echo n: $n
# file _site
qm=$(ipfs add -Q -r _site)
echo "qm: $qm"
if ! ipfs files stat --hash /root/www/$name 1>/dev/null 2>&1; then
 init=1;
 echo "init: create $name's root"
 ipfs files mkdir -p /root/www
 prv=$qm
else
 init=0
 prv=$(ipfs files stat --hash /root/www/$name 2>/dev/null)
 ipfs files rm -r /root/www/$name
fi
echo "prv: $prv"
#ipfs files cp /ipfs/$qm /root/www/$name
#ipfs files cp /ipfs/$prv /root/www/$name/prev
#new=$(ipfs files stat --hash /root/www/$name 2>/dev/null)
# run Jekyll
JEKYLL_ENV=production jekyll build
new=$(ipfs add -Q -r _site)
echo "new: $new"
echo " - $new" >> _data/qm.yml
ipfs files cp /ipfs/$new /root/www/$name
ipfs files cp /ipfs/$prv /root/www/$name/prev
next=$(ipfs files stat --hash /root/www/$name 2>/dev/null)
bafy=$(ipfs cid base32 $next)
echo "next: $next (w/ prev)"
echo "- $next" >> rings/geneRing.yml
git add _data/qm.yml rings/geneRing.yml
tic=$(date +%s)
eval "$(perl -S fullname.pl -a $next | eyml)"
bot="$fullname"
echo "*bot: $bot"
git config user.name "$fullname"
git config user.email "$user@$domain"
sed -i -e "s/bot: .*/bot: $bot/" -e "s/tic: .*/tic: $tic/" \
   -e "s/bafy: .*/bafy: $bafy/" -e "s/next: .*/next: $next/" _data/qm.yml


# publish next qm !
git config ipfs.prev $(git config ipfs.qm)
git config ipfs.qm $next
ipfs config Gateway.RootRedirect /ipfs/$next
ssh serv01 "ipfs config Gateway.RootRedirect /ipfs/$next"
ipfs --offline name publish --key=genesis /ipfs/$next
key=$(ipfs key list -l | grep -w $name | cut -d' ' -f1)
echo "url: https://127.0.0.1:8080/ipns/$key"
bafy=$(ipfs cid base32 $next)

echo "url: https://$bafy.cf-ipfs.com/"
sed -i -e "s/next: .*/next: $next/" _data/qm.yml
eval $(version _data/qm.yml | eyml)
git commit -m "ver: $version, tic: $tic, next:$next"
gitid=$(git rev-parse --short HEAD)
date=$(date +%D);
git tag -f -a "$scheduled" -m "tagging $gitid on $date"
if git ls-remote --tags | grep "$scheduled"; then
git push --delete origin "$scheduled"
fi
git push --follow-tags
np1=$(expr $n + 1)
sed -i -e "s/^n: $n/n: $np1/" _data/n.yml
