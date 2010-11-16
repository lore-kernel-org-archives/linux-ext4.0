From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Tue, 16 Nov 2010 14:01:46 +0100
Message-ID: <20101116130146.GG4757@quack.suse.cz>
References: <20101116110058.GA4298@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101116110058.GA4298@amd>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 16-11-10 22:00:58, Nick Piggin wrote:
> I saw a lock order warning on ext4 trigger. This should solve it.
> Raciness shouldn't matter much, because writeback can stop just
> after we make the test and return anyway (so the API is racy anyway).
  Hmm, for now the fix is OK. Ultimately, we probably want to call
writeback_inodes_sb() directly from all the callers. They all just want to
reduce uncertainty of delayed allocation reservations by writing delayed
data and actually wait for some of the writeback to happen before they
retry again the allocation.

Although the callers generally cannot get umount_sem because they hold
other locks, they have the superblock well pinned so grabbing umount_sem
makes sense mostly to make assertions happy. But as I'm thinking about it,
trylock *is* maybe the right answer to this anyway...

So
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c	2010-11-16 21:44:32.000000000 +1100
> +++ linux-2.6/fs/fs-writeback.c	2010-11-16 21:49:37.000000000 +1100
> @@ -1125,16 +1125,20 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
> + *
> + * May be called inside i_lock. May not start writeback if locks cannot
> + * be acquired.
>   */
>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb(sb);
> -		up_read(&sb->s_umount);
> -		return 1;
> -	} else
> -		return 0;
> +		if (down_read_trylock(&sb->s_umount)) {
> +			writeback_inodes_sb(sb);
> +			up_read(&sb->s_umount);
> +			return 1;
> +		}
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
>  
> @@ -1145,17 +1149,21 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idl
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
> + *
> + * May be called inside i_lock. May not start writeback if locks cannot
> + * be acquired.
>   */
>  int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>  				   unsigned long nr)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb_nr(sb, nr);
> -		up_read(&sb->s_umount);
> -		return 1;
> -	} else
> -		return 0;
> +		if (down_read_trylock(&sb->s_umount)) {
> +			writeback_inodes_sb_nr(sb, nr);
> +			up_read(&sb->s_umount);
> +			return 1;
> +		}
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
