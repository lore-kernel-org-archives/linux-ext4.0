From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: Mark block group as corrupt on inode bitmap
 error
Date: Wed, 28 Aug 2013 18:45:38 -0400
Message-ID: <20130828224538.GJ27079@thunk.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235559.24017.72336.stgit@blackbox.djwong.org>
 <20130724072252.GA3685@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50911 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab3H1Wpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 18:45:46 -0400
Content-Disposition: inline
In-Reply-To: <20130724072252.GA3685@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 24, 2013 at 03:22:52PM +0800, Zheng Liu wrote:
> On Fri, Jul 19, 2013 at 04:55:59PM -0700, Darrick J. Wong wrote:
> > If we detect either a discrepancy between the inode bitmap and the inode counts
> > or the inode bitmap fails to pass validation checks, mark the block group
> > corrupt and refuse to allocate or deallocate inodes from the group.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

> > @@ -266,7 +270,9 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
> >  	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
> >  	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
> >  	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
> > -	if (!bitmap_bh)
> > +	/* Don't bother if the inode bitmap is corrupt. */
> > +	grp = ext4_get_group_info(sb, block_group);
> > +	if (unlikely(EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) || !bitmap_bh)
> >  		goto error_return;
> 
> It seems that this is a duplicated check.  If we encounters a currupted
> inode bitmap, ext4_read_inode_bitmap() will return null.

If an already released inode is freed, the IBITMAP_CORRUPT bit can be
set even though the checksum is valid and ext4_read_inode_bitmap()
returns a non-null bh pointer.

						- Ted
