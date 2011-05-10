From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Ext4 punch hole 2/5 v7] Ext4 Punch Hole Support: Clear Hole
Date: Mon, 09 May 2011 17:47:08 -0700
Message-ID: <1304988428.2543.2.camel@mingming-laptop>
References: <4DC5DB9A.3030001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33991 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab1EJArK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 20:47:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4A0a8Un011572
	for <linux-ext4@vger.kernel.org>; Mon, 9 May 2011 20:36:08 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4A0lAkJ082782
	for <linux-ext4@vger.kernel.org>; Mon, 9 May 2011 20:47:10 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4A0l90M005764
	for <linux-ext4@vger.kernel.org>; Mon, 9 May 2011 21:47:09 -0300
In-Reply-To: <4DC5DB9A.3030001@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2011-05-07 at 16:54 -0700, Allison Henderson wrote:
> This patch adds routines needed to zero out the
> unblock aligned data of the hole.
> 
> The existing ext4_block_truncate_page routine that
> is used to zero out unblock aligned data from truncate
> has been modified to accept a length parameter, and
> renamed to ext4_block_zero_page_range.
> 
> The function can now be used to zero out the
> head of a block, the tail of a block, or the middle
> of a block.  The existing ext4_block_truncate_page
> has now become a wrapper to this function
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>

I have looked at this patch before, so you could add my reviewed-by here
too.
> ---
> :100644 100644 3ba6c31... 95efb4e... M	fs/ext4/ext4.h
> :100644 100644 f92c58b... 8ce382d... M	fs/ext4/inode.c
>  fs/ext4/ext4.h  |    2 ++
>  fs/ext4/inode.c |   33 +++++++++++++++++++++++++++++++--
>  2 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3ba6c31..95efb4e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1758,6 +1758,8 @@ extern int ext4_writepage_trans_blocks(struct inode *);
>  extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
>  extern int ext4_block_truncate_page(handle_t *handle,
>  		struct address_space *mapping, loff_t from);
> +extern int ext4_block_zero_page_range(handle_t *handle,
> +		struct address_space *mapping, loff_t from, loff_t length);
>  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
>  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
>  extern void ext4_da_update_reserve_space(struct inode *inode,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f92c58b..8ce382d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3916,9 +3916,30 @@ void ext4_set_aops(struct inode *inode)
>  int ext4_block_truncate_page(handle_t *handle,
>  		struct address_space *mapping, loff_t from)
>  {
> +	unsigned offset = from & (PAGE_CACHE_SIZE-1);
> +	unsigned length;
> +	unsigned blocksize;
> +	struct inode *inode = mapping->host;
> +
> +	blocksize = inode->i_sb->s_blocksize;
> +	length = blocksize - (offset & (blocksize - 1));
> +
> +	return ext4_block_zero_page_range(handle, mapping, from, length);
> +}
> +
> +/*
> + * ext4_block_zero_page_range() zeros out a mapping of length 'length'
> + * starting from file offset 'from'.  The range to be zero'd must
> + * be contained with in one block.  If the specified range exceeds
> + * the end of the block it will be shortened to end of the block
> + * that cooresponds to 'from'
> + */
> +int ext4_block_zero_page_range(handle_t *handle,
> +		struct address_space *mapping, loff_t from, loff_t length)
> +{
>  	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
>  	unsigned offset = from & (PAGE_CACHE_SIZE-1);
> -	unsigned blocksize, length, pos;
> +	unsigned blocksize, max, pos;
>  	ext4_lblk_t iblock;
>  	struct inode *inode = mapping->host;
>  	struct buffer_head *bh;
> @@ -3931,7 +3952,15 @@ int ext4_block_truncate_page(handle_t *handle,
>  		return -EINVAL;
> 
>  	blocksize = inode->i_sb->s_blocksize;
> -	length = blocksize - (offset & (blocksize - 1));
> +	max = blocksize - (offset & (blocksize - 1));
> +
> +	/*
> +	 * correct length if it does not fall between
> +	 * 'from' and the end of the block
> +	 */
> +	if (length > max || length < 0)
> +		length = max;
> +
>  	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
> 
>  	if (!page_has_buffers(page))


