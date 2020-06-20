hugo -D -t shiori
cd public
git add --all
git commit -m "update blog"
git pull origin master
git push origin master
cd -
