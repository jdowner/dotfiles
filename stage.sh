#!/bin/bash

curdir=${PWD}
prefix="."
target=${HOME}
config=
files=

# parse arguments
while [[ $# > 0 ]];
do
  case $1 in
    -t|--target)
      target=$2
      shift
      ;;
    -p|--prefix)
      prefix=$2
      shift
      ;;
    -c|--config)
      config=$2
      shift
      ;;
  esac
  shift
done

# check input
if [[ -z "${target}" ]]; then
  echo "ERROR: unknown target"
  exit 1
fi

if [[ -z "${config}" ]]; then
  echo "ERROR: a configuration file is required"
  exit 1
fi

# get the list of files and directories from the configuration file
files=$(cat "${config}" | xargs)

# TODO ensure the submodules are up to date

# create a staging repository
staging=$(mktemp -q -d --tmpdir dotfiles-XXXXXX)
echo staging area: ${staging}
cd ${staging}
git init -q
cd ${curdir}

# copy the deploy script to the staging area and add a .gitignore
echo "#!/bin/bash" > ${staging}/deploy.sh
echo "rsync -avc --exclude '.git/' --exclude 'deploy.sh' . ${target}" >> ${staging}/deploy.sh
chmod +x ${staging}/deploy.sh
echo deploy.sh >> ${staging}/.gitignore

cd ${staging}
git add .gitignore
git commit -qm "added .gitignore"
cd ${curdir}

# copy target files/directories to staging area
for f in ${files};
do
  if [[ -e ${target}/${prefix}${f} ]]; then
    cp -r ${target}/${prefix}${f} ${staging}
  fi
done

# create a commit for each file or directory in the staging repository that
# could be replaced. This will ensure that it is possible to revert any
# accidental changes.
cd ${staging}
for f in ${files};
do
  if [[ -e ${prefix}${f} ]]; then
    git add ${prefix}${f}
    git commit -qm "staged ${prefix}${f}"
    echo staging: ${prefix}${f}
  fi
done
cd ${curdir}

# copy the dotfiles into the repository area
for f in ${files};
do
  rsync -qavc ${f} ${staging}/${prefix}${f}
done

# change to the staging repository and show the status
cd ${staging}
git status
cd ${curdir}
