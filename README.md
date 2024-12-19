# TDEdemo
Quick demo to show TDE capabilities in EPAS. 
What is TDE?
![What is TDE?](images/Picture1.png)

### Pre-requisites
To deploy this demo the following needs to be installed in the PC from which you are going to deploy the demo:

- VirtualBox (https://www.virtualbox.org/)
- Vagrant (https://www.vagrantup.com/)
- Vagrant Hosts plug-in (`vagrant plugin install vagrant-hosts`)
- Vagrant Reload plug-in (`vagrant plugin install vagrant-reload`)
- A file called `.edbtoken` with your EDB repository 2.0 token. This token can be found in your EDB account profile here: https://www.enterprisedb.com/accounts/profile

### Provisioning VM's
Provision the host using `vagrant up`. This will create the bare virtual machine and will take appx. 5 minutes to complete. 

After provisioning, the hosts will have the current directory mounted in their filesystem under `/vagrant`

### Userid and Passwords
- enterprisedb / enterprisedb (Owner of the instance)

## What the scripts do
- `provision.sh` provisions the EPAS server and install ESPA 17.
- `create_cluster_no_tde.sh` creates a standard EPAS cluster on port 5444 and $PGDATA on `/var/lib/edb/as17/datanotde`
- `create_cluster_with_tde.sh` creates a TDE-enabled EPAS cluster on port 5445 and $PGDATA on `/var/lib/edb/as17/datawithtde`
- `create_users_table` creates a table called `users` with one entry.
- `deprovision.sh` tears down the EPAS server.

All scripts are in the /vagrant directory on the server.

## Demo flow
1. Open four panes in your terminal, SSH in all panes into the EPAS server using `vagrant ssh`.
2. Top Left, Top Right: Become the enterprisedb user using: `sudo su - enterprisedb` and move to the `/vagrant` directory.
3. Bottom Left: Show the `create_cluster_no_tde.sh` script. 
4. Bottom Right: Show the `create_cluster_with_tde.sh` script. 
5. Bootom Left: Create a normal database using `. ./create_cluster_no_tde.sh` 
6. Bottom right: Create a normal database using `. ./create_cluster_with_tde.sh` 
7. Top Left: Connect to the database using `psql -p 5444 edb` 
8. Top right: Connect to the database using `psql -p 5445 edb` 
9. Bottom Left: Show `postgresql.conf` using `less $PGDATA/../datanotde/postgresql.conf` and search for `Data\ Encryp` 
10. Bottom right: Show `postgresql.conf` using `less $PGDATA/../datawithtde/postgresql.conf` and search for `Data\ Encryp` 
11. In both top panes, run `select data_encryption_version from pg_control_init();` 
12. Bottom right: Show the encryption key using `cat $PGDATA/../datawithtde/pg_encryption/key.bin` 
13. In both top panes, run `\i /vagrant/create_table_users.sql`
14. In both top panes, run `select pg_relation_filepath('users');` and  copy the result on the clipboard.
15. In both bottom panes, run `hexdump -C <paste the result>` 
16. Bottom Left: `pg_dump -p 5444 -U enterprisedb edb`
17. Bottom Right: `pg_dump -p 5445 -U enterprisedb edb`

Depovision the server using `deprovision.sh`.