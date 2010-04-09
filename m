From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: EXT4_IOC_MOVE_EXT file corruption!
Date: Fri, 9 Apr 2010 09:20:28 -0700
Message-ID: <20100409162028.GV29604@tux1.beaverton.ibm.com>
References: <20100405220220.GT29604@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53294 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0DIQUd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Apr 2010 12:20:33 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e9.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o39G8mFu010970
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 12:08:48 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o39GKWgk120404
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 12:20:32 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o39GKV4F008655
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 12:20:31 -0400
Content-Disposition: inline
In-Reply-To: <20100405220220.GT29604@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 05, 2010 at 03:02:20PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> I wrote a program called e4frag that deliberately tries to fragment an ext4
> filesystem via EXT4_IOC_MOVE_EXT so that I could run e4defrag through its
> paces.  While running e4frag and e4defrag concurrently on a kernel source tree,
> I discovered ongoing file corruption.  It appears that if e4frag and e4defrag
> hit the same file at same time, the file ends up with a 4K data block from
> somewhere else.  "Somewhere else" seems to be a small chunk of binary gibberish
> followed by contents from other files(!)  Obviously this isn't a good thing to

It seems that if you mount the filesystem with -o sync this problem goes away.

--D

> see, since today it's header files but tomorrow it could be the credit card/SSN
> database. :)
> 
> Ted asked me to send out a copy of the program ASAP, so the test program source
> code is at the end of this message.  To build it, run:
> 
> $ gcc -o e4frag -O2 -Wall e4frag.c
> 
> and then to run it:
> 
> (unpack something in /path/to/files)
> $ cp -pRdu /path/to/files /path/to/intact_files
> $ while true; do e4defrag /path/to/files & done
> $ while true; do ./e4frag -m 500 -s random /path/to/files & done
> $ while true; do diff -Naurp /path/to/intact_files /path/to/files; done
> 
> ...and wait for diff to cough up differences.  This seems to happen on
> 2.6.34-rc3, and only if e4frag and e4defrag are running concurrently.  Running
> e4frag or e4defrag in a serial loop doesn't produce this corruption, so I think
> it's purely a concurrent access problem.
> 
> On a lark, I ran fsck afterwards:
> 
> # fsck -C -f -y /dev/sda
> fsck from util-linux-ng 2.16
> e2fsck 1.41.9 (22-Aug-2009)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure                                           
> Pass 3: Checking directory connectivity                                        
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information                                     
> Inode bitmap differences:  -534593 -534654 -534744 -534768 -534947 -662276
> -662438 -1058789 -1058850 -1059026 -1059219 -1318193 -1583270 -1583378 -1583422
> -2234673 -2631973 -3156444 -3156632 -3680888 -3680950 -4204922 -4205252
> -4205286
> Fix? yes
> 
>                                                                                
> /dev/sda: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/sda: 291596/107143168 files (4.6% non-contiguous), 7829819/428544000 blocks
> 
> Is this a sign that the extent tree is getting corrupted somehow?  Ted thought
> that it might have something to do with an ialloc mutex, I think.
> 
> --D
> 
> /*
>  * Try to fragment files.
>  * Copyright (C) 2010 IBM.  All rights reserved.
>  *
>  * This program is licensed under the GPLv2.
>  * Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
>  */
> #define _FILE_OFFSET_BITS	64
> #define _XOPEN_SOURCE		600
> #define _GNU_SOURCE
> 
> #include <stdio.h>
> #include <string.h>
> #include <ftw.h>
> #include <sys/vfs.h>
> #include <sys/statfs.h>
> #include <assert.h>
> #include <sys/statvfs.h>
> #include <errno.h>
> #include <linux/magic.h>
> #include <fcntl.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/param.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <asm-generic/int-l64.h>
> #include <sys/ioctl.h>
> #include <sys/mman.h>
> 
> #define DEFAULT_MAX_DONOR_FILES	0
> #define STATUS_NEWLINE		"\r"
> #define PROGRAM			"e4frag v0.2"
> 
> struct fragment_context {
> 	const char *fpath;
> 	off_t max_progress;
> 	off_t current_progress;
> 	int old_pct;
> };
> 
> struct fragment_profile {
> 	const char *name;
> 	int (*get_donor_fd)(struct fragment_context *fc, off_t max_files, off_t num_blocks);
> 	int (*prepare)(struct fragment_context *fc, off_t max_files, off_t num_blocks);
> };
> 
> static int max_donor_files = DEFAULT_MAX_DONOR_FILES;
> static struct statvfs statvfsbuf;
> static char donor_file_template[PATH_MAX];
> static off_t donor_files; /* expect as many donor files as blocks */
> static struct fragment_profile *profile;
> static int verbose = 0;
> 
> /* Shamelessly stolen from e4defrag.c */
> 
> struct move_extent {
> 	__s32 reserved;		/* original file descriptor */
> 	__u32 donor_fd;		/* donor file descriptor */
> 	__u64 orig_start;       /* logical start offset in block for orig */
> 	__u64 donor_start;      /* logical start offset in block for donor */
> 	__u64 len;		/* block length to be moved */
> 	__u64 moved_len;	/* moved block length */
> };
> 
> #ifndef EXT4_IOC_MOVE_EXT
> #define EXT4_IOC_MOVE_EXT      _IOWR('f', 15, struct move_extent)
> #endif
> 
> /* end stuff from e4defrag */
> 
> void print_status(struct fragment_context *fc, const char *str)
> {
> 	if (!verbose)
> 		return;
> 
> 	printf("%s: %s\n", fc->fpath, str);
> 	fflush(stdout);
> }
> 
> void emit_status(struct fragment_context *fc, const char *str)
> {
> 	if (!verbose)
> 		return;
> 
> 	printf("%s: %s" STATUS_NEWLINE, fc->fpath, str);
> 	fflush(stdout);
> }
> 
> void inc_status(struct fragment_context *fc)
> {
> 	int pct;
> 
> 	fc->current_progress++;
> 	pct = 100 * fc->current_progress / fc->max_progress;
> 	if (pct != fc->old_pct) {
> 		if (verbose)
> 			printf("%s: %d%%" STATUS_NEWLINE, fc->fpath, pct);
> 		fflush(stdout);
> 		fc->old_pct = pct;
> 	}
> }
> 
> int cleanup_donor_files(struct fragment_context *fc, int report_errors)
> {
> 	int ret;
> 	char tmp_inode_name[PATH_MAX];
> 
> 	while (donor_files) {
> 		snprintf(tmp_inode_name, PATH_MAX, donor_file_template, --donor_files);
> 		ret = unlink(tmp_inode_name);
> 		if (report_errors && ret) {
> 			perror(tmp_inode_name);
> 			return ret;
> 		}
> 		inc_status(fc);
> 	}
> 
> 	return 0;
> }
> 
> off_t calculate_max_files(off_t num_blocks)
> {
> 	off_t x = statvfsbuf.f_bavail / num_blocks;
> 
> 	/* Only use user setting if there's space. */
> 	if (max_donor_files > 0 && x > max_donor_files)
> 		return max_donor_files;
> 
> 	return x;
> }
> 
> int generic_frag_file(const char *fpath, const struct stat *sb, struct fragment_profile *fp)
> {
> 	struct fragment_context fc;
> 	struct move_extent move_data;
> 	off_t num_blocks, block, max_files;
> 	int ret, donor_fd, fd;
> 
> 	fc.fpath = fpath;
> 	fc.max_progress = 0;
> 	fc.current_progress = 0;
> 	fc.old_pct = -1;
> 
> 	/* Screen out non-files or single-block files. */
> 	if (!S_ISREG(sb->st_mode))
> 		return 0;
> 
> 	num_blocks = sb->st_size / statvfsbuf.f_bsize;
> 	if (sb->st_size % statvfsbuf.f_bsize)
> 		num_blocks++;
> 
> 	if (num_blocks < 2)
> 		return 0;
> 
> 	fd = open(fpath, O_RDWR);
> 	if (fd < 0) {
> 		perror(fpath);
> 		ret = -errno;
> 		goto out;
> 	}
> 
> 	/* Kernel can return -ENODATA if we don't sync the source file first. */
> 	emit_status(&fc, "syncing...");
> 	fsync(fd);
> 	emit_status(&fc, "          ");
> 
> 	/* Prepare for donor files */
> 	assert(!donor_files);
> 	donor_files = 0;
> 	snprintf(donor_file_template, PATH_MAX, "%s.%%lu.defrag", fpath);
> 
> 	/* Figure out the maximum donor file count for this file */
> 	max_files = calculate_max_files(num_blocks);
> 
> 	ret = fp->prepare(&fc, max_files, num_blocks);
> 	if (ret)
> 		goto err;
> 
> 	/* Start moving blocks */
> 	memset(&move_data, 0, sizeof(move_data));
> 	move_data.len = 1;
> 	for (block = num_blocks - 1; block >= 0; block--) {
> 		donor_fd = fp->get_donor_fd(&fc, max_files, num_blocks);
> 		if (donor_fd < 0)
> 			goto err;
> 
> 		/* Swap blocks */
> 		/* NB: Source and donor logical block must be the same. */
> 		move_data.donor_fd = donor_fd;
> 		move_data.orig_start = move_data.donor_start = block;
> 		move_data.moved_len = 0;
> 		ret = ioctl(fd, EXT4_IOC_MOVE_EXT, &move_data);
> 		if (ret < 0) {
> 			perror(fpath);
> 			goto err2;
> 		}
> 
> 		ret = close(donor_fd);
> 		if (ret) {
> 			perror("closing donor file");
> 			goto err;
> 		}
> 
> 		inc_status(&fc);
> 	}
> 
> 	cleanup_donor_files(&fc, 0);
> 	print_status(&fc, "Done.");
> 	close(fd);
> 	return 0;
> 
> err2:
> 	cleanup_donor_files(&fc, 0);
> 	close(donor_fd);
> err:
> 	close(fd);
> out:
> 	return ret;
> }
> 
> /*
>  * So, to "reverse" the source logical block numbers, create a donor
>  * file for every block and do the swap.  Occasionally flush out the
>  * donor files.  Iterate the source file's blocks backwards in the
>  * hope of maximizing the amount of extent blocks that must also be
>  * dumped all over the filesystem.
>  */
> int reverse_prepare(struct fragment_context *fc, off_t max_files, off_t num_blocks)
> {
> 	fc->max_progress = 3 * num_blocks;
> 	return 0;
> }
> 
> int reverse_get_donor_fd(struct fragment_context *fc, off_t max_files, off_t num_blocks)
> {
> 	char tmp_inode_name[PATH_MAX];
> 	int donor_fd, ret;
> 
> 	/* Clean out donor files */
> 	if (donor_files > max_files) {
> 		ret = cleanup_donor_files(fc, 1);
> 		if (ret)
> 			return ret;
> 	}
> 
> 	/* Create hidden donor inode */
> 	snprintf(tmp_inode_name, PATH_MAX, donor_file_template, donor_files++);
> 	donor_fd = open(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
> 	if (donor_fd < 0) {
> 		perror(tmp_inode_name);
> 		fprintf(stderr, "Is the fragmenter already running?\n");
> 		errno = EBUSY;
> 		return -1;
> 	}
> 
> 	/* Allocate space in the donor file */
> 	ret = posix_fallocate(donor_fd, 0, num_blocks * statvfsbuf.f_bsize);
> 	if (ret) {
> 		perror(tmp_inode_name);
> 		close(donor_fd);
> 		return ret;
> 	}
> 
> 	inc_status(fc);
> 
> 	return donor_fd;
> }
> 
> /*
>  * So, to "randomize" the source logical block numbers, create a bunch
>  * of donor files.  For each block, pick a donor file at random and
>  * swap blocks with it.
>  */
> int random_prepare(struct fragment_context *fc, off_t max_files, off_t num_blocks)
> {
> 	int donor_fd, ret;
> 	char tmp_inode_name[PATH_MAX];
> 
> 	fc->max_progress = num_blocks + (2 * max_files);
> 
> 	/* Allocate the donor files */
> 	for (donor_files = 0; donor_files < max_files; donor_files++) {
> 		/* Create donor inode */
> 		snprintf(tmp_inode_name, PATH_MAX, donor_file_template, donor_files);
> 		donor_fd = open(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
> 		if (donor_fd < 0) {
> 			perror(tmp_inode_name);
> 			fprintf(stderr, "Is a fragmenter already running?\n");
> 			return -1;
> 		}
> 
> 		/* Allocate space in the donor file */
> 		ret = posix_fallocate(donor_fd, 0, num_blocks * statvfsbuf.f_bsize);
> 		if (ret) {
> 			perror(tmp_inode_name);
> 			close(donor_fd);
> 			return -1;
> 		}
> 
> 		close(donor_fd);
> 		inc_status(fc);
> 	}
> 
> 	return 0;
> }
> 
> int random_get_donor_fd(struct fragment_context *fc, off_t max_files, off_t num_blocks)
> {
> 	char tmp_inode_name[PATH_MAX];
> 	int donor_fd;
> 	off_t donor = random() * max_files / RAND_MAX;
> 
> 	/* Reopen donor inode */
> 	snprintf(tmp_inode_name, PATH_MAX, donor_file_template, donor);
> 	donor_fd = open(tmp_inode_name, O_WRONLY, S_IRUSR);
> 	if (donor_fd < 0) {
> 		perror(tmp_inode_name);
> 		errno = EBUSY;
> 		return -1;
> 	}
> 
> 	return donor_fd;
> }
> 
> static struct fragment_profile profiles[] = {
> {"random", random_get_donor_fd, random_prepare},
> {"reverse", reverse_get_donor_fd, reverse_prepare},
> {NULL},
> };
> 
> int fragment_file(const char *fpath, const struct stat *sb, int typeflag,
> 		  struct FTW *ftwbuf)
> {
> 	return generic_frag_file(fpath, sb, profile);
> }
> 
> void print_help(char *progname)
> {
> 	printf("Usage: %s [-m max_files] [-s random|reverse] [-v] pathspec [pathspecs...]\n", progname);
> 	printf("-m	Number of donor files to create while fragmenting.  0 = automatic\n");
> 	printf("-s	Set fragmentation strategy. (\"reverse\" or \"random\" (default))\n");
> 	printf("-v	Print progress indicators.\n");
> }
> 
> int main(int argc, char *argv[])
> {
> 	struct fragment_profile *fp;
> 	struct statfs statfsbuf;
> 	struct stat statbuf;
> 	int i, ret, opt;
> 
> 	profile = profiles;
> 
> 	if (argc < 2) {
> 		print_help(argv[0]);
> 		return 0;
> 	}
> 
> 	while ((opt = getopt(argc, argv, "vm:s:")) != -1) {
> 		switch (opt) {
> 		case 'm':
> 			max_donor_files = atoi(optarg);
> 			break;
> 		case 's':
> 			fp = profiles;
> 			while (fp->name) {
> 				if (!strcmp(fp->name, optarg)) {
> 					profile = fp;
> 					break;
> 				}
> 				fp++;
> 			}
> 
> 			if (!fp->name) {
> 				print_help(argv[0]);
> 				return 1;
> 			}
> 			break;
> 		case 'v':
> 			verbose = 1;
> 			break;
> 		default:
> 			print_help(argv[0]);
> 			return 1;
> 		}
> 	}
> 
> 	if (verbose)
> 		printf(PROGRAM ", strategy \"%s\" max donors %d.\n", profile->name, max_donor_files);
> 
> 	for (i = optind; i < argc; i++) {
> 		/* ignore files on non-ext4 filesystems */
> 		ret = statfs(argv[i], &statfsbuf);
> 		if (ret) {
> 			perror(argv[i]);
> 			break;
> 		}
> 
> 		if (statfsbuf.f_type != EXT3_SUPER_MAGIC) {
> 			ret = -ENOENT;
> 			fprintf(stderr, "%s: Ignoring file on non-ext2/3/4 filesystem.\n", argv[i]);
> 			break;
> 		}
> 
> 		ret = stat(argv[i], &statbuf);
> 		if (ret) {
> 			perror(argv[i]);
> 			break;
> 		}
> 
> 		ret = statvfs(argv[i], &statvfsbuf);
> 		if (ret) {
> 			perror(argv[i]);
> 			break;
> 		}
> 
> 		if (S_ISDIR(statbuf.st_mode))
> 			nftw(argv[i], fragment_file, 64, FTW_MOUNT | FTW_PHYS);
> 		else
> 			fragment_file(argv[i], &statbuf, 0, NULL);
> 	}
> 
> 	sync();
> 
> 	return 0;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
