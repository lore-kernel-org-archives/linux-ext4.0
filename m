From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4_page_mkwrite and delalloc
Date: Thu, 12 Jun 2008 14:00:46 -0700
Message-ID: <1213304446.3698.9.camel@localhost.localdomain>
References: <20080612181407.GE22481@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55732 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbYFLVAs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 17:00:48 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5CL0lCK021202
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 17:00:47 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CL0lM2208574
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 17:00:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CL0ksE015576
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 17:00:46 -0400
In-Reply-To: <20080612181407.GE22481@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-12 at 23:44 +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> With delalloc we should not do writepage in ext4_page_mkwrite. The idea
> with delalloc is to delay the block allocation and make sure we allocate
> chunks of blocks together at writepages. So i guess we should update
> ext4_page_mkwrite to use write_begin and write_end instead of writepage.

I agree with delayed allocation page_mkwrite is much simplier, just to
block reservation to prevent ENOSPC

> Taking i_alloc_sem should protect against parallel truncate and the page
> lock should protect against parallel write_begin/write_end.
> 
> How about the patch below ?
> 

Do we plan to support page_mkwrite for non delalloc? the following patch
seems suggesting that we only do page_mkwrite with delalloc?

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cac132b..7f162cc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3543,18 +3543,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  	return err;
>  }
> 
> -static int ext4_bh_prepare_fill(handle_t *handle, struct buffer_head *bh)
> -{
> -	if (!buffer_mapped(bh)) {
> -		/*
> -		 * Mark buffer as dirty so that
> -		 * block_write_full_page() writes it
> -		 */
> -		set_buffer_dirty(bh);
> -	}
> -	return 0;
> -}
> -
>  static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
>  {
>  	return !buffer_mapped(bh);
> @@ -3596,24 +3584,22 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  				       ext4_bh_unmapped))
>  			goto out_unlock;
> -		/*
> -		 * Now mark all the  buffer head dirty so
> -		 * that writepage can write it
> -		 */
> -		walk_page_buffers(NULL, page_buffers(page), 0, len,
> -					NULL, ext4_bh_prepare_fill);
>  	}
>  	/*
> -	 * OK, we need to fill the hole... Lock the page and do writepage.
> -	 * We can't do write_begin and write_end here because we don't
> -	 * have inode_mutex and that allow parallel write_begin, write_end call.
> +	 * OK, we need to fill the hole... Lock the page and do write_begin
> +	 * write_end. We are not holding inode.i__mutex here. That allow
> +	 * parallel write_begin, write_end call.
>  	 * (lock_page prevent this from happening on the same page though)
>  	 */
> -	lock_page(page);
> -	wbc.range_start = page_offset(page);
> -	wbc.range_end = page_offset(page) + len;
> -	ret = mapping->a_ops->writepage(page, &wbc);
> -	/* writepage unlocks the page */
> +	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
> +			len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);

What is this AOP_FLAG_UNINTERRUPTIBLE flag ? Also shouldn't we test
delalloc is enabled?

> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
> +			len, len, page, NULL);

I am still puzzled why we need to mark the page dirty in write_end here.
Thought only do block reservation in write_begin is enough, we haven't
write anything yet...

Mingming
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = 0;
>  out_unlock:
>  	up_read(&inode->i_alloc_sem);
>  	return ret;
> 
> 
> 
> If we agree i will send an updated ext4_page_mkwrite.patch and other
> related patches that needed to be updated so that the patch queue apply
> cleanly. 
> 
> -aneesh

