From: "George Spelvin" <linux@horizon.com>
Subject: Sporadic metadata_csum errors
Date: 9 May 2013 05:12:23 -0400
Message-ID: <20130509091223.11334.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:52428 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751272Ab3EIJMZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 May 2013 05:12:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a "does this ring any bells" report, not yet a formal Bug Report.
As I said, I'm not 100% sure of the hardware, and metadata_csum may just
be catching previously invisible corruption.

One computer I've been running metata_csum on keeps bombing out
every couple of weeks with a kernel error like

[178447.345677] EXT4-fs error (device sda2): ext4_iget:4192: inode #892311: comm udisks-helper-a: checksum invalid
[178447.345682] Aborting journal on device sda2-8.
[178447.345891] EXT4-fs (sda2): Remounting filesystem read-only
[178447.346158] EXT4-fs error (device sda2): ext4_iget:4192: inode #892311: comm udisks-helper-a: checksum invalid
[180246.010747] EXT4-fs error (device sda2): ext4_iget:4192: inode #892311: comm udisks-helper-a: checksum invalid
[180246.011846] EXT4-fs error (device sda2): ext4_iget:4192: inode #892311: comm udisks-helper-a: checksum invalid

# debugfs -n /dev/sda2
debugfs 1.43-WIP (22-Sep-2012)
debugfs:  stat <892311>
Inode: 892311   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 444873085    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 322
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x502c7f65:37e9cca0 -- Thu Aug 16 01:04:37 2012
 atime: 0x5189802e:431ad914 -- Tue May  7 18:29:02 2013
 mtime: 0x5027d0d3:00000000 -- Sun Aug 12 11:50:43 2012
crtime: 0x502c7f06:c76d7c10 -- Thu Aug 16 01:03:02 2012
Size of extra inode fields: 28
Inode checksum: 0x9fe97671
EXTENTS:
(0):7475957

However, without -n, I get "stat: Inode checksum does not match inode
while reading inode 892311".  I can read 892310 and 892312.

A few notes:
* Processor is i3-530, with SSE 4.2 (CRC32)
* The hardware has been pretty good to me for about a year, but I'm
  not 100% sure of it.  I used to be annoyed that the RAM inexplicably
  wasn't stable at 1600 MHz, then after figuring out that it could run
  mprime (prime95) for 24 hours at 1530 MHz, I discovered that it was
  specified for 1333.  :-(  I haven't re-run that stability test lately.
* This has happened at least four times so far.  It's always the root file        system, and not /home on /dev/sda3.  Even though they're configured
  almost identically.  I have e2fsck logs from the last two (and this one,
  as soon as I fix it).
* Each time, e2fsck finds a couple of corrupted inodes and no other damage.
* This latest is with 3.9 + the ext4/dev tree, which fixed a metadata_csum
  bug.  I held off reporting the others because there was a known bugfix I
  didn't have.
* The file (/etc/udev/udev.conf in this case) appears uncorrupted when
  esamined with debigfs -n.  (Mut mi doesn't fix the checksum :-(.)
* ctime and mtime are both very old (although atime is only about three
  hiurs before the first erroe, despite relatime).
* Is there an existing tool to analyze an inode and look for single-bit
  errors?

This time, unlike other times, the inode that reported the error did
NOT show a checksum error after reboot:

Script started on Wed May  8 13:18:09 2013
# e2fsck -v /dev/sda2
e2fsck 1.43-WIP (22-Sep-2012)
root contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inodes that were part of a corrupted orphan linked list found.  Fix<y>? yes
Inode 3176 was part of the orphaned inode list.  FIXED.
Inode 474898 was part of the orphaned inode list.  FIXED.
Inode 578439 was part of the orphaned inode list.  FIXED.
Inode 587654 was part of the orphaned inode list.  FIXED.
Inode 588111 was part of the orphaned inode list.  FIXED.
Deleted inode 630260 has zero dtime.  Fix<y>? yes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(3517280--3517298) -(5091968--5092017) -(5868334--5868477) -(5890927--5890943) -(7769088--7769208) -(8725504--8726308)
Fix<y>? yes
Free blocks count wrong for group #107 (32749, counted=32768).
Fix<y>? yes
Free blocks count wrong for group #155 (27000, counted=27050).
Fix<y>? yes
Free blocks count wrong for group #179 (21646, counted=21807).
Fix<y>? yes
Free blocks count wrong for group #237 (27958, counted=28079).
Fix<y>? yes
Free blocks count wrong for group #266 (19765, counted=20570).
Fix<y>? yes
Free blocks count wrong (5796540, counted=5797696).
Fix<y>? yes
Inode bitmap differences:  -3176 -474898 -578439 -587654 -588111 -630260
Fix<y>? yes
Free inodes count wrong for group #0 (14, counted=15).
Fix<y>? yes
Free inodes count wrong for group #144 (0, counted=1).
Fix<y>? yes
Free inodes count wrong for group #176 (1, counted=2).
Fix<y>? yes
Free inodes count wrong for group #179 (379, counted=381).
Fix<y>? yes
Free inodes count wrong for group #192 (239, counted=240).
Fix<y>? yes
Free inodes count wrong (684282, counted=684288).
Fix<y>? yes

root: ***** FILE SYSTEM WAS MODIFIED *****
root: ***** REBOOT LINUX *****

      296432 inodes used (30.23%, out of 980720)
         183 non-contiguous files (0.1%)
         291 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 266628/113
     3967815 blocks used (40.63%, out of 9765511)
           0 bad blocks
           0 large files

      242897 regular files
       21904 directories
         164 character device files
          10 block device files
           1 fifo
          36 links
       31435 symbolic links (29496 fast symbolic links)
          12 sockets
------------
      296459 files
# ls -l /etc/udev
total 12
-rw-r--r-- 1 root root  281 Jun  6  2010 links.conf
drwxr-xr-x 2 root root 4096 Mar 30  2012 rules.d
-rw-r--r-- 1 root root  322 Aug 12  2012 udev.conf
columbia[503]# cat /etc/udev/udev.conf
# The initial syslog(3) priority: "err", "info", "debug" or its
# numerical equivalent. For runtime debugging, the daemons internal
# state can be changed with: "udevadm control --log-priority=<value>".
#
# udevd is started in the initramfs, so when this file is modified the
# initramfs should be rebuilt.
udev_log="err"
columbia[504]# debugfs /dev/sda2
debugfs 1.43-WIP (22-Sep-2012)
debugfs:  cd /etc/udev
debugfs:  ls
 896276  (12) .    845603  (12) ..    892311  (20) udev.conf   
 896278  (12) .dev    896279  (16) rules.d    896282  (4012) links.conf   
debugfs:  stat udev.conf
Inode: 892311   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 444873085    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 322
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x502c7f65:37e9cca0 -- Thu Aug 16 01:04:37 2012
 atime: 0x5189802e:431ad914 -- Tue May  7 18:29:02 2013
 mtime: 0x5027d0d3:00000000 -- Sun Aug 12 11:50:43 2012
crtime: 0x502c7f06:c76d7c10 -- Thu Aug 16 01:03:02 2012
Size of extra inode fields: 28
Inode checksum: 0x9ed4b13c
EXTENTS:
(0):7475957
debugfs:  columbia[505]# exit

Script done on Wed May  8 13:19:35 2013

