From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix xattr block allocation/release with bigalloc
Date: Mon, 18 Feb 2013 09:26:07 -0600
Message-ID: <5122480F.9030100@redhat.com>
References: <1361175262-16205-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab3BRP0G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2013 10:26:06 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1IFQ6JF031888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2013 10:26:06 -0500
In-Reply-To: <1361175262-16205-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/18/13 2:14 AM, Lukas Czerner wrote:
> Currently when new xattr block is created or released we we would call
> dquot_free_block() or dquot_alloc_block() respectively, among the else
> decrementing or incrementing the number of blocks assigned to the inode
> by one block.
> 
> This however does not work for bigalloc file system because we always
> allocate/free the whole cluster so we have to count with that in
> dquot_free_block() and dquot_alloc_block() as well.
> 
> Use the clusters-to-blocks conversion EXT4_C2B() when passing number of
> blocks to the dquot_alloc/free functions to fix the problem.
> 
> The problem has been revealed by xfstests #117 (and possibly others).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks for finding this!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/xattr.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 3a91ebc..b6741be 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -549,7 +549,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
>  		if (IS_SYNC(inode))
>  			ext4_handle_sync(handle);
> -		dquot_free_block(inode, 1);
> +		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
>  		ea_bdebug(bh, "refcount now=%d; releasing",
>  			  le32_to_cpu(BHDR(bh)->h_refcount));
>  	}
> @@ -832,7 +832,8 @@ inserted:
>  			else {
>  				/* The old block is released after updating
>  				   the inode. */
> -				error = dquot_alloc_block(inode, 1);
> +				error = dquot_alloc_block(inode,
> +						EXT4_C2B(EXT4_SB(sb), 1));
>  				if (error)
>  					goto cleanup;
>  				error = ext4_journal_get_write_access(handle,
> @@ -928,7 +929,7 @@ cleanup:
>  	return error;
>  
>  cleanup_dquot:
> -	dquot_free_block(inode, 1);
> +	dquot_free_block(inode, EXT4_C2B(EXT4_SB(sb), 1));
>  	goto cleanup;
>  
>  bad_block:
> 

