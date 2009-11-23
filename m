From: tytso@mit.edu
Subject: Re: Bug in extent zeroout: blocks not marked as new
Date: Mon, 23 Nov 2009 14:50:49 -0500
Message-ID: <20091123195049.GD2183@thunk.org>
References: <6601abe90911231017q5cf424a4s4e6c788922c336c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34806 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298AbZKWTuq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 14:50:46 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90911231017q5cf424a4s4e6c788922c336c8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 10:17:46AM -0800, Curt Wohlgemuth wrote:
> I believe I've found a bug in ext4's extent conversion design that results
> in block corruption in inodes using previously freed up metadata blocks.
> 
> (I've finally got around to understanding that the handling of old dirty
> metadata blocks is ultimately handled on the allocating side, not on the
> freeing side.  Although bforget() is called on freed up metadata blocks,
> because bforget() doesn't lock the buffer before it clears the dirty bit,
> there's a known race with the writeout path in __block_write_full_page().
> I've seen this race, and seen a block that's had bforget() called on it be
> written to disk.)

Note that these problems are much rarer (and perhaps impossible) when
journalling is enabled, because we don't allow any freed blocks to be
reused until after a transaction commit --- this prevents blocks from
getting overwritten, thus damaging existing files that don't end up
getting deleted because the system cashed before the transaction could
complete.

As a result, blocks which are deleted can't get reused immediately,
and this should defang the bforget() race that you mention.  Without
journalling we don't have this protection, so this exposes us to the
sorts of problems which you've been running into.

> The problem is that, during conversion of extents from uninitialized to
> initialized, ext4 will at some point decide that the remaining uninitialized
> extent is too small to split, and will just write zeroes for it, and mark it
> as initialized.  This is fine -- until blocks from this "14-block tail
> extent" are returned from ext4_ext_get_blocks().
> 
> The problem is that, since these blocks are not from an uninitialized
> extent, the aren't marked as "new" -- i.e., set_buffer_new() is not called
> on bh_result -- and the callers further up in the call stack don't call
> unmap_underlying_metadata() on them.

OK, I'm confused.  The corruption is that you're having blocks that
are all zeroes show up where they should be non-zero data, right?  But
in what you are describing, you should have garbage from old metadata
getting written over the newly initialized blocks --- garbage that
would have been discarded if unmap_underlying_metadata() had been
called.  But that's not what you're seeing.

Blocks from an uninitialized extent aren't new, because they've been
around for a while, and they've been attached to the inode and
allocated.  One thing we could do is call unmap_underlying_metadata
when those uninitialized blocks are *allocated*, because that's when
they their "allegiance" is transfered to the inode.  However, since we
don't care about the contents of these uninitialized blocks your
suggestion:

> The other obvious solution is to call unmap_underlying_metadata() at the
> time that we zeroout the blocks.

Is is a good one.  We should also call unmap_underlying_metadata() for
any blocks that are transitioning from uninitialized to initialized,
just in case there were any recently-freed buffers that might be
undergoing writeout.  So I agree this is a good thing to do, and it's
probably a hole that we should plug.

However, that doesn't explaining the corruption which you are seeing,
which is zero blocks showing up where they shouldn't --- since the
freed dirty metadata blocks that we would be zapping with
unmap_underlying_metadata() are highly unlikely to be all zero's.

Am I missing something?

					- Ted
