From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 extent issue when page size > block size
Date: Thu, 13 Mar 2014 22:24:28 +0100
Message-ID: <20140313212428.GE504@quack.suse.cz>
References: <5321F226.80505@fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	anton@samba.org
To: Cedric Le Goater <clg@fr.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaCMVYa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 17:24:30 -0400
Content-Disposition: inline
In-Reply-To: <5321F226.80505@fr.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 13-03-14 19:00:06, Cedric Le Goater wrote:
> While running openldap unit tests on a ppc64 system, we have had 
> issues with the cp command. cp uses the FS_IOC_FIEMAP ioctl to
> optimize the copy and it appeared that the ext4 extent list of 
> the file did not match all the data which was 'written' on disk. 
> 
> The system we use has a 64kB page size but the page size being 
> greater than the filesystem block seems to be the top level reason 
> of the problem. One can use a 1kB block size filesystem to reproduce 
> the issue on a 4kB page size system.
> 
> Attached is a simple test case from Anton, which creates extents
> as follow :
> 
> 	lseek(48K -1)		-> creates [11/1)
> 	p = mmap(128K)
> 	*(p) = 1		-> creates [0/1) with a fault
> 	lseek(128K)		-> creates [31/1) 
> 	*(p + 49K) = 1		-> creates [12/1) and then merges in [11/2) 
> 	munmap(128K)
> 	
> 
> On a 4kB page size system, the extent list returned by FS_IOC_FIEMAP 
> looks correct :
> 
> 	Extent 0: logical: 0 physical: 0 length: 4096 flags 0x006
> 	Extent 1: logical: 45056 physical: 0 length: 8192 flags 0x006
> 	Extent 2: logical: 126976 physical: 0 length: 4096 flags 0x007
> 
> 
> But, with a 64kB page size, we miss the in-the-middle extent (no page
> fault but the data is on disk) :
> 
> 	Extent 0: logical: 0 physical: 0 length: 49152 flags 0x006
> 	Extent 1: logical: 126976 physical: 0 length: 4096 flags 0x007
> 
> 
> This looks wrong. Right ? Or are we doing something wrong ? I have been 
> digging in the ext4 page writeback code. There are some caveats when 
> blocksize < pagesize but I am not sure my understanding is correct. 
  So you are completely right with the observation that in case like you
describe we don't create delayed allocation extent for the block just
beyond EOF. This is a problem which exists since day one when delayed
allocation was introduced for ext4 (but also xfs and I dare to say any
other fs doing delayed allocation). The culprit really is that we create
delayed allocation extents on page fault - at that time file is only 48KB
so we naturally don't allocate blocks for blocks beyond those 48KB. However
after extending the file, the part of the page at offsets beyond 48KB
suddently becomes part of the file and if you write some data there (no
page fault happens because the page is already marked writeable in the page
tables), we won't have any delayed allocation extent backing that data.

One thing to note here is that posix specifically says that extending file
while it is mmaped has undefined consequences for the mmap so technically
speaking if we would just throw away the data, we would still adhere to it.
I don't think we should be so harsh but I mention this to explain why some
weirdness may be acceptable.

Anyway, fixing this isn't completely easy. I was looking into that some
years ago and the best solution I've found back then was to writeprotect
the last partial page whenever blocksize < pagesize, we are extending the
file and creating hole in the last partial page beyond original EOF. This
actually requires tweaking not only truncate path but also write path and
the locking was somewhat hairy there because we need to writeprotect the
tail page before updating i_size and make sure noone can fault it in again
before the i_size is updated.

								Honza
> /*
>  * mmap vs extent issue
>  *
>  * Copyright (C) 2014 Anton Blanchard <anton@au.ibm.com>, IBM
>  *
>  * This program is free software; you can redistribute it and/or
>  * modify it under the terms of the GNU General Public License
>  * as published by the Free Software Foundation; either version
>  * 2 of the License, or (at your option) any later version.
>  */
> 
> #include <stdio.h>
> #include <string.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/types.h>
> #include <sys/mman.h>
> #include <sys/ioctl.h>
> #include <linux/fs.h>
> #include <linux/fiemap.h>
> 
> static void check_fiemap(int fd)
> {
> 	struct fiemap *fiemap;
> 	unsigned long i, ex_size;
> 
> 	fiemap = malloc(sizeof(struct fiemap));
> 	if (!fiemap) {
> 		perror("malloc");
> 		exit(1);
> 	}
> 
> 	memset(fiemap, 0, sizeof(struct fiemap));
> 	fiemap->fm_length = ~0;
> 
> 	if (ioctl(fd, FS_IOC_FIEMAP, fiemap) == -1) {
> 		perror("ioctl(FIEMAP)");
> 		exit(1);
> 	}
> 
> 	ex_size = sizeof(struct fiemap_extent) * fiemap->fm_mapped_extents;
> 
> 	fiemap = realloc(fiemap, sizeof(struct fiemap) + ex_size);
> 	if (!fiemap) {
> 		perror("realloc");
> 		exit(1);
> 	}
> 
> 	memset(fiemap->fm_extents, 0, ex_size);
> 	fiemap->fm_extent_count = fiemap->fm_mapped_extents;
> 	fiemap->fm_mapped_extents = 0;
> 
> 	if (ioctl(fd, FS_IOC_FIEMAP, fiemap) < 0) {
> 		perror("ioctl(FIEMAP)");
> 		exit(1);
> 	}
> 
> 	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
> 		unsigned long start = fiemap->fm_extents[i].fe_logical;
> 		unsigned long end = fiemap->fm_extents[i].fe_logical +
> 					fiemap->fm_extents[i].fe_length;
> 
> 		if (start <= 48*1024 && end > 48*1024) {
> 			printf("GOOD\n");
> 			exit(0);
> 		}
> 	}
> 
> 	printf("BAD:\n");
> 	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
> 		printf("%ld:\t%016llx %016llx\n", i,
> 			fiemap->fm_extents[i].fe_logical,
> 			fiemap->fm_extents[i].fe_length);
> 	}
> 
> 	exit(1);
> }
> 
> int main(int argc, char *argv[])
> {
> 	char name[] = "mmap-lseek-XXXXXX";
> 	int fd;
> 	char *p;
> 
> 	fd = mkstemp(name);
> 	if (fd == -1) {
> 		perror("mkstemp");
> 		exit(1);
> 	}
> 
> 	/* Create a 48 kB file */
> 	lseek(fd, 48 * 1024 - 1, SEEK_SET);
> 	if (write(fd, "\0", 1) != 1) {
> 		perror("write");
> 		exit(1);
> 	}
> 
> 	/* Map it, allowing space for it to grow */
> 	p = mmap(NULL, 128 * 1024, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> 	if (p == MAP_FAILED) {
> 		perror("mmap");
> 		exit(1);
> 	}
> 
> 	/* Write to the start of the file */
> 	*(p) = 1;
> 
> 	/* Extend the file */
> 	lseek(fd, 128 * 1024 - 1, SEEK_SET);
> 	if (write(fd, "\0", 1) != 1) {
> 		perror("write");
> 		exit(1);
> 	}
> 
> 	/* write to the new space in the first page */
> 	*(p + 49 * 1024) = 1;
> 
> 	munmap(p, 128 * 1024);
> 
> 	check_fiemap(fd);
> 
> 	close(fd);
> 
> 	return 0;
> }
> 
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
