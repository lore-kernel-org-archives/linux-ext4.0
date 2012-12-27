From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: 3.8.0-rc1: WARNING: at fs/ext4/page-io.c:232
Date: Thu, 27 Dec 2012 03:27:04 +0300
Message-ID: <CAA1sL1QgkEWciR2qBbKWr+_2tRdhxpE1Jh3P0waSeYR8LR8R5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o\"" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51169 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2L0AfA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Dec 2012 19:35:00 -0500
Received: by mail-vc0-f177.google.com with SMTP id m8so9227635vcd.8
        for <linux-ext4@vger.kernel.org>; Wed, 26 Dec 2012 16:34:59 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello

Let me know if you need more info

EXT4-fs (sda2): INFO: recovery required on readonly filesystem
EXT4-fs (sda2): write access will be enabled during recovery
EXT4-fs (sda2): orphan cleanup on readonly fs
EXT4-fs (sda2): ext4_orphan_cleanup: truncating inode 841849 to 0 bytes
------------[ cut here ]------------
WARNING: at fs/ext4/page-io.c:232 ext4_flush_unwritten_io+0x6b/0x80()
Hardware name: P35-DS3
Modules linked in:
Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc1-00004-g637704c #1
Call Trace:
 [<ffffffff81038f5a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81038fa5>] warn_slowpath_null+0x15/0x20
 [<ffffffff81163b8b>] ext4_flush_unwritten_io+0x6b/0x80
 [<ffffffff8117ac5c>] ext4_ext_truncate+0x2c/0x1f0
 [<ffffffff8116c6d0>] ? ext4_msg+0x50/0x60
 [<ffffffff8115e050>] ext4_truncate+0x70/0xb0
 [<ffffffff8117190b>] ext4_fill_super+0x2bab/0x2ce0
 [<ffffffff810ef02a>] mount_bdev+0x1aa/0x1f0
 [<ffffffff8102aec9>] ? default_spin_lock_flags+0x9/0x10
 [<ffffffff8116ed60>] ? ext4_calculate_overhead+0x3a0/0x3a0
 [<ffffffff8116a870>] ext4_mount+0x10/0x20
 [<ffffffff810ef96b>] mount_fs+0x1b/0xd0
 [<ffffffff81108fc1>] vfs_kern_mount+0x71/0x110
 [<ffffffff8110b096>] do_mount+0x386/0x980
 [<ffffffff810b7f43>] ? strndup_user+0x53/0x70
 [<ffffffff8110b71b>] sys_mount+0x8b/0xe0
 [<ffffffff816afcc8>] mount_block_root+0xfe/0x298
 [<ffffffff816afeb8>] mount_root+0x56/0x5a
 [<ffffffff816afff0>] prepare_namespace+0x134/0x16d
 [<ffffffff8147c9c6>] kernel_init+0x196/0x2a0
 [<ffffffff816af539>] ? loglevel+0x31/0x31
 [<ffffffff8147c830>] ? rest_init+0x80/0x80
 [<ffffffff81482a7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8147c830>] ? rest_init+0x80/0x80
---[ end trace 425942f4f0ed8d07 ]---
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 835709
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 835629
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 682715
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 832545
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 677529
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 838885
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 676342
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 832311
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 683216
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 828057
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 847476
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 834769
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 846534
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 842096
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 833886
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 688996
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 1085523
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 524364
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 12686
EXT4-fs (sda2): 19 orphan inodes deleted
EXT4-fs (sda2): 1 truncate cleaned up
EXT4-fs (sda2): recovery complete
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
