builtinCombinators:
with builtinCombinators;
{
  git-config = compose [
    (try-readonly "/etc/gitconfig")
    (try-readonly (noescape "~/.gitconfig"))
    (try-readonly (noescape "~/.config/git/config"))
  ];
}
