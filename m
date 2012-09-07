From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: How to query ext2/3/4 total fs size while mounted?
Date: Fri, 7 Sep 2012 21:12:49 +0100
Message-ID: <CAMU1PDg-WrH9TS-U9SfeMfV2FTBz7Md+7PR1k55aMTFVq=7NiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53101 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab2IGUMu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Sep 2012 16:12:50 -0400
Received: by qcro28 with SMTP id o28so1667562qcr.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Sep 2012 13:12:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Is there a way I can/should code GParted (GNOME Partition Editor) to
query a mounted ext2/3/4 file system to get the total file system size?

Unfortunately the f_blocks value from the statvfs() system call has
space occupied by inode tables, allocation bitmaps, etc. subtracted as
overhead and I need the total file system size.  This is so that GParted
can inform users when the file system doesn't fill the partition and
recommend resizing the FS to fix it.

I really want some way to get the the total file system size from
statvfs().  The mount option minixdf isn't really appropriate as GParted
shouldn't be remounting file systems adding mount options to query the
file system size.

Is it safe to read the super block off disk using ext2fs_open() or by
running dumpe2fs for a mounted file system?  What if the file system has
just been resized?  Are there any other methods for querying the total
file system size?

Thanks,
Mike


In this example I want to get the 194560 blocks figure while mounted,
not f_blocks=188403.

# sfdisk -s /dev/sda10
194560
# mkfs.ext4 /dev/sda10
mke2fs 1.41.12 (17-May-2010)
...
48768 inodes, 194560 blocks
...
# dumpe2fs -h /dev/sda10 | grep 'Block count:'
dumpe2fs 1.41.12 (17-May-2010)
Block count:              194560
# mount /dev/sda10 /mnt/0
# strace -e statfs64 stat -f /mnt/0
...
statfs64("/mnt/0", 84, {f_type="EXT2_SUPER_MAGIC", f_bsize=1024,
f_blocks=188403, f_bfree=182757, f_bavail=173029, f_files=48768,
f_ffree=48757, f_fsid={-1366779076, -459235834}, f_namelen=255,
f_frsize=1024}) = 0
  File: "/mnt/0"
    ID: ae889b3ce4a09e06 Namelen: 255     Type: ext2/ext3
Block size: 1024       Fundamental block size: 1024
Blocks: Total: 188403     Free: 182757     Available: 173029
Inodes: Total: 48768      Free: 48757
