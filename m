From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 2/3] ext4: Exchange the blocks between two inodes
Date: Wed, 4 Feb 2009 10:20:29 -0500
Message-ID: <20090204152029.GE14762@mit.edu>
References: <49829A91.8000800@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56258 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZBDPUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Feb 2009 10:20:32 -0500
Content-Disposition: inline
In-Reply-To: <49829A91.8000800@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 30, 2009 at 03:13:37PM +0900, Akira Fujita wrote:
> ext4: online defrag -- Exchange the blocks between two inodes
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> For each page, exchange the extents between original inode
> and destination inode, and then write the file data of
> the original inode to destination inode.

As I mentioned earlier, it would be better to merge this patch into
the previous once; we don't need to keep them broken apart.

> +/**
> + * ext4_defrag_replace_branches - Replace original extents with new extents
> + *
> + * @handle:		journal handle
> + * @org_inode:		original inode
> + * @dest_inode:		destination inode
> + * @from:		block offset of org_inode
> + * @count:		block count to be replaced

It's really good that this function can support moving an arbitrarily
large block range.  It's unfortunate that its caller is only moving a
4k page at a time.  :-)

> +
> +	up_write(&EXT4_I(org_inode)->i_data_sem);
> +	ret = a_ops->write_begin(o_filp, mapping, offs, data_len, w_flags,
> +								&page, &fsdata);
> +	down_write(&EXT4_I(org_inode)->i_data_sem);

This is going to be a problem.  Once we release i_data_sem, there is
the possibility that other processes which might be running and
accessing the file at the same time that the defragger is running
could be blocked waiting for i_data_sem to be released.  The moment it
gets released, they will grab the lock then start to modify extent
tree --- either allocating new blocks to it, or worse, truncating or
unlinking the target inode.

This is going to be a mess to fix, since Linux doesn't have recursive
locking primitives.  We do take i_mutex, which will protect us against
truncates, but it won't protect against a write() system call.  Also,
if there inode has delayed allocation blocks pending, those could get
written out by the page cleaner, and i_mutex won't protect us against
changes to i_data_sem, either.

We could add special-case kludgery to wrap around all of the places
that takes or release the i_data_sem so that we get recursive locking
support --- but that would be very ugly indeed.

I'm not sure what's the best way to deal with this; maybe if we sleep
on it someone will come up with a better suggestion --- but it's
something that we have to figure out.

	  					- Ted
