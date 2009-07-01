From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Return error if we fail to allocate block in
	noalloc_get_block_write
Date: Wed, 1 Jul 2009 15:26:36 +0530
Message-ID: <20090701095636.GB20540@skywalker>
References: <1246441575-20311-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:45366 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbZGAJ4g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 05:56:36 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp08.in.ibm.com (8.13.1/8.13.1) with ESMTP id n6193DeE026839
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 14:33:13 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n619ubYN1032274
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 15:26:38 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n619ub2I002881
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 15:26:37 +0530
Content-Disposition: inline
In-Reply-To: <1246441575-20311-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 01, 2009 at 03:16:15PM +0530, Aneesh Kumar K.V wrote:
> block_write_full_page consider a zero return from get_block as success.
> noalloc_get_block_write returned zero even if we failed to find a mapping
> blocks. Returning non zero ensures we fallback to the error handling path
> of block_write_full_page which would properly redirty the page after
> the below patch is applied.
> 
> http://article.gmane.org/gmane.linux.file-systems/33145
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
> 
> NOTE: I am not sure whether -EGAIN is the right error to be returned error.
> This patch should enable us to push the pending ext4 patches in the patch
> queue without depending on the full series from Jan. Will reply to this
> email with patch ordering.
> 
>  fs/ext4/inode.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 25638bc..6c814af 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2514,7 +2514,10 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
>  	if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
>  		ret = 0;
> -	}
> +	} else if (create && ret == 0)
> +		/* write request on unmapped buffer head. */
> +		ret = -EAGAIN;
> +
>  	return ret;
>  }
> 

The patch ordering I tested this with was
+ stable-boundary
+ stable-boundary-undo.patch
+ jan-kara-dont-clear-dirty-bits-in-block_write_full_page
+ dont-look-at-buffer_heads-outside-i_size
+ fix-mmap-truncate-race-with-subpage-blocksize
+ 01.patch  <=============================================== This is the  above patch
+ fix-mmap-truncate-race-with-nondelalloc
+ move-__ext4_journaled-writepage-function
+ add-WARN_ON-with-unmapped-dirty-bh-in-writepage
+ vfs-jan-kara-page_mkwrite-infrastructure
+ allocate-blocks-correctly-with-subpage-blocksize
> jan-kara-unmap-underlying-metadata-of-new-buffers-only-when-mapped

Now with jan-kara-dont-clear-dirty-bits-in-block_write_full_page
block_write_full_page will redirty the page when get_block fails. That
would ensure that we don't drop the pages if we find unmapped
buffer_heads in the writepage callback. The patch 
fix-mmap-truncate-race-with-subpage-blocksize actually  pass pages with
unmapped buffer heads to block_write_full_page.

This also means we can push patches upto
move-__ext4_journaled-writepage-function to upstream in 2.6.31

I am yet to run the full patch set on ABAT. So the patches had limited
testing.

-aneesh
