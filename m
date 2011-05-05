From: Tao Ma <tm@tao.ma>
Subject: [PATCH] jbd2: take j_list_lock when checking b_jlist in do_get_write_access.
Date: Thu,  5 May 2011 17:57:16 +0800
Message-ID: <1304589436-14860-1-git-send-email-tm@tao.ma>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:49519 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751515Ab1EEJ7z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 05:59:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In do_get_write_access, we check journal_head->b_jlist and if it
is BJ_Shadow, we will sleep until we remove it from t_shadow_list
in jbd2_journal_commit_transaction, but it isn't protected by any
lock. So if we uses some cached b_jlist and before schedule,
jbd2_journal_commit_transaction has already waken up all
the waiting thread. As a result, this thread will never be waken up.
We find this in our test env with the following error message.

kernel: [538683.634205] INFO: task java:17653 blocked for more than 120 seconds.
kernel: [538683.640633] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: [538683.648542] java          D 0000000000000000     0 17653  17302 0x00000000
kernel: [538683.648546]  ffff88050de7bb68 0000000000000082 0000000000000000 ffffffff81159041
kernel: [538683.656086]  ffff8805cf464540 ffffffff816740c0 ffff8805cf464af8 0000000120216c16
kernel: [538683.663617]  ffffffff0de7bb38 0000000000000000 0000000000000000 ffff880028043420
kernel: [538683.671190] Call Trace:
kernel: [538683.673730]  [<ffffffff81159041>] ? __find_get_block_slow+0x103/0x115
kernel: [538683.680258]  [<ffffffffa017ed00>] do_get_write_access+0x1ba/0x3ab [jbd2]
kernel: [538683.687033]  [<ffffffff8107bf9d>] ? wake_bit_function+0x0/0x2f
kernel: [538683.692943]  [<ffffffff81159494>] ? __getblk+0x2d/0x1e5
kernel: [538683.698243]  [<ffffffffa017ef18>] jbd2_journal_get_write_access+0x27/0x38 [jbd2]
kernel: [538683.705731]  [<ffffffffa01c5e65>] __ext4_journal_get_write_access+0x4c/0x5f [ext4]
kernel: [538683.713384]  [<ffffffffa01a3528>] ext4_new_inode+0x500/0xd68 [ext4]
kernel: [538683.719725]  [<ffffffffa017f26a>] ? start_this_handle+0x341/0x3ff [jbd2]
kernel: [538683.726671]  [<ffffffffa017f3c9>] ? jbd2_journal_start+0xa1/0xcd [jbd2]
kernel: [538683.733533]  [<ffffffffa01ae811>] ext4_create+0xb6/0x132 [ext4]
kernel: [538683.739700]  [<ffffffff811ab8dc>] ? security_inode_permission+0x21/0x23
kernel: [538683.746549]  [<ffffffff8113ba47>] vfs_create+0x7e/0x9e
kernel: [538683.751989]  [<ffffffff8113ebba>] do_filp_open+0x302/0xa39
kernel: [538683.757722]  [<ffffffff811353f2>] ? cp_new_stat+0xdb/0xf4
kernel: [538683.763365]  [<ffffffff810497a5>] ? should_resched+0xe/0x2f
kernel: [538683.769184]  [<ffffffff81406238>] ? _cond_resched+0xe/0x22
kernel: [538683.774925]  [<ffffffff811fdbc9>] ? might_fault+0xe/0x10
kernel: [538683.780479]  [<ffffffff811fdcb3>] ? __strncpy_from_user+0x20/0x4a
kernel: [538683.786810]  [<ffffffff8112dcec>] do_sys_open+0x62/0x109
kernel: [538683.792355]  [<ffffffff8112ddc6>] sys_open+0x20/0x22
kernel: [538683.797563]  [<ffffffff81011d72>] system_call_fastpath+0x16/0x1b

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/jbd2/transaction.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..2e837e8 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -693,7 +693,7 @@ repeat:
 		 * extra copy, not the primary copy, which gets
 		 * journaled.  If the primary copy is already going to
 		 * disk then we cannot do copy-out here. */
-
+		spin_lock(&journal->j_list_lock);
 		if (jh->b_jlist == BJ_Shadow) {
 			DEFINE_WAIT_BIT(wait, &bh->b_state, BH_Unshadow);
 			wait_queue_head_t *wqh;
@@ -701,18 +701,24 @@ repeat:
 			wqh = bit_waitqueue(&bh->b_state, BH_Unshadow);
 
 			JBUFFER_TRACE(jh, "on shadow: sleep");
-			jbd_unlock_bh_state(bh);
 			/* commit wakes up all shadow buffers after IO */
 			for ( ; ; ) {
 				prepare_to_wait(wqh, &wait.wait,
 						TASK_UNINTERRUPTIBLE);
 				if (jh->b_jlist != BJ_Shadow)
 					break;
+				spin_unlock(&journal->j_list_lock);
+				jbd_unlock_bh_state(bh);
 				schedule();
+				jbd_lock_bh_state(bh);
+				spin_lock(&journal->j_list_lock);
 			}
+			spin_unlock(&journal->j_list_lock);
+			jbd_unlock_bh_state(bh);
 			finish_wait(wqh, &wait.wait);
 			goto repeat;
 		}
+		spin_unlock(&journal->j_list_lock);
 
 		/* Only do the copy if the currently-owning transaction
 		 * still needs it.  If it is on the Forget list, the
-- 
1.6.3.GIT

