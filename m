From: Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
Subject: EXT3 file system with unsupported revision level can be mounted in
 R/W mode
Date: Tue, 22 Jul 2008 19:00:31 +0900
Message-ID: <4885AFBF.2010409@uniadex.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from igw03.unisys.co.jp ([202.233.47.13]:42530 "EHLO
	igw03.unisys.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYGVKSk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 06:18:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, all

I found there’s a contradiction between contents of some kernel warning
messages and the succeeding results, when an unsupported revision level
for EXT3 file system was detected in mounting process. In this case, the
messages said “EXT3-fs warning: revision level too high, forcing
read-only mode”. However, the warned file system was mounted with
ordinary read and write enabled mode actually, rather than read only
mode. The operation sequence described below shows a way to reproduce
this problem easily.

I think the messages should be changed, if the resultant mount mode is
valid, or the related mount code should be changed so that the file
system would be mounted with read only mode according to the warning
message. What do you think?

Here is my quick observation of the related kernel code. The kernel
function ext3_setup_super() checks the revision level of the file system
to be mounted and return a status indicating read only mode (MS_RDONLY),
if the level is too high. However, the current ext3_fill_super(), which
calls ext3_setup_super(), is careless of this status. ext3_remount()
also seem to fail to handle the returned status appropriately. In
addition, the corresponding code for EXT2 file system has the same problem.

--------------------
# mkfs -t ext3 -r 2 /dev/sdb1
mke2fs 1.39 (29-May-2006)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
8962048 inodes, 17920499 blocks
896024 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=0
547 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424

Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 34 mounts or
180 days, whichever comes first. Use tune2fs -c or -i to override.
# mount -t ext3 /dev/sdb1 /mnt/sdb1
# mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
/dev/sdb1 on /mnt/sdb1 type ext3 (rw)
# cd /mnt/sdb1
# touch aaa.txt
# ls
aaa.txt lost+found

>From /var/log/messages:
Jul 17 15:45:54 kernel kernel: EXT3-fs warning: revision level too high,
forcing read-only mode
Jul 17 15:45:54 kernel kernel: EXT3 FS on sdb1, internal journal
Jul 17 15:45:54 kernel kernel: EXT3-fs: mounted filesystem with ordered
data mode.
--------------------

Thanks,
Tadao Uchiyama
