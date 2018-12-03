Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39500 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbeLCBhG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 20:37:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1F04D2A6DF
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 01:37:02 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 01:37:00 +0000
Message-ID: <bug-201685-13602-j4HwH0P01R@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #177 from Néstor A. Marchesini (nestorm_des@hotmail.com) ---
I did a lot of tests here, the first thing was to configure with tune2fs so
that in each boot I forcefully check my three partitions, the / boot the / root
and the / home partition.

# tune2fs -c 1 /dev/md0
# tune2fs -c 1 /dev/md2
# tune2fs -c 1 /dev/md3

I have reinstalled and compiled tree 4.19.5 and 4.19.0 from scratch, as well as
the new tree 4.19.6.
I have not had problems with the 4.19.5 or with the new 4.19.6, many hours of
use and restarts every time .. everything perfect.
But at the first boot with 4.19.0 ... corruption of the root partition.
it leaves me in the console for repair, I repair it with:

# fsck.ext4 -y /dev/md2

After started, I'll see /lost+found and find many folders and files in perfect
condition, not corrupt, but with the numeric names #

# ls -l /lost+found/
total 76
-rw-r--r-- 1 portage portage 5051 dic 10  2013 '#1057825'
drwxr-xr-x 3 portage portage 4096 dic 10  2013 '#1057827'
-rw-r--r-- 1 root    root    2022 oct 22 03:37 '#3184673'
-rw-r--r-- 1 root    root     634 oct 22 03:37 '#3184674'
etc...
etc...

So decided I started with the bisection, download only from 4.18 onwards.

$ su
# cd /usr/src
# git clone
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
--shallow-exclude v4.17 linux-stable

# eselect kernel list
Available kernel symlink targets:
  [1]   linux-4.18.20-gentoo
  [2]   linux-4.19.0-gentoo
  [3]   linux-4.19.5-gentoo
  [4]   linux-4.19.6-gentoo *
  [5]   linux-stable

# eselect kernel set 5

# eselect kernel list 
Available kernel symlink targets:
  [1]   linux-4.18.20-gentoo
  [2]   linux-4.19.0-gentoo
  [3]   linux-4.19.5-gentoo
  [4]   linux-4.19.6-gentoo
  [5]   linux-stable *

# ls -l
total 20
lrwxrwxrwx  1 root root   12 dic  2 21:27 linux -> linux-stable
drwxr-xr-x 27 root root 4096 nov 24 14:44 linux-4.18.20-gentoo
drwxr-xr-x 27 root root 4096 dic  2 20:28 linux-4.19.0-gentoo
drwxr-xr-x 27 root root 4096 dic  2 03:47 linux-4.19.5-gentoo
drwxr-xr-x 27 root root 4096 dic  2 14:50 linux-4.19.6-gentoo
drwxr-xr-x 26 root root 4096 dic  2 19:18 linux-stable

# cd linux
# git bisect start v4.19 v4.18 -- fs/ext4
Bisectando: faltan 16 revisiones por probar después de esto (aproximadamente 4
pasos)
[863c37fcb14f8b66ea831b45fb35a53ac4a8d69e] ext4: remove unneeded variable "err"
in ext4_mb_release_inode_pa()

# git bisect log
# bad: [84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d] Linux 4.19
# good: [94710cac0ef4ee177a63b5227664b38c95bbf703] Linux 4.18
git bisect start 'v4.19' 'v4.18' '--' 'fs/ext4'

Just beginning, today was Sunday and ... besides little experience with git :)
I was also looking at the ebuilds of the gentoo-sources trees to know what
patches I applied to emerge when installing the sources.

$ cat /usr/portage/sys-kernel/gentoo-sources/gentoo-sources-4.18.20.ebuild
|grep K_GENPATCHES_VER=
K_GENPATCHES_VER="24"
$ ls -lh /usr/portage/distfiles/genpatches-4.18-24.base.tar.xz 
-rw-rw-r-- 1 portage portage 661K nov 21 10:13
/usr/portage/distfiles/genpatches-4.18-24.base.tar.xz
$ tar -tf /usr/portage/distfiles/genpatches-4.18-24.base.tar.xz 
./0000_README
./1000_linux-4.18.1.patch
./1001_linux-4.18.2.patch
./1002_linux-4.18.3.patch
./1003_linux-4.18.4.patch
./1004_linux-4.18.5.patch
./1005_linux-4.18.6.patch
./1006_linux-4.18.7.patch
./1007_linux-4.18.8.patch
./1008_linux-4.18.9.patch
./1009_linux-4.18.10.patch
./1010_linux-4.18.11.patch
./1011_linux-4.18.12.patch
./1012_linux-4.18.13.patch
./1013_linux-4.18.14.patch
./1014_linux-4.18.15.patch
./1015_linux-4.18.16.patch
./1016_linux-4.18.17.patch
./1017_linux-4.18.18.patch
./1018_linux-4.18.19.patch
./1019_linux-4.18.20.patch
./1500_XATTR_USER_PREFIX.patch
./1510_fs-enable-link-security-restrictions-by-default.patch
./2500_usb-storage-Disable-UAS-on-JMicron-SATA-enclosure.patch
./2600_enable-key-swapping-for-apple-mac.patch

$ tar -xf /usr/portage/distfiles/genpatches-4.18-24.base.tar.xz
./1019_linux-4.18.20.patch
$ ls -lh 1019_linux-4.18.20.patch
-rw-r--r-- 1 nestor nestor 164K nov 21 10:01 1019_linux-4.18.20.patch

$ cat /usr/portage/sys-kernel/gentoo-sources/gentoo-sources-4.19.0.ebuild |grep
K_GENPATCHES_VER=
K_GENPATCHES_VER="1"
$ ls -lh /usr/portage/distfiles/genpatches-4.19-1.base.tar.xz
-rw-rw-r-- 1 portage portage 4,0K oct 22 08:47
/usr/portage/distfiles/genpatches-4.19-1.base.tar.xz
$ tar -tf /usr/portage/distfiles/genpatches-4.19-1.base.tar.xz
./0000_README
./1500_XATTR_USER_PREFIX.patch
./1510_fs-enable-link-security-restrictions-by-default.patch
./2500_usb-storage-Disable-UAS-on-JMicron-SATA-enclosure.patch
./2600_enable-key-swapping-for-apple-mac.patch

As you can see in the 4.19.0 tree do not apply patches 1000_linux-4.19.x.patch

My gcc version for quite some time:
$ gcc -v
gcc versión 8.2.0 (Gentoo 8.2.0-r5 p1.6

Obviously something happens with the inodes, but apparently only I'm doing it
now with the tree 4.19.0.
If I find something I will be reporting it.

Regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
