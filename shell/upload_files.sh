git add ./*

time=$(date "+%Y-%m-%d %H:%M:%S")
echo $time

git commit -m "Sync files at: ${time}"
git push
