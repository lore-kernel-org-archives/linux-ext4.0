From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_page_mkwrite and delalloc
Date: Mon, 16 Jun 2008 16:11:41 +0200
Message-ID: <20080616141141.GB31567@duck.suse.cz>
References: <20080612181407.GE22481@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52736 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753734AbYFPOLn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jun 2008 10:11:43 -0400
Content-Disposition: inline
In-Reply-To: <20080612181407.GE22481@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Aneesh,

On Thu 12-06-08 23:44:07, Aneesh Kumar K.V wrote:
> With delalloc we should not do writepage in ext4_page_mkwrite. The idea
> with delalloc is to delay the block allocation and make sure we allocate
> chunks of blocks together at writepages. So i guess we should update
> ext4_page_mkwrite to use write_begin and write_end instead of writepage.
> Taking i_alloc_sem should protect against parallel truncate and the page
> lock should protect against parallel write_begin/write_end.
> 
> How about the patch below ?
  In principle the patch looks fine, I would only like to see two things
checked:
  1) Did you do some stress testing of the patch - combining mmapped writes
with ordinary writes to the same file and truncation so that we detect
possible bugs in locking / data corruption due to some bad locking. This
significantly changes when write_begin / write_end can be called in ext4
(i.e., it is now called without i_mutex - BTW: that is probably worth a
comment before these functions).
  2) How does this change influence CPU load for mmapped accesses - I worry
about write_begin / write_end path being significantly heavier than just
calling writepage. Probably just mmap a large file, write single byte
to every page and measure using oprofile whether accumulated time spent in
page_mkwrite didn't change to much.

  Thanks.
									Honza
> 
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
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
> +			len, len, page, NULL);
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = 0;
>  out_unlock:
>  	up_read(&inode->i_alloc_sem);
>  	return ret;
> 
> If we agree i will send an updated ext4_page_mkwrite.patch and other
> related patches that needed to be updated so that the patch queue apply
> cleanly. 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
