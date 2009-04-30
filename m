From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] ext3 data=guarded v7
Date: Thu, 30 Apr 2009 13:52:07 +0200
Message-ID: <20090430115207.GD29220@duck.suse.cz>
References: <1240941840.15136.44.camel@think.oraclecorp.com> <1241034706.20099.65.camel@think.oraclecorp.com> <1241038424.20099.74.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZD3LwJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Apr 2009 07:52:09 -0400
Content-Disposition: inline
In-Reply-To: <1241038424.20099.74.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 29-04-09 16:53:44, Chris Mason wrote:
...
> +static int ext3_guarded_write_end(struct file *file,
> +				struct address_space *mapping,
> +				loff_t pos, unsigned len, unsigned copied,
> +				struct page *page, void *fsdata)
> +{
> +	handle_t *handle = ext3_journal_current_handle();
> +	struct inode *inode = file->f_mapping->host;
> +	unsigned from, to;
> +	int ret = 0, ret2;
> +
> +	copied = block_write_end(file, mapping, pos, len, copied,
> +				 page, fsdata);
> +
> +	from = pos & (PAGE_CACHE_SIZE - 1);
> +	to = from + copied;
> +	ret = walk_page_buffers(handle, page_buffers(page),
> +		from, to, NULL, journal_dirty_data_guarded_fn);
> +
> +	/*
> +	 * we only update the in-memory i_size.  The disk i_size is done
> +	 * by the end io handlers
> +	 */
> +	if (ret == 0 && pos + copied > inode->i_size) {
> +		int must_log;
> +
> +		/* updated i_size, but we may have raced with a
> +		 * data=guarded end_io handler.
> +		 *
> +		 * All the guarded IO could have ended while i_size was still
> +		 * small, and if we're just adding bytes into an existing block
> +		 * in the file, we may not be adding a new guarded IO with this
> +		 * write.  So, do a check on the disk i_size and make sure it
> +		 * is updated to the highest safe value.
> +		 *
> +		 * This may also be required if the
> +		 * journal_dirty_data_guarded_fn chose to do an fully
> +		 * ordered write of this buffer instead of a guarded
> +		 * write.
> +		 *
> +		 * ext3_ordered_update_i_size tests inode->i_size, so we
> +		 * make sure to update it with the ordered lock held.
> +		 */
> +		ext3_ordered_lock(inode);
> +		i_size_write(inode, pos + copied);
> +		must_log = ext3_ordered_update_i_size(inode);
> +		ext3_ordered_unlock(inode);
> +
> +		orphan_del_trans(inode, must_log > 0);
> +	}
  Didn't we agree that only "i_size_write" should remain from the above
"if" after you changed journal_dirty_data_guarded_fn() function?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
