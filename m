From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv3 1/1] jbd2: Fix I/O hang in
 jbd2_journal_release_jbd_inode
Date: Thu, 2 Sep 2010 04:21:20 -0400
Message-ID: <20100902082119.GB4930@thunk.org>
References: <201008311407.o7VE7ATB020184@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: josef@redhat.com, linux-ext4@vger.kernel.org,
	cmm@linux.vnet.ibm.com, pmac@au1.ibm.com
To: Brian King <brking@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41624 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab0IBKPE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Sep 2010 06:15:04 -0400
Content-Disposition: inline
In-Reply-To: <201008311407.o7VE7ATB020184@d03av04.boulder.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added to the ext4 patch queue, thanks!!!

					- Ted

On Tue, Aug 31, 2010 at 09:07:16AM -0500, Brian King wrote:
> 
> This fixes a hang seen in jbd2_journal_release_jbd_inode
> on a lot of Power 6 systems running with ext4. When we get
> in the hung state, all I/O to the disk in question gets blocked
> where we stay indefinitely. Looking at the task list, I can see
> we are stuck in jbd2_journal_release_jbd_inode waiting on a
> wake up. I added some debug code to detect this scenario and
> dump additional data if we were stuck in jbd2_journal_release_jbd_inode
> for longer than 30 minutes. When it hit, I was able to see that
> i_flags was 0, suggesting we missed the wake up.
> 
> This patch changes i_flags to be an unsigned long, uses bit operators
> to access it, and adds barriers around the accesses. Prior to applying
> this patch, we were regularly hitting this hang on numerous systems
> in our test environment. After applying the patch, the hangs no longer
> occur.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  fs/jbd2/commit.c     |   12 ++++++++----
>  fs/jbd2/journal.c    |    4 +++-
>  include/linux/jbd2.h |    2 +-
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff -puN include/linux/jbd2.h~jbd2_ji_commit_barrier_patch include/linux/jbd2.h
> --- linux-2.6/include/linux/jbd2.h~jbd2_ji_commit_barrier_patch	2010-08-30 08:45:04.000000000 -0500
> +++ linux-2.6-bjking1/include/linux/jbd2.h	2010-08-30 08:45:04.000000000 -0500
> @@ -395,7 +395,7 @@ struct jbd2_inode {
>  	struct inode *i_vfs_inode;
>  
>  	/* Flags of inode [j_list_lock] */
> -	unsigned int i_flags;
> +	unsigned long i_flags;
>  };
>  
>  struct jbd2_revoke_table_s;
> diff -puN fs/jbd2/commit.c~jbd2_ji_commit_barrier_patch fs/jbd2/commit.c
> --- linux-2.6/fs/jbd2/commit.c~jbd2_ji_commit_barrier_patch	2010-08-30 08:45:04.000000000 -0500
> +++ linux-2.6-bjking1/fs/jbd2/commit.c	2010-08-30 08:45:04.000000000 -0500
> @@ -26,7 +26,9 @@
>  #include <linux/backing-dev.h>
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> +#include <linux/bitops.h>
>  #include <trace/events/jbd2.h>
> +#include <asm/system.h>
>  
>  /*
>   * Default IO end handler for temporary BJ_IO buffer_heads.
> @@ -236,7 +238,7 @@ static int journal_submit_data_buffers(j
>  	spin_lock(&journal->j_list_lock);
>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
>  		mapping = jinode->i_vfs_inode->i_mapping;
> -		jinode->i_flags |= JI_COMMIT_RUNNING;
> +		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>  		spin_unlock(&journal->j_list_lock);
>  		/*
>  		 * submit the inode data buffers. We use writepage
> @@ -251,7 +253,8 @@ static int journal_submit_data_buffers(j
>  		spin_lock(&journal->j_list_lock);
>  		J_ASSERT(jinode->i_transaction == commit_transaction);
>  		commit_transaction->t_flushed_data_blocks = 1;
> -		jinode->i_flags &= ~JI_COMMIT_RUNNING;
> +		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
> +		smp_mb__after_clear_bit();
>  		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>  	}
>  	spin_unlock(&journal->j_list_lock);
> @@ -272,7 +275,7 @@ static int journal_finish_inode_data_buf
>  	/* For locking, see the comment in journal_submit_data_buffers() */
>  	spin_lock(&journal->j_list_lock);
>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
> -		jinode->i_flags |= JI_COMMIT_RUNNING;
> +		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>  		spin_unlock(&journal->j_list_lock);
>  		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
>  		if (err) {
> @@ -288,7 +291,8 @@ static int journal_finish_inode_data_buf
>  				ret = err;
>  		}
>  		spin_lock(&journal->j_list_lock);
> -		jinode->i_flags &= ~JI_COMMIT_RUNNING;
> +		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
> +		smp_mb__after_clear_bit();
>  		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>  	}
>  
> diff -puN fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch fs/jbd2/journal.c
> --- linux-2.6/fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch	2010-08-30 08:45:04.000000000 -0500
> +++ linux-2.6-bjking1/fs/jbd2/journal.c	2010-08-31 08:58:24.000000000 -0500
> @@ -42,12 +42,14 @@
>  #include <linux/log2.h>
>  #include <linux/vmalloc.h>
>  #include <linux/backing-dev.h>
> +#include <linux/bitops.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/jbd2.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
> +#include <asm/system.h>
>  
>  EXPORT_SYMBOL(jbd2_journal_extend);
>  EXPORT_SYMBOL(jbd2_journal_stop);
> @@ -2206,7 +2208,7 @@ void jbd2_journal_release_jbd_inode(jour
>  restart:
>  	spin_lock(&journal->j_list_lock);
>  	/* Is commit writing out inode - we have to wait */
> -	if (jinode->i_flags & JI_COMMIT_RUNNING) {
> +	if (test_bit(__JI_COMMIT_RUNNING, &jinode->i_flags)) {
>  		wait_queue_head_t *wq;
>  		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
>  		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
> _
