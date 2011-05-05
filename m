From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: take j_list_lock when checking b_jlist in
 do_get_write_access.
Date: Thu, 5 May 2011 14:09:04 +0200
Message-ID: <20110505120904.GC5323@quack.suse.cz>
References: <1304589436-14860-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab1EEMJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 08:09:07 -0400
Content-Disposition: inline
In-Reply-To: <1304589436-14860-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 05-05-11 17:57:16, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In do_get_write_access, we check journal_head->b_jlist and if it
> is BJ_Shadow, we will sleep until we remove it from t_shadow_list
> in jbd2_journal_commit_transaction, but it isn't protected by any
> lock. So if we uses some cached b_jlist and before schedule,
> jbd2_journal_commit_transaction has already waken up all
> the waiting thread. As a result, this thread will never be waken up.
  I had a look at the code and I think it's more complicated than this.
The code is:
       prepare_to_wait(wqh, &wait.wait, TASK_UNINTERRUPTIBLE);
       if (jh->b_jlist != BJ_Shadow)
              break;
       schedule();

You're right that jh->b_jlist != BJ_Shadow test is done without any lock.
But prepare_to_wait() does set_current_state() which implies a memory
barrier. The comment there says:
/*
 * set_current_state() includes a barrier so that the write of current->state
 * is correctly serialised wrt the caller's subsequent test of whether to
 * actually sleep:
 *
 *      set_current_state(TASK_UNINTERRUPTIBLE);
 *      if (do_i_need_to_sleep())
 *              schedule();
 *
 * If the caller does not need such serialisation then use __set_current_state()
 */
So we are guaranteed that either we see that jh->b_jlist != BJ_Shadow or
the waking process sees us in the wait queue and removes us.

Well, not quite. The waking code is:
        journal_file_buffer(jh, commit_transaction, BJ_Forget);
        /* Wake up any transactions which were waiting for this
           IO to complete */
        wake_up_bit(&bh->b_state, BH_Unshadow);
And that's where the problem actually is. Even the comment before
wake_up_bit() warns that:
 * In order for this to function properly, as it uses waitqueue_active()
 * internally, some kind of memory barrier must be done prior to calling
 * this. Typically, this will be smp_mb__after_clear_bit(), but in some
 * cases where bitflags are manipulated non-atomically under a lock, one
 * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
 * because spin_unlock() does not guarantee a memory barrier.
I'll send proper fix in a moment.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
