# Grobisplitter
### Or how I learned to stop worrying and love modules

## Where are the sources 

The Current Master Git Repository for the grobisplitter program is
https://github.com/fedora-modularity/GrobiSplitter . The program
depends upon python3 and some other programs.

* gobject-introspection
* libmodulemd-2.5.0
* libmodulemd1-1.8.11
* librepo
* python3-gobject-base
* python3-hawkey
* python3-librepo

## What does Grobisplitter splitter.py do?

Grobisplitter was born out of the addition of modules to Fedora and
RHEL-8. A module is a virtual rpm repository inside of a standard rpm
repository where a sysadmin can choose which virtual repositories are
used in a system or not. This allows for useful choices without having
to add more repository configs, but it adds a complexity that the koji
build system does not understand. While the MBS system could help
handle this for packages it knows it built, it can not do so for ones
that are external which is the case when building CentOS or EPEL
packages. 

Grobisplitter was created by Patrick Uiterwijk to deal with part of
this while permanent solutions were created in MBS and
koji. Grobisplitter takes a modular repository (as example a reposync
copy of RHEL-8) and 'flattens' it out with each module becoming its
own independent repository. Options to the command are

``` shell
[smooge@batcave01 RHEL-8-001]$ /usr/local/bin/splitter.py --help
usage: splitter.py [-h] [--action {hardlink,symlink,copy}] [--target TARGET]
                   [--skip-missing] [--create-repos] [--only-defaults]
                   repository

Split repositories up

positional arguments:
  repository            The repository to split

optional arguments:
  -h, --help            show this help message and exit
  --action {hardlink,symlink,copy}
                        Method to create split repos files
  --target TARGET       Target directory for split repos
  --skip-missing        Skip missing packages
  --create-repos        Create repository metadatas
  --only-defaults       Only output default modules

```

To save diskspace, one can use different methods to copy packages,
target a specific directory, only allow for default modules, and
create repos for each of the virtual repositories seperately. 

Each module is split into a name matching its modular dataname, for
example as of 2020-12-03, here are the httpd modules of RHEL-8 split out:

``` shell

[smooge@batcave01 RHEL-8-001]$ ls -1d httpd*
httpd:2.4:8000020190405071959:55190bc5:x86_64/
httpd:2.4:8000020190829150747:f8e95b4e:x86_64/
httpd:2.4:8010020190829143335:cdc1202b:x86_64/
httpd:2.4:8020020200122152618:6a468ee4:x86_64/
httpd:2.4:8020020200824162909:4cda2c84:x86_64/
httpd:2.4:8030020200818000036:30b713e6:x86_64/

```

The reason that there are multiple modules versus just the latest
module was due to problems in knowing what the 'latest' module was to
use. It needs to know about all the packages in the upstream
repositories for modular decisions to be made. This means that the
staged data will be a complete copy of the RHN repository.

``` shell

total 4980
-rw-r--r--. 1 root sysadmin-main 1463679 2020-11-03 09:18 httpd-2.4.37-30.module+el8.3.0+7001+0766b9e7.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main  224591 2020-11-03 09:18 httpd-devel-2.4.37-30.module+el8.3.0+7001+0766b9e7.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main   37599 2020-11-03 09:18 httpd-filesystem-2.4.37-30.module+el8.3.0+7001+0766b9e7.noarch.rpm
-rw-r--r--. 1 root sysadmin-main 2486719 2020-11-03 09:18 httpd-manual-2.4.37-30.module+el8.3.0+7001+0766b9e7.noarch.rpm
-rw-r--r--. 1 root sysadmin-main  106479 2020-11-03 09:18 httpd-tools-2.4.37-30.module+el8.3.0+7001+0766b9e7.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main  157763 2020-11-03 09:18 mod_http2-1.15.7-2.module+el8.3.0+7670+8bf57d29.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main   84163 2020-11-03 09:18 mod_ldap-2.4.37-30.module+el8.3.0+7001+0766b9e7.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main  189343 2020-11-03 09:18 mod_md-2.0.8-8.module+el8.3.0+6814+67d1e611.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main   60531 2020-11-03 09:18 mod_proxy_html-2.4.37-30.module+el8.3.0+7001+0766b9e7.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main   72475 2020-11-03 09:18 mod_session-2.4.37-30.module+el8.3.0+7001+0766b9e7.x86_64.rpm
-rw-r--r--. 1 root sysadmin-main  135799 2020-11-03 09:18 mod_ssl-2.4.37-30.module+el8.3.0+7001+0766b9e7.x86_64.rpm


```

