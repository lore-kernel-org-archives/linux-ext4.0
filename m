From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RESEND 2/2] ext4: truncate the file properly if we fail
	to copy data from userspace
Date: Mon, 4 May 2009 13:23:15 +0200
Message-ID: <20090504112315.GB4870@duck.suse.cz>
References: <1241428381-13874-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241428381-13874-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbZEDLXU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 07:23:20 -0400
Content-Disposition: inline
In-Reply-To: <1241428381-13874-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 04-05-09 14:43:01, Aneesh Kumar K.V wrote:
> In generic_perform_write if we fail to copy the user data we don't
> update the inode->i_size. We should truncate the file in the above case
> so that we don't have blocks allocated outside inode->i_size. Add
> the inode to orphan list in the same transaction as block allocation
> This ensures that if we crash in between the recovery would do the truncate.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> CC:  Jan Kara <jack@suse.cz>
  This patch looks fine as well.
  Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/ext4/inode.c |  103 +++++++++++++++++++++++++++++++++++++++++--------------
>  1 files changed, 77 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 28e95ee..43884e3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1507,6 +1507,52 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
>  	return ext4_handle_dirty_metadata(handle, NULL, bh);
>  }
>  
> +static int ext4_generic_write_end(struct file *file,
> +				struct address_space *mapping,
> +				loff_t pos, unsigned len, unsigned copied,
> +				struct page *page, void *fsdata)
> +{
> +	int i_size_changed = 0;
> +	struct inode *inode = mapping->host;
> +	handle_t *handle = ext4_journal_current_handle();
> +
> +	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
> +
> +	/*
> +	 * No need to use i_size_read() here, the i_size
> +	 * cannot change under us because we hold i_mutex.
> +	 *
> +	 * But it's important to update i_size while still holding page lock:
> +	 * page writeout could otherwise come in and zero beyond i_size.
> +	 */
> +	if (pos + copied > inode->i_size) {
> +		i_size_write(inode, pos + copied);
> +		i_size_changed = 1;
> +	}
> +
> +	if (pos + copied >  EXT4_I(inode)->i_disksize) {
> +		/* We need to mark inode dirty even if
> +		 * new_i_size is less that inode->i_size
> +		 * bu greater than i_disksize.(hint delalloc)
> +		 */
> +		ext4_update_i_disksize(inode, (pos + copied));
> +		i_size_changed = 1;
> +	}
> +	unlock_page(page);
> +	page_cache_release(page);
> +
> +	/*
> +	 * Don't mark the inode dirty under page lock. First, it unnecessarily
> +	 * makes the holding time of page lock longer. Second, it forces lock
> +	 * ordering of page lock and transaction start for journaling
> +	 * filesystems.
> +	 */
> +	if (i_size_changed)
> +		ext4_mark_inode_dirty(handle, inode);
> +
> +	return copied;
> +}
> +
>  /*
>   * We need to pick up the new inode size which generic_commit_write gave us
>   * `file' can be NULL - eg, when called from page_symlink().
> @@ -1530,21 +1576,15 @@ static int ext4_ordered_write_end(struct file *file,
>  	ret = ext4_jbd2_file_inode(handle, inode);
>  
>  	if (ret == 0) {
> -		loff_t new_i_size;
> -
> -		new_i_size = pos + copied;
> -		if (new_i_size > EXT4_I(inode)->i_disksize) {
> -			ext4_update_i_disksize(inode, new_i_size);
> -			/* We need to mark inode dirty even if
> -			 * new_i_size is less that inode->i_size
> -			 * bu greater than i_disksize.(hint delalloc)
> -			 */
> -			ext4_mark_inode_dirty(handle, inode);
> -		}
> -
> -		ret2 = generic_write_end(file, mapping, pos, len, copied,
> +		ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
>  		copied = ret2;
> +		if (pos + len > inode->i_size)
> +			/* if we have allocated more blocks and copied
> +			 * less. We will have blocks allocated outside
> +			 * inode->i_size. So truncate them
> +			 */
> +			ext4_orphan_add(handle, inode);
>  		if (ret2 < 0)
>  			ret = ret2;
>  	}
> @@ -1552,6 +1592,9 @@ static int ext4_ordered_write_end(struct file *file,
>  	if (!ret)
>  		ret = ret2;
>  
> +	if (pos + len > inode->i_size)
> +		vmtruncate(inode, inode->i_size);
> +
>  	return ret ? ret : copied;
>  }
>  
> @@ -1563,25 +1606,21 @@ static int ext4_writeback_write_end(struct file *file,
>  	handle_t *handle = ext4_journal_current_handle();
>  	struct inode *inode = mapping->host;
>  	int ret = 0, ret2;
> -	loff_t new_i_size;
>  
>  	trace_mark(ext4_writeback_write_end,
>  		   "dev %s ino %lu pos %llu len %u copied %u",
>  		   inode->i_sb->s_id, inode->i_ino,
>  		   (unsigned long long) pos, len, copied);
> -	new_i_size = pos + copied;
> -	if (new_i_size > EXT4_I(inode)->i_disksize) {
> -		ext4_update_i_disksize(inode, new_i_size);
> -		/* We need to mark inode dirty even if
> -		 * new_i_size is less that inode->i_size
> -		 * bu greater than i_disksize.(hint delalloc)
> -		 */
> -		ext4_mark_inode_dirty(handle, inode);
> -	}
> -
> -	ret2 = generic_write_end(file, mapping, pos, len, copied,
> +	ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
>  	copied = ret2;
> +	if (pos + len > inode->i_size)
> +		/* if we have allocated more blocks and copied
> +		 * less. We will have blocks allocated outside
> +		 * inode->i_size. So truncate them
> +		 */
> +		ext4_orphan_add(handle, inode);
> +
>  	if (ret2 < 0)
>  		ret = ret2;
>  
> @@ -1589,6 +1628,9 @@ static int ext4_writeback_write_end(struct file *file,
>  	if (!ret)
>  		ret = ret2;
>  
> +	if (pos + len > inode->i_size)
> +		vmtruncate(inode, inode->i_size);
> +
>  	return ret ? ret : copied;
>  }
>  
> @@ -1633,10 +1675,19 @@ static int ext4_journalled_write_end(struct file *file,
>  	}
>  
>  	unlock_page(page);
> +	page_cache_release(page);
> +	if (pos + len > inode->i_size)
> +		/* if we have allocated more blocks and copied
> +		 * less. We will have blocks allocated outside
> +		 * inode->i_size. So truncate them
> +		 */
> +		ext4_orphan_add(handle, inode);
> +
>  	ret2 = ext4_journal_stop(handle);
>  	if (!ret)
>  		ret = ret2;
> -	page_cache_release(page);
> +	if (pos + len > inode->i_size)
> +		vmtruncate(inode, inode->i_size);
>  
>  	return ret ? ret : copied;
>  }
> -- 
> 1.6.3.rc4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
