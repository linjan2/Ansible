set -o errexit
set -o nounset


function pip_install
{
  pip install --upgrade pip
  pip install ansible-core ansible-vault jmespath
}

if [ $# -eq 0 ]
then  
  cat <<EOF
. ~/bin/py3venv/bin/activate
${0} pip_install
EOF
else
  declare -F ${1} > /dev/null && "${@}"
fi