All non-modular rpms from the repository are put in a directory called
`non-modular` which can also have its own repodata set up for it.

## What does rhel8-split.sh do?

While the splitter command does the hard work of splitting out the
packages, the rhel8-split.sh shell does the 'business' work of setting
up the repositories so that koji can consume it for EPEL-8 and other
builds.

The first part of this is done by a cron job which reposyncs down from
the Red Hat access.redhat.com the various packages for the
architectures Fedora Infrastructure needs. The data is synced down
into subdirectories in `/mnt/fedora/app/fi-repo/rhel/rhel8` which
match channels in RHEL BaseOS, AppStream, CodeReadyBuilder as needed. 

Next a new destination directory is made in
`/mnt/fedora/app/fi-repo/rhel/rhel8/koji/` with the date of the cron
job being run so that we can always roll back to an older external Red
Hat repo if needed. Afterwards we begin breaking apart the repos per
architecture. The splitter is then called per channel that is wanted
to be used in EPEL. The Base and AppStream channel only splits out the
'default' modules while the Code Ready Builder splits out all modules
as many are non-default.

After the files have been copied into a single tree a `createrepo_c`
is run with the data. This creates a 'flattened' repository with data
in it. However modular data from all these repos is currently lost.

Once the data has been synced and flattened for all repositories, a
series of links are set up that koji can point to. At this point a
last reposync cycle is done using dnf to pull in only the newest
rpms. This effectively cleans up large number of older packages to
make sure the builders have an easier time deciding which package to
use. [Basically as of 2020-12-03, the staged repo has 66130 packages
in it, and the latest shrinks that down to 26530.]

Koji then is pointed to the trees on batcave served from
`/mnt/fedora/app/fi-repo/rhel/rhel8/koji/latest/${arch}/RHEL-8-001`.

TODO:
1. Currently the RHEL-8-001 is a consequence of the rhel8-split.sh
   script. We split each repo into its own tree and then copy them
   into one final one. This should be done better.
2. A way to clean up the 'empty' directory names in latest would help
   make it easier to see what is actually being 'used' by koji.
   
   ```
[smooge@batcave01 latest]$ ls -1d x86_64/RHEL-8-001/go-toolset\:rhel8\:80*
x86_64/RHEL-8-001/go-toolset:rhel8:8000020190509153318:b9255456:x86_64/
x86_64/RHEL-8-001/go-toolset:rhel8:8000120190520160856:4a778a88:x86_64/
x86_64/RHEL-8-001/go-toolset:rhel8:8000120190828225436:14bc675c:x86_64/
x86_64/RHEL-8-001/go-toolset:rhel8:8010020190829001136:ccff3eb7:x86_64/
x86_64/RHEL-8-001/go-toolset:rhel8:8010020191220185136:0ed30617:x86_64/
x86_64/RHEL-8-001/go-toolset:rhel8:8020020200128163444:0ab52eed:x86_64/
x86_64/RHEL-8-001/go-toolset:rhel8:8020020200817154239:02f7cb7a:x86_64/
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/

   ``` 
   makes this look like it has lots of files .. however only one tree
   has files in it.
   ```

[smooge@batcave01 latest]$ find x86_64/RHEL-8-001/go-toolset\:rhel8\:80*
x86_64/RHEL-8-001/go-toolset:rhel8:8000020190509153318:b9255456:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8000120190520160856:4a778a88:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8000120190828225436:14bc675c:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8010020190829001136:ccff3eb7:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8010020191220185136:0ed30617:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8020020200128163444:0ab52eed:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8020020200817154239:02f7cb7a:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/delve-1.4.1-1.module+el8.3.0+7840+63dfb1ed.x86_64.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/go-toolset-1.14.7-1.module+el8.3.0+7840+63dfb1ed.x86_64.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/golang-1.14.7-2.module+el8.3.0+7840+63dfb1ed.x86_64.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/golang-bin-1.14.7-2.module+el8.3.0+7840+63dfb1ed.x86_64.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/golang-docs-1.14.7-2.module+el8.3.0+7840+63dfb1ed.noarch.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/golang-misc-1.14.7-2.module+el8.3.0+7840+63dfb1ed.noarch.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/golang-race-1.14.7-2.module+el8.3.0+7840+63dfb1ed.x86_64.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/golang-src-1.14.7-2.module+el8.3.0+7840+63dfb1ed.noarch.rpm
x86_64/RHEL-8-001/go-toolset:rhel8:8030020200827141259:13702366:x86_64/golang-tests-1.14.7-2.module+el8.3.0+7840+63dfb1ed.noarch.rpm

   ```
