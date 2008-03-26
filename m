From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/3] fiemap patches (RFC/testing)
Date: Wed, 26 Mar 2008 16:07:20 -0700
Message-ID: <1206572840.3637.9.camel@localhost.localdomain>
References: <47EA6DA9.4010103@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41278 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbYCZXHZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2008 19:07:25 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2QN7LkE026420
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 19:07:21 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2QN7LwJ231670
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 19:07:21 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2QN7LKx027641
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 19:07:21 -0400
In-Reply-To: <47EA6DA9.4010103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-03-26 at 10:37 -0500, Eric Sandeen wrote:
> Since Akira would like to use the fiemap ioctl for defrag, I thought I should
> put what I have so far out on the list, at least.  This could go in the unstable
> part of the tree if you like, though I need to do more testing etc before it's 
> really ready to go.
> 
I added the patches to the unstable queue, just fyi.
> Also, below is a quick test application I was using with the ioctl.
> 
> -Eric
> 
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <string.h>
> #include <sys/ioctl.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/vfs.h>
> #include <ext2fs/ext2_types.h>
> 
> /*************************************************/
> /* All this should come from fiemap.h eventually */
> struct fiemap_extent {
> 	__u64 fe_offset; /* offset in bytes for the start of the extent */
> 	__u64 fe_length; /* length in bytes for the extent */
> 	__u32 fe_flags;  /* returned FIEMAP_EXTENT_* flags for the extent */
> 	__u32 fe_lun;    /* logical device number for extent (starting at 0) */
> };
> 
> struct fiemap {
> 	__u64 fm_start;	 /* logical starting byte offset (in/out) */
> 	__u64 fm_length;	/* logical length of map (in/out) */
> 	__u32 fm_flags;	 /* FIEMAP_FLAG_* flags for request (in/out) */
> 	__u32 fm_extent_count;  /* number of extents in fm_extents (in/out) */
> 	__u64 fm_end_offset;    /* logical offset of end of mapping in last ioctl */
> 	struct fiemap_extent fm_extents[0];
> };
> 
> #define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
> #define FIEMAP_FLAG_HSM_READ    0x00000002 /* get data from HSM before map */
> #define FIEMAP_FLAG_NUM_EXTENTS 0x00000004 /* return only number of extents */
> #define FIEMAP_FLAG_INCOMPAT    0xff000000 /* error for unknown flags in here */
> #define FIEMAP_FLAG_LUN_OFFSET  0x01000000 /* use lun offsets, instead of
> 					    * logical file offsets */
> 
> #define FIEMAP_EXTENT_HOLE      0x00000001 /* has no data or space allocation */
> #define FIEMAP_EXTENT_UNWRITTEN 0x00000002 /* space allocated, but no data */
> #define FIEMAP_EXTENT_UNMAPPED  0x00000004 /* has data but no space allocation*/
> #define FIEMAP_EXTENT_ERROR     0x00000008 /* mapping error, errno in fe_start*/
> #define FIEMAP_EXTENT_NO_DIRECT 0x00000010 /* cannot access data directly */
> #define FIEMAP_EXTENT_LAST      0x00000020 /* last extent in the file */
> #define FIEMAP_EXTENT_DELALLOC  0x00000040 /* has data but not yet written,
> 					      must have EXTENT_UNKNOWN set */
> #define FIEMAP_EXTENT_SECONDARY 0x00000080 /* data (also) in secondary storage,
> 					      not in primary if EXTENT_UNKNOWN*/
> #define FIEMAP_EXTENT_EOF       0x00000100 /* if fm_start+fm_len is beyond EOF*/
> 
> #define FIGETBSZ	_IO(0x00, 2)    /* get the block size used for bmap */
> #define EXT4_IOC_FIEMAP _IOWR('f', 10, struct fiemap) /* get file extent info*/
> 
> /* End of what should be coming from fiemap.h */
> /**********************************************/
> 
> 
> void usage(void)
> {
> 	printf("Usage: fiemap [-vrSCL] [-s start] [-l length] [-c buf count] [-m max] filename\n");
> 	printf("  -v        : verbose mode\n");
> 	printf("  -r        : raw output: print raw ioctl structure values\n");
> 	printf("  -S        : set FIEMAP_FLAG_SYNC to sync before mapping\n");
> 	printf("  -C        : set FIEMAP_FLAG_NUM_EXTENTS to only get extent count, not mapping\n");
> 	printf("  -L        : set FIEMAP_FLAG_LUN_OFFSET to report extents in lun order\n");
> 	printf("  -s start  : start of mapping in bytes (default 0)\n");
> 	printf("  -l length : length of mapping in bytes (default to end of file)\n");
> 	printf("  -c count  : count of extents in ioctl input structure (default 32)\n");
> 	printf("  -m max    : max nr of ioctls to call before exit (default 512)\n");
> 	exit(EXIT_FAILURE);
> }
> 
> #define EXABYTES(x)     ((long long)(x) << 60)
> #define PETABYTES(x)    ((long long)(x) << 50)
> #define TERABYTES(x)    ((long long)(x) << 40)
> #define GIGABYTES(x)    ((long long)(x) << 30)
> #define MEGABYTES(x)    ((long long)(x) << 20)
> #define KILOBYTES(x)    ((long long)(x) << 10)
> 
> long long
> cvtnum(char *s)
> {
> 	long long	i;
> 	char		*sp;
> 	int		c;
> 
> 	i = strtoll(s, &sp, 0);
> 	if (i == 0 && sp == s)
> 		return -1LL;
> 	if (*sp == '\0')
> 		return i;
> 	if (sp[1] != '\0')
> 		return -1LL;
> 
> 	c = tolower(*sp);
> 	switch (c) {
> 	case 'k':
> 		return KILOBYTES(i);
> 	case 'm':
> 		return MEGABYTES(i);
> 	case 'g':
> 		return GIGABYTES(i);
> 	case 't':
> 		return TERABYTES(i);
> 	case 'p':
> 		return PETABYTES(i);
> 	case 'e':
> 		return  EXABYTES(i);
> 	}
> 
> 	return -1LL;
> }
> 
> void show_extents_table(struct fiemap *fiemap, int blocksize, int start_extent, int *is_last)
> {
> 	unsigned int	i;
> 	__u64		lstart;
> 
> 	lstart = fiemap->fm_start;
> 	for (i = 0; i < fiemap->fm_extent_count; i++) {
> 		__u64	length = fiemap->fm_extents[i].fe_length;
> 		__u64	phys = fiemap->fm_extents[i].fe_offset;
> 		int	flags = fiemap->fm_extents[i].fe_flags;
> 
> 		printf("ext: %3u logical: [%8llu..%8llu] phys: %8llu..%8llu flags: 0x%03X tot: %llu\n",
> 			i + start_extent,
> 			lstart, lstart + length - 1,
> 			(phys / blocksize),
> 			(flags & FIEMAP_EXTENT_HOLE) ? 0 : (phys + length - 1) / blocksize,
> 			flags,
> 			(length / blocksize));
> 
> 		lstart += length;
> 		if (fiemap->fm_extents[i].fe_flags & FIEMAP_EXTENT_LAST) {
> 			*is_last = 1;
> 			return; /* XXX should we?  or should look for exents filled in past last? */
> 		}
> 	}
> }
> 
> void show_extents_raw(struct fiemap *fiemap, int start_extent, int *is_last)
> {
> 	unsigned int	i;
> 
> 	for (i = 0; i < fiemap->fm_extent_count; i++) {
> 		printf("\tExtent %3u: start: %10lld length: %10lld flags 0x%03X lun %3u\n",
> 			i + start_extent,
> 			fiemap->fm_extents[i].fe_offset,
> 			fiemap->fm_extents[i].fe_length,
> 			fiemap->fm_extents[i].fe_flags,
> 			fiemap->fm_extents[i].fe_lun);
> 
> 		if (fiemap->fm_extents[i].fe_flags & FIEMAP_EXTENT_LAST) {
> 			*is_last = 1;
> 			return; /* XXX should we?  or should look for exents filled in past last? */
> 		}
> 	}
> }
> 
> int main(int argc, char**argv)
> {
> 	int	blocksize = 0;	/* filesystem blocksize */
> 	uint	count = 32;	/* extent count */
> 	int	countonly = 0;	/* return only extent count? */
> 	int	fd;		/* file descriptor */
> 	int	last = 0;	/* last extent found */
> 	int	lunwise = 0;	/* return extents lun-wise */
> 	int	maxioctls = 512; /* max ioctls to try */
> 	int	opt;
> 	int	rc;
> 	int	raw = 0;	/* raw output format */
> 	int	sync = 0;	/* sync file before mapping */
> 	int	verbose = 0;	/* verbose output */
> 	char	*fname;		/* filename to map */
> 	char	*fiebuf;	/* fiemap buffer / ioctl argument */
> 	__u64	lstart = 0;	/* logical input mapping start */
> 	__u64	llength = ~0ULL;/* logical input mapping length */
> 	uint	start_ext = 0;	/* starting extent nr. for this batch */
> 	struct fiemap *fiemap;
> 
> 
> 	while ((opt = getopt(argc, argv, "s:l:c:m:rSCLv")) != -1) {
> 		switch(opt) {
> 		/* logical mapping offset */
> 		case 's':
> 			lstart = cvtnum(optarg);
> 			break;
> 		/* logical mapping length */
> 		case 'l':
> 			llength = cvtnum(optarg);
> 			break;
> 		/* count of extent buffers to send */
> 		case 'c':
> 			count = atoi(optarg);
> 			break;
> 		/* max nr. of ioctls to try (safety net) */
> 		case 'm':
> 			maxioctls = atoi(optarg);
> 			break;
> 		/* raw format output */
> 		case 'r':
> 			raw++;
> 			break;
> 		/* sync file before mapping */
> 		case 'S':
> 			sync++;
> 			break;
> 		/* count extents only, no details */
> 		case 'C':
> 			countonly++;
> 			break;
> 		/* return extents in lun order */
> 		case 'L':
> 			lunwise++;
> 			break;
> 		/* be verbose */
> 		case 'v':
> 			verbose++;
> 			break;
> 		default:
> 			usage();
> 		}
> 	}
> 
> 	fname = argv[optind++];
> 	if (!fname)
> 		usage();
> 
> 	/* The whole buffer, extent maps and all */
> 	fiebuf = malloc(sizeof (struct fiemap) + (count * sizeof(struct fiemap_extent)));
> 	if (!fiebuf) {
> 		perror("Could not allocate fiemap buffers");
> 		exit(1);
> 	}
> 
> 	/* Just the header */
> 	fiemap = (struct fiemap *)fiebuf;
> 
> 	fiemap->fm_start = lstart;
> 	fiemap->fm_length = llength;
> 	fiemap->fm_flags = 0;
> 	if (sync)
> 		fiemap->fm_flags |= FIEMAP_FLAG_SYNC;
> 	if (countonly)
> 		fiemap->fm_flags |= FIEMAP_FLAG_NUM_EXTENTS;
> 	if (lunwise)
> 		fiemap->fm_flags |= FIEMAP_FLAG_LUN_OFFSET;
> 
> 	fiemap->fm_extent_count = count;
> 	fiemap->fm_end_offset = 0;	/* output only */
> 
> 	fd = open(fname, O_RDONLY);
> 	if (fd < 0) {
> 		perror("Can't open file");
> 		exit(1);
> 	}
> 
> 	if (ioctl(fd, FIGETBSZ, &blocksize) < 0) {
> 		perror("Can't get block size");
> 		close(fd);
> 		return;
> 	}
> 
> 	do {
> 		if (verbose)
> 			printf("Input:  start %llu length %llu flags 0x%X count %u end_offset %lld\n",
> 				fiemap->fm_start, fiemap->fm_length,
> 				fiemap->fm_flags, fiemap->fm_extent_count,
> 				fiemap->fm_end_offset);
> 
> 		rc = ioctl(fd, EXT4_IOC_FIEMAP, (unsigned long)fiemap);
> 		if (rc < 0) {
> 			perror("FIEMAP ioctl failed");
> 			close(fd);
> 			exit(1);
> 		}
> 
> 		if (verbose)
> 			printf("Output: start %llu length %llu flags 0x%X count %u end_offset %lld\n",
> 				fiemap->fm_start, fiemap->fm_length,
> 				fiemap->fm_flags, fiemap->fm_extent_count,
> 				fiemap->fm_end_offset);
> 		if (raw)
> 			show_extents_raw(fiemap, start_ext, &last);
> 		else
> 			show_extents_table(fiemap, blocksize, start_ext, &last);
> 
> 		start_ext += fiemap->fm_extent_count;
> 
> 		/* Did we finish up the last of the reqest? */
> 		if (fiemap->fm_length >= llength)
> 			break;
> 		/* Set up the next call arguments */
> 		fiemap->fm_start += fiemap->fm_length;
> 		llength -= fiemap->fm_length;
> 		fiemap->fm_length = llength;
> 		fiemap->fm_extent_count = count;
> 
> 		maxioctls--;
> 
> 	} while (!last && maxioctls > 0);
> 
> 	close(fd);
> 
> 	return 0;
> }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

