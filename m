From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 9/9] ext4: fix ext4_ext_remove_space tree traversal
Date: Thu, 13 Sep 2012 19:01:14 +0400
Message-ID: <1347548474-31897-10-git-send-email-dmonakhov@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52491 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758104Ab2IMPBd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 11:01:33 -0400
Received: by mail-lpp01m010-f46.google.com with SMTP id y9so1991611lag.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:32 -0700 (PDT)
In-Reply-To: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext4_ext_rm_leaf() restarted transaction we should restart loop
from the top because i_data_sem was internally dropped
but (i = 0) statement was moved out from the loop in following commit
968dee77220768a5 which result in NULL pointer dereference.

This patch fix tree walking procedure by moving 'i' and 'depth'
initalization inside loop body. Also perform code cleanup in order
to have better code flow separation for truncate and punch_hole
cases.

Originally i've found this on very speciffic test, but it can be easily
reproduced via fsstress.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
 IP: [<ffffffffa01b4ebd>] ext4_ext_remove_space+0x8e6/0xc4f [ext4]
 PGD fe763c067 PUD 101e5a4067 PMD 0
 Oops: 0000 [#1] SMP
 Modules linked in: brd netconsole configfs cpufreq_ondemand acpi_cpufreq freq_table mperf ext4 jbd2 kvm_intel kvm microcode lpc_ich mfd_core i7300_idle\
i_transport_fc scsi_tgt
 CPU 2
 Pid: 9930, comm: unlink Not tainted 3.6.0-rc1+ #35 Intel MP Server/S7000FC4UR
 RIP: 0010:[<ffffffffa01b4ebd>]  [<ffffffffa01b4ebd>] ext4_ext_remove_space+0x8e6/0xc4f [ext4]
 RSP: 0018:ffff88101f0ffcb8  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff88100b398190 RCX: ffff88100b398030
 RDX: 0000000000000001 RSI: 0000000000000002 RDI: 0000000000a00000
 RBP: ffff88101f0ffd98 R08: 0000000000a00000 R09: 00019b0d6466e2b3
 R10: 0000000000000367 R11: ffff88101f0ffb38 R12: ffff88101fb13d70
 R13: 0000000000000000 R14: ffff88101fb13d40 R15: 0000000000000000
 FS:  00007f603bbc7700(0000) GS:ffff88103ba00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000028 CR3: 0000000fe7639000 CR4: 00000000000007e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process unlink (pid: 9930, threadinfo ffff88101f0fe000, task ffff88101b26c620)
 Stack:
 ffff88101f0ffcc8 ffffffffa018ddd4 ffff88101f0ffd28 ffffffffa0192461
 ffff881000007800 00000000fffffff5 ffffffff0b398000 0000000000547fff
 ffff88100b398000 ffff88100b398190 ffff8810203d0000 ffff88100ea0900c
 Call Trace:
 [<ffffffffa018ddd4>] ? brelse+0xe/0x10 [ext4]
 [<ffffffffa0192461>] ? ext4_mark_iloc_dirty+0x50c/0x56f [ext4]
 [<ffffffffa01b6cb3>] ext4_ext_truncate+0xd8/0x184 [ext4]
 [<ffffffffa019416c>] ? ext4_evict_inode+0x1c2/0x358 [ext4]
 [<ffffffffa01904fb>] ext4_truncate+0xdb/0x158 [ext4]
 [<ffffffffa01941f7>] ext4_evict_inode+0x24d/0x358 [ext4]
 [<ffffffffa0193faa>] ? ext4_da_writepages+0x54e/0x54e [ext4]
 [<ffffffff8114b2e8>] evict+0xa1/0x15b
 [<ffffffff8114b58a>] iput+0x1a3/0x1ac
 [<ffffffff811410cd>] do_unlinkat+0xff/0x15a
 [<ffffffff8108e48b>] ? trace_hardirqs_on_caller+0x151/0x197
 [<ffffffff810b11a5>] ? __audit_syscall_entry+0x11f/0x14b
 [<ffffffff8121e4de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81142b2d>] sys_unlink+0x16/0x18
 [<ffffffff8145bca9>] system_call_fastpath+0x16/0x1b
 Code: ff 4c 63 65 b0 4d 6b e4 30 4c 03 65 a8 e9 08 01 00 00 48 63 55 b0 4c 6b e2 30 4c 03 65 a8 49 83 7c 24 20 00 75 0e 49 8b 44 24 28 <48> 8b 40 28 49\
8 85 c0 75 22 49 8b
 RIP  [<ffffffffa01b4ebd>] ext4_ext_remove_space+0x8e6/0xc4f [ext4]
 RSP <ffff88101f0ffcb8>
 CR2: 0000000000000028
 ---[ end trace 07fcb23f8e07b495 ]---

#ORIGINAL_TESTCASE(huge hosts only):
modprobe brd rd_size=$((40*1024*1024)) rd_nr=1
mkfs.ext4  /dev/ram0
mount /dev/ram0 $MNT
fallocate -l $((32*1024*1024*1024)) $MNT/file
fio random_write2.fio
unlink $MNT/file
umount $MNT
fsck.ext4 -f /dev/ram0

### fio random_write2.fio job file
[random-writers]
ioengine=libaio
iodepth=256
rw=randwrite
bs=32k
direct=1

directory=/mnt
nrfiles=1
filename=file
filesize=32G

size=8G
group_reporting
numjobs=24
### fio file end

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index af2cc76..5c1d313 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2616,7 +2616,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 	struct ext4_ext_path *path = NULL;
 	ext4_fsblk_t partial_cluster = 0;
 	handle_t *handle;
-	int i = 0, err;
+	int i, err;
 
 	BUG_ON(atomic_read(&EXT4_I(inode)->i_aiodio_unwritten));
 	ext_debug("truncate since %u to %u\n", start, end);
@@ -2627,8 +2627,9 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 		return PTR_ERR(handle);
 
 again:
+	err = 0;
+	depth = ext_depth(inode);
 	ext4_ext_invalidate_cache(inode);
-
 	trace_ext4_ext_remove_space(inode, start, depth);
 
 	/*
@@ -2641,6 +2642,7 @@ again:
 	if (end < EXT_MAX_BLOCKS - 1) {
 		struct ext4_extent *ex;
 		ext4_lblk_t ee_block;
+		int k;
 
 		/* find extent for this block */
 		path = ext4_ext_find_extent(inode, end, NULL);
@@ -2648,7 +2650,6 @@ again:
 			ext4_journal_stop(handle);
 			return PTR_ERR(path);
 		}
-		depth = ext_depth(inode);
 		/* Leaf not may not exist only if inode has no blocks at all */
 		ex = path[depth].p_ext;
 		if (!ex) {
@@ -2688,20 +2689,17 @@ again:
 			if (err < 0)
 				goto out;
 		}
-	}
-cont:
-
-	/*
-	 * We start scanning from right side, freeing all the blocks
-	 * after i_size and walking into the tree depth-wise.
-	 */
-	depth = ext_depth(inode);
-	if (path) {
-		int k = i = depth;
+		i = k = depth;
 		while (--k > 0)
 			path[k].p_block =
 				le16_to_cpu(path[k].p_hdr->eh_entries)+1;
 	} else {
+		/*
+		 * We start scanning from right side, freeing all the blocks
+		 * after i_size and walking into the tree depth-wise.
+		 */
+
+		i = 0;
 		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1),
 			       GFP_NOFS);
 		if (path == NULL) {
@@ -2716,7 +2714,6 @@ cont:
 			goto out;
 		}
 	}
-	err = 0;
 
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
-- 
1.7.7.6

