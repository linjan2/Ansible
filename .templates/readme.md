# .templates

```sh
ansible-playbook project/playbook.yml
ansible-playbook --list-tasks project/playbook.yml
ansible-playbook --list-tags project/playbook.yml
ansible-playbook --tags 'test1,test2' project/playbook.yml

# from git-root directory (otherwise ansible.cfg is used when in working directory)
ansible-playbook --inventory=.templates/inventory --vault-password-file=password.txt .templates/project/playbook.yml

# using `inventory/inventory.ini` instead of `inventory/inventory.yml`
ansible-playbook --inventory=.templates/inventory/inventory.ini --vault-password-file=password.txt .templates/project/playbook.yml

# generate ansible configuration with all options disabled
ansible-config init --format ini --disabled --type all > ansible.cfg
ansible-config init --format vars --disabled --type all > vars.yml
ansible-config init --format env --disabled --type all > vars.env

# documentation
ansible-doc --type lookup --list 
ansible-doc --type module ansible.builtin.uri
ansible-doc --type filter community.general.json_query
```

Run offline

```sh
export PIP_INDEX_URL=https://pip.domain.lo/pypi/DefaultPyPi/simple
export PIP_TRUSTED_HOST=pip.domain.lo
export PIP_CERT=/public-certs/ca-certs.ca-bundle.crt

pip install ansible-galaxy

GALAXY_URL=https://webserver.domain.lo
ansible-galaxy collection install -p ~/.ansible/collections ${GALAXY_URL}/{ansible-utils-2.9.0.tar.gz,community-general-7.0.0.tar.gz,kubernetes-core-2.4.0.tar.gz}
  # global collections are in /usr/share/ansible/collections
```
