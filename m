From: Anatoly Pugachev <matorola@gmail.com>
Subject: [sparc64] ext4 TPC and call trace (process blocked/stuck) on git
 kernel 4.8.0-rc3+
Date: Wed, 24 Aug 2016 11:13:25 +0300
Message-ID: <CADxRZqyE2HjaXzbv-9ovJM=G18C28tr7pEL8RsUx+9o870jqBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sparclinux@vger.kernel.org, fstests@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:36312 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752929AbcHXIQP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Aug 2016 04:16:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

Running fstests (xfstests) suite on sparc64 debian sid/unstable with
linux kernel 4.8.0-rc3+ , I'm getting the following call trace and TPC
on server console and system logs:

mator@nvg5120:~/xfstests-dev$ ./check ext4/022

[1968295.582734] run fstests ext4/022 at 2016-08-23 18:19:00
[1968298.917006] EXT4-fs (loop1): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[1968303.922338] EXT4-fs (loop1): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[1968304.032985] Kernel unaligned access at TPC[101c59d4]
ext4_mark_inode_dirty+0xf4/0x200 [ext4]
[1968493.042138] INFO: task 022:18119 blocked for more than 120 seconds.
[1968493.122028]       Not tainted 4.8.0-rc3+ #76
[1968493.176979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1968493.276108] 022             D 00000000008e1edc     0 18119   2687
0x308000107000000
[1968493.373659] Call Trace:
[1968493.406193]  [00000000008dfa28] schedule+0x68/0xa0
[1968493.467933]  [00000000008e1edc] rwsem_down_write_failed+0x13c/0x1e0
[1968493.547804]  [00000000008e16e4] down_write+0x24/0x40
[1968493.611787]  [00000000102027f4]
ext4_expand_extra_isize_ea+0x54/0x760 [ext4]
[1968493.701731]  [00000000101c5a04] ext4_mark_inode_dirty+0x124/0x200 [ext4]
[1968493.786655]  [00000000101c945c] ext4_dirty_inode+0x3c/0x60 [ext4]
[1968493.864366]  [00000000005b4dc4] __mark_inode_dirty+0x24/0x260
[1968493.937888]  [00000000101f7518] ext4_mb_new_blocks+0x118/0xa00 [ext4]
[1968494.019896]  [00000000101b8a74] ext4_new_meta_blocks+0xb4/0xe0 [ext4]
[1968494.101994]  [000000001020147c] ext4_xattr_block_set+0x7dc/0xa80 [ext4]
[1968494.185871]  [0000000010202d44]
ext4_expand_extra_isize_ea+0x5a4/0x760 [ext4]
[1968494.276431]  [00000000101c5a04] ext4_mark_inode_dirty+0x124/0x200 [ext4]
[1968494.361345]  [00000000101ec074] ext4_ext_truncate+0x14/0xe0 [ext4]
[1968494.440200]  [00000000101c6d34] ext4_truncate+0x254/0x3a0 [ext4]
[1968494.516622]  [00000000101c90c0] ext4_setattr+0x5c0/0x920 [ext4]
[1968494.591953]  [00000000005a7358] notify_change+0x2f8/0x4a0
[1968494.660866] INFO: task jbd2/loop1-8:19633 blocked for more than
120 seconds.
[1968494.750050]       Not tainted 4.8.0-rc3+ #76
[1968494.805325] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1968494.904421] jbd2/loop1-8    D 0000000010199684     0 19633      2
0x06000000
[1968494.994475] Call Trace:
[1968495.026968]  [00000000008dfa28] schedule+0x68/0xa0
[1968495.088380]  [0000000010199684]
jbd2_journal_commit_transaction+0x224/0x1580 [jbd2]
[1968495.185728]  [000000001019dec0] kjournald2+0xa0/0x240 [jbd2]
[1968495.258797]  [0000000000480b70] kthread+0xb0/0xe0
[1968495.319106]  [0000000000406044] ret_from_fork+0x1c/0x2c
[1968495.386182]  [0000000000000000]           (null)

I'll try to bisect it, but not earlier than 4.4 kernel (not sure i'll
able to boot 4.3).

xfstests setup is following:

mator@nvg5120:~/xfstests-dev$ git remote -v
origin  git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git (fetch)
origin  git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git (push)

mator@nvg5120:~/xfstests-dev$ cat local.config
export TEST_DEV=/dev/loop0
export TEST_DIR=/fst
export SCRATCH_DEV=/dev/loop1
export SCRATCH_MNT=/mnt/scratch

root@nvg5120:/home/mator/xfstests-dev# mkfs.ext4 /dev/loop0

/dev/loop0 and /dev/loop1 , each one is 6Gb file on tmpfs/ramdisk made
with fallocate.

mator@nvg5120:~/xfstests-dev$ findmnt /ramdisk/
TARGET   SOURCE FSTYPE OPTIONS
/ramdisk tmpfs  tmpfs  rw,relatime,size=13631488k
mator@nvg5120:~/xfstests-dev$ sudo losetup
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE            DIO
/dev/loop1         0      0         0  0 /ramdisk/scratchvol1   0
/dev/loop0         0      0         0  0 /ramdisk/testvol1      0

Thanks.
