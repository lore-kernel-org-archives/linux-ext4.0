From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] jbd2: jbd2_journal_stop needs an exclusive control
 to synchronize around t_update operations
Date: Tue, 3 Jan 2012 16:32:45 +0100
Message-ID: <20120103153245.GE31457@quack.suse.cz>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
 <CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
 <4EF066F0.5010809@jp.fujitsu.com>
 <20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
 <20111222205650.fe9d1b36.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab2ADRA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 12:00:56 -0500
Content-Disposition: inline
In-Reply-To: <20111222205650.fe9d1b36.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Thu 22-12-11 20:56:50, Toshiyuki Okajima wrote:
> The following statements need an exclusive control for the critical code section
> around t_update operations:
> [jbd2_journal_stop()]
> 1445         /*
> 1446          * Once we drop t_updates, if it goes to zero the transaction
> 1447          * could start committing on us and eventually disappear.  So
> 1448          * once we do this, we must not dereference transaction
> 1449          * pointer again.
> 1450          */
> 1451         tid = transaction->t_tid;
> +    read_lock(&journal->j_state_lock);
> ----- critical code section ------------------------------------------------
> 1452         if (atomic_dec_and_test(&transaction->t_updates)) {
> 1453                 wake_up(&journal->j_wait_updates);
> 1454                 if (journal->j_barrier_count)
> 1455                         wake_up(&journal->j_wait_transaction_locked);
> 1456         }
> -----------------------------------------------------------------------------
> +    read_unlock(&journal->j_state_lock);
> 1457 
> 
> Because the functions which have the other critical code sections around t_update 
> operations, 
>  - jbd2_journal_commit_transaction
>  - start_this_handle
>  - jbd2_journal_lock_updates
> can not synchronize with jbd2_journal_stop.
> 
> ex) jbd2_journal_lock_updates
>  505 void jbd2_journal_lock_updates(journal_t *journal)
>  506 {
>  507         DEFINE_WAIT(wait);
>  508 
>  509         write_lock(&journal->j_state_lock);
>  510         ++journal->j_barrier_count;
>  511 
>  512         /* Wait until there are no running updates */
>  513         while (1) {
>  514                transaction_t *transaction = journal->j_running_transaction;
>  515 
>  516                 if (!transaction)
>  517                         break;
>  518 
>  519                 spin_lock(&transaction->t_handle_lock);
> ----- critical code section ------------------------------------------------
>  520                 if (!atomic_read(&transaction->t_updates)) {
>  521                         spin_unlock(&transaction->t_handle_lock);
>  522                         break;
>  523                 }
>  524                 prepare_to_wait(&journal->j_wait_updates, &wait,
>  525                                 TASK_UNINTERRUPTIBLE);
> -----------------------------------------------------------------------------
>  526                 spin_unlock(&transaction->t_handle_lock);
>  527                 write_unlock(&journal->j_state_lock);
>  528                 schedule();
>  529                 finish_wait(&journal->j_wait_updates, &wait);
>  530                 write_lock(&journal->j_state_lock);
>  531         }
>  532         write_unlock(&journal->j_state_lock);
> 
> Thefore, the following steps causes a hang-up of process1:
> 1) (process1) line 520 in jbd2_journal_lock_updates
>       transaction->t_updates is equal to 1, and then goto 4).
> 2) (process2) line 1452 in jbd2_journal_stop
>       transaction->t_updates becomes to 0, and then goto 3).
> 3) (process2) line 1453 in jbd2_journal_stop
>       wake_up(&journal->j_wait_updates) tries to wake someone up.
> 4) (process1) line 524 in jbd2_journal_lock_updates
>       prepare to sleep itself, and then goto 5).
> 5) (process1) line 528 in jbd2_journal_lock_updates
>       sleep forever because process2 doesn't wake it up anymore.
  Thanks for the analysis. Actually, you fix adds unnecessary overhead.
