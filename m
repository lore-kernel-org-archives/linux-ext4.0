From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 1/2] ext4: add a version of
 convert_inline_data_nolock() for regular files
Date: Tue, 6 Jun 2017 20:47:07 -0700
Message-ID: <20170607034707.GA594@zzz>
References: <20170606000359.16794-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        gnehzuil.liu@gmail.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32902 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdFGDrK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jun 2017 23:47:10 -0400
Received: by mail-pg0-f67.google.com with SMTP id a70so212885pge.0
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jun 2017 20:47:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170606000359.16794-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Mon, Jun 05, 2017 at 08:03:58PM -0400, Theodore Ts'o wrote:
> The current version of ext4_convert_inline_data_nolock() should not be
> used for regular files, since it does the conversion via using jbd2,
> and this if we are not using data journalling, this is unsafe.  If the
> data block is updated after the inode is converted from using inline
> data to using a data block, when the journal is replayed, the new
> version of the data block can get overwritten by the old version of
> the data block.

Thanks for trying to fix this mess!  I'm not sure I know enough to fully review
it, but here are some things I'm questioning...

> 
> The ext4_convert_inline_data_nolock() also doesn't handle races with
> Direct I/O correctly.
> 

Are you sure direct I/O is an issue?   ext4_direct_IO() doesn't support files
with inline data; it returns 0 if 'ext4_has_inline_data(inode)'.

>  /*
> + * Only used for regular files, not directories!
> + *
> + * The inode and page must be locked when this function is called.
> + */
> +static int reg_convert_inline_data_nolock(handle_t *handle,
> +					  struct inode *inode,
> +					  struct page *page,
> +					  struct ext4_iloc *iloc)
> +{
> +	int error;
> +	struct buffer_head *data_bh = NULL;
> +	int inline_size = ext4_get_inline_size(inode);
> +
> +	if (!(inode->i_state & (I_NEW|I_FREEING)))
> +		WARN_ON(!inode_is_locked(inode));

I don't think the inode lock is guaranteed... ext4_convert_inline_data() is
called from ext4_fallocate() and ext4_page_mkwrite() without out.  It seems the
xattr_sem will always be taken for write, though.

> +
> +	/* If some one has already done this for us, just exit. */
> +	if (!ext4_has_inline_data(inode))
> +		return 0;
> +
> +	if (!PageUptodate(page)) {
> +		error = ext4_read_inline_page(inode, page);
> +		if (error < 0)
> +			return error;
> +	}
> +
> +	/* Avoid races with DIO */
> +	ext4_inode_block_unlocked_dio(inode);

What is ext4_inode_block_unlocked_dio() even supposed to do?  It sets
EXT4_STATE_DIOREAD_LOCK but nothing seems to check it.


> +	inode_dio_wait(inode);
> +
> +	error = ext4_destroy_inline_data_nolock(handle, inode);
> +	if (error)
> +		return error;
> +
> +	error = __block_write_begin(page, 0, inline_size, ext4_get_block);
> +	if (error)
> +		goto out_restore;
> +
> +	data_bh = page_buffers(page);
> +	BUG_ON(data_bh == NULL);
> +
> +	if (ext4_should_journal_data(inode)) {
> +		lock_buffer(data_bh);
> +		error = ext4_journal_get_create_access(handle, data_bh);
> +		if (error) {
> +			unlock_buffer(data_bh);
> +			error = -EIO;
> +			goto out_restore;
> +		}
> +		error = ext4_handle_dirty_metadata(handle, inode, data_bh);
> +		unlock_buffer(data_bh);
> +	} else {
> +		__set_page_dirty_buffers(page);
> +		if (ext4_should_order_data(inode))
> +			error = ext4_jbd2_inode_add_write(handle, inode);
> +	}
> +
> +out_restore:
> +	if (error) {
> +		void *kaddr = kmap_atomic(page);

kmap(), not kmap_atomic(), since the stuff in between can block.

>  
> +	if (S_ISREG(inode->i_mode)) {
> +		page = grab_cache_page_write_begin(inode->i_mapping, 0, 0);
> +		if (!page)
> +			return -ENOMEM;
> +	}
> +
>  	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
>  	if (IS_ERR(handle)) {
>  		error = PTR_ERR(handle);
> @@ -2027,11 +2121,21 @@ int ext4_convert_inline_data(struct inode *inode)
>  	}

Doesn't the page lock rank below transaction start?

Eric
