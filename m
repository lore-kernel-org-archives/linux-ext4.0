From: Tao Ma <tao.ma@oracle.com>
Subject: Re: fiemap is broken for sparse file in ext4?
Date: Fri, 11 Jun 2010 13:05:32 +0800
Message-ID: <4C11C41C.9070000@oracle.com>
References: <4C119C2E.2090801@oracle.com> <4C11B6D8.8070909@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040202060109010804080907"
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:21427 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0FKFGu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jun 2010 01:06:50 -0400
In-Reply-To: <4C11B6D8.8070909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040202060109010804080907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,
	Thanks for the quick response.

On 06/11/2010 12:08 PM, Eric Sandeen wrote:
> Tao Ma wrote:
>> Hi Ted and other ext4 gurus,
>>      I found fiemap may be broken for sparse files in ext4. Here is a
>> simple example.
>>
>> dd if=/dev/zero of=testfile1 bs=1M count=1
>> using fiemap shows that it has a delalloc extent.
>> Logical: 0 Ext length: 1048576    Physical: 0    flags: 7
>>
>> flags 7 means FIEMAP_EXTENT_LAST, FIEMAP_EXTENT_UNKNOWN and
>> FIEMAP_EXTENT_DELALLOC,
>>
>> while if we create a sparse file, fiemap will not show the delalloc extent.
>> dd if=/dev/zero of=testfile1 bs=1M count=1 seek=1
>> using fiemap shows that it has no extent for the file. while we should
>> have some output like:
>> Logical: 1048576 Ext length: 1048576    Physical: 0    flags: 7
>>
>> So we have different output with sparse and non-sparse file. Is it a bug
>> for ext4?
>
> What are you using to call fiemap?  Here it seems to be working:
I just wrote a simple test program by calling ioctl. It is attached. 
btw, you need to call it immediately after dd so that we have a chance 
that ext4 don't have time to allocate extents. ;)
>
> # dd if=/dev/zero of=testfile1 bs=1M count=1 seek=1;
>
> # filefrag -v testfile1
> Filesystem type is: ef53
> Filesystem cylinder groups is approximately 119
> File size of testfile1 is 2097152 (512 blocks, blocksize 4096)
>   ext logical physical expected length flags
>     0     256   151946               1 merged
>     1     257   151951   151946      2 merged
>     2     259   152434   151952    253 merged,eof
> testfile1: 4 extents found
I guess maybe filefrag use the diffrent ioctl flag, maybe 
FIEMAP_FLAG_SYNC to let ext4 sync first.

Regards,
Tao

--------------040202060109010804080907
Content-Type: text/x-csrc;
 name="fiemap.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fiemap.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

#include "fiemap.h"

#define FS_IOC_FIEMAP	_IOWR('f', 11, struct fiemap)

static unsigned int num_extents	= 1024;
static unsigned int estimate_extents = 1;

static unsigned long long map_start = 0ULL;
static unsigned long long map_len = FIEMAP_MAX_OFFSET;
static char *fname;
static unsigned int blocksize = 4096;

static void usage(void)
{
	printf("Usage: fiemap filename\n");
	exit(1);
}

static void print_extent(struct fiemap_extent *extent)
{
	__u64 val;

	printf("Logical: ###[%8"PRIu64"]\t", extent->fe_logical);
	printf("Ext length: ###[%8"PRIu64"]\t", extent->fe_length);
	printf("Physical: ###[%8"PRIu64"]\t", extent->fe_physical);
	printf("flags: %u\t", extent->fe_flags);

	if (extent->fe_flags & FIEMAP_EXTENT_SHARED)
		printf("Yeah, found an shared extent\n");
	if (extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
		printf("Yeah, you are hole?\n");

	printf("\n");
}

static void show_results(struct fiemap *fiemap)
{
	int i;

	printf("Extents returned: %u\n", fiemap->fm_mapped_extents);
	if (fiemap->fm_extent_count == 0 || fiemap->fm_mapped_extents == 0)
		return;

	for (i = 0; i < fiemap->fm_mapped_extents; i++)
		print_extent(&fiemap->fm_extents[i]);

}

static int
figure_extents(int fd, unsigned int *num)
{
	int ret;
	struct fiemap fiemap = { 0, };

	fiemap.fm_start = map_start;
	fiemap.fm_length = map_len;
	fiemap.fm_flags = 0;

	ret = ioctl(fd, FS_IOC_FIEMAP, &fiemap);
	if (ret == -1) {
		fprintf(stderr, "fiemap get count error %d: \"%s\"\n", errno,
			strerror(errno));
		return -1;
	}

	*num = fiemap.fm_mapped_extents;

	return 0;
}

int
main(int argc, char **argv)
{
	int ret, fd;
	struct fiemap *fiemap;

	fd = open(argv[1], O_RDONLY);
	if (fd == -1) {
		fprintf(stderr, "open error %d: \"%s\"\n", errno,
			strerror(errno));
		return -1;
	}

	if (figure_extents(fd, &num_extents))
		return -1;

	printf("Extents in file \"%s\":    %u\n", argv[1], num_extents);

	fiemap = malloc(sizeof(fiemap) +
			num_extents * sizeof(struct fiemap_extent));
	if (fiemap == NULL) {
		fprintf(stderr, "malloc error %d: \"%s\"\n", errno,
			strerror(errno));
		return -1;
	}

	fiemap->fm_start = map_start;
	fiemap->fm_length = map_len;
	fiemap->fm_extent_count = num_extents;

	ret = ioctl(fd, FS_IOC_FIEMAP, fiemap);
	if (ret == -1) {
		if (errno == EBADR) {
			fprintf(stderr, "Kernel does not support the flags: 0x%x\n",
				fiemap->fm_flags);
			return -1;
		}
		fprintf(stderr, "fiemap error %d: \"%s\"\n", errno,
			strerror(errno));
		return -1;
	}

	show_results(fiemap);

	close(fd);

	return 0;
}

--------------040202060109010804080907--
