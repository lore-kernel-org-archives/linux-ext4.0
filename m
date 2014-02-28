From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Fri, 28 Feb 2014 12:18:19 -0800
Message-ID: <20140228201819.GA9875@birch.djwong.org>
References: <20140130235044.31064.38113.stgit@birch.djwong.org>
 <20140130235058.31064.21096.stgit@birch.djwong.org>
 <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca>
 <20140131135325.GF7118@thunk.org>
 <530F6FFC.4040903@ubuntu.com>
 <20140228022826.GA31809@thunk.org>
 <E7F923E4-91D6-4F9B-97CD-0A4C305EC507@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Phillip Susi <psusi@ubuntu.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17553 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaB1US3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Feb 2014 15:18:29 -0500
Content-Disposition: inline
In-Reply-To: <E7F923E4-91D6-4F9B-97CD-0A4C305EC507@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 28, 2014 at 11:54:55AM -0700, Andreas Dilger wrote:
> On Feb 27, 2014, at 7:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Thu, Feb 27, 2014 at 12:03:56PM -0500, Phillip Susi wrote:
> >> 
> >> Why build your own cache instead of letting the kernel take care of
> >> it?  I  believe the IO elevator already gives preferential treatment
> >> to blocking reads so just using readahead() to prefetch and sticking
> >> with plain old read() should work nicely.
> > 
> > The reason why it might be better for us to use our own cache is
> > because we can more accurately know when we're done with the block,
> > and we can drop it from the cache.

But if we accurately know when we're done with the block, we can also ask the
kernel to drop the block from its cache.

> One argument in favour of using the kernel buffer cache is that the
> common case of e2fsck followed by mounting the filesystem would be
> much faster because e2fsck has already populated the kernel cache.
> Otherwise, all of the IO done to populate the userspace cache would
> be lost when e2fsck exits.  Similarly, repeated runs of e2fsck would
> not see any benefit of the userspace cache.

I tend to agree with this.

> > I suppose we could use posix_fadvise(POSIX_FADV_DONTNEED) --- and
> > hopefully this works on block devices for the buffer cache, but it
> > wouldn't all surprise me that if we can get finer-grained control if
> > we use O_DIRECT and manage the buffers ourselves.  Whether it's worth
> > the extra complexitry is a fair question --- but simply adding
> > metadata prefetching is going to add a fair amount of complexity

It's not too much churn; here's the diffstat from my patches:
21 files changed, 723 insertions(+), 8 deletions(-)

I was attempting to write the smallest readahead implementation I could get
away with.  I noticed that unix_io.c already implements a simplistic 8-block
cache, but it doesn't have the notion of readahead.  The kernel provides the
fadvise knob for readahead, so if it really worked as advertised, why not use
that?

I further thought that regardless of whether I use fadvise or build out
unix_io's cache, we'd probably want a way to asynchronously (pre)fetch large
chunks of metadata anyway.  unix_io is pretty terrible about threaded IO (the
lseek+read/write are not thread safe), which means I'd probably have to make
them thread safe if I wanted any significant threaded RA ability.  I actually
converted unix_io to use pread/pwrite if available as part of that work, and
I'll send that patch along in case anyone wants to reduce system call
overhead.

The fadvise approach avoids most of that thread safety requirement.  I tried to
write the prefetch code carefully enough not to modify any of the data
structures fed into it, and let the kernel take care of all the details of
threaded IO.  At worst, fadvise ignores e2fsck and we lose nothing.

> > already, and we should test to make sure that readahead() and
> > posix_fadvise() actually work correctly on block devices --- a couple
> > of years ago, I had explored readahead() precisely as a cheap way of
> > adding metadata precaching for e2fsck, and it was a no-op when I tried
> > the test back then.

(See below)

> We tested several different mechanisms for readahead a few years ago
> for the e2scan tool, and that resulted in the readahead patch that
> Darrick updated recently.  It definitely shows performance improvement.
> 
> Whether POSIX_FADV_DONTNEED actually flushes pages from cache is a
> separate question.  My preference would be that if this is currently
> a no-op that we work to fix it in the kernel so that it is working
> for everyone rather than investing time and effort into code that is
> only useful for e2fsprogs.

I wrote a test program[1] that WILLNEED's 256M and then DONTNEED's it, and saw
these results (on 3.14-rc4):

Before WILLNEED
             total       used       free     shared    buffers     cached
Mem:       2049412      83764    1965648          0          0      14124
-/+ buffers/cache:      69640    1979772
Swap:            0          0          0
After WILLNEED
             total       used       free     shared    buffers     cached
Mem:       2049412     346304    1703108          0     262144      14148
-/+ buffers/cache:      70012    1979400
Swap:            0          0          0
Sleeping for 30 seconds...
             total       used       free     shared    buffers     cached
Mem:       2049412     346236    1703176          0     262144      14180
-/+ buffers/cache:      69912    1979500
Swap:            0          0          0
After DONTNEED
             total       used       free     shared    buffers     cached
Mem:       2049412      77112    1972300          0          0      14160
-/+ buffers/cache:      62952    1986460
Swap:            0          0          0
Sleeping for another 30 seconds...
             total       used       free     shared    buffers     cached
Mem:       2049412      76752    1972660          0          0      14180
-/+ buffers/cache:      62572    1986840
Swap:            0          0          0

Based on that, it looks as though the two fadvise calls actually work, at least
on a quiet system.

--D

[1] test program:

/* Test RA */
#define _XOPEN_SOURCE 600
#define _DARWIN_C_SOURCE
#define _FILE_OFFSET_BITS 64
#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int fd, ret = 0;

	if (argc != 2 || strcmp(argv[1], "--help") == 0) {
		printf("Usage: %s device\n", argv[0]);
		return 0;
	}

	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		perror(argv[1]);
		goto fail;
	}

	ret = system("echo 3 > /proc/sys/vm/drop_caches");
	if (ret)
		goto fail2;

	printf("Before WILLNEED\n");
	ret = system("free");
	if (ret)
		goto fail2;

	ret = posix_fadvise(fd, 0, 256 * 1048576, POSIX_FADV_WILLNEED);
	if (ret)
		goto fail2;

	printf("After WILLNEED\n");
	ret = system("free");
	if (ret)
		goto fail2;

	printf("Sleeping for 30 seconds...\n");
	sleep(30);
	ret = system("free");
	if (ret)
		goto fail2;

	ret = posix_fadvise(fd, 0, 256 * 1048576, POSIX_FADV_DONTNEED);
	if (ret)
		goto fail2;

	printf("After DONTNEED\n");
	ret = system("free");
	if (ret)
		goto fail2;

	printf("Sleeping for another 30 seconds...\n");
	sleep(30);
	ret = system("free");
	if (ret)
		goto fail2;

fail2:
	close(fd);
fail:
	if (ret)
		perror(argv[1]);
	return ret;
}
