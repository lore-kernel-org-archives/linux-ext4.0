From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and 3.11.7
Date: Thu, 16 Jan 2014 13:48:26 -0500
Message-ID: <20140116184826.GG12751@kvack.org>
References: <20140115192802.GK21295@kvack.org> <20140115202214.GH9229@birch.djwong.org> <20140115203205.GA12751@kvack.org> <20140115215613.GD12751@kvack.org> <20140116035459.GB14736@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:58976 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaAPSs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jan 2014 13:48:27 -0500
Content-Disposition: inline
In-Reply-To: <20140116035459.GB14736@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Wed, Jan 15, 2014 at 10:54:59PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 15, 2014 at 04:56:13PM -0500, Benjamin LaHaise wrote:
> > On Wed, Jan 15, 2014 at 03:32:05PM -0500, Benjamin LaHaise wrote:
> > > I tried a few tests setting goal to different things, but evidently I'm 
> > > not managing to convince mballoc to put the file's data close to my goal 
> > > block, something in that mess of complicated logic is making it ignore 
> > > the goal value I'm passing in.
> > 
> > It appears that ext4_new_meta_blocks() essentially ignores the goal block 
> > specified for metadata blocks.  If I hack around things and pass in the 
> > EXT4_MB_HINT_TRY_GOAL flag where ext4_new_meta_blocks() is called in 
> > ext4_alloc_blocks(), then it will at least try to allocate the block 
> > specified by goal.  However, if the block specified by goal is not free, 
> > it ends up allocating blocks many megabytes away, even if one is free 
> > within a few blocks of goal.
> 
> I don't remember who sent in the patch to make this change, but the
> goal of this change (which was deliberate) was to speed up operations
> such as deletes, since the indirect blocks would be (ideally) close
> together.  If I recall correctly, the person who made this change was
> more concerned about random read/write workloads than sequential
> workloads.  He or she did make the assertion that in general the
> triple indirect and double indirect blocks would be tend to be flushed
> out of memory anyway.

Any idea when this commit was made or titled?  I care about random 
performance as well, but that can't be at the cost of making sequential 
reads suck.

> Looking back, I'm not sure how strong that particular argument really
> was, but I don't think we really spent a lot time focusing on that
> argument, given that extents were what was going to give the very
> clear win.
> 
> Something that might be worth experimenting with is extending the
> EXT4_IOC_PRECACHE_EXTENTS to support indirect blocks mapped file.  If
> we have managed to keep all of the indirect blocks close together at
> the beginning of the flex_bg, and if we have indeed succeeded in
> keeping the data blocks contiguous on disk, then sucking in all of the
> indirect blocks and distilling it into a few extent status cache
> entries might be the best way to accelerate performance.

The seek to get to the indirect blocks is still a cost that is not present 
in ext3, meaning that the bar is pretty high to avoid a regression.

> If we can keep the data blocks for the multi-gigabyte file completely
> contiguous on disk, then all of the indirect blocks (or extent tree)
> can be stored in memory in a single 40 byte data structure.  (Of
> course, with a legacy ext3 file system layout, the 128 megs or so the
> data blocks will be broken up by the block group metadata --- this is
> one of the reasons why we implemented the flex_bg feature in ext4, to
> relax the requirement that the inode table and allocation bitmaps for
> a block group have to be stored in the block group.  Still, using 320
> bytes of memory for each 1G file is not too shabby.)

The files I'm dealing with are usually 8MB in size, and there can be up 
to 1 million of them.  In such a use-case, I don't expect the inodes will 
always remain cached in memory (some of the systems involved only have 
4GB of RAM), so adding another metadata cache won't fix the regression.  
The crux of the issue is that the indirect blocks are getting placed many 
*megabytes* away from the data blocks.  Incurring a seek for every 4MB 
of data read seems pretty painful.  Putting the metadata closer to the 
data seems like the right thing to do.  And it should help the random 
i/o case as well.

		-ben

> That way, we get the best of both worlds; because the indirect blocks
> are close to each other (instead of being inline with the data blocks)
> things like deleting the file will be fast.  But so will precaching
> all of the logical->physical block data, since we can read all of the
> indirect blocks in at once, and then store it in memory in a highly
> compacted form in the extents status cache.
> 
> Regards,
> 
> 					- Ted

-- 
"Thought is the essence of where you are now."
