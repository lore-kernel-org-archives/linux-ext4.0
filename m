From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Do not reserve clusters when fs doesn't support
 extents
Date: Fri, 29 Nov 2013 13:01:36 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1311291300500.2088@localhost.localdomain>
References: <1385638965-14674-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab3K2MBq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Nov 2013 07:01:46 -0500
In-Reply-To: <1385638965-14674-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 28 Nov 2013, Jan Kara wrote:

> Date: Thu, 28 Nov 2013 12:42:45 +0100
> From: Jan Kara <jack@suse.cz>
> To: Ted Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
>     Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH] ext4: Do not reserve clusters when fs doesn't support extents
> 
> When filesystem doesn't support extents (like in ext2/3 compatibility
> modes), there is no need to reserve any clusters. Space estimates for
> writing are exact, hole punching doesn't need new metadata, and there
> are no unwritten extents to convert.
> 
> This fixes a problem when filesystem still having some free space when
> accessed with a native ext2/3 driver suddently reports ENOSPC when
> accessed with ext4 driver.

Right, I forgot about that. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c977f4e4e63b..0561713cd6d8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3316,11 +3316,19 @@ int ext4_calculate_overhead(struct super_block *sb)
>  }
>  
>  
> -static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
> +static ext4_fsblk_t ext4_calculate_resv_clusters(struct super_block *sb)
>  {
>  	ext4_fsblk_t resv_clusters;
>  
>  	/*
> +	 * There's no need to reserve anything when we aren't using extents.
> +	 * The space estimates are exact, there are no unwritten extents,
> +	 * hole punching doesn't need new metadata... This is needed especially
> +	 * to keep ext2/3 backward compatibility.
> +	 */
> +	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
> +		return 0;
> +	/*
>  	 * By default we reserve 2% or 4096 clusters, whichever is smaller.
>  	 * This should cover the situations where we can not afford to run
>  	 * out of space like for example punch hole, or converting
> @@ -3328,7 +3336,8 @@ static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
>  	 * allocation would require 1, or 2 blocks, higher numbers are
>  	 * very rare.
>  	 */
> -	resv_clusters = ext4_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
> +	resv_clusters = ext4_blocks_count(EXT4_SB(sb)->s_es) >>
> +			EXT4_SB(sb)->s_cluster_bits;
>  
>  	do_div(resv_clusters, 50);
>  	resv_clusters = min_t(ext4_fsblk_t, resv_clusters, 4096);
> @@ -4071,10 +4080,10 @@ no_journal:
>  			 "available");
>  	}
>  
> -	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sbi));
> +	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sb));
>  	if (err) {
>  		ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
> -			 "reserved pool", ext4_calculate_resv_clusters(sbi));
> +			 "reserved pool", ext4_calculate_resv_clusters(sb));
>  		goto failed_mount4a;
>  	}
>  
> 
