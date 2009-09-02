From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 5/5] ext2: convert to use the new truncate convention.
Date: Wed, 2 Sep 2009 11:14:26 +0200
Message-ID: <20090902091426.GC32632@wotan.suse.de>
References: <20090710073028.782561541@suse.de> <20090710073231.195528273@suse.de> <20090901182929.GG8242@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
	viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZIBJOZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 05:14:25 -0400
Content-Disposition: inline
In-Reply-To: <20090901182929.GG8242@duck.novell.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 08:29:29PM +0200, Jan Kara wrote:
>   Hi Nick,
> 
> On Fri 10-07-09 17:30:33, npiggin@suse.de wrote:
> > I have some questions, marked with XXX.
> > 
> > Cc: linux-ext4@vger.kernel.org
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > ---
> >  fs/ext2/ext2.h  |    1 
> >  fs/ext2/file.c  |    2 
> >  fs/ext2/inode.c |  138 +++++++++++++++++++++++++++++++++++++++++++++-----------
> >  3 files changed, 113 insertions(+), 28 deletions(-)
> > 
> > Index: linux-2.6/fs/ext2/inode.c
> > ===================================================================
> > --- linux-2.6.orig/fs/ext2/inode.c
> > +++ linux-2.6/fs/ext2/inode.c
> ...
> > +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
> > +{
> > +	/*
> > +	 * XXX: it seems like a bug here that we don't allow
> > +	 * IS_APPEND inode to have blocks-past-i_size trimmed off.
> > +	 * review and fix this.
> > +	 */
> > +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> > +	    S_ISLNK(inode->i_mode)))
> > +		return -EINVAL;
> > +	if (ext2_inode_is_fast_symlink(inode))
> > +		return -EINVAL;
> > +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > +		return -EPERM;
> > +	__ext2_truncate_blocks(inode, offset);
> > +}
>   Actually, looking again into this, I think you've introduced a subtle bug
> into the code. When a write fails for some reason, we did vmtruncate()
> previously which called block_truncate_page() which zeroed a tail of the
> last block. Now, ext2_truncate_blocks() does not do this and I think it
> could be a problem because at least in direct IO case, we could have written
> some data into that block on disk.
>   We really rely on the tail of the block being zeroed because otherwise
> extending truncate will show those old data in the block. I plan to change
> that in my mkwrite fixes but until then, we should preserve the old
> assumptions.
>   So I think that ext2_truncate_blocks() should do all that tail page magic
> as well (although it's not needed in all cases).

Hi Jan,

Yeah I did think about this and yes we usually do need to zero out
the page but for these error cases with normal writes we shouldn't
write anything in there.  For direct IO... I don't see the problem
because we're not coherent with pagecache anyway...

Hmm, but possiby it is a good idea just to keep the same block_truncate_page
calls for this patchset and we can look at it again with your truncate
patches. I'll work on fixing these up.

