From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] ext4: Avoid unnecessarily writing back dirty pages
 before hole punching
Date: Tue, 21 May 2013 11:50:18 +0800
Message-ID: <20130521035018.GB23907@gmail.com>
References: <20130517032328.GA14249@gmail.com>
 <1369040675-7347-1-git-send-email-liwang@ubuntukylin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-kernel@vger.kernel.org,
	Yunchuan Wen <yunchuanwen@ubuntukylin.com>
To: Li Wang <liwang@ubuntukylin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1369040675-7347-1-git-send-email-liwang@ubuntukylin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 20, 2013 at 05:04:35PM +0800, Li Wang wrote:
> For hole punching, currently ext4 will synchronously write back the
> dirty pages fit into the hole, since the data on the disk responding
> to those pages are to be deleted, it is benefical to directly release
> those pages, no matter they are dirty or not, except the ordered case.
> 
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> Reviewed-by: Zheng Liu <gnehzuil.liu@gmail.com>

FWIW, you could Cc me but you couldn't add 'Reviewed-by' here because in
first version I give a comment to you, and I don't think the patch looks
good to me at that time.  So please do not add 'Reviewed-by'.  I paste a
description about 'Reviewed-by' from Documentation/SubmittingPatches for
you information:

Reviewed-by:, instead, indicates that the patch has been reviewed and found
acceptable according to the Reviewer's Statement:

	Reviewer's statement of oversight

	By offering my Reviewed-by: tag, I state that:

 	 (a) I have carried out a technical review of this patch to
	     evaluate its appropriateness and readiness for inclusion into
	     the mainline kernel.

	 (b) Any problems, concerns, or questions relating to the patch
	     have been communicated back to the submitter.  I am satisfied
	     with the submitter's response to my comments.

	 (c) While there may be things that could be improved with this
	     submission, I believe that it is, at this time, (1) a
	     worthwhile modification to the kernel, and (2) free of known
	     issues which would argue against its inclusion.

	 (d) While I have reviewed the patch and believe it to be sound, I
	     do not (unless explicitly stated elsewhere) make any
	     warranties or guarantees that it will achieve its stated
	     purpose or function properly in any given situation.

A Reviewed-by tag is a statement of opinion that the patch is an
appropriate modification of the kernel without any remaining serious
technical issues.  Any interested reviewer (who has done the work) can
offer a Reviewed-by tag for a patch.  This tag serves to give credit to
reviewers and to inform maintainers of the degree of review which has been
done on the patch.  Reviewed-by: tags, when supplied by reviewers known to
understand the subject area and to perform thorough reviews, will normally
increase the likelihood of your patch getting into the kernel.

Otherwise the patch looks good to me.  You can add:
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

:-)

> Cc: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> Hi Zheng,
>   Thanks for your comments.
>   This is the revised version with the operation of writting back moved
> down after the inode mutex held. But there is one thing I wanna confirm
> is that whether the inode mutex could prevent the mmap() writer? I did
> not take a careful look at the mmap() code, the straightforward thinking
> is that mmap() write will directly dirty the pages without going through 
> the VFS generic_file_write() path.

As far as I understand, you are right.  We couldn't avoid this race
condition with punching hole.  Please correct me if I miss something.

>   BTW, I have one other question to confirm regarding the ext4 journal mode:
> what is the advantage of data=ordered journal mode compared to data=writeback?

'data=ordered' mode means that when we try to commit metadata, we must
make sure that related data has been written out on disk, but
'data=writeback' mode doesn't guarantee this.  So when we got a power
failure, we could read stale data with 'data=writeback' mode.

> For overwriting write, it still may lead to the inconsistence between data and
> metadata, that is, data is new and metadata is old.

No, a overwriting write means that metadata has been allocated.  So we
don't need to allocate some blocks for these data.  That means that we
don't need to worry about the corrupted metadata.

>So its standpoint is
> that it beats data=writeback in appending write?

> ---

One tip: you can write your question here in a patch.  When maintainer
apply your patch, your question will be ignored automatically.
Otherwise maintainer will change your commit log manually.

Regards,
                                                - Zheng

