#

cat >_data/n.yml <<EOF
--- # Genesis counter n
n: 0
EOF

cat >_data/qm.yml <<EOF
--- # genesis blockRing™
name: genesis
tic: epoch
bot: ""
bafy: ~
next: ~
qm:
 - z6cYNbecZSFzLjbSimKuibtdpGt7DAUMMt46aKQNdwfs
EOF

echo "--- # GeneRing™ mutable block" > rings/geneRing.yml
rm -rf _site/*




true; # $Source: /my/shell/script/geneRing-reset.sh $
