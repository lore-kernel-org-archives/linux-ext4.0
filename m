From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Avoid unnecessarily writing back dirty pages
 before hole punching
Date: Mon, 27 May 2013 16:47:27 +0200
Message-ID: <20130527144727.GA3877@quack.suse.cz>
References: <20130521092233.GA10180@quack.suse.cz>
 <1369664736-9045-1-git-send-email-liwang@ubuntukylin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org,
	Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
	Jan Kara <jack@suse.cz>
To: Li Wang <liwang@ubuntukylin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1369664736-9045-1-git-send-email-liwang@ubuntukylin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 27-05-13 22:25:36, Li Wang wrote:
> For hole punching, currently ext4 will synchronously write back the
> dirty pages fit into the hole, since the data on the disk responding
> to those pages are to be deleted, it is benefical to directly release
> those pages, no matter they are dirty or not, except the ordered case.
> 
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> Cc: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: Jan Kara <jack@suse.cz>
  The patch looks good to me except for one nitpick below. Feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -2305,29 +2305,10 @@ done:
>  	return 0;
>  }
>  
> -/*
> - * File truncate and transaction commit interact with each other in a
> - * non-trivial way.  If a transaction writing data block A is
> - * committing, we cannot discard the data by truncate until we have
> - * written them.  Otherwise if we crashed after the transaction with
> - * write has committed but before the transaction with truncate has
> - * committed, we could see stale data in block A.  This function is a
> - * helper to solve this problem.  It starts writeout of the truncated
> - * part in case it is in the committing transaction.
> - *
> - * Filesystem code must call this function when inode is journaled in
> - * ordered mode before truncation happens and after the inode has been
> - * placed on orphan list with the new inode size. The second condition
> - * avoids the race that someone writes new data and we start
> - * committing the transaction after this function has been called but
> - * before a transaction for truncate is started (and furthermore it
> - * allows us to optimize the case where the addition to orphan list
> - * happens in the same transaction as write --- we don't have to write
> - * any data in such case).
> - */
> -int jbd2_journal_begin_ordered_truncate(journal_t *journal,
> +
> +int jbd2_journal_begin_ordered_discard(journal_t *journal,
>  					struct jbd2_inode *jinode,
> -					loff_t new_size)
> +					loff_t start, loff_t end)
  Why don't you call this function jbd2_journal_begin_ordered_punch_hole()?
They are the same (well, except the end vs length difference but that seems
minor).

								Honza

>  {
>  	transaction_t *inode_trans, *commit_trans;
>  	int ret = 0;
> @@ -2346,10 +2327,12 @@ int jbd2_journal_begin_ordered_truncate(journal_t *journal,
>  	spin_unlock(&journal->j_list_lock);
>  	if (inode_trans == commit_trans) {
>  		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
> -			new_size, LLONG_MAX);
> +			start, end);
>  		if (ret)
>  			jbd2_journal_abort(journal, ret);
>  	}
>  out:
>  	return ret;
>  }
> +
> +
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 6e051f4..9543a5a 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1126,12 +1126,49 @@ extern int	   jbd2_journal_clear_err  (journal_t *);
>  extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
>  extern int	   jbd2_journal_force_commit(journal_t *);
>  extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
> -extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
> -				struct jbd2_inode *inode, loff_t new_size);
> +extern int	   jbd2_journal_begin_ordered_discard(journal_t *,
> +					struct jbd2_inode *,
> +					loff_t, loff_t);
>  extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
>  extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
>  
>  /*
> + * File truncate and transaction commit interact with each other in a
> + * non-trivial way.  If a transaction writing data block A is
> + * committing, we cannot discard the data by truncate until we have
> + * written them.  Otherwise if we crashed after the transaction with
> + * write has committed but before the transaction with truncate has
> + * committed, we could see stale data in block A.  This function is a
> + * helper to solve this problem.  It starts writeout of the truncated
> + * part in case it is in the committing transaction.
> + *
> + * Filesystem code must call this function when inode is journaled in
> + * ordered mode before truncation happens and after the inode has been
> + * placed on orphan list with the new inode size. The second condition
> + * avoids the race that someone writes new data and we start
> + * committing the transaction after this function has been called but
> + * before a transaction for truncate is started (and furthermore it
> + * allows us to optimize the case where the addition to orphan list
> + * happens in the same transaction as write --- we don't have to write
> + * any data in such case).
> + */
> +static inline int jbd2_journal_begin_ordered_truncate(journal_t *journal,
> +					struct jbd2_inode *jinode,
> +					loff_t new_size)
> +{
> +	return jbd2_journal_begin_ordered_discard(journal, jinode,
> +						  new_size, LLONG_MAX);
> +}
> +
> +static inline int jbd2_journal_begin_ordered_punch_hole(journal_t *journal,
> +					struct jbd2_inode *jinode,
> +					loff_t start, loff_t length)
> +{
> +	return jbd2_journal_begin_ordered_discard(journal, jinode,
> +						  start, start + length - 1);
> +}
> +
> +/*
>   * journal_head management
>   */
>  struct journal_head *jbd2_journal_add_journal_head(struct buffer_head *bh);
> -- 
> 1.7.9.5
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
