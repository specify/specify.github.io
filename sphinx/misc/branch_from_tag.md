## Create a branch from a tagged release

1. Go to the tagged releases (<https://github.com/specify/specify7/tags|tags>) for Specify 7
2. Navigate directly to the last commit linked from the tagged release directly by clicking on the commit hash: (<https://github.com/specify/specify7/commit/a991a42658c83e626f3631326895cbe5ebe4edc4>) From here, copy the last component (full commit hash) from the URL (after /commit/)
3. Open Terminal and went to the `specify7` dir
4. Run `git checkout a991a42658c83e626f3631326895cbe5ebe4edc4` (replacing `a991a42658c83e626f3631326895cbe5ebe4edc4` with the exact commit hash copied in step 2)
5. Create a new branch: `git checkout -b 7961` (the branch name is arbitrary, in this case it is 7961)
6. Push it to GitHub: `git push -u origin 7961`
7. Now you have a new branch based on a tagged release!