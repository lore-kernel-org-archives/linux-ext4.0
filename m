From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v7
Date: Thu, 30 Apr 2009 09:17:53 -0400
Message-ID: <1241097473.4986.7.camel@think.oraclecorp.com>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
	 <1241034706.20099.65.camel@think.oraclecorp.com>
	 <1241038424.20099.74.camel@think.oraclecorp.com>
	 <20090430115207.GD29220@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:29117 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043AbZD3NSf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Apr 2009 09:18:35 -0400
In-Reply-To: <20090430115207.GD29220@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-04-30 at 13:52 +0200, Jan Kara wrote:
> On Wed 29-04-09 16:53:44, Chris Mason wrote:
> ...
> > +static int ext3_guarded_write_end(struct file *file,
> > +				struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned copied,
> > +				struct page *page, void *fsdata)
> > +{
> > +	handle_t *handle = ext3_journal_current_handle();
> > +	struct inode *inode = file->f_mapping->host;
> > +	unsigned from, to;
> > +	int ret = 0, ret2;
> > +
> > +	copied = block_write_end(file, mapping, pos, len, copied,
> > +				 page, fsdata);
> > +
> > +	from = pos & (PAGE_CACHE_SIZE - 1);
> > +	to = from + copied;
> > +	ret = walk_page_buffers(handle, page_buffers(page),
> > +		from, to, NULL, journal_dirty_data_guarded_fn);
> > +
> > +	/*
> > +	 * we only update the in-memory i_size.  The disk i_size is done
> > +	 * by the end io handlers
> > +	 */
> > +	if (ret == 0 && pos + copied > inode->i_size) {
> > +		int must_log;
> > +
> > +		/* updated i_size, but we may have raced with a
> > +		 * data=guarded end_io handler.
> > +		 *
> > +		 * All the guarded IO could have ended while i_size was still
> > +		 * small, and if we're just adding bytes into an existing block
> > +		 * in the file, we may not be adding a new guarded IO with this
> > +		 * write.  So, do a check on the disk i_size and make sure it
> > +		 * is updated to the highest safe value.
> > +		 *
> > +		 * This may also be required if the
> > +		 * journal_dirty_data_guarded_fn chose to do an fully
> > +		 * ordered write of this buffer instead of a guarded
> > +		 * write.
> > +		 *
> > +		 * ext3_ordered_update_i_size tests inode->i_size, so we
> > +		 * make sure to update it with the ordered lock held.
> > +		 */
> > +		ext3_ordered_lock(inode);
> > +		i_size_write(inode, pos + copied);
> > +		must_log = ext3_ordered_update_i_size(inode);
> > +		ext3_ordered_unlock(inode);
> > +
> > +		orphan_del_trans(inode, must_log > 0);
> > +	}
>   Didn't we agree that only "i_size_write" should remain from the above
> "if" after you changed journal_dirty_data_guarded_fn() function?

It sounded like a really good idea at the time ;) But it doesn't cover
all the cases.  If journal_dirty_data_guarded_fn decided to do a full
ordering of a buffer because the start of the buffer was inside of
i_size, we might not have updated disk_i_size.

Basically something like this:

dd if=/dev/zero of=foo bs=2k count=1 # makes an ordered buffer
sync # disk_i_size is now 2k
dd if=/dev/zero of=foo bs=3k count=1 conv=notrunc

This will become an ordered write.  There isn't a really good way to do
it as a guarded IO because that buffer head may already have a guarded
IO attached.  I could add some complexity and cover all the cases where
an ordered IO is in flight etc etc, but it doesn't seem worth it for the
small append case.

Since it is an ordered write, there is no guarded IO to update the disk
i_size later.  The update needs to happen during write_end().  I did try
to update the comments to reflect that, but it might not be as clear as
it should be.

-chris


