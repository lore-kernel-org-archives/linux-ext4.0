From: Greg KH <greg@kroah.com>
Subject: Re: [stable] Patch Upstream: ext4: Fix s_dirty_blocks_counter if
	block allocation failed with nodelalloc
Date: Wed, 14 Jan 2009 15:47:48 -0800
Message-ID: <20090114234748.GD24230@kroah.com>
References: <200901090125.n091P7CU028977@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, aneesh.kumar@linux.vnet.ibm.com,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:37845 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756366AbZANX4j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 18:56:39 -0500
Content-Disposition: inline
In-Reply-To: <200901090125.n091P7CU028977@hera.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted and others,

I see a bunch of ext4 / jbd2 patches were tagged as requested to go into
the -stable tree.  But there seems to not be any simple way to determine
what order these patches should go in.

Can someone please list the order of them, or resend all patches that
they request to go into the 2.6.28-stable tree (and 2.6.27 if some of
the patches apply there as well.)

thanks,

greg k-h

> commit: 0087d9fb3f29f59e8d42c8b058376d80e5adde4c
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date: Mon, 5 Jan 2009 21:49:12 -0500
> Subject: ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc
> 
> With nodelalloc option we need to update the dirty block counter on
> block allocation failure. This is needed because we increment the
> dirty block counter early in the block allocation phase. Without
> the patch s_dirty_blocks_counter goes wrong so that filesystem's
> free blocks decreases incorrectly.
> 
> Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@kernel.org
> ---
>  fs/ext4/mballoc.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index fd2294d..05d9f81 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4541,7 +4541,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  	}
>  	if (ar->len == 0) {
>  		*errp = -EDQUOT;
> -		return 0;
> +		goto out3;
>  	}
>  	inquota = ar->len;
>  
> @@ -4614,6 +4614,13 @@ out2:
>  out1:
>  	if (ar->len < inquota)
>  		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
> +out3:
> +	if (!ar->len) {
> +		if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> +			/* release all the reserved blocks if non delalloc */
> +			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> +						reserv_blks);
> +	}
>  
>  	return block;
>  }
> -- 
> 1.6.0.2
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
