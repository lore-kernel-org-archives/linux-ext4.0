From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and
 3.11.7
Date: Wed, 15 Jan 2014 22:54:59 -0500
Message-ID: <20140116035459.GB14736@thunk.org>
References: <20140115192802.GK21295@kvack.org>
 <20140115202214.GH9229@birch.djwong.org>
 <20140115203205.GA12751@kvack.org>
 <20140115215613.GD12751@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48840 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaAPDzE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jan 2014 22:55:04 -0500
Content-Disposition: inline
In-Reply-To: <20140115215613.GD12751@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 15, 2014 at 04:56:13PM -0500, Benjamin LaHaise wrote:
> On Wed, Jan 15, 2014 at 03:32:05PM -0500, Benjamin LaHaise wrote:
> > I tried a few tests setting goal to different things, but evidently I'm 
> > not managing to convince mballoc to put the file's data close to my goal 
> > block, something in that mess of complicated logic is making it ignore 
> > the goal value I'm passing in.
> 
> It appears that ext4_new_meta_blocks() essentially ignores the goal block 
> specified for metadata blocks.  If I hack around things and pass in the 
> EXT4_MB_HINT_TRY_GOAL flag where ext4_new_meta_blocks() is called in 
> ext4_alloc_blocks(), then it will at least try to allocate the block 
> specified by goal.  However, if the block specified by goal is not free, 
> it ends up allocating blocks many megabytes away, even if one is free 
> within a few blocks of goal.

I don't remember who sent in the patch to make this change, but the
goal of this change (which was deliberate) was to speed up operations
such as deletes, since the indirect blocks would be (ideally) close
together.  If I recall correctly, the person who made this change was
more concerned about random read/write workloads than sequential
workloads.  He or she did make the assertion that in general the
triple indirect and double indirect blocks would be tend to be flushed
out of memory anyway.

Looking back, I'm not sure how strong that particular argument really
was, but I don't think we really spent a lot time focusing on that
argument, given that extents were what was going to give the very
clear win.

Something that might be worth experimenting with is extending the
EXT4_IOC_PRECACHE_EXTENTS to support indirect blocks mapped file.  If
we have managed to keep all of the indirect blocks close together at
the beginning of the flex_bg, and if we have indeed succeeded in
keeping the data blocks contiguous on disk, then sucking in all of the
indirect blocks and distilling it into a few extent status cache
entries might be the best way to accelerate performance.

If we can keep the data blocks for the multi-gigabyte file completely
contiguous on disk, then all of the indirect blocks (or extent tree)
can be stored in memory in a single 40 byte data structure.  (Of
course, with a legacy ext3 file system layout, the 128 megs or so the
data blocks will be broken up by the block group metadata --- this is
one of the reasons why we implemented the flex_bg feature in ext4, to
relax the requirement that the inode table and allocation bitmaps for
a block group have to be stored in the block group.  Still, using 320
bytes of memory for each 1G file is not too shabby.)

That way, we get the best of both worlds; because the indirect blocks
are close to each other (instead of being inline with the data blocks)
things like deleting the file will be fast.  But so will precaching
all of the logical->physical block data, since we can read all of the
indirect blocks in at once, and then store it in memory in a highly
compacted form in the extents status cache.

Regards,

					- Ted
