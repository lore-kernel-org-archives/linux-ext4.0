From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A proposal for making ext4's journal more SMR (and flash)
 friendly
Date: Thu, 9 Jan 2014 08:41:02 -0500
Message-ID: <20140109134102.GA18972@thunk.org>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
 <22006ACD-BC60-4462-B000-CB121DC26FBE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47058 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaAINlH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jan 2014 08:41:07 -0500
Content-Disposition: inline
In-Reply-To: <22006ACD-BC60-4462-B000-CB121DC26FBE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 08, 2014 at 08:55:30PM -0700, Andreas Dilger wrote:
> Since even small flash drives are in the 10s of GB in size, it would be
> very useful to use them for log-structured writes to avoid seeks on the
> spinning disks.  One would certainly hope that in the age of multi-TB
> SMR devices that manufacturers would be smart enough to include a few GB
> of flash/NVRAM on board to take the majority of the pain away from using
> SMR directly for anything other than replacements for tape drives.

Certainly, if we could have, say, 1GB per TB of flash that was
accessible to the OS (i.e., not used for SMR's internal physical to
logical mapping), this would be a huge help.

> One important change needed for ext4/jbd2 is that buffers in the journal
> can be unpinned from RAM before they are checkpointed.  Otherwise, jbd2
> requires potentially as much RAM as the journal size.  With a flash or
> NVRAM journal device that is not a problem to do random reads to fetch
> the data blocks back if they are pushed out of cache.  With an SMR disk
> this could potentially be a big slowdown to do random reads from the
> journal just at the same time that it is doing random checkpoint writes.

There's another question that this brings up.  Depending on how:

	* Whether the journal is in flash or not
	* How busy the SMR drive is
	* The likelihood that the block will need to be modified in the future

etc., we may be better off forcing that block to its final location on
disk, instead of letting it get pushed out of memory, only to have to
reread it back in when it comes time to checkpoint the file.

For example, if we are unpacking a large tar file, or the distribution
is installing a large number of files, once an inode table block is
filled, we probably won't need to modify it in the future (modulo
atime updates[1]) so we probably should just write it to the inode table
at that point.  (Or we could possibly wait until we have multiple
consecutive inode table blocks, and then write them all to the disk at
the sasme time.)

But in order to do this, we need to have something different from LRU
--- we actually need to track LRM: "least recently modified", since it
doesn't matter if a directory block is getting referenced a lot; if it
hasn't been modified in a while, and we have a series of adjacent
blocks that are all ready to be written out, maybe we should more
aggressively get them out to the disk, especially if the disk is
relatively idle at the moment.

> Similarly, with NVRAM journal there is no need to order writes inside
> the journal, but with SMR there may be a need to "allocate" blocks in
> the journal in some sensible order to avoid pathalogical random seeks
> for every single block.  I don't think it will be practical in many
> cases to pin the buffers in memory for more than the few seconds that
> JBD already does today.

Determining the best order to write the blocks into the journal at
commit time is going to be tricky since we want to keep the layering
guarantees between the jbd2 and ext4 layers.  I'm also not entirely
sure how much this will actually buy us.  If we are worrying about
seeks when we need to read related metadata blocks, if the blocks are
used frequently, the LRU algorithms wil keep them in memory, so this
is really only a cold cache startup issue.  Also, if we think about
the most common cases where we need to read multiple metadata blocks,
it's the case of a directory block followed by an inode table block,
or an inode table block followed by an extent tree block.  In both of
these cases, the blocks will be "close" to one another, but there is
absolutely no guarantee that they will be adjacent.  So reordering the
blocks within the tens or hundreds of blocks that need to be written
as part of the journal commit may not be something that's worth a lot
of complexity.  Just by virtue of the fact that they are located
within the same commit means that the metadata blocks will be "close"
together.

So I think this is something we can look at as a later optimization /
refinement.

The first issue which you raised, that of handling the case where a
buffer that hasn't yet been checkpointed is under memory pressure and
how do we handle it, is also an optimization question, but I think
that's a higher priority item for us to consider.

Cheers,

							- Ted


[1] Another design tangent: with SMR drives, it's clear that atime
updates are going to be a big deal.  So the question is how much will
our users really care about atime.  Can we just simply say, "use
noatime", or should we think about some way of handling atime updates
specially?  (For example, we could track atime updates separately, and
periodically include in the journal a list of inode numbers and their
real atimes.)  This is not something we should do early on --- it's
another later optional enhancement --- but it is something to think
about.

