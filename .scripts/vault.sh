set -o errexit
set -o nounset

# Create a vault file from a variables YAML file.
# Encrypted variables are prefixed with 'vault_', and a vault.vars.yml maps the non-prefixed variables to these.
function encrypt    # USAGE: encrypt vars.yml inventory/host_vars/localhost/ [password.txt]
{
  VARS_FILE="${1}"
  VAULT_DIR="${2}"
  PASSWORD_FILE="${3:-}"
  mkdir -p "${VAULT_DIR}" &>/dev/null || :

  # create mappings file containg: VAR: "{{ vault_VAR }}"
  sed -E 's/^(.+):.+$/\1: "{{ vault_\1 }}"/g' "${VARS_FILE}" > "${VAULT_DIR}/vault.vars.yml"

  # generate a variables file with prefixed variables, and then encypt it into a vault file
  sed -E 's/^(.+):(.+)$/vault_\1: \2/g' "${VARS_FILE}" | \
  ansible-vault encrypt \
    --output "${VAULT_DIR}/vault" \
    ${PASSWORD_FILE:+--vault-password-file "${PASSWORD_FILE}"} \
    /dev/fd/0

}

# decrypt a vault file
function decrypt    # USAGE: decrypt vault [password.txt]
{
  VAULT_FILE="${1}"
  PASSWORD_FILE="${2:-}"
  ansible-vault decrypt --output - ${PASSWORD_FILE:+--vault-password-file "${PASSWORD_FILE}"} "${VAULT_FILE}"
}

if [ $# -eq 0 ]
then
  echo 'Availabe functions:'
  grep '^function .*' "$(readlink -f $0)"
else
  declare -F ${1} > /dev/null && "${@}"
fi
