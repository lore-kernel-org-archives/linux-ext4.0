From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: Make ext2fs_extent_set_bmap() more robust
 against ENOSPC
Date: Thu, 09 Jul 2009 23:45:19 -0500
Message-ID: <4A56C75F.9060004@redhat.com>
References: <1247199830-21179-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49950 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZGJEpY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 00:45:24 -0400
In-Reply-To: <1247199830-21179-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> In the case where we ext2fs_extent_set_bmap() is replacing the block
> mapping at the beginning of an already-existing extent, insert a new
> extent if necessary before shrinking an existing extent, to avoid data
> loss if the disk is full.
> 
> This mostly addresses the problem described in Red Hat Bugzilla's
> statistics are still wrong, but at least the files on the filesystem
> are not corrupted.  If there is a failure during the
> inode_scan_and_fix pass, the simplest thing to do may be to tell the
> user to run e2fsck -fy.
> 
> Addresses-Red-Hat-Bug: #510379

Thanks Ted, looks reasonable at first glance.  I'll review more in depth
tomorrow, but I think you can also remove the again: target, since
nobody's going there anymore w/ this patch.

-Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/extent.c |   44 ++++++++++++++++++++++++++++++++------------
>  1 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index 4a4fd2c..2f280ea 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -1270,24 +1270,44 @@ again:
>  #ifdef DEBUG
>  		printf("(re/un)mapping first block in extent\n");
>  #endif
> +		if (physical) {
> +			retval = ext2fs_extent_get(handle, 
> +						   EXT2_EXTENT_PREV_LEAF,
> +						   &extent);
> +			if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
> +				extent_uninit = 1;
> +			if (retval == EXT2_ET_EXTENT_NO_PREV) {
> +				retval = ext2fs_extent_insert(handle,
> +							      0, &newextent);
> +			} else if (retval)
> +				goto done;
> +			else if ((logical == extent.e_lblk + extent.e_len) &&
> +				 (physical == extent.e_pblk + extent.e_len) &&
> +				 (new_uninit == extent_uninit) &&
> +				 ((int) extent.e_len < max_len-1)) {
> +				extent.e_len++;
> +				retval = ext2fs_extent_replace(handle, 0,
> +							       &extent);
> +			} else {
> +				retval = ext2fs_extent_insert(handle,
> +				      EXT2_EXTENT_INSERT_AFTER, &newextent);
> +			}
> +			if (retval)
> +				goto done;
> +		}
> +		retval = ext2fs_extent_fix_parents(handle);
> +		if (retval)
> +			goto done;
> +		retval = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF,
> +					   &extent);
> +		if (retval)
> +			goto done;
>  		extent.e_pblk++;
>  		extent.e_lblk++;
>  		extent.e_len--;
>  		retval = ext2fs_extent_replace(handle, 0, &extent);
>  		if (retval)
>  			goto done;
> -		if (physical) {
> -			/*
> -			 * We've removed the old block, now rely on
> -			 * the optimized hueristics for adding a new
> -			 * mapping with appropriate merging if necessary.
> -			 */
> -			goto again;
> -		} else {
> -			retval = ext2fs_extent_fix_parents(handle);
> -			if (retval)
> -				goto done;
> -		}
>  	} else {
>  		__u32	orig_length;
>  

