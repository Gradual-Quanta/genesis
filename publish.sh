#

#set -e
find . -name \*~1 -delete
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


JEKYLL_ENV=production jekyll build
next=$(ipfs add -Q -r _site)
echo "next: $next"
ipfs config Gateway.RootRedirect /ipfs/$next
ssh serv01 "ipfs config Gateway.RootRedirect /ipfs/$next"
ipfs --offline name publish --key=genesis /ipfs/$next
key=$(ipfs key list -l | grep -w $name | cut -d' ' -f1)
echo "url: https://127.0.0.1:8080/ipns/$key"
bafy=$(ipfs cid base32 $qm)
echo "url: https://$baffy.cf-ipfs.com/"
sed -i -e "s/next: .*/next: $next/" _data/qm.yml
git add _data/qm.yml
eval $($HOME/bin/version _data/qm.yml | eyml)
git commit -m "ver: $version, tic: $tic, next:$next"
gitid=$(git rev-parse --short HEAD)
date=$(date +%D);
git tag -f -a "$scheduled" -m "tagging $gitid on $date"
if git ls-remote --tags | grep "$scheduled"; then
git push --delete origin "$scheduled"
fi
git push --follow-tags

