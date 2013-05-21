From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: Avoid unnecessarily writing back dirty pages
 before  hole punching
Date: Tue, 21 May 2013 11:22:33 +0200
Message-ID: <20130521092233.GA10180@quack.suse.cz>
References: <20130517032328.GA14249@gmail.com>
 <1369040675-7347-1-git-send-email-liwang@ubuntukylin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org,
	Yunchuan Wen <yunchuanwen@ubuntukylin.com>
To: Li Wang <liwang@ubuntukylin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1369040675-7347-1-git-send-email-liwang@ubuntukylin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 20-05-13 17:04:35, Li Wang wrote:
> For hole punching, currently ext4 will synchronously write back the
> dirty pages fit into the hole, since the data on the disk responding
> to those pages are to be deleted, it is benefical to directly release
> those pages, no matter they are dirty or not, except the ordered case.
> 
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> Reviewed-by: Zheng Liu <gnehzuil.liu@gmail.com>
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
  Currently there's no easy way to stop mmap writer. When I eventually get
to implementing the mapping range lock, it will be used exactly for that.

>   BTW, I have one other question to confirm regarding the ext4 journal mode:
> what is the advantage of data=ordered journal mode compared to data=writeback?
> For overwriting write, it still may lead to the inconsistence between data and
> metadata, that is, data is new and metadata is old. So its standpoint is
> that it beats data=writeback in appending write?
  The advantage of data=ordered mode is that in case of a system crash /
power failure, you are guaranteed that only data sometimes written to a
file is visible there - i.e., you will not ever expose uninitialized blocks
to user (which is a security concern on multiuser systems as those
uninitialized blocks can contain old versions of /etc/shadow or other
sensitive data).

								Honza

> ---
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
  I somewhat dislike the naming of the functions - especially 'fallocate'
seems a bit misleading as it's really about hole punching. So maybe we
could call the functions like:
  ext4_begin_ordered_punch_hole()
and
  jbd2_journal_begin_ordered_punch_hole()?

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
  I don't see a need for this internal function - it is exactly the same as
the external one (jbd2_journal_begin_ordered_punch_hole()).

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
  You can make this function inline and declare it in jbd2.h header file...

									Honza

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
