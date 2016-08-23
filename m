From: Marcos Mello <marcosfrm@gmail.com>
Subject: Kernel does not respect tune2fs -E mount_opts=foo
Date: Tue, 23 Aug 2016 09:57:07 -0300
Message-ID: <CAJZVDJDeLePt1RYAtLQ-NzZ0R5nwRb_wwBW9H7dcgD2zG8_m=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35527 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757082AbcHWNEr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Aug 2016 09:04:47 -0400
Received: by mail-yw0-f175.google.com with SMTP id j12so71296032ywb.2
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2016 06:04:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs 1.43.1. Kernel 4.7.1 with

CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_USE_FOR_EXT2=y

Steps to reproduce the issue:

# mkfs.ext4 -q /dev/sda2

# tune2fs -E mount_opts="noatime" /dev/sda2
tune2fs 1.43.1 (08-Jun-2016)
Setting extended default mount options to 'noatime'

# tune2fs -l /dev/sda2 | grep -i 'mount options'
Default mount options:    user_xattr acl
Mount options:            noatime

# mount /dev/sda2 /mnt

# findmnt /mnt
TARGET SOURCE    FSTYPE OPTIONS
/mnt   /dev/sda2 ext4   rw,relatime,data=ordered
                           ^^^^^^^^
# touch /mnt/aaa

# stat /mnt/aaa
  File: '/mnt/aaa'
  Size: 0             Blocks: 0          IO Block: 4096   regular empty file
Device: 802h/2050d    Inode: 12          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2016-08-23 08:14:10.056525341 -0300
Modify: 2016-08-23 08:14:10.056525341 -0300
Change: 2016-08-23 08:14:10.056525341 -0300
 Birth: -

# cat /mnt/aaa

# stat /mnt/aaa
  File: '/mnt/aaa'
  Size: 0             Blocks: 0          IO Block: 4096   regular empty file
Device: 802h/2050d    Inode: 12          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2016-08-23 08:19:27.081474536 -0300
Modify: 2016-08-23 08:14:10.056525341 -0300
Change: 2016-08-23 08:14:10.056525341 -0300
 Birth: -

Other options like noacl, nouser_xattr, are ignored too. This
filesystem is not listed in fstab.

Marcos
