# git-bare

Basic git utilities for working using worktrees in bare repositories.

I use worktrees in order to perform concurrent work on the same repository.
Rather than stashing or committing changes, I create a new worktree if I need to perform a review or have a very long-running branch.
The top-level directory shows all of the active worktrees, so I can easily see if it is getting out of hand.

This also ensures that there can be an up to date main branch (or others, if you have special branches) to diff against.

## git-bare-clone

Performs a `git clone` operation, and places the main branch in a worktree named `main`.
The main branch is determined via git, so if your repo's branch is not `main`, it will be detected.
However, the worktree will still be located in the `main` directory.

### usage

`nix run github:justinrubek/git-bare#clone git@github.com:justinrubek/git-bare.git`

`git bare-clone git@github.com:justinrubek/git-bare.git`


## git-bare-init

Performs a `git init` operation and places the main branch in a worktree named `main`.
This will create an empty initial commit.
Any non-hidden files located in the directory will be moved into a worktree called `workspace` and left otherwise untouched.

### usage

`nix run github:justinrubek/git-bare#init`

`git bare-init repo_name`
