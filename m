Return-Path: <SRS0=0UAC=MJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40724 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbeI0Tma (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2018 15:42:30 -0400
Received: by mail-ot1-f67.google.com with SMTP id g14-v6so2512871otj.7
        for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2018 06:24:14 -0700 (PDT)
MIME-Version: 1.0
From: Vignesh Raman <vignesh.raman.in@gmail.com>
Date: Thu, 27 Sep 2018 18:54:02 +0530
Message-ID: <CAH3OF51p+Sty54KJswtPBa6aj3T4dDsiYOGcn265MAAf+L5EEA@mail.gmail.com>
Subject: inode/block bitmap checksum error
To: linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

We are seeing the below ext4 corruption messages when running linux
4.9 on debian,
[   13.694043] EXT4-fs error (device sda4):
ext4_validate_block_bitmap:384: comm plymouthd: bg 6: bad block bitmap
checksum
[   13.694359] EXT4-fs error (device sda4) in ext4_free_blocks:4916:
Filesystem failed CRC
[   13.694807] EXT4-fs error (device sda4):
ext4_validate_inode_bitmap:96: comm plymouthd: Corrupt inode bitmap -
block_group = 1, inode_bitmap = 331
[   13.695025] EXT4-fs error (device sda4) in ext4_free_inode:358:
Filesystem failed CRC
[   13.696127] EXT4-fs error (device sda4):
ext4_validate_block_bitmap:384: comm plymouthd: bg 7: bad block bitmap
checksum
[   13.715278] EXT4-fs error (device sda4):
ext4_validate_block_bitmap:384: comm systemd-tmpfile: bg 16: bad block
bitmap checksum
[   13.715736] EXT4-fs error (device sda4) in ext4_free_blocks:4916:
Filesystem failed CRC
[   13.716358] EXT4-fs error (device sda4):
ext4_validate_inode_bitmap:96: comm systemd-tmpfile: Corrupt inode
bitmap - block_group = 16, inode_bitmap = 524292
[   13.716639] EXT4-fs error (device sda4) in ext4_free_inode:358:
Filesystem failed CRC
[   13.717477] EXT4-fs error (device sda4) in ext4_free_inode:358:
Corrupt filesystem

fsck shows the below error,
systemd-fsck[193]: fsck failed with exit status 8.
systemd-fsck[193]: Ignoring error.
systemd-fsck[193]: fsck.ext4: Superblock checksum does not match
superblock while trying to open /dev/sda4
systemd-fsck[193]: /dev/sda4:
systemd-fsck[193]: The superblock could not be read or does not
describe a valid ext2/ext3/ext4
systemd-fsck[193]: filesystem.  If the device is valid and it really
contains an ext2/ext3/ext4
systemd-fsck[193]: filesystem (and not swap or ufs or something else),
then the superblock
systemd-fsck[193]: is corrupt, and you might try running e2fsck with
an alternate superblock:
systemd-fsck[193]:     e2fsck -b 8193 <device>
systemd-fsck[193]:  or
systemd-fsck[193]:     e2fsck -b 32768 <device>

Would the fsck failure cause the inode/block bitmap checksum issue?

Kernel version: [    0.000000] Linux version 4.9.0-8-amd64
(debian-kernel@lists.debian.org) (gcc version 6.3.0 20170516 (Debian
6.3.0-18+deb9u1) ) #1 SMP Debian 4.9.110-3+deb9u4 (2018-08-21)

Backported the below patch, but the issue was still seen.
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=8d5a803c6a6ce4ec258e31f76059ea5153ba46ef

Any pointers will be helpful. Thanks.

Regards,
Vignesh
