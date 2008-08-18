From: Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
Subject: Re: EXT3 file system with unsupported revision level can be mounted
 in R/W mode
Date: Mon, 18 Aug 2008 14:06:57 +0900
Message-ID: <48A90371.6070700@uniadex.co.jp>
References: <4885AFBF.2010409@uniadex.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from igw03.unisys.co.jp ([202.233.47.13]:5825 "EHLO
	igw03.unisys.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYHREyG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 00:54:06 -0400
In-Reply-To: <4885AFBF.2010409@uniadex.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> Hello, all
>
> I found there’s a contradiction between contents of some kernel warning messages and the succeeding results, when an unsupported revision level for EXT3 file system was detected in mounting process. In this case, the messages said “EXT3-fs warning: revision level too high, forcing read-only mode”. However, the warned file system was mounted with ordinary read and write enabled mode actually, rather than read only mode. The operation sequence described below shows a way to reproduce this problem easily.
>
> I think the messages should be changed, if the resultant mount mode is valid, or the related mount code should be changed so that the file
> system would be mounted with read only mode according to the warning message. What do you think?
>
> Here is my quick observation of the related kernel code. The kernel function ext3_setup_super() checks the revision level of the file system to be mounted and return a status indicating read only mode (MS_RDONLY), if the level is too high. However, the current ext3_fill_super(), which calls ext3_setup_super(), is careless of this status. ext3_remount() also seem to fail to handle the returned status appropriately. In addition, the corresponding code for EXT2 file system has the same problem.
>
>   
Hi,

Assuming that the intention of the warning message (“EXT3-fs warning:
revision level too high, forcing read only mode”) is valid, I made the
following patch based on linux-2.6.26.2. This will force an EXT3 file
system with unsupported revision to be mounted with read only mode for
both mount case and remount case, even though read and write enabled
mode is specified or assumed as default for mounting. Any comments would
be highly appreciated. The test results with this patch is attached below.

----------
diff -up linux-2.6.26.2/fs/ext3/super.c.orig linux-2.6.26.2/fs/ext3/super.c
--- linux-2.6.26.2/fs/ext3/super.c.orig 2008-08-18 11:01:02.000000000 +0900
+++ linux-2.6.26.2/fs/ext3/super.c 2008-08-18 11:06:29.000000000 +0900
@@ -1898,7 +1898,8 @@ static int ext3_fill_super (struct super
goto failed_mount4;
}

- ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+ if (ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY))
+ sb->s_flags |= MS_RDONLY;
/*
* akpm: core read_super() calls in here with the superblock locked.
* That deadlocks, because orphan cleanup needs to lock the superblock
@@ -2506,8 +2507,8 @@ static int ext3_remount (struct super_bl
sbi->s_mount_state = le16_to_cpu(es->s_state);
if ((err = ext3_group_extend(sb, es, n_blocks_count)))
goto restore_opts;
- if (!ext3_setup_super (sb, es, 0))
- sb->s_flags &= ~MS_RDONLY;
+ if (ext3_setup_super (sb, es, 0))
+ *flags &= ~MS_RDONLY;
}
}
#ifdef CONFIG_QUOTA
----------

There’s one thing I have to add. Even if the patch works and read only
mode is forced for an EXT3 file system with unsupported revision, the
mount mode for the file system shown by mount command or /etc/mtab can
be still “rw”, rather than “ro”. I think this issue should be cared not
only by kernel, but also by mount command itself. Any suggestion would
be highly appreciated for this issue also.

Thanks a lot.

Signed-off-by :Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>

The test results with the patch as above mentioned:
----------
# mkfs -t ext3 -r 2 /dev/sdb1
mke2fs 1.39 (29-May-2006)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
3014656 inodes, 6024367 blocks
301218 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=0
184 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000

Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 34 mounts or
180 days, whichever comes first. Use tune2fs -c or -i to override.
# mount -t ext3 /dev/sdb1 /mnt/sdb1
# cd /mnt/sdb1
# touch aaa.txt
touch: cannot touch `aaa.txt': Read-only file system
# mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
/dev/sdb1 on /mnt/sdb1 type ext3 (rw)
# cd /tmp
# mount -o rw,remount /mnt/sdb1
# cd /mnt/sdb1
# touch aaa.txt
touch: cannot touch `aaa.txt': Read-only file system
# mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
/dev/sdb1 on /mnt/sdb1 type ext3 (rw)
----------
