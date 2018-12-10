Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbeLJNpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 08:45:12 -0500
Date: Mon, 10 Dec 2018 14:45:08 +0100
From: Jan Kara <jack@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz,
        linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com,
        amir73il@gmail.com, jmorris@namei.org, jlayton@kernel.org,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH v2] fs: Convert open-coded "is inode open for write" check
Message-ID: <20181210134508.GK29289@quack2.suse.cz>
References: <20181210131903.4528-1-nborisov@suse.com>
 <20181210132500.10864-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210132500.10864-1-nborisov@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 10-12-18 15:25:00, Nikolay Borisov wrote:
> There is a generic helper inode_is_open_for_write that could be used
> when checking i_writecount. Use it instead of opencoding
> if (i_writecount > 0) check.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Changes v2: 
>  * This time actually compile-tested it, doh...

You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

for the fanotify and ext4 bits. But I think you may have better chances of
getting this applied if you split the patch by subsystem - i.e., ext4,
fanotify, security, locks - and let each maintainer merge the patch on his
own...

								Honza

> 
> 
>  fs/ext4/inode.c                    | 2 +-
>  fs/ext4/mballoc.c                  | 7 +++----
>  fs/locks.c                         | 2 +-
>  fs/notify/fanotify/fanotify_user.c | 2 +-
>  security/integrity/ima/ima_main.c  | 2 +-
>  5 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a9d8159720..04e5bc0b5c8d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -391,7 +391,7 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  	 * inode's preallocations.
>  	 */
>  	if ((ei->i_reserved_data_blocks == 0) &&
> -	    (atomic_read(&inode->i_writecount) == 0))
> +	    !inode_is_open_for_write(inode))
>  		ext4_discard_preallocations(inode);
>  }
>  
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2248083cdca..b811a9cb896e 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4176,9 +4176,8 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
>  	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
>  		>> bsbits;
>  
> -	if ((size == isize) &&
> -	    !ext4_fs_is_busy(sbi) &&
> -	    (atomic_read(&ac->ac_inode->i_writecount) == 0)) {
> +	if ((size == isize) && !ext4_fs_is_busy(sbi)
> +	    && !inode_is_open_for_write(ac->ac_inode)) {
>  		ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
>  		return;
>  	}
> @@ -4258,7 +4257,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
>  			(unsigned) ar->goal, ac->ac_flags, ac->ac_2order,
>  			(unsigned) ar->lleft, (unsigned) ar->pleft,
>  			(unsigned) ar->lright, (unsigned) ar->pright,
> -			atomic_read(&ar->inode->i_writecount) ? "" : "non-");
> +			inode_is_open_for_write(ar->inode) ? "" : "non-");
>  	return 0;
>  
>  }
> diff --git a/fs/locks.c b/fs/locks.c
> index 2ecb4db8c840..16ea7d89a67d 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1646,7 +1646,7 @@ check_conflicting_open(const struct dentry *dentry, const long arg, int flags)
>  	if (flags & FL_LAYOUT)
>  		return 0;
>  
> -	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> +	if ((arg == F_RDLCK) && inode_is_open_for_write(inode))
>  		return -EAGAIN;
>  
>  	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index e03be5071362..98b0769e4cf2 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -669,7 +669,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
>  	 */
>  	if ((flags & FAN_MARK_IGNORED_MASK) &&
>  	    !(flags & FAN_MARK_IGNORED_SURV_MODIFY) &&
> -	    (atomic_read(&inode->i_writecount) > 0))
> +	    inode_is_open_for_write(inode))
>  		return 0;
>  
>  	return fanotify_add_mark(group, &inode->i_fsnotify_marks,
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 1b88d58e1325..05fbf8a2fa42 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -103,7 +103,7 @@ static void ima_rdwr_violation_check(struct file *file,
>  	} else {
>  		if (must_measure)
>  			set_bit(IMA_MUST_MEASURE, &iint->atomic_flags);
> -		if ((atomic_read(&inode->i_writecount) > 0) && must_measure)
> +		if (inode_is_open_for_write(inode) && must_measure)
>  			send_writers = true;
>  	}
>  
> -- 
> 2.17.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
