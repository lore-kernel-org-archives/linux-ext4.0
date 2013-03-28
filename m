From: John Jolly <john.jolly@gmail.com>
Subject: Failure of resize2fs past 4TB
Date: Wed, 27 Mar 2013 21:44:38 -0600
Message-ID: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38710 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3C1Doj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Mar 2013 23:44:39 -0400
Received: by mail-wg0-f53.google.com with SMTP id c11so1182664wgh.32
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 20:44:38 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All,

I recently had a major data loss when expanding an LVM logical volume
past 2TB in size. I have preserved the 2.25TB just in case I might be
able to recover some data. But this backup is not my reason for
writing.

I have done several tests and these are the results. First the error
condition, where I create a 1GB file system, expand the volume to 2TB,
resize the file system and have it become corrupted:

linux-ek23:/mnt # lvcreate -L 1G -n main storage
  Logical volume "main" created
linux-ek23:/mnt # mkfs.ext4 /dev/storage/main
mke2fs 1.42.6 (21-Sep-2012)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=640 blocks
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

linux-ek23:/mnt # lvextend -L 2T /dev/storage/main
  Extending logical volume main to 2.00 TiB
  Logical volume main successfully resized
linux-ek23:/mnt # fsck.ext4 /dev/storage/main
e2fsck 1.42.6 (21-Sep-2012)
/dev/storage/main: clean, 11/65536 files, 12635/262144 blocks
linux-ek23:/mnt # resize2fs -p /dev/storage/main
resize2fs 1.42.6 (21-Sep-2012)
Resizing the filesystem on /dev/storage/main to 536870912 (4k) blocks.
Begin pass 2 (max = 5)
Relocating blocks             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 8)
Scanning inode table          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 5 (max = 1)
Moving inode table            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /dev/storage/main is now 536870912 blocks long.

linux-ek23:/mnt # fsck.ext4 /dev/storage/main
e2fsck 1.42.6 (21-Sep-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
fsck.ext4: Group descriptors look bad... trying backup blocks...
/dev/storage/main was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Group 1's inode table at 609 conflicts with some other fs block.
Relocate<y>?
/dev/storage/main: e2fsck canceled.

/dev/storage/main: ***** FILE SYSTEM WAS MODIFIED *****

Following is a successful attempt, but instead of starting with a 1GB
ext4 file system, I start with a 2GB ext4 file system. There is no
error after resizing to 2TB:

linux-ek23:/mnt # lvcreate -L 2G -n main storage
  Logical volume "main" created
linux-ek23:/mnt # mkfs.ext4 /dev/storage/main
mke2fs 1.42.6 (21-Sep-2012)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=640 blocks
131072 inodes, 524288 blocks
26214 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=536870912
16 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

linux-ek23:/mnt # lvextend -L 2T /dev/storage/main
  Extending logical volume main to 2.00 TiB
  Logical volume main successfully resized
linux-ek23:/mnt # fsck.ext4 /dev/storage/main
e2fsck 1.42.6 (21-Sep-2012)
/dev/storage/main: clean, 11/131072 files, 25388/524288 blocks
linux-ek23:/mnt # resize2fs -p /dev/storage/main
resize2fs 1.42.6 (21-Sep-2012)
Resizing the filesystem on /dev/storage/main to 536870912 (4k) blocks.
The filesystem on /dev/storage/main is now 536870912 blocks long.

linux-ek23:/mnt # fsck.ext4 /dev/storage/main
e2fsck 1.42.6 (21-Sep-2012)
/dev/storage/main: clean, 11/134217728 files, 8440346/536870912 blocks

I know it is unusual to start so small and expand like this, but I
doubt I am the only one to have experienced this. How could I have
prepared my small 1GB file system so that it would be able to handle
an expansion past 2TB? Any help would be appreciated.

Regards,
--
John Jolly - john.jolly@gmail.com - http://john.jolly.name
