From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Return the length of a hole from get_block
Date: Sat, 18 Jul 2015 08:11:57 +1000
Message-ID: <20150717221157.GP7943@dastard>
References: <1435936511-17705-1-git-send-email-matthew.r.wilcox@intel.com>
 <20150713151610.GC17075@quack.suse.cz>
 <20150713152615.GH13681@linux.intel.com>
 <20150714090246.GA24369@quack.suse.cz>
 <20150714134851.GK13681@linux.intel.com>
 <20150715095903.GE22609@quack.suse.cz>
 <20150716014647.GK7943@dastard>
 <20150716070834.GB22847@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39801 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbbGQWMG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jul 2015 18:12:06 -0400
Content-Disposition: inline
In-Reply-To: <20150716070834.GB22847@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 16, 2015 at 09:08:34AM +0200, Jan Kara wrote:
> On Thu 16-07-15 11:46:47, Dave Chinner wrote:
> > On Wed, Jul 15, 2015 at 11:59:03AM +0200, Jan Kara wrote:
> > > On Tue 14-07-15 09:48:51, Matthew Wilcox wrote:
> > > > On Tue, Jul 14, 2015 at 11:02:46AM +0200, Jan Kara wrote:
> > > > > On Mon 13-07-15 11:26:15, Matthew Wilcox wrote:
> > > > > > On Mon, Jul 13, 2015 at 05:16:10PM +0200, Jan Kara wrote:
> > > > > > > On Fri 03-07-15 11:15:11, Matthew Wilcox wrote:
> > > > > > > > From: Matthew Wilcox <willy@linux.intel.com>
> > > > > > > > 
> > > > > > > > Currently, if ext4's get_block encounters a hole, it does not modify the
> > > > > > > > buffer_head.  That's fine for many callers, but for DAX, it's useful to
> > > > > > > > know how large the hole is.  XFS already returns the length of the hole,
> > > > > > > > so this improvement should not confuse any callers.
> > > > > > > > 
> > > > > > > > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > > > > > > 
> > > > > > > So I'm somewhat wondering: What is the reason of BH_Uptodate flag being
> > > > > > > set? I can see the XFS sets it in some cases as well but the use of the
> > > > > > > flag isn't really clear to me...
> > > > > > 
> > > > > > No clue.  I'm just following the documentation in buffer.c:
> > > > > > 
> > > > > >  * NOTE! All mapped/uptodate combinations are valid:
> > > > > >  *
> > > > > >  *      Mapped  Uptodate        Meaning
> > > > > >  *
> > > > > >  *      No      No              "unknown" - must do get_block()
> > > > > >  *      No      Yes             "hole" - zero-filled
> > > > > >  *      Yes     No              "allocated" - allocated on disk, not read in
> > > > > >  *      Yes     Yes             "valid" - allocated and up-to-date in memory.
> > > > > 
> > > > > OK, but that speaks about buffer head attached to a page. get_block()
> > > > > callback gets a temporary bh (at least in some cases) only so that it can
> > > > > communicate result of block mapping. And BH_Uptodate should be set only if
> > > > > data in the buffer is properly filled (which cannot be the case for
> > > > > temporary bh which doesn't have *any* data) and it simply isn't the case
> > > > > even for bh attached to a page because ext4 get_block() functions don't
> > > > > touch bh->b_data at all. So I just wouldn't set BH_Uptodate in get_block()
> > > > > at all..
> > > > 
> > > > OK, but how should DAX then distinguish between an old-style filesystem
> > > > (like current ext4) which reports "unknown" and leaves b_size untouched
> > > > when it encounters a hole, versus a new-style filesystem (XFS, ext4 with
> > > > this patch) which wants to report the size of a hole in b_size?  The use
> > > > of Uptodate currently distinguishes the two cases.
> > > > 
> > > > Plus, why would you want bh's to be treated differently, depending on
> > > > whether they're stack-based or attached to a page?  That seems even more
> > > > confusing than bh's already are.
> > > 
> > > Well, you may want to treat them differently because they *are* different.
> > > For example touching b_size of page-attached buffer_head is a no-go.
> > > get_block() interface is abusing buffer_head structure for historical
> > > reasons.
> > > 
> > > Seeing you have hit issues with using buffer_head for passing mapping
> > > information I agree with Dave that we should convert DAX code to use
> > > iomaps instead of cluttering get_block() via buffer_head further. You can
> > > lift struct iomap from include/linux/exportfs.h (and related constant
> > > definitions) and use it for passing map information. It should be quite
> > > straightforward and simple now that DAX doesn't have many users. We will
> > > have:
> > > 
> > > typedef int (iomap_fn_t)(struct inode *inode, loff_t offset, u64 length,
> > > 			 bool create, struct iomap *iomap);
> > > 
> > > and DAX functions will take this instead of get_block_t. Adding a wrapper
> > > to ext4_map_blocks() to work as iomap_fn_t is pretty straightforward as
> > > well.
> > 
> > I've got one of them sitting around in a multipage write patchset
> > somewhere. See below.
> 
> Yeah, but Matthew actually doesn't need your patch. Your patch converts
> fs/buffer.c so that iomap interface works with buffer heads but Matthew can
> convert *just* the DAX code because that is standalone and doesn't need
> buffer heads at all. So that is even simpler.

True, I was thinking that it would help not needing to convert ext4
initially, but it's the wrong conversion for that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