>  fs/ext4/inode.c       |   27 +++++++++++++---------
>  fs/jbd2/journal.c     |    1 +
>  fs/jbd2/transaction.c |   61 +++++++++++++++++++++++++++++++------------------
>  include/linux/jbd2.h  |    3 +++
>  4 files changed, 59 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d6382b8..568b0bd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3569,6 +3569,16 @@ int ext4_can_truncate(struct inode *inode)
>  	return 0;
>  }
>  
> +static inline int ext4_begin_ordered_fallocate(struct inode *inode,
> +					       loff_t start, loff_t length)
> +{
> +	if (!EXT4_I(inode)->jinode)
> +		return 0;
> +	return jbd2_journal_begin_ordered_fallocate(EXT4_JOURNAL(inode),
> +						    EXT4_I(inode)->jinode,
> +						    start, length);
> +}
> +
>  /*
>   * ext4_punch_hole: punches a hole in a file by releaseing the blocks
>   * associated with the given offset and length
> @@ -3602,17 +3612,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  
>  	trace_ext4_punch_hole(inode, offset, length);
>  
> -	/*
> -	 * Write out all dirty pages to avoid race conditions
> -	 * Then release them.
> -	 */
> -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> -		ret = filemap_write_and_wait_range(mapping, offset,
> -						   offset + length - 1);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	mutex_lock(&inode->i_mutex);
>  	/* It's not possible punch hole on append only file */
>  	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
> @@ -3644,6 +3643,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	first_page_offset = first_page << PAGE_CACHE_SHIFT;
>  	last_page_offset = last_page << PAGE_CACHE_SHIFT;
>  
> +	if (ext4_should_order_data(inode)) {
> +		ret = ext4_begin_ordered_fallocate(inode, offset, length);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* Now release the pages */
>  	if (last_page_offset > first_page_offset) {
>  		truncate_pagecache_range(inode, first_page_offset,
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 9545757..ccc483a 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -98,6 +98,7 @@ EXPORT_SYMBOL(jbd2_journal_file_inode);
>  EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
>  EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
>  EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
> +EXPORT_SYMBOL(jbd2_journal_begin_ordered_fallocate);
>  EXPORT_SYMBOL(jbd2_inode_cache);
>  
>  static void __journal_abort_soft (journal_t *journal, int errno);
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 10f524c..035c064 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -2305,6 +2305,36 @@ done:
>  	return 0;
>  }
>  
> +
> +static int jbd2_journal_begin_ordered_discard(journal_t *journal,
> +					struct jbd2_inode *jinode,
> +					loff_t start, loff_t end)
> +{
> +	transaction_t *inode_trans, *commit_trans;
> +	int ret = 0;
> +
> +	/* This is a quick check to avoid locking if not necessary */
> +	if (!jinode->i_transaction)
> +		goto out;
> +	/* Locks are here just to force reading of recent values, it is
> +	 * enough that the transaction was not committing before we started
> +	 * a transaction adding the inode to orphan list */
> +	read_lock(&journal->j_state_lock);
> +	commit_trans = journal->j_committing_transaction;
> +	read_unlock(&journal->j_state_lock);
> +	spin_lock(&journal->j_list_lock);
> +	inode_trans = jinode->i_transaction;
> +	spin_unlock(&journal->j_list_lock);
> +	if (inode_trans == commit_trans) {
> +		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
> +			start, end);
> +		if (ret)
> +			jbd2_journal_abort(journal, ret);
> +	}
> +out:
> +	return ret;
> +}
> +
>  /*
>   * File truncate and transaction commit interact with each other in a
>   * non-trivial way.  If a transaction writing data block A is
> @@ -2329,27 +2359,14 @@ int jbd2_journal_begin_ordered_truncate(journal_t *journal,
>  					struct jbd2_inode *jinode,
>  					loff_t new_size)
>  {
> -	transaction_t *inode_trans, *commit_trans;
> -	int ret = 0;
> +	return jbd2_journal_begin_ordered_discard(journal, jinode,
> +						  new_size, LLONG_MAX);
> +}
>  
> -	/* This is a quick check to avoid locking if not necessary */
> -	if (!jinode->i_transaction)
> -		goto out;
> -	/* Locks are here just to force reading of recent values, it is
> -	 * enough that the transaction was not committing before we started
> -	 * a transaction adding the inode to orphan list */
> -	read_lock(&journal->j_state_lock);
> -	commit_trans = journal->j_committing_transaction;
> -	read_unlock(&journal->j_state_lock);
> -	spin_lock(&journal->j_list_lock);
> -	inode_trans = jinode->i_transaction;
> -	spin_unlock(&journal->j_list_lock);
> -	if (inode_trans == commit_trans) {
> -		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
> -			new_size, LLONG_MAX);
> -		if (ret)
> -			jbd2_journal_abort(journal, ret);
> -	}
> -out:
> -	return ret;
> +int jbd2_journal_begin_ordered_fallocate(journal_t *journal,
> +					struct jbd2_inode *jinode,
> +					loff_t start, loff_t length)
> +{
> +	return jbd2_journal_begin_ordered_discard(journal, jinode,
> +						  start, start + length - 1);
>  }
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 6e051f4..6c63c5e 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1128,6 +1128,9 @@ extern int	   jbd2_journal_force_commit(journal_t *);
>  extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
>  extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
>  				struct jbd2_inode *inode, loff_t new_size);
> +extern int	   jbd2_journal_begin_ordered_fallocate(journal_t *journal,
> +				struct jbd2_inode *inode, loff_t start,
> +				loff_t length);
>  extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
>  extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
>  
> -- 
> 1.7.9.5
> 
> 
