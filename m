From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: remove unused function ext4_ext_check_cache
Date: Wed, 26 Sep 2012 15:46:26 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209261546210.31136@dhcp-187-45.bos.redhat.com>
References: <1347457961-16182-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2IZTq2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 15:46:28 -0400
In-Reply-To: <1347457961-16182-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 12 Sep 2012, Lukas Czerner wrote:

> Date: Wed, 12 Sep 2012 09:52:41 -0400
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH] ext4: remove unused function ext4_ext_check_cache
> 
> Remove unused function ext4_ext_check_cache() and merge the code back to
> the ext4_ext_in_cache().

ping

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c |   48 +++++++++---------------------------------------
>  1 files changed, 9 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index aabbb3f..d635dd6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2092,13 +2092,10 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
>  }
>  
>  /*
> - * ext4_ext_check_cache()
> + * ext4_ext_in_cache()
>   * Checks to see if the given block is in the cache.
>   * If it is, the cached extent is stored in the given
> - * cache extent pointer.  If the cached extent is a hole,
> - * this routine should be used instead of
> - * ext4_ext_in_cache if the calling function needs to
> - * know the size of the hole.
> + * cache extent pointer.
>   *
>   * @inode: The files inode
>   * @block: The block to look for in the cache
> @@ -2107,8 +2104,10 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
>   *
>   * Return 0 if cache is invalid; 1 if the cache is valid
>   */
> -static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
> -	struct ext4_ext_cache *ex){
> +static int
> +ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
> +			struct ext4_extent *ex)
> +{
>  	struct ext4_ext_cache *cex;
>  	struct ext4_sb_info *sbi;
>  	int ret = 0;
> @@ -2125,7 +2124,9 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
>  		goto errout;
>  
>  	if (in_range(block, cex->ec_block, cex->ec_len)) {
> -		memcpy(ex, cex, sizeof(struct ext4_ext_cache));
> +		ex->ee_block = cpu_to_le32(cex->ec_block);
> +		ext4_ext_store_pblock(ex, cex->ec_start);
> +		ex->ee_len = cpu_to_le16(cex->ec_len);
>  		ext_debug("%u cached by %u:%u:%llu\n",
>  				block,
>  				cex->ec_block, cex->ec_len, cex->ec_start);
> @@ -2138,37 +2139,6 @@ errout:
>  }
>  
>  /*
> - * ext4_ext_in_cache()
> - * Checks to see if the given block is in the cache.
> - * If it is, the cached extent is stored in the given
> - * extent pointer.
> - *
> - * @inode: The files inode
> - * @block: The block to look for in the cache
> - * @ex:    Pointer where the cached extent will be stored
> - *         if it contains block
> - *
> - * Return 0 if cache is invalid; 1 if the cache is valid
> - */
> -static int
> -ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
> -			struct ext4_extent *ex)
> -{
> -	struct ext4_ext_cache cex;
> -	int ret = 0;
> -
> -	if (ext4_ext_check_cache(inode, block, &cex)) {
> -		ex->ee_block = cpu_to_le32(cex.ec_block);
> -		ext4_ext_store_pblock(ex, cex.ec_start);
> -		ex->ee_len = cpu_to_le16(cex.ec_len);
> -		ret = 1;
> -	}
> -
> -	return ret;
> -}
> -
> -
> -/*
>   * ext4_ext_rm_idx:
>   * removes index from the index block.
>   */
> 
