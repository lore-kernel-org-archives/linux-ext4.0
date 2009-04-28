From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] ext4: Replace lock/unlock_super() with an explicit lock for the orphan list
Date: Tue, 28 Apr 2009 17:52:51 +0200
Message-ID: <20090428155250.GH21950@atrey.karlin.mff.cuni.cz>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu> <1240717765-16572-4-git-send-email-tytso@mit.edu> <1240717765-16572-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48758 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbZD1Pww (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 11:52:52 -0400
Content-Disposition: inline
In-Reply-To: <1240717765-16572-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> Use a separate lock to protect the orphan list, so we can stop
> overloading the use of lock_super().
  Yes, this was needed for a long time.

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4_sb.h |    1 +
>  fs/ext4/namei.c   |   20 +++++++++++---------
>  fs/ext4/super.c   |    1 +
>  3 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
> index 57b71fe..4bda2f7 100644
> --- a/fs/ext4/ext4_sb.h
> +++ b/fs/ext4/ext4_sb.h
> @@ -71,6 +71,7 @@ struct ext4_sb_info {
>  	struct inode *s_journal_inode;
>  	struct journal_s *s_journal;
>  	struct list_head s_orphan;
> +	struct mutex s_orphan_lock;
>  	unsigned long s_commit_interval;
>  	u32 s_max_batch_time;
>  	u32 s_min_batch_time;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 22098e1..8018e49 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1997,7 +1997,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	if (!ext4_handle_valid(handle))
>  		return 0;
>  
> -	lock_super(sb);
> +	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
>  	if (!list_empty(&EXT4_I(inode)->i_orphan))
>  		goto out_unlock;
>  
> @@ -2006,9 +2006,13 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  
>  	/* @@@ FIXME: Observation from aviro:
>  	 * I think I can trigger J_ASSERT in ext4_orphan_add().  We block
> -	 * here (on lock_super()), so race with ext4_link() which might bump
> +	 * here (on s_orphan_lock), so race with ext4_link() which might bump
>  	 * ->i_nlink. For, say it, character device. Not a regular file,
>  	 * not a directory, not a symlink and ->i_nlink > 0.
> +	 *
> +	 * tytso, 4/25/2009: I'm not sure how that could happen;
> +	 * shouldn't the fs core protect us from these sort of
> +	 * unlink()/link() races?
>  	 */
  We always call ext4_orphan_add() under i_mutex of the inode we are
adding (except for migrate code, well) and hence i_nlink should better
be stable... I'd just remove the comment.

>  	J_ASSERT((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
>  		  S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
> @@ -2045,7 +2049,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	jbd_debug(4, "orphan inode %lu will point to %d\n",
>  			inode->i_ino, NEXT_ORPHAN(inode));
>  out_unlock:
> -	unlock_super(sb);
> +	mutex_unlock(&EXT4_SB(sb)->s_orphan_lock);
>  	ext4_std_error(inode->i_sb, err);
>  	return err;
>  }
> @@ -2066,11 +2070,9 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  	if (!ext4_handle_valid(handle))
>  		return 0;
>  
> -	lock_super(inode->i_sb);
> -	if (list_empty(&ei->i_orphan)) {
> -		unlock_super(inode->i_sb);
> -		return 0;
> -	}
> +	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
> +	if (list_empty(&ei->i_orphan))
> +		goto out;
>  
>  	ino_next = NEXT_ORPHAN(inode);
>  	prev = ei->i_orphan.prev;
> @@ -2120,7 +2122,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  out_err:
>  	ext4_std_error(inode->i_sb, err);
>  out:
> -	unlock_super(inode->i_sb);
> +	mutex_unlock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
>  	return err;
>  
>  out_brelse:
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 176d43f..c23e82c 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2623,6 +2623,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->dq_op = &ext4_quota_operations;
>  #endif
>  	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
> +	mutex_init(&sbi->s_orphan_lock);
>  
>  	sb->s_root = NULL;
  Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
