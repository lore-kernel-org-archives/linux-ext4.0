From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] jbd2: remove all t_handle_lock statements
Date: Mon, 26 Dec 2011 09:20:50 +0900
Message-ID: <4EF7BDE2.4000309@jp.fujitsu.com>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>	<CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>	<4EF066F0.5010809@jp.fujitsu.com>	<20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>	<20111222210007.ca8fb54f.toshi.okajima@jp.fujitsu.com> <CAGBYx2YBq_=N0Gnky7RhNHhyTybhP1fLB6Fzzp-GLhEy6Lyekw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60345 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1LZARV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Dec 2011 19:17:21 -0500
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 0940D3EE0AE
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 09:17:20 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id E4A6245DEA6
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 09:17:19 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id CADAE45DE9E
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 09:17:19 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id AF4F31DB8042
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 09:17:19 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5DAD31DB803F
	for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 09:17:19 +0900 (JST)
In-Reply-To: <CAGBYx2YBq_=N0Gnky7RhNHhyTybhP1fLB6Fzzp-GLhEy6Lyekw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Yongqiang,

(2011/12/22 23:07), Yongqiang Yang wrote:
> On Thu, Dec 22, 2011 at 8:00 PM, Toshiyuki Okajima
> <toshi.okajima@jp.fujitsu.com> wrote:
>> Remove all t_handle_lock statements because they are not necessary anymore.
>>
>> Because there is read_lock(&journal->j_state_lock) or
>> write_lock(&journal->j_state_lock) on all the forward codes beyond the place
>> which needs a spin_lock(&transaction->t_handle_lock).
>>
>> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
>> Cc:
>> ---
>>  fs/jbd2/commit.c      |    4 ----
>>  fs/jbd2/transaction.c |   18 +++---------------
>>  include/linux/jbd2.h  |    8 --------
>>  3 files changed, 3 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> index 68d704d..1030d47 100644
>> --- a/fs/jbd2/commit.c
>> +++ b/fs/jbd2/commit.c
>> @@ -364,22 +364,18 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>>        stats.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
>>                                              stats.run.rs_locked);
>>
>> -       spin_lock(&commit_transaction->t_handle_lock);
>>        while (atomic_read(&commit_transaction->t_updates)) {
>>                DEFINE_WAIT(wait);
>>
>>                prepare_to_wait(&journal->j_wait_updates, &wait,
>>                                        TASK_UNINTERRUPTIBLE);
>>                if (atomic_read(&commit_transaction->t_updates)) {
>> -                       spin_unlock(&commit_transaction->t_handle_lock);
>>                        write_unlock(&journal->j_state_lock);
>>                        schedule();
>>                        write_lock(&journal->j_state_lock);
>> -                       spin_lock(&commit_transaction->t_handle_lock);
>>                }
>>                finish_wait(&journal->j_wait_updates, &wait);
>>        }
>> -       spin_unlock(&commit_transaction->t_handle_lock);
>>
>>        J_ASSERT (atomic_read(&commit_transaction->t_outstanding_credits) <=
>>                        journal->j_max_transaction_buffers);
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index 76f2eca..7f84e3f 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -56,7 +56,6 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
>>        transaction->t_start_time = ktime_get();
>>        transaction->t_tid = journal->j_transaction_sequence++;
>>        transaction->t_expires = jiffies + journal->j_commit_interval;
>> -       spin_lock_init(&transaction->t_handle_lock);
>>        atomic_set(&transaction->t_updates, 0);
>>        atomic_set(&transaction->t_outstanding_credits, 0);
>>        atomic_set(&transaction->t_handle_count, 0);

