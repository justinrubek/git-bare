# Check if at least one argument (git URL) is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <git_url> [directory_name]"
    echo "Example: $0 git@github.com:user/project.git [my-project]"
    exit 1
fi

git_url="$1"
dir_name="${2:-}"  # parameter expansion; default empty string

# If no directory name is provided, extract it from the git URL
if [ -z "$dir_name" ]; then
    repo_with_ext=$(basename "$git_url")
    dir_name=${repo_with_ext%.git}
fi

mkdir -p "$dir_name" && cd "$dir_name"
git clone --bare "$git_url" .bare
echo "gitdir: ./.bare" > .git

git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git fetch
git for-each-ref --format='%(refname:short)' refs/heads | xargs -n1 -I{} git branch --set-upstream-to=origin/{}

echo "Bare repository cloned successfully in '$dir_name'"

main_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
git worktree add main "${main_branch}"
