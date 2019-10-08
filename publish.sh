#

#set -e
find . -name \*.org -delete

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
echo "new: $new"
echo " - $new" >> _data/qm.yml

