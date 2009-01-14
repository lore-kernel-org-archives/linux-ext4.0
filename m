From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Date: Wed, 14 Jan 2009 14:26:12 -0800
Message-ID: <20090114142612.03945fd2.akpm@linux-foundation.org>
References: <1231945948-23676-1-git-send-email-jack@suse.cz>
	<1231945948-23676-2-git-send-email-jack@suse.cz>
	<20090114101834.fbb9ea12.akpm@linux-foundation.org>
	<20090114220900.GO6222@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, pavel@suse.cz
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117AbZANW0d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 17:26:33 -0500
In-Reply-To: <20090114220900.GO6222@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 14 Jan 2009 17:09:00 -0500
Theodore Tso <tytso@MIT.EDU> wrote:

> On Wed, Jan 14, 2009 at 10:18:34AM -0800, Andrew Morton wrote:
> > On Wed, 14 Jan 2009 16:12:28 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> > > To be really safe that the data hit the platter, we should also flush drive's
> > > writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.
> > > 
> > 
> > It's not good to randomly sprinkle blkdev_issue_flush() calls all over
> > the filesystem like this.  How do we know that you didn't miss a site? 
> > How do we ensure that people who modify the fs in the future don't
> > forget to add the blkdev_issue_flush() call, if needed?
> > 
> > IOW, it is fragile.  Is there anything we can do to make this more
> > robust?  Do the flush calls from some higher-level callsite?  Perhaps
> > even the VFS?
> 
> The problem with doing it in the VFS is that we might end up calling
> flush twice; it may very well be that for some filesystems, we'll be
> calling the flush operation as part of writing out the commit block,
> for example.

It depends how it's done.  One way would be via a new
address_space_operations entry.

> I'm not sure it's fair to say that we need to "randomly sprinkle
> blkdev_issue_flush() calls all over the place".  The number of places
> where we need to do O_SYNC or fsync() handling is in fact quite small.
> We were simply ignoring this problem before.

Well it _does_ sprinkle them all over.

> > > +			blkdev_issue_flush(dir->i_sb->s_bdev, NULL);
> > 
> > The patch itself would have been a bit neater if it had added
> > 
> > int ext3_blkdev_issue_flush(struct inode *inode)
> 
> What, just to avoid needing the "..->i_sb->s_bdev" construction?

Partly as a cleanup, yes.  But such a function then becomes a site
where we can add commentary explaining the reason for its existence,
along with commentary which describes the semantics in details,
exceptions, caveats, etc.

It also becomes a single site where the feature can be disabled for
those who wish to evaluate its performance cost.

The single site can also be used for convenient gathering of timing
information.

One thing we may well choose to do is to stop issuing the flush if
blkdev_issue_flush() is returning -EOPNOTSUPP, which some devices will
presumably do.  Reissuing a pointless and quite expensive command over
and over again doesn't seem clever.

And I can probably think of more reasons :)


>  I
> personally find extra levels of inline functions

It shouldn't be inlined.

> to be harder to deal
> with long term, since I then I have to track down the definition of
> ext3_blkdev_issue_flush in the header files to make sure there isn't
> any other magic hiding in there other than the i->i_sb->s_bdev
> derefencing.
> 
> 						- Ted
