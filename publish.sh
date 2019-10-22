#

#set -e
find . -name \*.\*~\* -delete
#curl -s https://www.genesis-block.ml | pandoc -t json | xjson blocks.29.c.1.1.c.4.c

echo "--- # ${0##*/}"
name=genesis
qm=$(ipfs add -Q -r _site)
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
sed -i -e "s/bot: .*/bot: $bot/" -e "s/tic: .*/tic: $tic/" _data/qm.yml
echo "new: $new"
echo " - $new" >> _data/qm.yml



