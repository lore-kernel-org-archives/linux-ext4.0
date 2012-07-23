From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout all
 dirty pages in punch hole
Date: Mon, 23 Jul 2012 13:01:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207231249020.20857@localhost>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com> <1342943986-12413-10-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab2GWLCF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2012 07:02:05 -0400
In-Reply-To: <1342943986-12413-10-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 22 Jul 2012, Zheng Liu wrote:

> Date: Sun, 22 Jul 2012 15:59:45 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com, wenqing.lz@taobao.com
> Subject: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout all dirty
>     pages in punch hole
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Now we don't need to writeout all dirty pages when punching a hole.  The i_mutex
> locking is taken to avoid concurrent writes.  In truncate_pagecache_range, all
> pages in this hole is released, and ext4_es_remove_space is called to update
> extent status tree. 

Hi Zheng,

I am currently in the middle of reworking punch hole for ext4 so
there will be some changes in this area. See the patch set

http://www.spinics.net/lists/linux-ext4/msg33014.html

Moreover I think that we should avoid taking i_mutex if we can and I
believe that we can in this case, because we only need to prevent
allocation. So I just want to let you know that this part is
probably going to change anyway.

Thanks!
-Lukas

> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents.c |   28 ++++++++++++----------------
>  1 files changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f2c5294..2a526b4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4529,9 +4529,11 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	loff_t first_page_offset, last_page_offset;
>  	int credits, err = 0;
>  
> +	mutex_lock(&inode->i_mutex);
> +
>  	/* No need to punch hole beyond i_size */
>  	if (offset >= inode->i_size)
> -		return 0;
> +		goto error;
>  
>  	/*
>  	 * If the hole extends beyond i_size, set the hole
> @@ -4549,18 +4551,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	first_page_offset = first_page << PAGE_CACHE_SHIFT;
>  	last_page_offset = last_page << PAGE_CACHE_SHIFT;
>  
> -	/*
> -	 * Write out all dirty pages to avoid race conditions
> -	 * Then release them.
> -	 */
> -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> -		err = filemap_write_and_wait_range(mapping,
> -			offset, offset + length - 1);
> -
> -		if (err)
> -			return err;
> -	}
> -
>  	/* Now release the pages */
>  	if (last_page_offset > first_page_offset) {
>  		truncate_pagecache_range(inode, first_page_offset,
> @@ -4572,12 +4562,14 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  
>  	credits = ext4_writepage_trans_blocks(inode);
>  	handle = ext4_journal_start(inode, credits);
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto error;
> +	}
>  
>  	err = ext4_orphan_add(handle, inode);
>  	if (err)
> -		goto out;
> +		goto error;
>  
>  	/*
>  	 * Now we need to zero out the non-page-aligned data in the
> @@ -4652,6 +4644,8 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	ext4_ext_invalidate_cache(inode);
>  	ext4_discard_preallocations(inode);
>  
> +	err = ext4_es_remove_space(inode, first_block,
> +				   stop_block - first_block);
>  	err = ext4_ext_remove_space(inode, first_block, stop_block - 1);
>  
>  	ext4_ext_invalidate_cache(inode);
> @@ -4667,6 +4661,8 @@ out:
>  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
> +error:
> +	mutex_unlock(&inode->i_mutex);
>  	return err;
>  }
>  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> 
