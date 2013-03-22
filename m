From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback
Date: Fri, 22 Mar 2013 20:18:41 +0400
Message-ID: <1363969123-16852-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:42827 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab3CVQTr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Mar 2013 12:19:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Following race is possible
[kjournald2]                              other_task
jbd2_journal_commit_transaction()
  j_state = T_FINISHED;
  spin_unlock(&journal->j_list_lock);
                                         ->jbd2_journal_remove_checkpoint()
					   ->jbd2_journal_free_transaction();
					     ->kmem_cache_free(transaction)
  ->j_commit_callback(journal, transaction);
    -> USE_AFTER_FREE

WARNING: at lib/list_debug.c:62 __list_del_entry+0x1c0/0x250()
Hardware name:
list_del corruption. prev->next should be ffff88019a4ec198, but was 6b6b6b6b6b6b6b6b
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
Pid: 16400, comm: jbd2/dm-1-8 Tainted: G        W    3.8.0-rc3+ #107
Call Trace:
 [<ffffffff8106fb0d>] warn_slowpath_common+0xad/0xf0
 [<ffffffff8106fc06>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff813637e9>] ? ext4_journal_commit_callback+0x99/0xc0
 [<ffffffff8148cae0>] __list_del_entry+0x1c0/0x250
 [<ffffffff813637bf>] ext4_journal_commit_callback+0x6f/0xc0
 [<ffffffff813ca336>] jbd2_journal_commit_transaction+0x23a6/0x2570
 [<ffffffff8108aa42>] ? try_to_del_timer_sync+0x82/0xa0
 [<ffffffff8108b491>] ? del_timer_sync+0x91/0x1e0
 [<ffffffff813d3ecf>] kjournald2+0x19f/0x6a0
 [<ffffffff810ad630>] ? wake_up_bit+0x40/0x40
 [<ffffffff813d3d30>] ? bit_spin_lock+0x80/0x80
 [<ffffffff810ac6be>] kthread+0x10e/0x120
 [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff818ff6ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70

In order to demonstrace this issue one should mount ext4 with -odiscard option
on SSD disk. This makes callback longer and race window becomes wider.

In order to fix this we should mark transaction as finished only after
one of contidions are true:
1) Checkpoint lists are empty so we are shure what jbd2_journal_remove_checkpoint()
   can not be called under our feets.
2) All callbacks have completed

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd2/commit.c     |   28 +++++++++++++++++++++++-----
 include/linux/jbd2.h |    1 +
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 750c701..31541f7 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -1134,7 +1134,7 @@ restart_loop:
 	journal->j_stats.run.rs_blocks_logged += stats.run.rs_blocks_logged;
 	spin_unlock(&journal->j_history_lock);
 
-	commit_transaction->t_state = T_FINISHED;
+	commit_transaction->t_state = T_COMMIT_CALLBACK;
 	J_ASSERT(commit_transaction == journal->j_committing_transaction);
 	journal->j_commit_sequence = commit_transaction->t_tid;
 	journal->j_committing_transaction = NULL;
@@ -1149,12 +1149,20 @@ restart_loop:
 				journal->j_average_commit_time*3) / 4;
 	else
 		journal->j_average_commit_time = commit_time;
-	write_unlock(&journal->j_state_lock);
 
+	/*
+	 * If checkpoint lists are empty it is safe to mark transaction as
+	 * finished because no one will destroy it in under our feets.
+	 */
 	if (commit_transaction->t_checkpoint_list == NULL &&
 	    commit_transaction->t_checkpoint_io_list == NULL) {
-		__jbd2_journal_drop_transaction(journal, commit_transaction);
 		to_free = 1;
+		commit_transaction->t_state = T_FINISHED;
+	}
+	write_unlock(&journal->j_state_lock);
+
+	if (to_free) {
+		__jbd2_journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
 			journal->j_checkpoint_transactions = commit_transaction;
@@ -1179,8 +1187,18 @@ restart_loop:
 	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
-	if (to_free)
-		jbd2_journal_free_transaction(commit_transaction);
 
+	write_lock(&journal->j_state_lock);
+	spin_lock(&journal->j_list_lock);
+	commit_transaction->t_state = T_FINISHED;
+	/* Recheck checkpoint lists after j_list_lock was dropped */
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
+		if (!to_free)
+			__jbd2_journal_drop_transaction(journal, commit_transaction);
+		jbd2_journal_free_transaction(commit_transaction);
+	}
+	spin_unlock(&journal->j_list_lock);
+	write_unlock(&journal->j_state_lock);
 	wake_up(&journal->j_wait_done_commit);
 }
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 50e5a5e..608ea13 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -480,6 +480,7 @@ struct transaction_s
 		T_COMMIT,
 		T_COMMIT_DFLUSH,
 		T_COMMIT_JFLUSH,
+		T_COMMIT_CALLBACK,
 		T_FINISHED
 	}			t_state;
 
-- 
1.7.1

