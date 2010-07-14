From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCHv2 1/1] jbd2: Fix I/O hang in
	jbd2_journal_release_jbd_inode
Date: Wed, 14 Jul 2010 15:05:05 -0400
Message-ID: <20100714190505.GB2378@localhost.localdomain>
References: <201007141456.o6EEuFe9004519@d01av03.pok.ibm.com> <20100714174458.GA2378@localhost.localdomain> <4C3E08E6.2050203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	cmm@linux.vnet.ibm.com, pmac@au1.ibm.com
To: Brian King <brking@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab0GNTFL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jul 2010 15:05:11 -0400
Content-Disposition: inline
In-Reply-To: <4C3E08E6.2050203@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 14, 2010 at 01:58:46PM -0500, Brian King wrote:
> 
> I've been debugging a hang in jbd2_journal_release_jbd_inode
> which is being seen on Power 6 systems quite a lot. When we get
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
> occur. Its still not clear to me why the j_list_lock doesn't protect us
> in this path. It also appears a hang very similar to this was seen
> in the past and then was no longer recreatable:
> 
> http://forum.soft32.com/linux/20090310-ext4-hangs-ftopict478916.html
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  fs/jbd2/commit.c     |   12 ++++++++----
>  fs/jbd2/journal.c    |    5 ++++-
>  include/linux/jbd2.h |    2 +-
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff -puN include/linux/jbd2.h~jbd2_ji_commit_barrier_patch include/linux/jbd2.h
> --- linux-2.6/include/linux/jbd2.h~jbd2_ji_commit_barrier_patch	2010-07-14 13:46:17.000000000 -0500
> +++ linux-2.6-bjking1/include/linux/jbd2.h	2010-07-14 13:46:17.000000000 -0500
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
> --- linux-2.6/fs/jbd2/commit.c~jbd2_ji_commit_barrier_patch	2010-07-14 13:46:17.000000000 -0500
> +++ linux-2.6-bjking1/fs/jbd2/commit.c	2010-07-14 13:56:27.000000000 -0500
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
> @@ -245,7 +247,7 @@ static int journal_submit_data_buffers(j
>  	spin_lock(&journal->j_list_lock);
>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
>  		mapping = jinode->i_vfs_inode->i_mapping;
> -		jinode->i_flags |= JI_COMMIT_RUNNING;
> +		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>  		spin_unlock(&journal->j_list_lock);
>  		/*
>  		 * submit the inode data buffers. We use writepage
> @@ -260,7 +262,8 @@ static int journal_submit_data_buffers(j
>  		spin_lock(&journal->j_list_lock);
>  		J_ASSERT(jinode->i_transaction == commit_transaction);
>  		commit_transaction->t_flushed_data_blocks = 1;
> -		jinode->i_flags &= ~JI_COMMIT_RUNNING;
> +		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
> +		smp_mb__after_clear_bit();
>  		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>  	}
>  	spin_unlock(&journal->j_list_lock);
> @@ -281,7 +284,7 @@ static int journal_finish_inode_data_buf
>  	/* For locking, see the comment in journal_submit_data_buffers() */
>  	spin_lock(&journal->j_list_lock);
>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
> -		jinode->i_flags |= JI_COMMIT_RUNNING;
> +		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>  		spin_unlock(&journal->j_list_lock);
>  		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
>  		if (err) {
> @@ -297,7 +300,8 @@ static int journal_finish_inode_data_buf
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
> --- linux-2.6/fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch	2010-07-14 13:46:17.000000000 -0500
> +++ linux-2.6-bjking1/fs/jbd2/journal.c	2010-07-14 13:46:17.000000000 -0500
> @@ -41,12 +41,14 @@
>  #include <linux/hash.h>
>  #include <linux/log2.h>
>  #include <linux/vmalloc.h>
> +#include <linux/bitops.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/jbd2.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
> +#include <asm/system.h>
>  
>  EXPORT_SYMBOL(jbd2_journal_start);
>  EXPORT_SYMBOL(jbd2_journal_restart);
> @@ -2209,9 +2211,10 @@ void jbd2_journal_release_jbd_inode(jour
>  restart:
>  	spin_lock(&journal->j_list_lock);
>  	/* Is commit writing out inode - we have to wait */
> -	if (jinode->i_flags & JI_COMMIT_RUNNING) {
> +	if (test_bit(__JI_COMMIT_RUNNING, &jinode->i_flags)) {
>  		wait_queue_head_t *wq;
>  		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
> +		smp_mb();
>  		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
>  		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
>  		spin_unlock(&journal->j_list_lock);
> _

Seems reasonable to me, I assume you re-tested with this patch to make sure it
still fixes the problem?  You can add

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
