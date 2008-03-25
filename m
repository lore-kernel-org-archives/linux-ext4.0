From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] ext2: Retry block allocation if new blocks are
	allocated from system zone.
Date: Tue, 25 Mar 2008 17:56:49 -0600
Message-ID: <20080325235649.GY2691@webber.adilger.int>
References: <1206471371-9659-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61161 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbYCYX5T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 19:57:19 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2PNvIQv007750
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 16:57:18 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JYB0080191KS200@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Mar 2008 16:57:18 -0700 (PDT)
In-reply-to: <1206471371-9659-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 26, 2008  00:26 +0530, Aneesh Kumar K.V wrote:
> If the block allocator gets blocks out of system zone ext2 calls
> ext2_error. But if the file system is mounted with errors=continue
> retry block allocation. We need to mark the system zone
> blocks as in use to make sure retry don't pick them again
> 
> System zone is the block range mapping block bitmap, inode bitmap
> and inode table.

Nack * 3.  It appears that this will spin in a loop, because retry_alloc:
will not change the group that is being used, and extN_valid_block_bitmap()
does nothing to fix up the bitmap to avoid re-allocating the same blocks.

Instead, it seems safest that extN_new_blocks() should skip the group
entirely after marking the group as having no free blocks, so the allocator
will no longer choose it.  This also means that when freeing blocks it
needs to watch out for underflow of the ->bg_free_blocks_count value,
which is itself a good safety measure.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext2/balloc.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index e7b2baf..501399e 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -149,11 +149,12 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
>  			    block_group, le32_to_cpu(desc->bg_block_bitmap));
>  		return NULL;
>  	}
> -	if (!ext2_valid_block_bitmap(sb, desc, block_group, bh)) {
> -		brelse(bh);
> -		return NULL;
> -	}
>  
> +	ext2_valid_block_bitmap(sb, desc, block_group, bh);
> +	/*
> +	 * file system mounted not to panic on error,
> +	 * continue with corrput bitmap
> +	 */
>  	return bh;
>  }
>  
> @@ -1381,7 +1382,12 @@ allocated:
>  			    "Allocating block in system zone - "
>  			    "blocks from "E2FSBLK", length %lu",
>  			    ret_block, num);
> -		goto out;
> +		/*
> +		 * ext2_try_to_allocate marked the blocks we allocated
> +		 * as in use. So we may want to selectively
> +		 * mark some of the blocks as free
> +		 */
> +		goto retry_alloc;
>  	}
>  
>  	performed_allocation = 1;
> -- 
> 1.5.5.rc0.16.g02b00.dirty

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

