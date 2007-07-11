From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
 features in larger inode
Date: Wed, 11 Jul 2007 10:34:05 -0700
Message-ID: <20070711103405.1656dd71.akpm@linux-foundation.org>
References: <1183275482.4010.133.camel@localhost.localdomain>
	<20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	<20070711121056.GV6417@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andy Whitcroft <apw@shadowen.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070711121056.GV6417@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 11 Jul 2007 06:10:56 -0600 Andreas Dilger <adilger@clusterfs.com> wrote:

> On Jul 10, 2007  16:32 -0700, Andrew Morton wrote:
> > >  	err = ext4_reserve_inode_write(handle, inode, &iloc);
> > > +	if (EXT4_I(inode)->i_extra_isize <
> > > +	    EXT4_SB(inode->i_sb)->s_want_extra_isize &&
> > > +	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
> > > +		/* We need extra buffer credits since we may write into EA block
> > > +		 * with this same handle */
> > > +		if ((jbd2_journal_extend(handle,
> > > +			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
> > > +			ret = ext4_expand_extra_isize(inode,
> > > +				EXT4_SB(inode->i_sb)->s_want_extra_isize,
> > > +				iloc, handle);
> > > +			if (ret) {
> > > +				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
> > > +				if (!expand_message) {
> > > +					ext4_warning(inode->i_sb, __FUNCTION__,
> > > +					"Unable to expand inode %lu. Delete"
> > > +					" some EAs or run e2fsck.",
> > > +					inode->i_ino);
> > > +					expand_message = 1;
> > > +				}
> > > +			}
> > > +		}
> > > +	}
> > 
> > Maybe that message should come out once per mount rather than once per boot
> > (or once per modprobe)?
> 
> Probably true.
> 
> > What are the consequences of a jbd2_journal_extend() failure in here?
> 
> Not fatal, just like every user of i_extra_isize.  If the inode isn't a
> large inode, or it can't be expanded then there will be a minor loss of
> functionality on that inode.  If the i_extra_isize is critical, then
> the sysadmin will have run e2fsck to force s_min_extra_isize large enough.
> 
> Note that this is only applicable for filesystems which are upgraded.  For
> new inodes (i.e. all inodes that exist in the filesystem if it was always
> run on a kernel with the currently understood extra fields) then this will
> never be invoked (until such a time new extra fields are added).

I'd suggest that we get a comment in the code explaining this: this
unchecked error does rather stand out.

> > > +	if (EXT4_I(inode)->i_file_acl) {
> > > +		bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
> > > +		error = -EIO;
> > > +		if (!bh)
> > > +			goto cleanup;
> > > +		if (ext4_xattr_check_block(bh)) {
> > > +			ext4_error(inode->i_sb, __FUNCTION__,
> > > +				"inode %lu: bad block %llu", inode->i_ino,
> > > +				EXT4_I(inode)->i_file_acl);
> > > +			error = -EIO;
> > > +			goto cleanup;
> > > +		}
> > > +		base = BHDR(bh);
> > > +		first = BFIRST(bh);
> > > +		end = bh->b_data + bh->b_size;
> > > +		min_offs = end - base;
> > > +		free = ext4_xattr_free_space(first, &min_offs, base,
> > > +					     &total_blk);
> > > +		if (free < new_extra_isize) {
> > > +			if (!tried_min_extra_isize && s_min_extra_isize) {
> > > +				tried_min_extra_isize++;
> > > +				new_extra_isize = s_min_extra_isize;
> > 
> > Aren't we missing a brelse(bh) here?
> 
> Seems likely, yes.

OK - could we get a positive ack from someone indicating that this will get
looked at?  Because I am about to forget about it.

