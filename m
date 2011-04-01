From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v0 RFC]  ext4: Fix a bug in ext4_journal_start_sb().
Date: Fri,  1 Apr 2011 16:44:53 +0800
Message-ID: <1301647493-13163-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz, sandeen@redhat.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39682 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1DAImk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 04:42:40 -0400
Received: by iwn34 with SMTP id 34so3264781iwn.19
        for <linux-ext4@vger.kernel.org>; Fri, 01 Apr 2011 01:42:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_journal_start_sb() should not prevent active handle from being
started due to s_frozen.  Otherwise, deadlock is easy to happen, below
is a situation.

======================================================================
     freeze         |       truncate             |      kjournald
======================================================================
                    |  ext4_ext_truncate()       |
    freeze_super()  |   starts a handle          |
    sets s_frozen   |                            |
                    |  ext4_ext_truncate()       |
                    |  holds i_data_sem          |
  ext4_freeze()     |                            |   commit_transaction()
  waits for updates |                            |   waits for i_data_sem
                    |  ext4_free_blocks()        |
                    |  calls dquot_free_block()  |
                    |                            |
                    |  dquot_free_blocks()       |
                    |  calls ext4_dirty_inode()  |
                    |                            |
                    |  ext4_dirty_inode()        |
                    |  trys to start an active   |
                    |  handle                    |
                    |                            |
                    |  block due to s_frozen     |
=======================================================================

Messages reported by Amir:
while running phoronix test suite and taking a snapshot every 10 seconds,
the following hang happened during tiobench [64MB Random Write - 32 Threads]:

