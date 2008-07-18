From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fix data corruption when writing to prealloc area
Date: Fri, 18 Jul 2008 10:12:46 -0500
Message-ID: <4880B2EE.8030903@redhat.com>
References: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYGRPPn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 11:15:43 -0400
In-Reply-To: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> We need to recalucate the path information on extent insert
> even if depth doesn't change.

Aneesh, do you have a compact test case for this?

Thanks,
-Eric

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   41 +++++++++++++++++++++++------------------
>  1 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7bdaeec..9c8541e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2462,7 +2462,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		unsigned int newdepth;
>  		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
>  		if (allocated <= EXT4_EXT_ZERO_LEN) {
> -			/* Mark first half uninitialized.
> +			/*
> +			 * iblock == ee_block is handled by the zerouout
> +			 * at the beginning.
> +			 * Mark first half uninitialized.
>  			 * Mark second half initialized and zero out the
>  			 * initialized extent
>  			 */
> @@ -2485,7 +2488,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  				ex->ee_len   = orig_ex.ee_len;
>  				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  				ext4_ext_dirty(handle, inode, path + depth);
> -				/* zeroed the full extent */
> +				/* blocks available from iblock */
>  				return allocated;
>  
>  			} else if (err)
> @@ -2513,6 +2516,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  					err = PTR_ERR(path);
>  					return err;
>  				}
> +				/* get the second half extent details */
>  				ex = path[depth].p_ext;
>  				err = ext4_ext_get_access(handle, inode,
>  								path + depth);
> @@ -2542,6 +2546,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  			ext4_ext_dirty(handle, inode, path + depth);
>  			/* zeroed the full extent */
> +			/* blocks available from iblock */
>  			return allocated;
>  
>  		} else if (err)
> @@ -2557,23 +2562,22 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		 */
>  		orig_ex.ee_len = cpu_to_le16(ee_len -
>  						ext4_ext_get_actual_len(ex3));
> -		if (newdepth != depth) {
> -			depth = newdepth;
> -			ext4_ext_drop_refs(path);
> -			path = ext4_ext_find_extent(inode, iblock, path);
> -			if (IS_ERR(path)) {
> -				err = PTR_ERR(path);
> -				goto out;
> -			}
> -			eh = path[depth].p_hdr;
> -			ex = path[depth].p_ext;
> -			if (ex2 != &newex)
> -				ex2 = ex;
> -
> -			err = ext4_ext_get_access(handle, inode, path + depth);
> -			if (err)
> -				goto out;
> +		depth = newdepth;
> +		ext4_ext_drop_refs(path);
> +		path = ext4_ext_find_extent(inode, iblock, path);
> +		if (IS_ERR(path)) {
> +			err = PTR_ERR(path);
> +			goto out;
>  		}
> +		eh = path[depth].p_hdr;
> +		ex = path[depth].p_ext;
> +		if (ex2 != &newex)
> +			ex2 = ex;
> +
> +		err = ext4_ext_get_access(handle, inode, path + depth);
> +		if (err)
> +			goto out;
> +
>  		allocated = max_blocks;
>  
>  		/* If extent has less than EXT4_EXT_ZERO_LEN and we are trying
> @@ -2591,6 +2595,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  			ext4_ext_dirty(handle, inode, path + depth);
>  			/* zero out the first half */
> +			/* blocks available from iblock */
>  			return allocated;
>  		}
>  	}

