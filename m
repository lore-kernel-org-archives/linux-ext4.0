From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH][RFC] ext4: fix a panic by ext4_change_inode_journal_flag()
 with delalloc mode
Date: Thu, 8 Dec 2011 19:24:08 +0900
Message-ID: <20111208192408.03eeeb96.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42300 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1LHKWp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2011 05:22:45 -0500
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id DEA8C3EE0B6
	for <linux-ext4@vger.kernel.org>; Thu,  8 Dec 2011 19:22:43 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id C254745DF54
	for <linux-ext4@vger.kernel.org>; Thu,  8 Dec 2011 19:22:43 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id ABA7445DF03
	for <linux-ext4@vger.kernel.org>; Thu,  8 Dec 2011 19:22:43 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 9D8851DB802C
	for <linux-ext4@vger.kernel.org>; Thu,  8 Dec 2011 19:22:43 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.240.81.133])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 4AA301DB8038
	for <linux-ext4@vger.kernel.org>; Thu,  8 Dec 2011 19:22:43 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following reproducer causes a panic.

Reproducer:
-------------------------------------------------------------------------------
#!/bin/sh

echo "a" > /tmp/a # file under an ext4 filesystem
chattr +j /tmp/a
echo "a" >> /tmp/a
chattr -j /tmp/a
-------------------------------------------------------------------------------

The timing when the panic occurs is a time of executing "chattr -j".
Because "chattr -j" calls ioctl(EXT4_IOC_SETFLAGS) which executes
ext4_change_inode_journal_flag() to change the attribute of "/tmp/a".

The detailed explanation is as follows:

ext4_change_inode_journal_flag() needs to write all the unprocessed data of 
this inode (/tmp/a) by jbd2_journal_flush() first. However, if an ext4 
filesystem mounts with "delalloc" mode, jbd2_journal_flush() cannot completely 
flush all the unprocessed delayed allocation's buffers of this inode before 
calling jbd2_log_do_checkpoint(). 

Therefore, a panic can occur by "BUG_ON(buffer_delay(bh))" of submit_bh() via 
__flush_batch() called from jbd2_log_do_checkpoint() because some unprocessed 
delayed allocation's buffers may remain though jbd2_journal_flush() flushed all 
transactions.

The following is an example backtrace():
-------------------------------------------------------------------------------
crash> bt
PID: 4591   TASK: ffff88007980a0c0  CPU: 2   COMMAND: "chattr"
 #0 [ffff88003795f900] machine_kexec at ffffffff810356e5
 #1 [ffff88003795f980] crash_kexec at ffffffff810a5c64
 #2 [ffff88003795fa50] oops_end at ffffffff8149bf7b
 #3 [ffff88003795fa80] die at ffffffff810163cb
 #4 [ffff88003795fab0] do_trap at ffffffff8149b960
 #5 [ffff88003795fb00] do_invalid_op at ffffffff810143c5
 #6 [ffff88003795fba0] invalid_op at ffffffff814a4b2b
    [exception RIP: submit_bh+288]
    RIP: ffffffff8117e280  RSP: ffff88003795fc58  RFLAGS: 00010202
    RAX: 000000000004c225  RBX: ffff880071890f00  RCX: 0000000000000002
    RDX: ffff88003795ffd8  RSI: ffff880071890f00  RDI: 0000000000000211
    RBP: ffff88003795fc78   R8: 0000000091827364   R9: 0000000000000000
    R10: 0000000000000002  R11: 0000000000000000  R12: 0000000000000211
    R13: 0000000000000211  R14: ffff88003795fca8  R15: 0000000000000004
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff88003795fc50] __sync_dirty_buffer at ffffffff811817dd
 #8 [ffff88003795fc80] write_dirty_buffer at ffffffff8117ede7
 #9 [ffff88003795fca0] __flush_batch at ffffffffa01af8f8 [jbd2]
#10 [ffff88003795fd00] jbd2_log_do_checkpoint at ffffffffa01afb72 [jbd2]
#11 [ffff88003795fd60] jbd2_journal_flush at ffffffffa01b3e2f [jbd2]
#12 [ffff88003795fda0] ext4_change_inode_journal_flag at ffffffffa01d0ad3 [ext4]
#13 [ffff88003795fdd0] ext4_ioctl at ffffffffa01d66b6 [ext4]
#14 [ffff88003795fea0] vfs_ioctl at ffffffff81162b1d
#15 [ffff88003795feb0] do_vfs_ioctl at ffffffff81163145
#16 [ffff88003795ff30] sys_ioctl at ffffffff81163644
#17 [ffff88003795ff80] system_call_fastpath at ffffffff814a2b42
    RIP: 00000034930d95f7  RSP: 00007fff656ceae8  RFLAGS: 00010213
    RAX: 0000000000000010  RBX: ffffffff814a2b42  RCX: 00000034930d95f7
    RDX: 00007fff656ceb8c  RSI: 0000000040086602  RDI: 0000000000000003
    RBP: 0000000000080000   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000001  R11: 0000000000000246  R12: 0000000000004000
    R13: 0000000000000001  R14: 0000000000000000  R15: 0000000000000003
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
-------------------------------------------------------------------------------

Therefore, we must flush all unprocessed delayed allocation's buffers and turn 
"delalloc" mode off before jbd2_journal_flush() calls. Then, we must turn 
"delalloc" mode on after jbd2_journal_flush() finishes.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/ext4.h  |    3 +++
 fs/ext4/inode.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5b0e26a..3eeb68b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1249,6 +1249,9 @@ struct ext4_sb_info {
 
 	/* record the last minlen when FITRIM is called. */
 	atomic_t s_last_trim_minblks;
+
+	/* to sync the delayed allocation's buffers */
+	atomic_t s_need_da_sync;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..8d317a3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2368,6 +2368,14 @@ static int ext4_nonda_switch(struct super_block *sb)
 		 */
 		return 1;
 	}
+
+	/*
+	 * Second case to switch to non dealloc mode, if we want to write all the ext4
+	 * data out.
+	 */
+	if (atomic_read(&sbi->s_need_da_sync) > 0)
+		return 1;
+
 	/*
 	 * Even if we don't switch but are nearing capacity,
 	 * start pushing delalloc when 1/2 of free blocks are dirty.
@@ -4665,6 +4673,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	journal_t *journal;
 	handle_t *handle;
 	int err;
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 	/*
 	 * We have to be very careful here: changing a data block's
@@ -4682,6 +4692,13 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	if (is_journal_aborted(journal))
 		return -EROFS;
 
+	/*
+	 * To write all delayed allocation's buffers out before calling
+	 * jbd2_journal_flush(). Because it cannot flush the buffers.
+	 */
+	atomic_inc(&sbi->s_need_da_sync);
+	sync_filesystem(sb);
+
 	jbd2_journal_lock_updates(journal);
 	jbd2_journal_flush(journal);
 
@@ -4700,6 +4717,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
+	atomic_dec(&sbi->s_need_da_sync);
 
 	/* Finally we can mark the inode as dirty. */
 
-- 
1.5.5.6