[20868.207441] snapshot: snapshot (913) created
[21000.040021] [Hardware Error]: Machine check events logged
[21001.300039] INFO: task jbd2/sda6-8:3560 blocked for more than 120 seconds.
[21001.300043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[21001.300048] jbd2/sda6-8     D 0000000000000000     0  3560      2 0x00000000
[21001.300055]  ffff880037a8fce0 0000000000000046 0000000000000000
ffff880100000000
[21001.300063]  0000000000014000 ffff880037a1bf40 ffff880037a1c2c0
ffff880037a8ffd8
[21001.300070]  ffff880037a1c2c8 0000000000014000 ffff880037a8e010
0000000000014000
[21001.300078] Call Trace:
[21001.300089]  [<ffffffff8124ebcc>] jbd2_journal_commit_transaction+
0x1cc/0x15d0
[21001.300095]  [<ffffffff815bea70>] ? _raw_spin_unlock_irq+0x30/0x40
[21001.300102]  [<ffffffff810746dc>] ? lock_timer_base+0x3c/0x70
[21001.300108]  [<ffffffff81075ae0>] ? try_to_del_timer_sync+0x90/0x100
[21001.300113]  [<ffffffff81088d30>] ? autoremove_wake_function+0x0/0x40
[21001.300118]  [<ffffffff81075bf2>] ? del_timer_sync+0xa2/0xe0
[21001.300123]  [<ffffffff81075b50>] ? del_timer_sync+0x0/0xe0
[21001.300129]  [<ffffffff81254b71>] kjournald2+0xc1/0x220
[21001.300133]  [<ffffffff81088d30>] ? autoremove_wake_function+0x0/0x40
[21001.300138]  [<ffffffff81254ab0>] ? kjournald2+0x0/0x220
[21001.300143]  [<ffffffff810887d6>] kthread+0xb6/0xc0
[21001.300149]  [<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
[21001.300154]  [<ffffffff815bea70>] ? _raw_spin_unlock_irq+0x30/0x40
[21001.300158]  [<ffffffff815bf054>] ? restore_args+0x0/0x30
[21001.300163]  [<ffffffff81088720>] ? kthread+0x0/0xc0
[21001.300167]  [<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10
[21001.300171] INFO: lockdep is turned off.
[21001.300175] INFO: task tiotest:6277 blocked for more than 120 seconds.
[21001.300178] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[21001.300182] tiotest         D 0000000000000000     0  6277   6276 0x00000000
[21001.300188]  ffff88003789d9d8 0000000000000046 ffff88005b87a068
0000000000000002
[21001.300196]  0000000000014000 ffff8800ac435ee0 ffff8800ac436260
ffff88003789dfd8
[21001.300203]  ffff8800ac436268 0000000000014000 ffff88003789c010
0000000000014000
[21001.300211] Call Trace:
[21001.300216]  [<ffffffff81088fe0>] ? prepare_to_wait+0x60/0x90
[21001.300236]  [<ffffffffa0297745>] __next4_journal_start+0x85/0x1d0 [next4]
[21001.300241]  [<ffffffff815beb1b>] ? _raw_spin_unlock+0x2b/0x40
[21001.300246]  [<ffffffff81088d30>] ? autoremove_wake_function+0x0/0x40
[21001.300259]  [<ffffffffa027d98e>] next4_dirty_inode+0x2e/0x70 [next4]
[21001.300266]  [<ffffffff811942e8>] __mark_inode_dirty+0x38/0x220
[21001.300283]  [<ffffffffa02af022>] __next4_free_blocks+0xb42/0xeb0 [next4]
[21001.300300]  [<ffffffffa02a297e>] next4_ext_truncate+0x8ce/0xa90 [next4]
[21001.300315]  [<ffffffffa0283921>] next4_truncate+0x601/0x860 [next4]
[21001.300331]  [<ffffffffa02a6da3>] ? __next4_handle_dirty_metadata+0x83/0x1d0
[next4]
[21001.300344]  [<ffffffffa027ccc0>] ? next4_mark_iloc_dirty+0x480/0x6b0 [next4]
[21001.300358]  [<ffffffffa027d7b6>] ? next4_mark_inode_dirty+0xa6/0x250 [next4]
[21001.300372]  [<ffffffffa0285c00>] next4_evict_inode+0x3a0/0x490 [next4]
[21001.300378]  [<ffffffff81186c44>] evict+0x24/0xb0
[21001.300382]  [<ffffffff811872a6>] iput+0x1f6/0x2f0
[21001.300388]  [<ffffffff8117b06f>] do_unlinkat+0x11f/0x1e0
[21001.300394]  [<ffffffff815be0d9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21001.300399]  [<ffffffff8117b146>] sys_unlink+0x16/0x20
[21001.300405]  [<ffffffff8100bf82>] system_call_fastpath+0x16/0x1b
[21001.300408] INFO: lockdep is turned off.
[21001.300411] INFO: task chsnap:6510 blocked for more than 120 seconds.
[21001.300414] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[21001.300418] chsnap          D 0000000000000000     0  6510   6481 0x00000000
[21001.300424]  ffff8800ac2ffba8 0000000000000046 0000000000000000
ffff880107fe5688
[21001.300431]  0000000000014000 ffff8800ac599fa0 ffff8800ac59a320
[21001.300439]  ffff8800ac59a328 0000000000014000 ffff8800ac2fe010
0000000000014000
[21001.300447] Call Trace:
[21001.300452]  [<ffffffff8124cc55>] jbd2_journal_lock_updates+0x95/0x100
[21001.300457]  [<ffffffff81088d30>] ? autoremove_wake_function+0x0/0x40
[21001.300473]  [<ffffffffa0295756>] next4_freeze+0x46/0xa0 [next4]
[21001.300479]  [<ffffffff811a27e4>] ? __sync_blockdev+0x24/0x50
[21001.300484]  [<ffffffff8116ec2d>] freeze_super+0x7d/0x100
[21001.300500]  [<ffffffffa02bbe48>] next4_snapshot_take+0x268/0xa70 [next4]
[21001.300506]  [<ffffffff8124c910>] ? jbd2_journal_stop+0x1e0/0x2c0
[21001.300520]  [<ffffffffa0287558>] next4_ioctl+0xc28/0xcc0 [next4]
[21001.300527]  [<ffffffff812f66b4>] ? do_raw_spin_lock+0x54/0x150
[21001.300532]  [<ffffffff8117e175>] do_vfs_ioctl+0xa5/0x5a0
[21001.300537]  [<ffffffff8109e6ad>] ? trace_hardirqs_on+0xd/0x10
[21001.300542]  [<ffffffff8116dc5c>] ? fget_light+0x1ec/0x370
[21001.300547]  [<ffffffff8117e711>] sys_ioctl+0xa1/0xb0
[21001.300552]  [<ffffffff8100bf82>] system_call_fastpath+0x16/0x1b
[21001.300555] INFO: lockdep is turned off.

Reported-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/super.c |   49 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ccfa686..f35b53e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -242,27 +242,49 @@ static void ext4_put_nojournal(handle_t *handle)
  * journal_end calls result in the superblock being marked dirty, so
  * that sync() will call the filesystem's write_super callback if
  * appropriate.
+ *
+ * To avoid j_barrier hold in userspace when a user calls freeze(),
+ * ext4 prevents a new handle from being started by s_frozen, which
+ * is in an upper layer.
  */
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 {
 	journal_t *journal;
+	handle_t  *handle;
 
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
-	vfs_check_frozen(sb, SB_FREEZE_TRANS);
-	/* Special case here: if the journal has aborted behind our
-	 * backs (eg. EIO in the commit thread), then we still need to
-	 * take the FS itself readonly cleanly. */
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal) {
-		if (is_journal_aborted(journal)) {
-			ext4_abort(sb, "Detected aborted journal");
-			return ERR_PTR(-EROFS);
-		}
-		return jbd2_journal_start(journal, nblocks);
+	if (!journal)
+		/*
+		 * Under no-journal mode, vfs_check_frozen() is not neeed.
+		 */
+		return ext4_get_nojournal();
+
+	/*
+	 * Before vfs_check_frozen(), the current handle should be allowed
+	 * to finish, otherwise deadlock would happen when the filesystem
+	 * is freezed && active handles are not stopped.
+	 */
+	handle = ext4_journal_current_handle();
+	if (handle) {
+		BUG_ON(!(handle->h_transaction->t_journal == journal));
+		handle->h_ref++;
+		return handle;
 	}
-	return ext4_get_nojournal();
+
+	/*
+	 * Special case here: if the journal has aborted behind our
+	 * backs (eg. EIO in the commit thread), then we still need to
+	 * take the FS itself readonly cleanly.
+	 */
+	vfs_check_frozen(sb, SB_FREEZE_TRANS);
+	if (is_journal_aborted(journal)) {
+		ext4_abort(sb, "Detected aborted journal");
+		return ERR_PTR(-EROFS);
+	}
+	return jbd2_journal_start(journal, nblocks);
 }
 
 /*
@@ -4131,6 +4153,11 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 /*
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
+ *
+ * Note that only this function cannot bring a filesystem to be in a clean
+ * state independently, because ext4 prevents a new handle from being started
+ * by @sb->s_frozen, which stays in an upper layer.  It thus needs help from
+ * the upper layer.
  */
 static int ext4_freeze(struct super_block *sb)
 {
-- 
1.7.4

