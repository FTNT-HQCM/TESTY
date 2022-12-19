cd ~/github/TESTY # when calling from jenkins, need to ssh to this directory
ls -lah
# git config --list # for some reason, jenkins ssh'd terminal has a hard time with this. leave it out
# exit 0

# git tag with version info given as args 
maj=${1}
min=${2}
patch=${3}

# configure git and env variables. this is needed every time
git config user.name "FTNT-HQCM"
git config user.email "hq-devops-admin@fortinet.com"
git config user.signingKey 2F2D5F2F0C4A474B
git config commit.gpgsign true
export GPG_TTY=$(tty)
export GPG_FINGERPRINT=B0B70C24FDCD58F7ED456EF52F2D5F2F0C4A474B
export http_proxy=http://172.30.41.250:3128
export https_proxy=http://172.30.41.250:3128
eval `ssh-agent -s`
ssh-add ~/.ssh/dops_admin_ssh

# commit changes
git add .
git commit -m "commit for release v${maj}.${min}.${patch}" # at this point in the script it should stop and ask for the gpg passphrase
git push # need this I think to push commit to remote. not needed for real terraform release?
git tag -a ${maj}.${min}.${patch} -m "v${maj}.${min}.${patch}"
git push --tags
