From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support features in larger inode
Date: Wed, 11 Jul 2007 06:10:56 -0600
Message-ID: <20070711121056.GV6417@schatzie.adilger.int>
References: <1183275482.4010.133.camel@localhost.localdomain> <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:43446 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbXGKMK6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 08:10:58 -0400
Content-Disposition: inline
In-Reply-To: <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  16:32 -0700, Andrew Morton wrote:
> >  	err = ext4_reserve_inode_write(handle, inode, &iloc);
> > +	if (EXT4_I(inode)->i_extra_isize <
> > +	    EXT4_SB(inode->i_sb)->s_want_extra_isize &&
> > +	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
> > +		/* We need extra buffer credits since we may write into EA block
> > +		 * with this same handle */
> > +		if ((jbd2_journal_extend(handle,
> > +			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
> > +			ret = ext4_expand_extra_isize(inode,
> > +				EXT4_SB(inode->i_sb)->s_want_extra_isize,
> > +				iloc, handle);
> > +			if (ret) {
> > +				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
> > +				if (!expand_message) {
> > +					ext4_warning(inode->i_sb, __FUNCTION__,
> > +					"Unable to expand inode %lu. Delete"
> > +					" some EAs or run e2fsck.",
> > +					inode->i_ino);
> > +					expand_message = 1;
> > +				}
> > +			}
> > +		}
> > +	}
> 
> Maybe that message should come out once per mount rather than once per boot
> (or once per modprobe)?

Probably true.

> What are the consequences of a jbd2_journal_extend() failure in here?

Not fatal, just like every user of i_extra_isize.  If the inode isn't a
large inode, or it can't be expanded then there will be a minor loss of
functionality on that inode.  If the i_extra_isize is critical, then
the sysadmin will have run e2fsck to force s_min_extra_isize large enough.

Note that this is only applicable for filesystems which are upgraded.  For
new inodes (i.e. all inodes that exist in the filesystem if it was always
run on a kernel with the currently understood extra fields) then this will
never be invoked (until such a time new extra fields are added).

> > +static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
> > +				     int value_offs_shift, void *to,
> > +				     void *from, size_t n, int blocksize)
> > +{
> > +	/* Adjust the value offsets of the entries */
> > +	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
> > +		if (!last->e_value_block && last->e_value_size) {
> > +			new_offs = le16_to_cpu(last->e_value_offs) +
> > +							value_offs_shift;
> > +			BUG_ON(new_offs + le32_to_cpu(last->e_value_size)
> > +				 > blocksize);
> > +			last->e_value_offs = cpu_to_le16(new_offs);
> > +		}
> > +	}
> > +	/* Shift the entries by n bytes */
> > +	memmove(to, from, n);
> > +}
> 
> Under what circumstances will that new BUG_ON trigger?  Can it be triggered
> via incorrect disk contents?  If so, it should not be there.

Only under code defect or memory corruption.  The needed extra space was
already checked in ext4_expand_extra_isize_ea(), but I asked for this
BUG_ON() because it would otherwise seem that there was a chance from
reading just the above code that the shifted EA might overflow the buffer.

> > +int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
> > +			    struct ext4_inode *raw_inode, handle_t *handle)
> > +{
> > +	down_write(&EXT4_I(inode)->xattr_sem);
> > +retry:
> > +	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
> > +		up_write(&EXT4_I(inode)->xattr_sem);
> > +		return 0;
> > +	}
> 
> So..  xattr_sem is a lock which protects i_extra_isize?  That seems a bit
> strange to me - I'd have expected i_mutex.

Well, since this is the only code that ever changes i_extra_isize, and it
also needs to move the EAs around, it makes sense to use the EA lock for it.
This is also a relatively low-contention lock, and it needs to be held to
access any of the EAs (which are the only things beyond i_extra_isize).

> > +	if (EXT4_I(inode)->i_file_acl) {
> > +		bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
> > +		error = -EIO;
> > +		if (!bh)
> > +			goto cleanup;
> > +		if (ext4_xattr_check_block(bh)) {
> > +			ext4_error(inode->i_sb, __FUNCTION__,
> > +				"inode %lu: bad block %llu", inode->i_ino,
> > +				EXT4_I(inode)->i_file_acl);
> > +			error = -EIO;
> > +			goto cleanup;
> > +		}
> > +		base = BHDR(bh);
> > +		first = BFIRST(bh);
> > +		end = bh->b_data + bh->b_size;
> > +		min_offs = end - base;
> > +		free = ext4_xattr_free_space(first, &min_offs, base,
> > +					     &total_blk);
> > +		if (free < new_extra_isize) {
> > +			if (!tried_min_extra_isize && s_min_extra_isize) {
> > +				tried_min_extra_isize++;
> > +				new_extra_isize = s_min_extra_isize;
> 
> Aren't we missing a brelse(bh) here?

Seems likely, yes.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
