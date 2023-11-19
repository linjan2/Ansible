set -o errexit
set -o nounset

# Create an encrypted vault file "vault" from input variables file, and also create "vault.vars.yml" with the vaulted variables safely visible.
# Encrypted variables are prefixed with 'vault_', and the vault.vars.yml maps them to the non-prefixed variables specified in input variables file.
# As specified at: https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html#keep-vaulted-variables-safely-visible
# If vault password file if not specified then user is prompted for the vault password.
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
    -
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
