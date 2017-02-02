
# antibody() {
  source <(antibody init)
  # antibody "$@"
# }

# Antibody - zsh plugin manager
# I was using Antigen. It is a good plugin manager, but it's bloated and slow - 5+ seconds to load on my Mac...
# that's way too much to wait for a prompt to load!
# https://github.com/getantibody/antibody

# load antibody plugins
source ~/.bundles.txt
