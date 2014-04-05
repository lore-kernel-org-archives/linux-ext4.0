From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [heads-up][RFC] ext4_file_write() breakage
Date: Sat, 5 Apr 2014 05:32:43 +0100
Message-ID: <20140405043243.GT18016@ZenIV.linux.org.uk>
References: <20140403163739.GR18016@ZenIV.linux.org.uk>
 <20140404025558.GB2525@thunk.org>
 <20140404061107.GS18016@ZenIV.linux.org.uk>
 <20140405031507.GA18456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:41893 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaDEEcq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Apr 2014 00:32:46 -0400
Content-Disposition: inline
In-Reply-To: <20140405031507.GA18456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2014 at 11:15:07PM -0400, Theodore Ts'o wrote:

> Hang on a second.  What are you assuming the block size to be in this
> example?  If the block size is 4k, then this doesn't make any sense,
> because unmapped memory will be in units of the block size, so we
> couldn't have the second 512 byte segment be unmapped.  Blocks are
> unmaped, not individual 512 byte sectors.

char *p = (char *)mmap(NULL, 8192, PROT_READ | PROT_WRITE, MAP_ANON, -1, 0);
struct iovec v[8];
memset(p, 'a', 4096);
munmap(p + 4096, 4096);
for (int i = 0; i < 8; i++)
	v[i] = (struct iovec){p + i * 512, 512};
v[1].iov_base = p + 4096;	/* unmapped */

The rest of feeding v to aio (with AIO_PWRITEV) is left as an exercise.

v[0] points to 512 bytes of RAM, all present (and filled with 'a').
v[1] points to the memory we'd just munmapped; trying to dereference it
would segfault, passing it to write() would give -EFAULT and passing the
entire array to writev(2) will result in short write - 512 bytes (all 'a')
written to file, return value is 512.

Unmapped memory is in 4K units, all right - and iovec elements are free to
point whereever they bloody please.  Sure, v[0].iov_base is 4K-aligned
and v[0].iov_len is 512, but that doesn't mean that v[1].iov_base can't point
into completely different page.  It does *not* have to be v[0].iov_base + 512.
That's the whole point of iovec, after all - ability to take an arbitrary
bunch of memory objects and write them all in one syscall, without having to
copy them into adjacent addresses...
