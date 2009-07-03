From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Improve consistency check of uninit block
	group and some cleanup
Date: Fri, 3 Jul 2009 11:17:24 -0400
Message-ID: <20090703151724.GE15038@mit.edu>
References: <4A4C450C.6060808@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36317 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZGCPRd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jul 2009 11:17:33 -0400
Content-Disposition: inline
In-Reply-To: <4A4C450C.6060808@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Kazuya-san,

Many thanks for sending this patch.   Couple of comments about it.

1) Please send clean-up patches separately.  The "remove unnecessary
continue statement" I could easily separate out, but it wasn't
immediately obvious what "fix loop counter properly" was all about.

2) Requiring the allocation of a zero buffer to be passed into
ext2fs_test_bits() is *really* ugly.  I'll note that the only reason
why it's faster to use memcmp() is because the C compiler has
optimized it so that it can use custom assembly that can compare the
memory block 32 bits at a time, after accounting for alignment
restrictions.  In fact, comparing one block of memory against another
block of known-zero memory should trash our D-cache, and in theory it
should be faster to simply check the block of memory for non-zero
bytes.

In addition, in the future (see the 64-bit e2fsprogs patches in the
'pu' branch), bitmaps will be hidden behind an abstraction, so testing
against a known block isn't going to be easy or convenient; but having
an ext2fs_test_zero_range() does make a lot of sense.  (For example,
if we use a AVL tree with extent encodings for a compact in-memory
bitmap representation to save memory usage for very large filesystems,
implementing ext2fs_test_zero_range() might be trivially easy)

So what I would suggest doing is to use the mem_is_zero() function
defined in the attached test program.  This way at least we don't have
to pass in a huge chunk of zero-ed memory.  If we really cared we
could write optimized x86 and x86-64 assembly that further optimized
mem_is_zero(), but this is probably good enough for now.  I did some
testing, and it looks like that 256 bytes seems to minimize the loop
overhead, and gives us a win in terms of minimizing the D-cache used
for zero-buffer --- and 256 bytes is small enough that we can afford
to simply use a statically allocated zero buffer, so we don't have to
pass it into the library function.

Do you think you could make these changes and resend the patch?
Thanks,

						- Ted

#include <unistd.h>
#include <stdio.h>

#include <sys/time.h>
#include <sys/resource.h>
#include <string.h>

struct resource_track {
	struct timeval time_start;
	struct timeval user_start;
	struct timeval system_start;
};

void init_resource_track(struct resource_track *track)
{
	struct rusage r;

	gettimeofday(&track->time_start, 0);
	getrusage(RUSAGE_SELF, &r);
	track->user_start = r.ru_utime;
	track->system_start = r.ru_stime;
}

#ifdef __GNUC__
#define _INLINE_ __inline__
#else
#define _INLINE_
#endif

static _INLINE_ float timeval_subtract(struct timeval *tv1,
				       struct timeval *tv2)
{
	return ((tv1->tv_sec - tv2->tv_sec) +
		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
}

void print_resource_track(const char *desc, struct resource_track *track)
{
	struct rusage r;
	struct timeval time_end;

	gettimeofday(&time_end, 0);

	if (desc)
		printf("%s: ", desc);

	getrusage(RUSAGE_SELF, &r);

	printf("time: %5.2f/%5.2f/%5.2f\n",
	       timeval_subtract(&time_end, &track->time_start),
	       timeval_subtract(&r.ru_utime, &track->user_start),
	       timeval_subtract(&r.ru_stime, &track->system_start));
}

int mem_is_zero(const char *mem, size_t len)
{
	static const char zero_buf[256];

	while (len >= sizeof(zero_buf)) {
		if (memcmp(mem, zero_buf, sizeof(zero_buf)))
			return 0;
		len -= sizeof(zero_buf);
		mem += sizeof(zero_buf);
	}
	/* Deal with leftover bytes. */
	if (len)
		return !memcmp(mem, zero_buf, len);
	return 1;
}

int mem_is_zero2(char *p, unsigned len)
{
	while (len--)
		if (*p++)
			return 0;
	return 1;
} 

#define LEN 4096

char	a[LEN], b[LEN];

main(int argc, char **argv)
{
	struct resource_track	r;
	int			i, j;

	memset(a, 0, LEN);
	memset(b, 0, LEN);

	init_resource_track(&r);
	for (i=0; i < 102400; i++)
		if (memcmp(a, b, LEN))
			printf("a is non-zero\n");
	print_resource_track("memcmp", &r);

	init_resource_track(&r);
	for (i=0; i < 102400; i++)
		if (!mem_is_zero(a, LEN))
			printf("a is non-zero\n");
	print_resource_track("mem_is_zero", &r);

	init_resource_track(&r);
	for (i=0; i < 102400; i++)
		if (!mem_is_zero2(a, LEN))
			printf("a is non-zero\n");
	print_resource_track("mem_is_zero2", &r);

}