The problem really is the wrong ordering of prepare_to_wait() and t_updates
check. So attached patch should fix the issue as well without introducing
the overhead.

> Similar problem also exists for j_barrier_count operations but it can be
> fixed, too:
> [jbd2_journal_lock_updates]
>  505 void jbd2_journal_lock_updates(journal_t *journal)
>  506 {
>  507         DEFINE_WAIT(wait);
>  508 
>  509         write_lock(&journal->j_state_lock);
> ----------------------------------------------------------------------------
>  510         ++journal->j_barrier_count;
> ----------------------------------------------------------------------------
> ...
>  532         write_unlock(&journal->j_state_lock);
> 
> [jbd2_journal_stop]
> 1445         /*
> 1446          * Once we drop t_updates, if it goes to zero the transaction
> 1447          * could start committing on us and eventually disappear.  So
> 1448          * once we do this, we must not dereference transaction
> 1449          * pointer again.
> 1450          */
> 1451         tid = transaction->t_tid;
> +    read_lock(&journal->j_state_lock);
> 1452         if (atomic_dec_and_test(&transaction->t_updates)) {
> 1453                 wake_up(&journal->j_wait_updates);
> ----------------------------------------------------------------------------
> 1454                 if (journal->j_barrier_count)
> 1455                         wake_up(&journal->j_wait_transaction_locked);
> ----------------------------------------------------------------------------
> 1456         }
> +    read_unlock(&journal->j_state_lock);
> 1457 
  Here I don't agree. We use wait_event() to wait for j_barrier_count to
drop to zero and wait_event() has proper ordering of prepare_to_wait() and
test.

								Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--SUOF0GtieIMvvwua
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Fix-hung-processes-in-jbd2_journal_lock_updates.patch"

>From 1cd5b8178893f3f186ce93eb1f47664a1a3e81fc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 3 Jan 2012 16:13:29 +0100
Subject: [PATCH] jbd2: Fix hung processes in jbd2_journal_lock_updates()

Toshiyuki Okajima found out that when running

for ((i=0; i < 100000; i++)); do
        if ((i%2 == 0)); then
                chattr +j /mnt/file
        else
                chattr -j /mnt/file
        fi
        echo "0" >> /mnt/file
done

process sometimes hangs indefinitely in jbd2_journal_lock_updates().

Toshiyuki identified that the following race happens:

jbd2_journal_lock_updates()            |jbd2_journal_stop()
---------------------------------------+---------------------------------------
 write_lock(&journal->j_state_lock)    |    .
 ++journal->j_barrier_count            |    .
 spin_lock(&tran->t_handle_lock)       |    .
 atomic_read(&tran->t_updates) //not 0 |
                                       | atomic_dec_and_test(&tran->t_updates)
                                       |    // t_updates = 0
                                       | wake_up(&journal->j_wait_updates)
 prepare_to_wait()                     |    // no process is woken up.
 spin_unlock(&tran->t_handle_lock)     |
 write_unlock(&journal->j_state_lock)  |
 schedule() // never return            |

We fix the problem by first calling prepare_to_wait() and only after that
checking t_updates in jbd2_journal_lock_updates().

Reported-and-analyzed-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a0e41a4..35ae096 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -517,12 +517,13 @@ void jbd2_journal_lock_updates(journal_t *journal)
 			break;
 
 		spin_lock(&transaction->t_handle_lock);
+		prepare_to_wait(&journal->j_wait_updates, &wait,
+				TASK_UNINTERRUPTIBLE);
 		if (!atomic_read(&transaction->t_updates)) {
 			spin_unlock(&transaction->t_handle_lock);
+			finish_wait(&journal->j_wait_updates, &wait);
 			break;
 		}
-		prepare_to_wait(&journal->j_wait_updates, &wait,
-				TASK_UNINTERRUPTIBLE);
 		spin_unlock(&transaction->t_handle_lock);
 		write_unlock(&journal->j_state_lock);
 		schedule();
-- 
1.7.1


--SUOF0GtieIMvvwua--
