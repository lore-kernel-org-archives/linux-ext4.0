From: Daniel Phillips <phillips@phunq.net>
Subject: Re: Dot and dotdot need to be physically present?
Date: Wed, 20 Aug 2008 16:52:04 -0700
Message-ID: <200808201652.05252.phillips@phunq.net>
References: <200808131636.59436.phillips@phunq.net> <20080814034701.GC6469@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from phunq.net ([64.81.85.152]:43606 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751508AbYHTXwI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 19:52:08 -0400
In-Reply-To: <20080814034701.GC6469@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Sorry for the lag, I was a little busy.

On Wednesday 13 August 2008 20:47, Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 04:36:59PM -0700, Daniel Phillips wrote:
> > 
> > Many years ago we had a discussion about whether or not the . and ..
> > directory entries had to be physically present in htree, and I remember
> > the conclusion was that they had to be, but I forget the argument and
> > lost track of the email thread.  I think the VFS will happily supply
> > the . and .. entries to getdents on its own.  So what was the issue?
> > Something about telldir?
> 
> . and .. are needed for backwards compatibility.

Thankyou, I think I remember now.  We had to put . and .. in there to
be able to fall back from indexed to linear scan on old kernels that
know nothing about the index.  So my inclination is to leave these out
of the dirent data proper but record them in block headers for
redundancy as you suggest.

> If you aren't going 
> to do backwards compatibility, then you might as well not bother
> putting the btree in the directory nodes.  Just use physically block
> numbers directly.

Even without any backward compatibility requirement, putting the btree
into a file is a win:

  * CPU: for a terabyte volume each radix tree lookup requires 6
    dereferences (2^6 fanout) vs 0, 1 or 2 for a modest sized directory
    mapped logically in the page cache.  This matters because CPU is the
    main cost and cause of latency for big directories that are small
    enough to fit in cache.  (On page cache miss the logical mapping
    needs one extra radix tree probe, but these are orders of magnitude
    rare than hits.)

  * Index fanout for a file-mapped btree is 2^9 while a direct mapped
    btree is less, probably 2^8.  Less to load, less cache pressure.

  * Deferred allocation is harder with physical block pointers because
    you have to choose a physical address before you can put data in
    the buffer cache.  With the page cache, this decision can be
    deferred till sync time, when better information is available.

  * No need to implement new physical block goal algorithms, the file
    locality algorithms will already do the right thing (if possible!)

> The other reason why '..' is useful is that it helps to knit the
> fliesystem back together in case of corruption.  (For example, e2fsck
> uses the '..' so we can display full pathnames which is very helpful
> to system administrators.)
> 
> The '.' pointer is slightly less useful, but it is helpful as an
> additional sanity check.
> 
> If I were doing things all over in a completely incompatible way, I'd
> probably put at the beginning of the first directory block (a) a magic
> number, (b) the current inode number (as a sanity check), (c) the
> parent inode number (i.e., '..'), and (d) a pointer to a physical
> block which is the root of the index tree. 

Sensible, and I will do it much like that, but probably in every dirent
block, not just the first one.  Recording the physical root of the tree
seems like overkill since the inode number will be there, giving the
root index block via the inode table.  That is, if a physical pointer
design to be used.  For a logical mapping the directory index root is
always block zero, a simplification that is not possible with physical
pointers.

The directory index itself can be reconstructed on demand, so adding
redundancy only for fsck reconstruction does not seem like a win.  We
just want to be able to spot the raw dirents reliably.  To that end, a
commit sequence number might be helpful as well, to reduce the chance
of misinterpreting stale, migrated or data blocks.

Regards,

Daniel
