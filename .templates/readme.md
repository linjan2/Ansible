# .templates

```sh
ansible-playbook project/playbook.yml

# from git-root directory (otherwise ansible.cfg is used when in working directory)
ansible-playbook --inventory=.templates/inventory --vault-password-file=password.txt .templates/project/playbook.yml

# using `inventory/inventory.ini` instead of `inventory/inventory.yml`
ansible-playbook --inventory=.templates/inventory/inventory.ini --vault-password-file=password.txt .templates/project/playbook.yml
```
