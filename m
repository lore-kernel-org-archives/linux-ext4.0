From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/1] e2fsprogs: Add undo I/O manager.
Date: Wed, 6 Jun 2007 08:02:18 -0400
Message-ID: <20070606120218.GC32603@thunk.org>
References: <4c7823c85d4ea3b4535f9fc0e4afa93078317f81.1179828850.git.aneesh.kumar@linux.vnet.ibm.com> <20070603231701.GA10140@thunk.org> <46668633.7060403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49651 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569AbXFFMCe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jun 2007 08:02:34 -0400
Content-Disposition: inline
In-Reply-To: <46668633.7060403@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 06, 2007 at 03:32:27PM +0530, Aneesh Kumar K.V wrote:
> 
> If we allow to change the block size in between that would mean the
> records that we store in the tdb database will be of variable size ( 
> different block sizes). That would also add all the code/complexity that 
> i have in is_trans_overlapping. So if we are looking at avoiding the 
> above for() loop then we should have constant block size (4K ?).  But in 
> your above statement, you are counting overhead as a percentage of 
> blocksize. So how do we handle this ?

As I suggested in my previous mail message, the block size rarely
changes (mke2fs being the primary counter-example, and then only in a
fairly restricted case).  So as far as the tdb is concerned, we have
to use a constant blocksize (the first one which is used when writing
to the i/o block).  So the undo manager would save away the blocksize
the first time it was written to --- and yes, we would have to store
that information in the tdb file so the restore program knows what
block size is used, but that's easy; just write out the blocksize that
out as an ascii number (to avoid byte swapping issues) with the key
"blocksize" :-).

Once the block size has been established, all writes to the tdb file
would be in terms of that block size.  For correctness' sake, the undo
manager would have to pass any blocksize changes to the underlying i/o
manager, and keep track of what the "current" blocksize, and if the
"current" blocksize is different from the blocksized used to store the
original contents of the filesystem in the tdb file, it would have to
translate the block numbers appropriately.  So for example if in the
tdb file everything is stored in terms of 4k blocks, and the blocksize
changes to 512, and a write to sector 23 is attempted, 23 in 512 byte
sectors is equivalent to block #5 assuming a 4k blocksize, and the
undo manager would check to see if block #5 had been saved, and if it
hadn't, it would temporarily set the blocksize of the underlying i/o
manager to 4k, read block #5, save it to the tdb, and then restore the
blocksize back to the current 512 byte blocksize.

If the tdb blocksize is 512, and the block size gets switched to 4k,
then we have to do the reverse; we would need to take the 4k block
number, translate it to 512 byte sector numbers, and then save out 8
entries in the tdb file to correspond to each 4k block that the first
time each 4k block is written.

Makes sense?  As I said, in practice this happens but rarely, so this
is just for correctness's sake, so it doesn't have to be efficient.
If necessary we can modify mke2fs to make sure the first write is the
native filesystem blocksize write, so that the undo manager will be
efficient if used with mke2fs.

> >This looks like notes to yourself; but it's not obvious what's going
> >on here.  Fortunately with the above suggested change in algorith,
> >most of this will go away, but please make your comments more obvious.
> >
> 
> rl -> req_loc
> cl -> cur_loc
> rs -> req_size
> cs -> cur_size

Yes, I could figure it out, but the point I was trying to make was
that obscure comments don't improve code readability.  When writing
comments, it's polite to think in terms of a future reader of the
code.  (As E.B. White wrote in the introduction of the classic, 'The
Elements of Style' by Oliver Strunk, "All through 'The Elements of
Style', one finds evidence of the author's deep sympathy for the
reader."  This general philosophy applies just as much to code as it
does to English prose.)

So if it really is necessary to document the various sizes, then do
something like this:

	/* req_loc < cur_loc < req_lock+req_size < cur_loc+cur+size */

Or perhaps something more explicit in english text explaining the case
that you're dealing with --- but only if it's adding something beyond
the C code.   As others have said, this is not particularly useful:

	/* Add two to the block count */
	block_count += 2;

> >What version of e2fsprogs are you developing against?
> 
> Right now i am manually linking it against libtdb.
> 
> dpkg --search /usr/lib/libtdb.so
> tdb-dev: /usr/lib/libtdb.so

Any particular reason you're not using the development version from
Mercurial for your development?  In general it's good practice to send
patches against the latest develoment tip.  What caught my eye of that
particular comment was that it was pretty much saying that you weren't
doing that....

Thanks, regards,

						- Ted
