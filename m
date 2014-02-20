From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] patch add-ext4_es_store_pblock_status
Date: Wed, 19 Feb 2014 16:42:14 -0800
Message-ID: <20140220004214.GK9176@birch.djwong.org>
References: <1392856717-20201-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38031 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBTAmU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Feb 2014 19:42:20 -0500
Content-Disposition: inline
In-Reply-To: <1392856717-20201-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 19, 2014 at 07:38:37PM -0500, Theodore Ts'o wrote:
> ---

A changelog would be helpful...

--D

>  fs/ext4/extents_status.c | 15 +++++++--------
>  fs/ext4/extents_status.h |  9 +++++++++
>  2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 3981ff7..0578b6b 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -658,8 +658,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  
>  	newes.es_lblk = lblk;
>  	newes.es_len = len;
> -	ext4_es_store_pblock(&newes, pblk);
> -	ext4_es_store_status(&newes, status);
> +	ext4_es_store_pblock_status(&newes, status, pblk);
>  	trace_ext4_es_insert_extent(inode, &newes);
>  
>  	ext4_es_insert_extent_check(inode, &newes);
> @@ -699,8 +698,7 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  
>  	newes.es_lblk = lblk;
>  	newes.es_len = len;
> -	ext4_es_store_pblock(&newes, pblk);
> -	ext4_es_store_status(&newes, status);
> +	ext4_es_store_pblock_status(&newes, pblk, status);
>  	trace_ext4_es_cache_extent(inode, &newes);
>  
>  	if (!len)
> @@ -812,13 +810,14 @@ retry:
>  
>  			newes.es_lblk = end + 1;
>  			newes.es_len = len2;
> +			block = 0x7FDEADBEEF;
>  			if (ext4_es_is_written(&orig_es) ||
> -			    ext4_es_is_unwritten(&orig_es)) {
> +			    ext4_es_is_unwritten(&orig_es))
>  				block = ext4_es_pblock(&orig_es) +
>  					orig_es.es_len - len2;
> -				ext4_es_store_pblock(&newes, block);
> -			}
> -			ext4_es_store_status(&newes, ext4_es_status(&orig_es));
> +			ext4_es_store_pblock_status(&newes,
> +						    ext4_es_status(&orig_es),
> +						    block);
>  			err = __es_insert_extent(inode, &newes);
>  			if (err) {
>  				es->es_lblk = orig_es.es_lblk;
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index 167f4ab8..f1b62a4 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -129,6 +129,15 @@ static inline void ext4_es_store_status(struct extent_status *es,
>  		       (es->es_pblk & ~ES_MASK));
>  }
>  
> +static inline void ext4_es_store_pblock_status(struct extent_status *es,
> +					       ext4_fsblk_t pb,
> +					       unsigned int status)
> +{
> +	es->es_pblk = (((ext4_fsblk_t)
> +			(status & EXTENT_STATUS_FLAGS) << ES_SHIFT) |
> +		       (pb & ~ES_MASK));
> +}
> +
>  extern void ext4_es_register_shrinker(struct ext4_sb_info *sbi);
>  extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
>  extern void ext4_es_lru_add(struct inode *inode);
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
