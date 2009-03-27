From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: Avoid false EIO errors
Date: Fri, 27 Mar 2009 23:38:06 +0530
Message-ID: <20090327180806.GB2810@skywalker>
References: <1238091711-23464-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:48015 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZC0SIe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Mar 2009 14:08:34 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp09.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2RHe9lQ001637
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2009 23:10:09 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2RI4k0X4133026
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2009 23:34:46 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2RI8K8k004615
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2009 23:38:20 +0530
Content-Disposition: inline
In-Reply-To: <1238091711-23464-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 26, 2009 at 07:21:51PM +0100, Jan Kara wrote:
> Sometimes block_write_begin() can map buffers in a page but later we fail to
> copy data into those buffers (because the source page has been paged out in the
> mean time). We then end up with !uptodate mapped buffers. To add a bit more to
> the confusion, block_write_end() does not commit any data (and thus does not
> any mark buffers as uptodate) if we didn't succeed with copying all the data.
> 
> Commit f4fc66a894546bdc88a775d0e83ad20a65210bcb (ext3: convert to new aops)
> missed these cases and thus we were inserting non-uptodate buffers to
> transaction's list which confuses JBD code and it reports IO errors, aborts
> a transaction and generally makes users afraid about their data ;-P.
> 
> This patch fixes the problem by reorganizing ext3_..._write_end() code to
> first call block_write_end() to mark buffers with valid data uptodate and
> after that we file only uptodate buffers to transaction's lists. Also
> fix a problem where we could leave blocks allocated beyond i_size (i_disksize
> in fact).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext3/inode.c |   99 +++++++++++++++++++++++-------------------------------
>  1 files changed, 42 insertions(+), 57 deletions(-)
> 
>   As a side note, ext4 / JBD2 only needs the "proper i_disksize update"
> part of the fix (we got rid of special handling of ordered mode buffers
> there). But I have to first figure out how to properly do it...
>   Andrew, would you please merge the patch? Thanks.
> 
> 									Honza
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 5fa453b..e230f7a 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1211,6 +1211,18 @@ int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
>  	return err;
>  }
> 
> +/* For ordered writepage and write_end functions */
> +static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
> +{
> +	/*
> +	 * Write could have mapped the buffer but it didn't copy the data in
> +	 * yet. So avoid filing such buffer into a transaction.
> +	 */
> +	if (buffer_mapped(bh) && buffer_uptodate(bh))
> +		return ext3_journal_dirty_data(handle, bh);
> +	return 0;
> +}
> +
>  /* For write_end() in data=journal mode */
>  static int write_end_fn(handle_t *handle, struct buffer_head *bh)
>  {
> @@ -1221,26 +1233,29 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
>  }
> 
>  /*
> - * Generic write_end handler for ordered and writeback ext3 journal modes.
> - * We can't use generic_write_end, because that unlocks the page and we need to
> - * unlock the page after ext3_journal_stop, but ext3_journal_stop must run
> - * after block_write_end.
> + * This is nasty and subtle: ext3_write_begin() could have allocated blocks
> + * for the whole page but later we failed to copy the data in. So the disk
> + * size we really have allocated is pos + len (block_write_end() has zeroed
> + * the freshly allocated buffers so we aren't going to write garbage). But we
> + * want to keep i_size at the place where data copying finished so that we
> + * don't confuse readers. The worst what can happen is that we expose a page
> + * of zeros at the end of file after a crash...
>   */
> -static int ext3_generic_write_end(struct file *file,
> -				struct address_space *mapping,
> -				loff_t pos, unsigned len, unsigned copied,
> -				struct page *page, void *fsdata)
> +static void update_file_sizes(struct inode *inode, loff_t pos, unsigned len,
> +			      unsigned copied)
>  {
> -	struct inode *inode = file->f_mapping->host;
> -
> -	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
> +	int mark_dirty = 0;
> 
> -	if (pos+copied > inode->i_size) {
> -		i_size_write(inode, pos+copied);
> -		mark_inode_dirty(inode);
> +	if (pos + len > EXT3_I(inode)->i_disksize) {
> +		mark_dirty = 1;
> +		EXT3_I(inode)->i_disksize = pos + len;
>  	}

Won't this result in file having wrong contents if we failed to copy
the contents from user space? Now if we successfully allocated
blocks and we failed to copy the contents from user space, the above
would result in update of i_disksize and a mark_inode_dirty. Doesn't
that imply we have wrong contents in those block for which we failed to
copy the contents from user space ?

> -
> -	return copied;
> +	if (pos + copied > inode->i_size) {
> +		i_size_write(inode, pos + copied);
> +		mark_dirty = 1;
> +	}
> +	if (mark_dirty)
> +		mark_inode_dirty(inode);
>  }
> 

-aneesh
