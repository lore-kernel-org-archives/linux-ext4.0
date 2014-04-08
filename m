From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [heads-up][RFC] ext4_file_write() breakage
Date: Mon, 7 Apr 2014 22:01:12 -0400
Message-ID: <20140408020112.GA19462@thunk.org>
References: <20140403163739.GR18016@ZenIV.linux.org.uk>
 <20140404025558.GB2525@thunk.org>
 <20140404061107.GS18016@ZenIV.linux.org.uk>
 <20140405031507.GA18456@thunk.org>
 <20140405043243.GT18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51357 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbaDHCBQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 22:01:16 -0400
Content-Disposition: inline
In-Reply-To: <20140405043243.GT18016@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 05, 2014 at 05:32:43AM +0100, Al Viro wrote:
> 
> char *p = (char *)mmap(NULL, 8192, PROT_READ | PROT_WRITE, MAP_ANON, -1, 0);
> struct iovec v[8];
> memset(p, 'a', 4096);
> munmap(p + 4096, 4096);
> for (int i = 0; i < 8; i++)
> 	v[i] = (struct iovec){p + i * 512, 512};
> v[1].iov_base = p + 4096;	/* unmapped */
> 
> The rest of feeding v to aio (with AIO_PWRITEV) is left as an exercise.
> 
> v[0] points to 512 bytes of RAM, all present (and filled with 'a').
> v[1] points to the memory we'd just munmapped; trying to dereference it
> would segfault, passing it to write() would give -EFAULT and passing the
> entire array to writev(2) will result in short write - 512 bytes (all 'a')
> written to file, return value is 512.

It's hard for me to stare the direct I/O code without my eyes
bleeding, but I'm not sure that we're not causing corruption for
another reason, without even needing to race.

If we have an error leading to a short write, after we bail out, we
don't zero the the rest of the block, but it looks like we also won't
clear the uninitialized bit, which means even though we would have
written out the short write, an attempt to read back of the file
should lead to all zeros.  I'll need to write some test cases to make
sure whether we're doing the right thing or not, but I'm worried we're
screwing up there.

Fortunately most DIO users tend to page align their buffers out of
paranoia, and they're not deliberately trying to induce failures and
check to make sure the failures are correct.


I do think we should force the use of the ext4_aio_mutex() if the file
is opened O_APPEND.  That way we force serialization if the DIO is
unaligned or in the O_APPEND case, which should fix a number of
problems.

						- Ted
