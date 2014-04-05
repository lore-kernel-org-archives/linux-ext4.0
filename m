From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [heads-up][RFC] ext4_file_write() breakage
Date: Fri, 4 Apr 2014 23:15:07 -0400
Message-ID: <20140405031507.GA18456@thunk.org>
References: <20140403163739.GR18016@ZenIV.linux.org.uk>
 <20140404025558.GB2525@thunk.org>
 <20140404061107.GS18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50248 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaDEDPM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2014 23:15:12 -0400
Content-Disposition: inline
In-Reply-To: <20140404061107.GS18016@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2014 at 07:11:07AM +0100, Al Viro wrote:
> > So basically, we'll have to take i_mutex in order to check the file
> > size, which means there's no point with the ext4_unaligned_aio()
> > logics.  We can just take the i_mutex and then do the tests based on
> > i_size in ext4_file_dio_write()
> 
> Can you hold it across ext4_unwritten_wait(), though?

Gah....  I'm not sure.  But ultimately, all of this is really about
O_APPEND being something horrible, right?

If we have to create a new mutex which is just used to serialized
O_APPEND writes, I'm OK with that.  The main thing that I really want
to preserve is to able to do parallel O_DIRECT writes in the the
non-O_APPEND case.

> Thread A: write at offset 40M+512.  Unaligned as far as ext4_unaligned_aio()
> is concerned, so it takes that mutex.
> 
> Thread B: write at offset 40M, with 8 512-byte segments in iovec.  The second
> segment points to munmapped memory.  Same as 512-byte write at the same offset,
> but not from the ext4_unaligned_aio() point of view.  It does *not* wait
> for unwritten blocks resulting from A to be dealt with.

Hang on a second.  What are you assuming the block size to be in this
example?  If the block size is 4k, then this doesn't make any sense,
because unmapped memory will be in units of the block size, so we
couldn't have the second 512 byte segment be unmapped.  Blocks are
unmaped, not individual 512 byte sectors.

If you are assuming the block size is 512 bytes, then it's not a
problem, since the entire block is unmapped, and dio_zero_block() can
operatate on the whole block.

(actually, ext4 doesn't support 512 byte blocks, but it does support
1024 block sizes.  but the same argument applies)

> Area around 40M is still unwritten.  Apply Eric's scenario from the commit
> that has introduced the whole "we need exclusion on unaligned aio" thing...

Right, but Eric's scneario was talking about unaligned *blocks* not
*pages*.

So his scenario was one where the block size was 4k, and the write was
unaligned with respect to the 4k block size.  For example, if with a
4k block size, we had one write starting at offset 0 with a size 512,
and at the same time another write starting at offset 2048 with a size
1024 bytes.  The problem is that we were doing two writes inside the
same *block*, and so if dio_zero_block() tried to operate on the same
block at the same time, bad things would happen.

Does that make sense?

							- Ted
