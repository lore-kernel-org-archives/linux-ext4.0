From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/12] jbd2: revert "jbd2: add COW fields to struct
 jbd2_journal_handle"
Date: Mon, 11 Feb 2013 16:58:36 +0100
Message-ID: <20130211155836.GH5318@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab3BKP6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 10:58:39 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 16:53:42, Ted Tso wrote:
> This reverts commit 93737456d68ddcb86232f669b83da673dd12e351.
> 
> The cow-snapshots effort is no longer active, so remove these extra
> fields to shrink down the handle structure.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  include/linux/jbd2.h | 28 +++-------------------------
>  1 file changed, 3 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index e0aafc4..24db725 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -397,35 +397,13 @@ struct jbd2_journal_handle
>  	int			h_err;
>  
>  	/* Flags [no locking] */
> -	unsigned int	h_sync:1;	/* sync-on-close */
> -	unsigned int	h_jdata:1;	/* force data journaling */
> -	unsigned int	h_aborted:1;	/* fatal error on handle */
> -	unsigned int	h_cowing:1;	/* COWing block to snapshot */
> -
> -	/* Number of buffers requested by user:
> -	 * (before adding the COW credits factor) */
> -	unsigned int	h_base_credits:14;
> -
> -	/* Number of buffers the user is allowed to dirty:
> -	 * (counts only buffers dirtied when !h_cowing) */
> -	unsigned int	h_user_credits:14;
> -
> +	unsigned int	h_sync:		1;	/* sync-on-close */
> +	unsigned int	h_jdata:	1;	/* force data journaling */
> +	unsigned int	h_aborted:	1;	/* fatal error on handle */
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map	h_lockdep_map;
>  #endif
> -
> -#ifdef CONFIG_JBD2_DEBUG
> -	/* COW debugging counters: */
> -	unsigned int h_cow_moved; /* blocks moved to snapshot */
> -	unsigned int h_cow_copied; /* blocks copied to snapshot */
> -	unsigned int h_cow_ok_jh; /* blocks already COWed during current
> -				     transaction */
> -	unsigned int h_cow_ok_bitmap; /* blocks not set in COW bitmap */
> -	unsigned int h_cow_ok_mapped;/* blocks already mapped in snapshot */
> -	unsigned int h_cow_bitmaps; /* COW bitmaps created */
> -	unsigned int h_cow_excluded; /* blocks set in exclude bitmap */
> -#endif
>  };
>  
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
