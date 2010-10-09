From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
Date: Sat, 9 Oct 2010 14:03:58 -0400
Message-ID: <20101009180357.GG18454@thunk.org>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45085 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab0JISED (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 14:04:03 -0400
Content-Disposition: inline
In-Reply-To: <1286583147-14760-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 09, 2010 at 02:12:24AM +0200, Jan Kara wrote:
> 
>   currently, when mmapped write is done to a file backed by ext3, the
> filesystem does nothing to make sure blocks will be available when we need
> to write them out.

Hmm, you've done all of this work already, so this isn't the best time
to suggest this, but I wonder if we've explored all of the
alternatives that might allow for a less drastic set of changes to
ext3, just out of stability's sake.

How often do legitimate workloads mmap a sparse file then write into
it?  As I recall, the original POSIX.1 spec didn't allow mmap beyond
the end of the file; this I believe was lifted later on (at least I
don't see it in SUSv3 spec).

If it's not all that common, then other options are:

1) Fail an mmap with EINVAL if there is an attempt to map a file
region which is either sparse or extends beyond the end of a file.
This is probably not a great alternative, but it's a possibility.

2) Allocate all of the pages that are not allocated at mmap time.
Since ext3 doesn't have space for an uninitialized bit, we'd have to
either (2a) forcing a disk write out for all of the newly initialized
pages, or (2b) keep track of the allocated disk blocks in memory, but
don't actually write the block mappings to the indirect blocks until
the blocks are actually written out.  (This last might be just as
complex, alas).

3) Keep a global counter of sparse blocks which are mapped at mmap()
time, and update it as blocks are allocated, or when the region is
freed at munmap() time.

#3 might be much simpler, at the end of the day.  Note that there are
some Japanese customers that really freaked with ext4 just because it
was *different*, and begged a distribution not to ship ext4 because it
might destablize their customers.  Not that I think we are obliged to
listen to some of the more extremely conservative customers, but there
was something nice about telling people (well, if you want something
which is nice and stable and conservative, you can pick ext3).

Do really have legitimate and common workloads which are allocating
blocks by writing into an mmapped region?  I wasn't aware of such
beasts, but maybe they are out there...

					- Ted
