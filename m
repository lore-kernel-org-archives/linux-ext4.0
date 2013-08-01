From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] jbd: drop checkpoint mutex when waiting in
 __log_wait_for_space()
Date: Fri, 2 Aug 2013 00:35:00 +0200
Message-ID: <20130801223500.GH31857@quack.suse.cz>
References: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
 <1375383668-8072-4-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375383668-8072-4-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 01-08-13 15:01:07, Paul Gortmaker wrote:
> Backport of jbd2 commit 0ef54180e0187117062939202b96faf04c8673bc
> ("jbd2: drop checkpoint mutex when waiting in __jbd2_log_wait_for_space()")
> 
> Quoting that commit:
>  --------------
>  While trying to debug an an issue under extreme I/O loading
>  on preempt-rt kernels, the following backtrace was observed
>  via SysRQ output:
> 
>  rm              D ffff8802203afbc0  4600  4878   4748 0x00000000
>   ffff8802217bfb78 0000000000000082 ffff88021fc2bb80 ffff88021fc2bb80
>   ffff88021fc2bb80 ffff8802217bffd8 ffff8802217bffd8 ffff8802217bffd8
>   ffff88021f1d4c80 ffff88021fc2bb80 ffff8802217bfb88 ffff88022437b000
>  Call Trace:
>   [<ffffffff8172dc34>] schedule+0x24/0x70
>   [<ffffffff81225b5d>] jbd2_log_wait_commit+0xbd/0x140
>   [<ffffffff81060390>] ? __init_waitqueue_head+0x50/0x50
>   [<ffffffff81223635>] jbd2_log_do_checkpoint+0xf5/0x520
>   [<ffffffff81223b09>] __jbd2_log_wait_for_space+0xa9/0x1f0
>   [<ffffffff8121dc40>] start_this_handle.isra.10+0x2e0/0x530
>   [<ffffffff81060390>] ? __init_waitqueue_head+0x50/0x50
>   [<ffffffff8121e0a3>] jbd2__journal_start+0xc3/0x110
>   [<ffffffff811de7ce>] ? ext4_rmdir+0x6e/0x230
>   [<ffffffff8121e0fe>] jbd2_journal_start+0xe/0x10
>   [<ffffffff811f308b>] ext4_journal_start_sb+0x5b/0x160
>   [<ffffffff811de7ce>] ext4_rmdir+0x6e/0x230
>   [<ffffffff811435c5>] vfs_rmdir+0xd5/0x140
>   [<ffffffff8114370f>] do_rmdir+0xdf/0x120
>   [<ffffffff8105c6b4>] ? task_work_run+0x44/0x80
>   [<ffffffff81002889>] ? do_notify_resume+0x89/0x100
>   [<ffffffff817361ae>] ? int_signal+0x12/0x17
>   [<ffffffff81145d85>] sys_unlinkat+0x25/0x40
>   [<ffffffff81735f22>] system_call_fastpath+0x16/0x1b
> 
>  What is interesting here, is that we call log_wait_commit, from
>  within wait_for_space, but we are still holding the checkpoint_mutex
>  as it surrounds mostly the whole of wait_for_space.  And then, as we
>  are waiting, journal_commit_transaction can run, and if the JBD2_FLUSHED
>  bit is set, then we will also try to take the same checkpoint_mutex.
> 
>  It seems that we need to drop the checkpoint_mutex while sitting in
>  jbd2_log_wait_commit, if we want to guarantee that progress can be made
>  by jbd2_journal_commit_transaction().  There does not seem to be
>  anything preempt-rt specific about this, other then perhaps increasing
>  the odds of it happening.
>  --------------
  As much as this is a sensible optimization, I don't agree with the
analysis that the system can deadlock when JBD2_FLUSHED is set. We call
jbd2_log_wait_commit() only if there is already committing transaction and
that gets set *after* JBD2_FLUSHED is handled. So it would be good if you
went back and actually checked where exactly did we hang in
jbd2_journal_commit_transaction()...

								Honza
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  fs/jbd/checkpoint.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
> index 08c0304..8e8e0ee 100644
> --- a/fs/jbd/checkpoint.c
> +++ b/fs/jbd/checkpoint.c
> @@ -160,7 +160,15 @@ void __log_wait_for_space(journal_t *journal)
>  				/* We were able to recover space; yay! */
>  				;
>  			} else if (tid) {
> +				/*
> +				 * jbd_journal_commit_transaction() may want
> +				 * to take the checkpoint_mutex if JBD_FLUSHED
> +				 * is set.  So we need to temporarily drop it.
> +				 */
> +				mutex_unlock(&journal->j_checkpoint_mutex);
>  				log_wait_commit(journal, tid);
> +				spin_lock(&journal->j_state_lock);
> +				continue;
>  			} else {
>  				printk(KERN_ERR "%s: needed %d blocks and "
>  				       "only had %d space available\n",
> -- 
> 1.8.1.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
