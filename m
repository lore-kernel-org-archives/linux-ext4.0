From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: some large dir testing results
Date: Thu, 20 Apr 2017 22:00:48 +0300
Message-ID: <52B4B404-9FE0-4586-A02A-3451AA5BE089@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Andreas Dilger <adilger@dilger.ca>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34654 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934581AbdDTTAx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Apr 2017 15:00:53 -0400
Received: by mail-wm0-f65.google.com with SMTP id z129so142799wmb.1
        for <linux-ext4@vger.kernel.org>; Thu, 20 Apr 2017 12:00:53 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I run some testing on my environment with large dir patches provided by =
Artem.
Each test run a 11 loops with creating 20680000 mknod objects for normal =
dir, and 20680000 for large dir.
FS was reformatted before each test, files was created in root dir to =
have an allocate inodes and blocks from GD#0 and up.
Journal have a size - 4G and it was internal journal.
Kernel was RHEL 7.2 based with lustre patches.

Test script code
#!/bin/bash

LOOPS=3D11

for i in `seq ${LOOPS}`; do=20
	mkfs -t ext4 -F -I 256 -J size=3D4096 ${DEV}
	mount -t ldiskfs ${DEV} ${MNT}
	pushd ${MNT}
	/usr/lib/lustre/tests/createmany -m test 20680000 >& =
/tmp/small-mknod${i}
	popd
	umount ${DEV}
done


for i in `seq ${LOOPS}`; do=20
	mkfs -t ext4 -F -I 256 -J size=3D4096 -O large_dir ${DEV}
	mount -t ldiskfs ${DEV} ${MNT}
	pushd ${MNT}
	/usr/lib/lustre/tests/createmany -m test 206800000 >& =
/tmp/large-mknod${i}
	popd
	umount ${DEV}
done

Tests was run on two nodes - first node have a storage with raid10 of =
fast HDD=E2=80=99s, second node have a NMVE as block device.
Current directory code have a near of similar results for both nodes for =
first test:
 - HDD node 56k-65k creates/s
 - SSD node ~80k creates/s
But large_dir testing have a large differences for nodes.
- HDD node have a drop a creation rate to 11k create/s
- SSD node have drop to 46k create/s

Initial analyze say about several problems
0) CPU load isn=E2=80=99t high, and perf top say ldiskfs functions =
isn=E2=80=99t hot (2%-3% cpu), most spent for dir entry checking =
function.

1) lookup have a large time to read a directory block to verify file not =
exist. I think it because a block fragmentation.
[root@pink03 ~]# cat /proc/100993/stack
[<ffffffff81211b1e>] sleep_on_buffer+0xe/0x20
[<ffffffff812130da>] __wait_on_buffer+0x2a/0x30
[<ffffffffa0899e6c>] ldiskfs_bread+0x7c/0xc0 [ldiskfs]
[<ffffffffa088ee4a>] __ldiskfs_read_dirblock+0x4a/0x400 [ldiskfs]
[<ffffffffa08915af>] ldiskfs_dx_find_entry+0xef/0x200 [ldiskfs]
[<ffffffffa0891b8b>] ldiskfs_find_entry+0x4cb/0x570 [ldiskfs]
[<ffffffffa08921d5>] ldiskfs_lookup+0x75/0x230 [ldiskfs]
[<ffffffff811e8e7d>] lookup_real+0x1d/0x50
[<ffffffff811e97f2>] __lookup_hash+0x42/0x60
[<ffffffff811ee848>] filename_create+0x98/0x180
[<ffffffff811ef6e1>] user_path_create+0x41/0x60
[<ffffffff811f084a>] SyS_mknodat+0xda/0x220
[<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
[<ffffffff81645549>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
2) Some JBD problems when create thread have a wait a shadow BH from a =
committed transaction.
[root@pink03 ~]# cat /proc/100993/stack
[<ffffffffa06a072e>] sleep_on_shadow_bh+0xe/0x20 [jbd2]
[<ffffffffa06a1bad>] do_get_write_access+0x2dd/0x4e0 [jbd2]
[<ffffffffa06a1dd7>] jbd2_journal_get_write_access+0x27/0x40 [jbd2]
[<ffffffffa08c7cab>] __ldiskfs_journal_get_write_access+0x3b/0x80 =
[ldiskfs]
[<ffffffffa08ce817>] __ldiskfs_new_inode+0x447/0x1300 [ldiskfs]
[<ffffffffa08948c8>] ldiskfs_create+0xd8/0x190 [ldiskfs]
[<ffffffff811eb42d>] vfs_create+0xcd/0x130
[<ffffffff811f0960>] SyS_mknodat+0x1f0/0x220
[<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
[<ffffffff81645549>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
[root@pink03 ~]# cat /proc/100993/stack
[<ffffffffa06a072e>] sleep_on_shadow_bh+0xe/0x20 [jbd2]
[<ffffffffa06a1bad>] do_get_write_access+0x2dd/0x4e0 [jbd2]
[<ffffffffa06a1dd7>] jbd2_journal_get_write_access+0x27/0x40 [jbd2]
[<ffffffffa08c7cab>] __ldiskfs_journal_get_write_access+0x3b/0x80 =
[ldiskfs]
[<ffffffffa08a75bd>] ldiskfs_mb_mark_diskspace_used+0x7d/0x4f0 [ldiskfs]
[<ffffffffa08abacc>] ldiskfs_mb_new_blocks+0x2ac/0x5d0 [ldiskfs]
[<ffffffffa08db63d>] ldiskfs_ext_map_blocks+0x49d/0xed0 [ldiskfs]
[<ffffffffa08997d9>] ldiskfs_map_blocks+0x179/0x590 [ldiskfs]
[<ffffffffa0899c55>] ldiskfs_getblk+0x65/0x200 [ldiskfs]
[<ffffffffa0899e17>] ldiskfs_bread+0x27/0xc0 [ldiskfs]
[<ffffffffa088e3be>] ldiskfs_append+0x7e/0x150 [ldiskfs]
[<ffffffffa088fb09>] do_split+0xa9/0x900 [ldiskfs]
[<ffffffffa0892bb2>] ldiskfs_dx_add_entry+0xc2/0xbc0 [ldiskfs]
[<ffffffffa0894154>] ldiskfs_add_entry+0x254/0x6e0 [ldiskfs]
[<ffffffffa0894600>] ldiskfs_add_nondir+0x20/0x80 [ldiskfs]
[<ffffffffa0894904>] ldiskfs_create+0x114/0x190 [ldiskfs]
[<ffffffff811eb42d>] vfs_create+0xcd/0x130
[<ffffffff811f0960>] SyS_mknodat+0x1f0/0x220
[<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
[<ffffffff81645549>] system_call_fastpath+0x16/0x1b

I know several jbd2 improvements by Kara isn=E2=80=99t landed into =
RHEL7, but i don=E2=80=99t think it will big improvement, as SSD have =
less perf drop.
I think perf dropped due additional seeks requested to have access to =
the dir data or inode allocation.

Alex
