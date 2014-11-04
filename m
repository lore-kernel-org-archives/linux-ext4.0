From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6] RFC: (partially) endian-annotate e2fsprogs
Date: Tue, 4 Nov 2014 11:34:07 -0500
Message-ID: <20141104163407.GA30614@thunk.org>
References: <54497296.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38272 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbaKDQeM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:34:12 -0500
Content-Disposition: inline
In-Reply-To: <54497296.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 23, 2014 at 04:26:46PM -0500, Eric Sandeen wrote:
> This is really only partial, and in the end didn't spot any
> actual problems.  And things are a bit odd and tricky, because
> some structures (superblocks, inodes, etc) are swapped in-place
> in the same structure (so they can't be easily annotated - 
> if we wish to, we should define separate on-disk and in-memory
> structures).
> 
> Further, i_block in the inode is sometimes swapped on read, and
> sometimes not (!), depending on whether it's indirect blocks,
> extents, or inline data.  So that's still messy too.
> 
> So this is really just kind of an RFC; I did it on a whim, and
> things aren't yet totally sparse-check clean, but figured I'd send
> it out and see what people think, whether it's worth merging,
> or working on cleaning up the above issues to make it all tidier.
> 
> (sparse is pretty good at looking for casts in and out of blk64_t
> too, though I haven't looked much at those.)

I've applied all of these patches, thanks.  I'm not sure how much we
can clean up some of the rest of the bits without breaking the library
ABI, and we're not all that sparse-clean to start, so I think it's
worth merging now.  We can always do more clean ups (both with sparse,
or gcc-wall, clang, etc.) as people have time.

Thanks!!

						- Ted
