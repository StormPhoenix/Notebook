git add ./*

time=$(data "+%Y-%m-%d %H:%M:%S")
git commit -m "Sync files at: ${time}"
git push