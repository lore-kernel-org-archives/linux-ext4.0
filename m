From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and
 3.11.7
Date: Thu, 16 Jan 2014 14:12:27 -0500
Message-ID: <20140116191227.GC32098@thunk.org>
References: <20140115192802.GK21295@kvack.org>
 <20140115202214.GH9229@birch.djwong.org>
 <20140115203205.GA12751@kvack.org>
 <20140115215613.GD12751@kvack.org>
 <20140116035459.GB14736@thunk.org>
 <20140116184826.GG12751@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49132 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaAPTMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jan 2014 14:12:32 -0500
Content-Disposition: inline
In-Reply-To: <20140116184826.GG12751@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 16, 2014 at 01:48:26PM -0500, Benjamin LaHaise wrote:
> 
> Any idea when this commit was made or titled?  I care about random 
> performance as well, but that can't be at the cost of making sequential 
> reads suck.

Thinking about this some more, I think it was made as part of the
changes to better take advantage of the flex_bg feature in ext4.  The
idea was to keep metadata blocks such as directory blocks and extent
trees closer together.  I don't think when we made that change we
really consciously thought that much about indirect block support,
since that was viewed as a legacy feature for backwards compatibility
support in ext4.  (This was years ago, before distributions started
wanting to support only one code base for ext3 and ext4 file systems.)

I *know* we've had this discussion about whether to put the indirect
blocks inline with the data, or closer together to speed up metadata
operations (i.e., unlink, fsck, etc.) before, though.  There was a
patch against ext3 I remember looking at which forced the indirect
blocks to the end of the previous block group.  That kept the indirect
blocks closer together, and on average 64MB away from the data blocks.
As I recall, the stated reason for the patch was to make unlinks of
backups of DVD images not take forever and a day.

I'm pretty sure we've had it at least once on the weekly ext4
concalls, and I'm pretty sure we've had it one hallway track or
another.  Ultimately, extents are such a huge win that it's not clear
it's really worth that much effort to try to optimize indirect blocks,
which are a lose no matter how you slice and dice things.

> The files I'm dealing with are usually 8MB in size, and there can be up 
> to 1 million of them.  In such a use-case, I don't expect the inodes will 
> always remain cached in memory (some of the systems involved only have 
> 4GB of RAM), so adding another metadata cache won't fix the regression.  
> The crux of the issue is that the indirect blocks are getting placed many 
> *megabytes* away from the data blocks.  Incurring a seek for every 4MB 
> of data read seems pretty painful.  Putting the metadata closer to the 
> data seems like the right thing to do.  And it should help the random 
> i/o case as well.

An 8MB file will require two indirect blocks.  If you are using
extents, almost certainly it will fit inside the inode, which means we
don't need any external metadata blocks.  That massively speeds up
fsck time, and unlink time, and it also speeds up the random read case
since the best way to optimize a seek is to eliminate it.  :-)

I understand that for your use case, it would be hard to move to using
extents right away.  But I think you'd see so many improvements from
going to ext4 and extents that it might be more efficient to optimize
an indirect blocok scheme.

						- Ted