>> @@ -100,10 +99,8 @@ static inline void update_t_max_wait(transaction_t *transaction,
>>        if (jbd2_journal_enable_debug &&
>>            time_after(transaction->t_start, ts)) {
>>                ts = jbd2_time_diff(ts, transaction->t_start);
>> -               spin_lock(&transaction->t_handle_lock);
>>                if (ts > transaction->t_max_wait)
>>                        transaction->t_max_wait = ts;
>> -               spin_unlock(&transaction->t_handle_lock);
> Hi Toshiyuki,
> 
>      I think you removed too much.  t_handle_lock is needed here to
> protect t_max_wait.   I meant just removing t_handle_lock from where I
> commented in your patch post out last time.
Thanks for your comment. OK, I understand.

This function tries to protect itself by 
 read_lock(&journal->j_state_lock), but by only 
read_lock(&journal->j_state_lock) cannot protect this critical code 
section.

  96 static inline void update_t_max_wait(transaction_t *transaction,
  97                                      unsigned long ts)
  98 {
  99 #ifdef CONFIG_JBD2_DEBUG
 100         if (jbd2_journal_enable_debug &&
 101             time_after(transaction->t_start, ts)) {
 102                 ts = jbd2_time_diff(ts, transaction->t_start);
 103                 spin_lock(&transaction->t_handle_lock);
 104                 if (ts > transaction->t_max_wait)
 105                         transaction->t_max_wait = ts;
 106                 spin_unlock(&transaction->t_handle_lock);
 107         }
 108 #endif
 109 }

I will delete the part of my patch for update_t_max_wait().

Due to the same reason, 
 - jbd2_journal_extend
 - jbd2_journal_restart
cannot be protected by my patch. So, I will delete these parts, too.

Best Regards,
Toshiyuki Okajima

> 
> Yongqiang.
>>        }
>>  #endif
>>  }
>> @@ -401,19 +398,18 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
>>                goto error_out;
>>        }
>>
>> -       spin_lock(&transaction->t_handle_lock);
>>        wanted = atomic_read(&transaction->t_outstanding_credits) + nblocks;
>>
>>        if (wanted > journal->j_max_transaction_buffers) {
>>                jbd_debug(3, "denied handle %p %d blocks: "
>>                          "transaction too large\n", handle, nblocks);
>> -               goto unlock;
>> +               goto error_out;
>>        }
>>
>>        if (wanted > __jbd2_log_space_left(journal)) {
>>                jbd_debug(3, "denied handle %p %d blocks: "
>>                          "insufficient log space\n", handle, nblocks);
>> -               goto unlock;
>> +               goto error_out;
>>        }
>>
>>        handle->h_buffer_credits += nblocks;
>> @@ -421,8 +417,6 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
>>        result = 0;
>>
>>        jbd_debug(3, "extended handle %p by %d\n", handle, nblocks);
>> -unlock:
>> -       spin_unlock(&transaction->t_handle_lock);
>>  error_out:
>>        read_unlock(&journal->j_state_lock);
>>  out:
>> @@ -464,12 +458,10 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
>>        J_ASSERT(journal_current_handle() == handle);
>>
>>        read_lock(&journal->j_state_lock);
>> -       spin_lock(&transaction->t_handle_lock);
>>        atomic_sub(handle->h_buffer_credits,
>>                   &transaction->t_outstanding_credits);
>>        if (atomic_dec_and_test(&transaction->t_updates))
>>                wake_up(&journal->j_wait_updates);
>> -       spin_unlock(&transaction->t_handle_lock);
>>
>>        jbd_debug(2, "restarting handle %p\n", handle);
>>        tid = transaction->t_tid;
>> @@ -516,14 +508,10 @@ void jbd2_journal_lock_updates(journal_t *journal)
>>                if (!transaction)
>>                        break;
>>
>> -               spin_lock(&transaction->t_handle_lock);
>> -               if (!atomic_read(&transaction->t_updates)) {
>> -                       spin_unlock(&transaction->t_handle_lock);
>> +               if (!atomic_read(&transaction->t_updates))
>>                        break;
>> -               }
>>                prepare_to_wait(&journal->j_wait_updates, &wait,
>>                                TASK_UNINTERRUPTIBLE);
>> -               spin_unlock(&transaction->t_handle_lock);
>>                write_unlock(&journal->j_state_lock);
>>                schedule();
>>                finish_wait(&journal->j_wait_updates, &wait);
>> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
>> index 2092ea2..55f7a8c 100644
>> --- a/include/linux/jbd2.h
>> +++ b/include/linux/jbd2.h
>> @@ -440,9 +440,6 @@ struct transaction_chp_stats_s {
>>  *    ->j_list_lock
>>  *
>>  *    j_state_lock
>> - *    ->t_handle_lock
>> - *
>> - *    j_state_lock
>>  *    ->j_list_lock                    (journal_unmap_buffer)
>>  *
>>  */
>> @@ -538,11 +535,6 @@ struct transaction_s
>>        struct list_head        t_inode_list;
>>
>>        /*
>> -        * Protects info related to handles
>> -        */
>> -       spinlock_t              t_handle_lock;
>> -
>> -       /*
>>         * Longest time some handle had to wait for running transaction
>>         */
>>        unsigned long           t_max_wait;
>> --
>> 1.5.5.6
> 
> 
> 

