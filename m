From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: Fix possible use after free of buffer head
Date: Thu, 29 Nov 2012 11:02:39 -0800
Message-ID: <20121129190239.GA2888@blackbox.djwong.org>
References: <1354185828-28545-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34976 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2K2TCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2012 14:02:53 -0500
Content-Disposition: inline
In-Reply-To: <1354185828-28545-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 29, 2012 at 11:43:48AM +0100, Lukas Czerner wrote:
> Commit fa77dcfafeaa6bc73293c646bfc3d5192dcf0be2 introduces block bitmap
> checksum calculation into ext4_new_inode() in the case that block group
> was uninitialized. However we brelse() the bitmap buffer before we
> attempt to checksum it so we have no guarantee that the buffer is still
> there.
> 
> Fix this by releasing the buffer after the possible checksum
> computation.

Looks ok, so:
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

That IBM fellow is gone. ;)

--D
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/ialloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 3a100e7..c7efa88 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -762,7 +762,6 @@ got:
>  
>  		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
>  		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
> -		brelse(block_bitmap_bh);
>  
>  		/* recheck and clear flag under lock if we still need to */
>  		ext4_lock_group(sb, group);
> @@ -775,6 +774,7 @@ got:
>  			ext4_group_desc_csum_set(sb, group, gdp);
>  		}
>  		ext4_unlock_group(sb, group);
> +		brelse(block_bitmap_bh);
>  
>  		if (err)
>  			goto fail;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
