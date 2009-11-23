From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/4] ext4: fix race chown vs truncate
Date: Mon, 23 Nov 2009 21:42:42 +0300
Message-ID: <87pr79xeu5.fsf@openvz.org>
References: <873a45ytwa.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:48721 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZKWSmi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 13:42:38 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KTK00D5ZS6P4B20@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 23 Nov 2009 21:47:16 +0300 (MSK)
In-reply-to: <873a45ytwa.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:
> To prevent ext4_reservation vs dquot_reservation inconsistency, we have
> to reorganize locking ordering like follows:
> i_block_reservation_lock > dqptr_sem
> This means what all functions which changes ext4 or quota reservation have
> to hold i_block_reservation_lock.
While investigating this issue i've considered other solution

* Introduce i_block analog for generic reserved space management:
We may introduce i_rsv_block field in generic inode, and protected
it by i_lock(similar to i_block).
Introduce inc/dec/set/get methods similar to inode_get_bytes,
inode_sub_bytes.. . 
This value is managed internally by quota code. Perform reservation
management inside dquot_reserve_space, dquot_release_reservation
without interfering with fs internals, as we do for i_blocks.
IMHO this is best way because:

1)We don't have to hold i_block_reservation_lock while quota-op
  which may lead to virtual performance penalty.
2)This brings to well defined VFS interface for reserved space management.

But I expect some problems from AlViro because only ext4 would use it by now.
And off course this may lead to ext4_rsv quot_rsv inconsistency
due to some bugs.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 84863e6..c521c93 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1047,16 +1047,23 @@ cleanup:
>  out:
>  	return err;
>  }
> +/*
> + * Quota_transfer callback.
> + * During quota transfer we have to transfer rsv-blocks from one dquot to
> + * another. inode must be protected from concurrent reservation/reclamation.
> + * Locking ordering for all space reservation code:
> + *  i_block_reservation_lock > dqptr_sem
> + * This is differ from i_block,i_lock locking ordering, but this is the
> + * only possible way.
> + * NOTE: Caller must hold i_block_reservation_lock.
> + */
>  
>  qsize_t ext4_get_reserved_space(struct inode *inode)
>  {
>  	unsigned long long total;
>  
> -	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	total = EXT4_I(inode)->i_reserved_data_blocks +
>  		EXT4_I(inode)->i_reserved_meta_blocks;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -
>  	return (total << inode->i_blkbits);
>  }
>  /*
> @@ -1131,6 +1138,8 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  	if (mdb_free)
>  		vfs_dq_release_reservation_block(inode, mdb_free);
>  
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
>  	/*
>  	 * If we have done all the pending block allocations and if
>  	 * there aren't any writers on the inode, we can discard the
> @@ -1866,8 +1875,8 @@ repeat:
>  	}
>  
>  	if (ext4_claim_free_blocks(sbi, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		vfs_dq_release_reservation_block(inode, total);
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
>  			goto repeat;
> @@ -1924,9 +1933,9 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
>  
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
>  	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  
>  	vfs_dq_release_reservation_block(inode, release);
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
>  
>  static void ext4_da_page_release_reservation(struct page *page,
> @@ -5436,7 +5445,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  			error = PTR_ERR(handle);
>  			goto err_out;
>  		}
> +		/* i_block_reservation must being held in order to avoid races
> +		 * with concurent block reservation. */
> +		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  		error = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		if (error) {
>  			ext4_journal_stop(handle);
>  			return error;
