From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: + jbd-fix-error-handling-for-checkpoint-io.patch added to -mm
    tree
Date: Thu, 21 Aug 2008 19:09:27 +0900
Message-ID: <48AD3ED7.6050903@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu, sct@redhat.com,
	adilger@clusterfs.com, mm-commits@vger.kernel.org,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44995 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbYHUKJj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 06:09:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew and Jan,

> The patch titled
>      jbd: fix error handling for checkpoint io
> has been added to the -mm tree.  Its filename is
>      jbd-fix-error-handling-for-checkpoint-io.patch

[snip]

> Subject: jbd: fix error handling for checkpoint io
> From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> 
> When a checkpointing IO fails, current JBD code doesn't check the error
> and continue journaling.  This means latest metadata can be lost from both
> the journal and filesystem.
> 
> This patch leaves the failed metadata blocks in the journal space and
> aborts journaling in the case of log_do_checkpoint().  To achieve this, we
> need to do:
> 
> 1. don't remove the failed buffer from the checkpoint list where in
>    the case of __try_to_free_cp_buf() because it may be released or
>    overwritten by a later transaction
> 2. log_do_checkpoint() is the last chance, remove the failed buffer
>    from the checkpoint list and abort the journal
> 3. when checkpointing fails, don't update the journal super block to
>    prevent the journaled contents from being cleaned.  For safety,
>    don't update j_tail and j_tail_sequence either
> 4. when checkpointing fails, notify this error to the ext3 layer so
>    that ext3 don't clear the needs_recovery flag, otherwise the
>    journaled contents are ignored and cleaned in the recovery phase
> 5. if the recovery fails, keep the needs_recovery flag

> 6. prevent cleanup_journal_tail() from being called between
>    __journal_drop_transaction() and journal_abort() (a race issue
>    between journal_flush() and __log_wait_for_space()

When I read the source code again, I noticed the race condition described
in 6 doesn't happen.  I've thought journal_flush() can invoke
log_do_checkpoint() while __log_wait_for_space() is invoking
log_do_checkpoint(), but it would be wrong.

First journal_flush() invokes __log_start_commit() and log_wait_commit()
pair.  After this, there is no running transaction and no starting handle.
New handles are also not created because j_barrier_count blocks it.
Thus, when journal_flush() invokes log_do_checkpoint(), there is
no other process which invokes __log_wait_for_space() and
log_do_checkpoint() to get free log space.  So invocations of
log_do_checkpoint() are always isolated, the race condition doesn't
happen.

If my understanding is correct, adding mutex_lock() around
log_do_checkpoint() (see bellow) is unneeded.

What do you think about this?

[snip]
> @@ -1359,10 +1369,16 @@ int journal_flush(journal_t *journal)
>  	spin_lock(&journal->j_list_lock);
>  	while (!err && journal->j_checkpoint_transactions != NULL) {
>  		spin_unlock(&journal->j_list_lock);
> +		mutex_lock(&journal->j_checkpoint_mutex);
>  		err = log_do_checkpoint(journal);
> +		mutex_unlock(&journal->j_checkpoint_mutex);
>  		spin_lock(&journal->j_list_lock);

Best regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


