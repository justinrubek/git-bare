# Check if a directory name is provided
dir_name="${1:-$(basename "$(pwd)")}"

# If we're not already in the target directory, create it and navigate to it
if [ "$(basename "$(pwd)")" != "$dir_name" ]; then
    mkdir -p "$dir_name" && cd "$dir_name"
fi

# Check if there are existing files (excluding hidden files/dirs)
has_existing_files=false
shopt -s nullglob  # Handle case where no files match pattern
files=(*)  # Get all non-hidden files in current directory
if [ ${#files[@]} -gt 0 ]; then
    has_existing_files=true
fi

# create a temporary directory to move existing files
if [ "$has_existing_files" = true ]; then
    temp_storage_dir=$(mktemp -d -t git-init-files-XXXXXXXXXX)
    # Move all non-hidden files to temp directory
    for file in "${files[@]}"; do
        mv "$file" "$temp_storage_dir/"
    done
fi

git init --bare .bare
echo "gitdir: ./.bare" > .git

git config --local init.defaultBranch main
git config --local core.bare false

git worktree add main
pushd main
git commit --allow-empty -m "chore: initial commit"
popd

# if there were existing files, set up workspace and move files there
if [ "$has_existing_files" = true ]; then
    git worktree add workspace

    # move existing files to workspace
    # use nullglob to handle case where no files match pattern
    shopt -s nullglob
    temp_files=("$temp_storage_dir"/*)
    if [ ${#temp_files[@]} -gt 0 ]; then
        mv "$temp_storage_dir"/* workspace/
    fi
    rm -rf "$temp_storage_dir"

    echo "Existing files have been moved to the workspace worktree"
    echo "You can navigate to the workspace directory and commit them when ready"
fi

# Fix remote references for future use
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'

echo "git repository initialized in $dir_name"
if [ "$has_existing_files" = true ]; then
    echo "Workspace worktree with your existing files is in the 'workspace' directory"
fi
