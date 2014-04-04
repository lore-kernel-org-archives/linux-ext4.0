From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [heads-up][RFC] ext4_file_write() breakage
Date: Fri, 4 Apr 2014 07:11:07 +0100
Message-ID: <20140404061107.GS18016@ZenIV.linux.org.uk>
References: <20140403163739.GR18016@ZenIV.linux.org.uk>
 <20140404025558.GB2525@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35380 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaDDGLJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2014 02:11:09 -0400
Content-Disposition: inline
In-Reply-To: <20140404025558.GB2525@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 03, 2014 at 10:55:59PM -0400, Theodore Ts'o wrote:
> On Thu, Apr 03, 2014 at 05:37:39PM +0100, Al Viro wrote:
> > 2) simply looking at file size in O_APPEND case instead of pos would not
> > close that one - file size is unstable at that point (we don't have any
> > locks held here).
> > 
> > 3) ext4_unaligned_aio() suffers the same problem, but that's *not* the
> > only issue with it.
> 
> So basically, we'll have to take i_mutex in order to check the file
> size, which means there's no point with the ext4_unaligned_aio()
> logics.  We can just take the i_mutex and then do the tests based on
> i_size in ext4_file_dio_write()

Can you hold it across ext4_unwritten_wait(), though?

> >  It checks that (O_DIRECT) aio write tries to hit
> > something aligned only to hw sector and not to block size.  Fine, but...
> > think what rlimit will do to us.  generic_write_checks() contains this:
> > 
> > 	unsigned long limit = rlimit(RLIMIT_FSIZE);
> > 	....
> > 		if (limit != RLIM_INFINITY) {
> > 			if (*pos >= limit) {
> > 				send_sig(SIGXFSZ, current, 0);
> > 				return -EFBIG;
> > 			}
> > 			if (*count > limit - (typeof(limit))*pos) {
> > 				*count = limit - (typeof(limit))*pos;
> > 			}
> > 		}
> > 
> > and it's done only after we'd called ext4_unaligned_aio().  
> 
> Can we solve these problem by simply doing these tests in
> ext4_file_dio_write(), so we modify pos/couint before we do the
> ext4_unaligned_aio() checks?  We don't need i_mutex to do these
> particular tests, right?

Yes, we do - O_APPEND, again ;-/

> > So it doesn't
> > predict whether the iovec seen by ->direct_IO() will be unaligned - there
> > are false negatives.  Even worse, consider an iovec that consists of
> > 8 segments, 512 bytes each.  Starting offset in file is a multiple of block
> > size.  Everything's fine from ext4_unaligned_aio() POV, right?  And from
> > fs/direct-io.c one it's only sector-aligned sucker.  For a good reason,
> > since a segment in the middle of that thing might very well point to unmapped
> > memory, which will mean short write, with all zeroing issues ext4 is trying
> > to avoid here.
> 
> I'm not sure I understand the concern here.  The zeroing issues we're
> concerned about is when two threads need to work on the same unwritten
> block.  So if the pos and size are block aligned, this can't heppen.
> What am I missing?

Thread A: write at offset 40M+512.  Unaligned as far as ext4_unaligned_aio()
is concerned, so it takes that mutex.

Thread B: write at offset 40M, with 8 512-byte segments in iovec.  The second
segment points to munmapped memory.  Same as 512-byte write at the same offset,
but not from the ext4_unaligned_aio() point of view.  It does *not* wait
for unwritten blocks resulting from A to be dealt with.

Area around 40M is still unwritten.  Apply Eric's scenario from the commit
that has introduced the whole "we need exclusion on unaligned aio" thing...

That, BTW, is one of the areas where we rely on blocks being less than
page-sized.  Aligned iovec will *not* have page boundaries inside the
pieces that will go into one block, so there we are guaranteed that we
won't end up with sub-block writes when we hit a VMA boundary in the
memory area we are trying to write from.

If iovec elements are not block-aligned, we can run into a short write due
to that effect.  And short write ending in the middle of a new block would
bloody better make sure to zero the rest of that block out, for obvious
reasons...

The mess happens if we have zero-the-rest-of-new-block logics trigger when
that block is, in reality, not new anymore.  I.e. when we have an earlier
write that has already returned from ->aio_write(), but still hasn't reached
the IO completion.  That's what this ext4_unwritten_wait(inode) is about,
as far as I understand the whole thing.
