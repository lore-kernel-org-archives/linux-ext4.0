From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/3] ext4: Return error code from ext4_mb_good_group()
Date: Tue, 2 Jun 2015 09:27:18 -0700
Message-ID: <20150602162718.GA10167@birch.djwong.org>
References: <1433247890-15570-1-git-send-email-lczerner@redhat.com>
 <1433247890-15570-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49294 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbbFBQ1W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jun 2015 12:27:22 -0400
Content-Disposition: inline
In-Reply-To: <1433247890-15570-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 02, 2015 at 02:24:50PM +0200, Lukas Czerner wrote:
> Currently ext4_mb_good_group() only returns 0 or 1 depending on whether
> the allocation group is suitable for use or not. However we might get
> various errors and fail while initializing new group including -EIO
> which would never get propagated up the call chain. This might lead to
> an endless loop at writeback when we're trying to find a good group to
> allocate from and we fail to initialize new group (read error for
> example).
> 
> Fix this by returning proper error code from ext4_mb_good_group() and
> using it in ext4_mb_regular_allocator(). In ext4_mb_regular_allocator()
> we will always return only the first occurred error from
> ext4_mb_good_group() and we only propagate it back  to the caller if we
> do not get any other errors and we fail to allocate any blocks.
> 
> Note that with other modes than errors=continue, we will fail
> immediately in ext4_mb_good_group() in case of error, however with
> errors=continue we should try to continue using the file system, that's
> why we're not going to fail immediately when we see an error from
> ext4_mb_good_group(), but rather when we fail to find a suitable block
> group to allocate from due to an problem in group initialization.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: nothing changed
> 
>  fs/ext4/mballoc.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index df02951..e0e77a7 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2034,7 +2034,7 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,

I'd prefer a comment clarifying the possible return values.  Otherwise,
everything (patches 1-3) looks ok to me.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

>  	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
>  		int ret = ext4_mb_init_group(ac->ac_sb, group);
>  		if (ret)
> -			return 0;
> +			return ret;
>  	}
>  
>  	fragments = grp->bb_fragments;
> @@ -2081,7 +2081,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  {
>  	ext4_group_t ngroups, group, i;
>  	int cr;
> -	int err = 0;
> +	int err = 0, first_err = 0;
>  	struct ext4_sb_info *sbi;
>  	struct super_block *sb;
>  	struct ext4_buddy e4b;
> @@ -2148,6 +2148,7 @@ repeat:
>  		group = ac->ac_g_ex.fe_group;
>  
>  		for (i = 0; i < ngroups; group++, i++) {
> +			int ret = 0;
>  			cond_resched();
>  			/*
>  			 * Artificially restricted ngroups for non-extent
> @@ -2157,8 +2158,12 @@ repeat:
>  				group = 0;
>  
>  			/* This now checks without needing the buddy page */
> -			if (!ext4_mb_good_group(ac, group, cr))
> +			ret = ext4_mb_good_group(ac, group, cr);
> +			if (ret <= 0) {
> +				if (!first_err)
> +					first_err = ret;
>  				continue;
> +			}
>  
>  			err = ext4_mb_load_buddy(sb, group, &e4b);
>  			if (err)
> @@ -2170,9 +2175,12 @@ repeat:
>  			 * We need to check again after locking the
>  			 * block group
>  			 */
> -			if (!ext4_mb_good_group(ac, group, cr)) {
> +			ret = ext4_mb_good_group(ac, group, cr);
> +			if (ret <= 0) {
>  				ext4_unlock_group(sb, group);
>  				ext4_mb_unload_buddy(&e4b);
> +				if (!first_err)
> +					first_err = ret;
>  				continue;
>  			}
>  
> @@ -2219,6 +2227,8 @@ repeat:
>  		}
>  	}
>  out:
> +	if (!err && ac->ac_status != AC_STATUS_FOUND && first_err)
> +		err = first_err;
>  	return err;
>  }
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
