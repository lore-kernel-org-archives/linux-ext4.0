From: "George Spelvin" <linux@sciencehorizons.net>
Subject: More inline data oddities
Date: 1 May 2017 13:40:01 -0400
Message-ID: <20170501174001.3541.qmail@ns.sciencehorizons.net>
Cc: linux@sciencehorizons.net
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:51857 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750703AbdEARkD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 May 2017 13:40:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The new e2fsck 1.43.4 (31-Jan-2017) has definitely helped, but I'm
still seeing some flakiness with inline_data directories.  There's still
a kernel problem, which is creating file systems that confuse e2fsck.

But I have more data on the e2fsck problem which is mis-correcting that
problem so it takes a second run to get a clean file system.

Specifically, e2fsck is creating the missing system.date problem on one
run and then zeroing out the directory on another.

The problem is occurring when I rsync to a small directory.  Consider
the following directories:

 1461410  (12) .    1421827  (12) ..    1461583  (20) potd-800.jpg
 1472133  (36) .xvpics    1461401  (72) .potd-800.jpg.4176

 1461314  (12) .    1421827  (12) ..    1461426  (20) potd-800.jpg
 1463943  (36) .xvpics    1461400  (72) .potd-800.jpg.4176

During the rsync run, I got syslog complaints:

[255031.626936] EXT4-fs warning (device md3): ext4_dirent_csum_verify:352: inode #1461410: comm find: No space for directory leaf checksum. Please run e2fsck -D.
[255031.626940] EXT4-fs error (device md3): ext4_readdir:198: inode #1461410: comm find: path $PATH1: directory fails checksum at offset 0
[255035.720542] EXT4-fs warning (device md3): ext4_dirent_csum_verify:352: inode #1461314: comm find: No space for directory leaf checksum. Please run e2fsck -D.
[255035.720547] EXT4-fs error (device md3): ext4_readdir:198: inode #1461314: comm find: path $PATH2: directory fails checksum at offset 0


The inline data consists of two parts: 60 bytes in the block pointers which
hold the first four entries, and 72 bytes in an ea, which holds the fifth and
last entry.

debugfs on the directories reveals the following:
Inode: 1461410   Type: directory    Mode:  0755   Flags: 0x10000000
Generation: 927521379    Version: 0x00000000:00000007
User:  1000   Group:    11   Project:     0   Size: 132
File ACL: 1496481792    Directory ACL: 0
Links: 3   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 mtime: 0x55016b84:e7729ec8 -- Thu Mar 12 06:33:40 2015
crtime: 0x56c1c093:0d01b4b4 -- Mon Feb 15 07:12:03 2016
Size of extra inode fields: 32
Extended attributes:
  system.data (72)
Inode checksum: 0x456bd90c
Size of inline data: 132

Inode: 1461314   Type: directory    Mode:  0755   Flags: 0x10000000
Generation: 927521364    Version: 0x00000000:00000004
User:  1000   Group:    11   Project:     0   Size: 132
File ACL: 1496383488    Directory ACL: 0
Links: 3   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 mtime: 0x55016b84:1670325c -- Thu Mar 12 06:33:40 2015
crtime: 0x56c1c093:01161e74 -- Mon Feb 15 07:12:03 2016
Size of extra inode fields: 32
Extended attributes:
  system.data (72)
Inode checksum: 0x008d7abf
Size of inline data: 132


If I run e2fsck on that stat, it complains about two things:

Inode 1461314, i_blocks is 8, should be 0.  Fix<y>? yes
Inode 1461410, i_blocks is 8, should be 0.  Fix<y>? yes
i_file_acl for inode 1461314 ($PATH2) is 1496383488, should be zero.
Clear<y>? yes
i_file_acl for inode 1461410 ($PATH1) is 1496481792, should be zero.
Clear<y>? yes

I don't really understand how those two errors were created in the
first place.

However, after saying yes to those, the system.data ea is missing and the
final entries in each directory get dropped, leading to being dumped
in loat+found.

Here's the state after the first e2fsck run completes:

Inode: 1461410   Type: directory    Mode:  0755   Flags: 0x10000000
Generation: 927521379    Version: 0x00000000:00000007
User:  1000   Group:    11   Project:     0   Size: 132
File ACL: 0    Directory ACL: 0
Links: 3   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 mtime: 0x55016b84:e7729ec8 -- Thu Mar 12 06:33:40 2015
crtime: 0x56c1c093:0d01b4b4 -- Mon Feb 15 07:12:03 2016
Size of extra inode fields: 32
Inode checksum: 0xcd34b98c
Size of inline data: 60

Inode: 1461314   Type: directory    Mode:  0755   Flags: 0x10000000
Generation: 927521364    Version: 0x00000000:00000004
User:  1000   Group:    11   Project:     0   Size: 132
File ACL: 0    Directory ACL: 0
Links: 3   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
 mtime: 0x55016b84:1670325c -- Thu Mar 12 06:33:40 2015
crtime: 0x56c1c093:01161e74 -- Mon Feb 15 07:12:03 2016
Size of extra inode fields: 32
Inode checksum: 0x042ed119
Size of inline data: 60


This then leads to a second run complaining about

Inode 1461314 has INLINE_DATA_FL flag but extended attribute not found.  Truncate<y>?

If I instead fix it by "ea_set -f /dev/null <1461314> system.data", I get the
directory back in a relatively unbroken state.  But why is system.data
being deleted in the first place?
