From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 2/2 take2] jbd2: delete spin_lock(t_handle_lock) inside
 wirte_lock(j_state_lock)
Date: Mon, 26 Dec 2011 10:17:27 +0900
Message-ID: <20111226101727.1ca09119.toshi.okajima@jp.fujitsu.com>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
	<CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
	<4EF066F0.5010809@jp.fujitsu.com>
	<20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
	<20111222210007.ca8fb54f.toshi.okajima@jp.fujitsu.com>
	<CAGBYx2YBq_=N0Gnky7RhNHhyTybhP1fLB6Fzzp-GLhEy6Lyekw@mail.gmail.com>
	<4EF7BDE2.4000309@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, toshi.okajima@jp.fujitsu.com
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50943 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1LZBZN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Dec 2011 20:25:13 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 11FAA3EE0B6
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 10:25:12 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id DDF8145DE61
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 10:25:11 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id BDDFA45DE55
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 10:25:11 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id ACC7D1DB804F
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 10:25:11 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 634F7E08005
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 10:25:11 +0900 (JST)
In-Reply-To: <4EF7BDE2.4000309@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Delete all spin_lock(t_handle_lock) statements inside write_lock(j_state_lock) 
because the critical code sections can be protected by write_lock(j_state_lock)
only.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Reported-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd2/commit.c      |    4 ----
 fs/jbd2/transaction.c |    6 +-----
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 68d704d..1030d47 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -364,22 +364,18 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	stats.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
 					      stats.run.rs_locked);
 
-	spin_lock(&commit_transaction->t_handle_lock);
 	while (atomic_read(&commit_transaction->t_updates)) {
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(&journal->j_wait_updates, &wait,
 					TASK_UNINTERRUPTIBLE);
 		if (atomic_read(&commit_transaction->t_updates)) {
-			spin_unlock(&commit_transaction->t_handle_lock);
 			write_unlock(&journal->j_state_lock);
 			schedule();
 			write_lock(&journal->j_state_lock);
-			spin_lock(&commit_transaction->t_handle_lock);
 		}
 		finish_wait(&journal->j_wait_updates, &wait);
 	}
-	spin_unlock(&commit_transaction->t_handle_lock);
 
 	J_ASSERT (atomic_read(&commit_transaction->t_outstanding_credits) <=
 			journal->j_max_transaction_buffers);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 76f2eca..c418ed9 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -516,14 +516,10 @@ void jbd2_journal_lock_updates(journal_t *journal)
 		if (!transaction)
 			break;
 
-		spin_lock(&transaction->t_handle_lock);
-		if (!atomic_read(&transaction->t_updates)) {
-			spin_unlock(&transaction->t_handle_lock);
+		if (!atomic_read(&transaction->t_updates))
 			break;
-		}
 		prepare_to_wait(&journal->j_wait_updates, &wait,
 				TASK_UNINTERRUPTIBLE);
-		spin_unlock(&transaction->t_handle_lock);
 		write_unlock(&journal->j_state_lock);
 		schedule();
 		finish_wait(&journal->j_wait_updates, &wait);
-- 
1.5.5.6
