From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 20 May 2014 02:33:23 -0600
Message-ID: <537B1353.8060704@hp.com>
References: <1400185026-3972-1-git-send-email-jack@suse.cz> <1400185026-3972-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:58047 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaETIfr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2014 04:35:47 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id C9EF860353
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2014 08:35:45 +0000 (UTC)
In-Reply-To: <1400185026-3972-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please see my one comment below.

BTW, I've run aim7 on your before I notice what I commented below.  There are workloads that my patch outperform yours and vice versa.  I will have to redo it over again.

On 05/15/2014 02:17 PM, Jan Kara wrote:
> Shuffle code around in ext4_orphan_add() and ext4_orphan_del() so that
> we avoid taking global s_orphan_lock in some cases and hold it for
> shorter time in other cases.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/namei.c | 109 +++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 65 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 5fcaa85b6dc5..0486fbafb808 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2539,13 +2539,17 @@ static int empty_dir(struct inode *inode)
>  	return 1;
>  }
>  
> -/* ext4_orphan_add() links an unlinked or truncated inode into a list of
> +/*
> + * ext4_orphan_add() links an unlinked or truncated inode into a list of
>   * such inodes, starting at the superblock, in case we crash before the
>   * file is closed/deleted, or in case the inode truncate spans multiple
>   * transactions and the last transaction is not recovered after a crash.
>   *
>   * At filesystem recovery time, we walk this list deleting unlinked
>   * inodes and truncating linked inodes in ext4_orphan_cleanup().
> + *
> + * Orphan list manipulation functions must be called under i_mutex unless
> + * we are just creating the inode or deleting it.
>   */
>  int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  {
> @@ -2553,13 +2557,19 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_iloc iloc;
>  	int err = 0, rc;
> +	bool dirty = false;
>  
>  	if (!sbi->s_journal)
>  		return 0;
>  
> -	mutex_lock(&sbi->s_orphan_lock);
> +	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
> +		     !mutex_is_locked(&inode->i_mutex));
> +	/*
> +	 * Exit early if inode already is on orphan list. This is a big speedup
> +	 * since we don't have to contend on the global s_orphan_lock.
> +	 */
>  	if (!list_empty(&EXT4_I(inode)->i_orphan))
> -		goto out_unlock;
> +		return 0;
>  
>  	/*
>  	 * Orphan handling is only valid for files with data blocks
> @@ -2573,44 +2583,47 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
>  	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
>  	if (err)
> -		goto out_unlock;
> +		goto out;
>  
>  	err = ext4_reserve_inode_write(handle, inode, &iloc);
>  	if (err)
> -		goto out_unlock;
> +		goto out;
> +
> +	mutex_lock(&sbi->s_orphan_lock);
>  	/*
>  	 * Due to previous errors inode may be already a part of on-disk
>  	 * orphan list. If so skip on-disk list modification.
>  	 */
> -	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
> -		(le32_to_cpu(sbi->s_es->s_inodes_count)))
> -			goto mem_insert;
> -
> -	/* Insert this inode at the head of the on-disk orphan list... */
> -	NEXT_ORPHAN(inode) = le32_to_cpu(sbi->s_es->s_last_orphan);
> -	sbi->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
> -	err = ext4_handle_dirty_super(handle, sb);
> -	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
> -	if (!err)
> -		err = rc;
> -
> -	/* Only add to the head of the in-memory list if all the
> -	 * previous operations succeeded.  If the orphan_add is going to
> -	 * fail (possibly taking the journal offline), we can't risk
> -	 * leaving the inode on the orphan list: stray orphan-list
> -	 * entries can cause panics at unmount time.
> -	 *
> -	 * This is safe: on error we're going to ignore the orphan list
> -	 * anyway on the next recovery. */
> -mem_insert:
> -	if (!err)
> -		list_add(&EXT4_I(inode)->i_orphan, &sbi->s_orphan);
> +	if (!NEXT_ORPHAN(inode) || NEXT_ORPHAN(inode) >
> +	    (le32_to_cpu(sbi->s_es->s_inodes_count))) {
> +		/* Insert this inode at the head of the on-disk orphan list */
> +		NEXT_ORPHAN(inode) = le32_to_cpu(sbi->s_es->s_last_orphan);
> +		sbi->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
> +		dirty = true;
> +	}
> +	list_add(&EXT4_I(inode)->i_orphan, &sbi->s_orphan);
> +	mutex_unlock(&sbi->s_orphan_lock);
>  
> +	if (dirty) {
> +		err = ext4_handle_dirty_super(handle, sb);
> +		rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
> +		if (!err)
> +			err = rc;
> +		if (err) {
> +			/*
> +			 * We have to remove inode from in-memory list if
> + 			 * addition to on disk orphan list failed. Stray orphan
> +			 * list entries can cause panics at unmount time.
> +			 */
> +			mutex_lock(&sbi->s_orphan_lock);
> +			list_del(&EXT4_I(inode)->i_orphan);
> +			mutex_unlock(&sbi->s_orphan_lock);
> +		}
> +	}
>  	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
>  	jbd_debug(4, "orphan inode %lu will point to %d\n",
>  			inode->i_ino, NEXT_ORPHAN(inode));
> -out_unlock:
> -	mutex_unlock(&sbi->s_orphan_lock);
> +out:
>  	ext4_std_error(sb, err);
>  	return err;
>  }
> @@ -2631,13 +2644,18 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
>  		return 0;
>  
> -	mutex_lock(&sbi->s_orphan_lock);
> +	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
> +		     !mutex_is_locked(&inode->i_mutex));
> +	/* Do this quick check before taking global s_orphan_lock. */
>  	if (list_empty(&ei->i_orphan))
> -		goto out;
> +		return 0;
>  
> -	ino_next = NEXT_ORPHAN(inode);
> -	prev = ei->i_orphan.prev;
> +	if (handle) {
> +		/* Grab inode buffer early before taking global s_orphan_lock */
> +		err = ext4_reserve_inode_write(handle, inode, &iloc);
> +	}
>  
> +	mutex_lock(&sbi->s_orphan_lock);
>  	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
> 

Should set prev = ei->i_orphan.prev; here, instead of down below where it has already been removed from the list.

Thanks,
Mak.
 
>  	list_del_init(&ei->i_orphan);
> @@ -2646,20 +2664,23 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  	 * transaction handle with which to update the orphan list on
>  	 * disk, but we still need to remove the inode from the linked
>  	 * list in memory. */
> -	if (!handle)
> -		goto out;
> -
> -	err = ext4_reserve_inode_write(handle, inode, &iloc);
> -	if (err)
> +	if (!handle || err) {
> +		mutex_unlock(&sbi->s_orphan_lock);
>  		goto out_err;
> +	}
>  
> +	ino_next = NEXT_ORPHAN(inode);
> +	prev = ei->i_orphan.prev;

