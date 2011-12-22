From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 1/2] jbd2: jbd2_journal_stop needs an exclusive control to
 synchronize around t_update operations
Date: Thu, 22 Dec 2011 20:56:50 +0900
Message-ID: <20111222205650.fe9d1b36.toshi.okajima@jp.fujitsu.com>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
	<CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
	<4EF066F0.5010809@jp.fujitsu.com>
	<20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51099 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1LVMCn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Dec 2011 07:02:43 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 3FBC63EE0AE
	for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2011 21:02:42 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 287AB45DE5B
	for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2011 21:02:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 1170A45DE59
	for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2011 21:02:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 05A771DB804E
	for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2011 21:02:42 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.240.81.147])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id AB1401DB8045
	for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2011 21:02:41 +0900 (JST)
In-Reply-To: <20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following statements need an exclusive control for the critical code section
around t_update operations:
[jbd2_journal_stop()]
1445         /*
1446          * Once we drop t_updates, if it goes to zero the transaction
1447          * could start committing on us and eventually disappear.  So
1448          * once we do this, we must not dereference transaction
1449          * pointer again.
1450          */
1451         tid = transaction->t_tid;
+    read_lock(&journal->j_state_lock);
----- critical code section ------------------------------------------------
1452         if (atomic_dec_and_test(&transaction->t_updates)) {
1453                 wake_up(&journal->j_wait_updates);
1454                 if (journal->j_barrier_count)
1455                         wake_up(&journal->j_wait_transaction_locked);
1456         }
-----------------------------------------------------------------------------
+    read_unlock(&journal->j_state_lock);
1457 

Because the functions which have the other critical code sections around t_update 
operations, 
 - jbd2_journal_commit_transaction
 - start_this_handle
 - jbd2_journal_lock_updates
can not synchronize with jbd2_journal_stop.

ex) jbd2_journal_lock_updates
 505 void jbd2_journal_lock_updates(journal_t *journal)
 506 {
 507         DEFINE_WAIT(wait);
 508 
 509         write_lock(&journal->j_state_lock);
 510         ++journal->j_barrier_count;
 511 
 512         /* Wait until there are no running updates */
 513         while (1) {
 514                transaction_t *transaction = journal->j_running_transaction;
 515 
 516                 if (!transaction)
 517                         break;
 518 
 519                 spin_lock(&transaction->t_handle_lock);
----- critical code section ------------------------------------------------
 520                 if (!atomic_read(&transaction->t_updates)) {
 521                         spin_unlock(&transaction->t_handle_lock);
 522                         break;
 523                 }
 524                 prepare_to_wait(&journal->j_wait_updates, &wait,
 525                                 TASK_UNINTERRUPTIBLE);
-----------------------------------------------------------------------------
 526                 spin_unlock(&transaction->t_handle_lock);
 527                 write_unlock(&journal->j_state_lock);
 528                 schedule();
 529                 finish_wait(&journal->j_wait_updates, &wait);
 530                 write_lock(&journal->j_state_lock);
 531         }
 532         write_unlock(&journal->j_state_lock);

Thefore, the following steps causes a hang-up of process1:
1) (process1) line 520 in jbd2_journal_lock_updates
      transaction->t_updates is equal to 1, and then goto 4).
2) (process2) line 1452 in jbd2_journal_stop
      transaction->t_updates becomes to 0, and then goto 3).
3) (process2) line 1453 in jbd2_journal_stop
      wake_up(&journal->j_wait_updates) tries to wake someone up.
4) (process1) line 524 in jbd2_journal_lock_updates
      prepare to sleep itself, and then goto 5).
5) (process1) line 528 in jbd2_journal_lock_updates
      sleep forever because process2 doesn't wake it up anymore.

Similar problem also exists for j_barrier_count operations but it can be
fixed, too:
[jbd2_journal_lock_updates]
 505 void jbd2_journal_lock_updates(journal_t *journal)
 506 {
 507         DEFINE_WAIT(wait);
 508 
 509         write_lock(&journal->j_state_lock);
----------------------------------------------------------------------------
 510         ++journal->j_barrier_count;
----------------------------------------------------------------------------
...
 532         write_unlock(&journal->j_state_lock);

[jbd2_journal_stop]
1445         /*
1446          * Once we drop t_updates, if it goes to zero the transaction
1447          * could start committing on us and eventually disappear.  So
1448          * once we do this, we must not dereference transaction
1449          * pointer again.
1450          */
1451         tid = transaction->t_tid;
+    read_lock(&journal->j_state_lock);
1452         if (atomic_dec_and_test(&transaction->t_updates)) {
1453                 wake_up(&journal->j_wait_updates);
----------------------------------------------------------------------------
1454                 if (journal->j_barrier_count)
1455                         wake_up(&journal->j_wait_transaction_locked);
----------------------------------------------------------------------------
1456         }
+    read_unlock(&journal->j_state_lock);
1457 

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/jbd2/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a0e41a4..76f2eca 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1449,11 +1449,13 @@ int jbd2_journal_stop(handle_t *handle)
 	 * pointer again.
 	 */
 	tid = transaction->t_tid;
+	read_lock(&journal->j_state_lock);
 	if (atomic_dec_and_test(&transaction->t_updates)) {
 		wake_up(&journal->j_wait_updates);
 		if (journal->j_barrier_count)
 			wake_up(&journal->j_wait_transaction_locked);
 	}
+	read_unlock(&journal->j_state_lock);
 
 	if (wait_for_commit)
 		err = jbd2_log_wait_commit(journal, tid);
-- 
1.5.5.6
