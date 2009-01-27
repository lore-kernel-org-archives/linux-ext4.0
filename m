From: Andreas Dilger <adilger@sun.com>
Subject: device/filesystem test tools
Date: Mon, 26 Jan 2009 19:02:01 -0700
Message-ID: <20090127020201.GA3499@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_nHdyfUoCY8mBv2CgvYao2A)"
Cc: kelly@newdream.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60142 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZA0CCX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 21:02:23 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n0R22KAr017751
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2009 18:02:20 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KE300H01XKNKB00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 26 Jan 2009 18:02:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_nHdyfUoCY8mBv2CgvYao2A)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline

Per discussion in IRC, attached are some tools we use to verify the
block device and filesystem are behaving correctly w.r.t. common
block device filesystem overflow boundaries (e.g. 1TB, 2TB, 4TB, ...).

There is a block device verification tool that writes to the whole
block device, either sparsely or densely, and then reads the data back
and verifies that what was written is still there.  The data pattern
includes both a per-run timestamp, and offset information so that
phantom writes will not match data from a previous run, and that
misplaced writes (whatever the cause) will be detectable.

There is a second filesystem verification tool that creates a number
of subdirectories (number == group count on ext3, though this is not
required), and then creates files in each subdirectory either until
the requested number of files are created or the filesystem is full.
Then it reads back the files and verifies the data therein, similar
to the block device verification tool.  With filesystems other than
ext2/3 the creation of subdirectories does not necessarily force
file creation to be spread around the filesystem, but is not harmful
and will help test the directory allocation code on large devices.

The tools are intended to be compiled after a "configure" run in Lustre,
so they have a number of non-critical header checks to enable extra
functionality via libblkid and libext2fs (check for an existing filesystem,
get the number of block groups, etc).  The tools can be compiled with
-D HAVE_EXT2FS_EXT2FS_H and -D HAVE_BLKID_BLKID_H defined, but should
be OK without them.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--Boundary_(ID_nHdyfUoCY8mBv2CgvYao2A)
Content-type: text/plain; NAME=llverdev.c; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=llverdev.c

/* -*- mode: c; c-basic-offset: 8; indent-tabs-mode: nil; -*-
 * vim:expandtab:shiftwidth=8:tabstop=8:
 *
 * GPL HEADER START
 *
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 only,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License version 2 for more details (a copy is included
 * in the LICENSE file that accompanied this code).
 *
 * You should have received a copy of the GNU General Public License
 * version 2 along with this program; If not, see
 * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
 *
 * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
 * CA 95054 USA or visit www.sun.com if you need additional information or
 * have any questions.
 *
 * GPL HEADER END
 */
/*
 * Copyright  2008 Sun Microsystems, Inc. All rights reserved
 * Use is subject to license terms.
 */
/*
 * This file is part of Lustre, http://www.lustre.org/
 * Lustre is a trademark of Sun Microsystems, Inc.
 *
 * lustre/utils/llverdev.c
 *
 * Large Block Device Verification Tool.
 * This program is used to test whether the block device is correctly
 * handling IO beyond 2TB boundary.
 * This tool have two working modes
 * 1. full mode
 * 2. fast mode
 *	The full mode is basic mode in which program writes the test pattern
 * on entire disk. The test pattern (device offset and timestamp) is written
 * at the beginning of each 4kB block. When the whole device is full then
 * read operation is performed to verify that the test pattern is correct.
 *	In the fast mode the program writes data at the critical locations
 * of the device such as start of the device, before and after multiple of 1GB
 * offset and at the end.
 *	A chunk buffer with default size of 1MB is used to write and read test
 * pattern in bulk.
 */

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#ifndef LUSTRE_UTILS
#define LUSTRE_UTILS
#endif
#ifndef _LARGEFILE64_SOURCE
#define _LARGEFILE64_SOURCE
#endif
#ifndef _FILE_OFFSET_BITS
#define _FILE_OFFSET_BITS 64
#endif

#include <features.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/time.h>
#include <gnu/stubs.h>

#ifdef HAVE_EXT2FS_EXT2FS_H
#  include <ext2fs/ext2fs.h>
#endif

#define ONE_MB (1024 * 1024)
#define ONE_GB (1024 * 1024 * 1024)
#define HALF_MB (ONE_MB / 2)
#define ONE_KB 1024
#define HALF_KB (ONE_KB / 2)
#define BLOCKSIZE 4096

/* Structure for writting test pattern */
struct block_data {
	long long  bd_offset;
	time_t  bd_time;
};
static char *progname;		/* name by which this program was run. */
static unsigned verbose = 1;	/* prints offset in kB, operation rate */
static int readoption;		/* run test in read-only (verify) mode */
static int writeoption;		/* run test in write_only mode */
const char *devname;		/* name of device to be tested. */
static unsigned full = 1;	/* flag to full check */
static int fd;
static int isatty_flag;

static struct option const longopts[] =
{
	{ "chunksize", required_argument, 0, 'c' },
	{ "force", no_argument, 0, 'f' },
	{ "help", no_argument, 0, 'h' },
	{ "offset", required_argument, 0, 'o' },
	{ "partial", required_argument, 0, 'p' },
	{ "quiet", required_argument, 0, 'q' },
	{ "read", no_argument, 0, 'r' },
	{ "timestamp", required_argument, 0, 't' },
	{ "verbose", no_argument, 0, 'v' },
	{ "write", no_argument, 0, 'w' },
	{ "long", no_argument, 0, 'l' },
	{ 0, 0, 0, 0}
};

/*
 * Usage: displays help information, whenever user supply --help option in
 * command or enters incorrect command line.
 */
void usage(int status)
{
	if (status != 0) {
	      printf("\nUsage: %s [OPTION]... <device-name> ...\n",
		     progname);
	      printf("Block device verification tool.\n"
		     "\t-t {seconds}, --timestamp, "
		     "set test time  (default=current time())\n"
		     "\t-o {offset}, --offset, "
		     "offset in kB of start of test, default=0\n"
		     "\t-r, --read run test in verify mode\n"
		     "\t-w, --write run test in test-pattern mode, default=rw\n"
		     "\t-v, --verbose\n"
		     "\t-q, --quiet\n"
		     "\t-l, --long, full check of device\n"
		     "\t-p, --partial, for partial check (1GB steps)\n"
		     "\t-c, --chunksize, IO chunk size, default=1048576\n"
		     "\t-f, --force, force test to run without confirmation\n"
		     "\t-h, --help display this help and exit\n");
	}
	exit(status);
}

/*
 * Open_dev: Opens device in specified mode and returns fd.
 */
static int open_dev(const char *devname, int mode)
{
#ifdef HAVE_EXT2FS_EXT2FS_H
	int	mount_flags;
	char	mountpt[80] = "";

	if (ext2fs_check_mount_point(devname, &mount_flags, mountpt,
				     sizeof(mountpt))) {
		fprintf(stderr, "%s: ext2fs_check_mount_point failed:%s",
			progname, strerror(errno));
		exit(1);
	}
	if (mount_flags & EXT2_MF_MOUNTED){
		fprintf(stderr, "%s: %s is already mounted\n", progname,
			devname);
		exit(1);
	}
#endif
	fd = open(devname, mode | O_EXCL | O_LARGEFILE);
	if (fd < 0) {
		fprintf(stderr, "%s: Open failed: %s",progname,strerror(errno));
		exit(3);
	}
	return (fd);
}

#undef HAVE_BLKID_BLKID_H /* sigh, RHEL3 systems do not have libblkid.so.1 */
#ifdef HAVE_BLKID_BLKID_H
#include <blkid/blkid.h>
#endif
/*
 * sizeof_dev: Returns size of device in bytes
 */
static loff_t sizeof_dev(int fd)
{
	loff_t numbytes;

#ifdef HAVE_BLKID_BLKID_H
	numbytes = blkid_get_dev_size(fd);
	if (numbytes <= 0) {
		fprintf(stderr, "%s: blkid_get_dev_size(%s) failed",
			progname, devname);
		return 1;
	}
	goto out;
#else
# if defined BLKGETSIZE64	/* in sys/mount.h */
	if (ioctl(fd, BLKGETSIZE64, &numbytes) >= 0)
		goto out;
# endif
# if defined BLKGETSIZE		/* in sys/mount.h */
	{
		unsigned long sectors;

		if (ioctl(fd, BLKGETSIZE, &sectors) >= 0) {
			numbytes = (loff_t)sectors << 9;
			goto out;
		}
	}
# endif
	{
		struct stat statbuf;

		if (fstat(fd, &statbuf) == 0 && S_ISREG(statbuf.st_mode)) {
			numbytes = statbuf.st_size;
			goto out;
		}
	}
	fprintf(stderr, "%s: unable to determine size of %s\n",
			progname, devname);
	return 0;
#endif

out:
	if (verbose)
		printf("%s: %s is %llu bytes (%g GB) in size\n",
		       progname, devname,
		       (unsigned long long)numbytes, (double)numbytes / ONE_GB);

	return numbytes;
}

/*
 * Verify_chunk: Verifies test pattern in each 4kB (BLOCKSIZE) is correct.
 * Returns 0 if test offset and timestamp is correct otherwise 1.
 */
int verify_chunk(char *chunk_buf, size_t chunksize,
		 unsigned long long chunk_off, time_t time_st)
{
	struct block_data *bd;
	char *chunk_end;

	for (chunk_end = chunk_buf + chunksize - sizeof(*bd);
	     (char *)chunk_buf < chunk_end;
	     chunk_buf += BLOCKSIZE, chunk_off += BLOCKSIZE) {
		bd = (struct block_data *)chunk_buf;
		if ((bd->bd_offset == chunk_off) && (bd->bd_time == time_st))
			continue;

		fprintf(stderr, "\n%s: verify failed at offset/timestamp "
			"%llu/%lu: found %llu/%lu instead\n", progname,
			chunk_off, time_st, bd->bd_offset, bd->bd_time);
		return 1;
	}
	return 0;
}

/*
 * fill_chunk: Fills the chunk with current or user specified timestamp
 * and  offset. The test patters is filled at the beginning of
 * each 4kB(BLOCKSIZE) blocks in chunk_buf.
 */
void fill_chunk(char *chunk_buf, size_t chunksize, loff_t chunk_off,
		time_t time_st)
{
	struct block_data *bd;
	char *chunk_end;

	for (chunk_end = chunk_buf + chunksize - sizeof(*bd);
	     (char *)chunk_buf < chunk_end;
	     chunk_buf += BLOCKSIZE, chunk_off += BLOCKSIZE) {
		bd = (struct block_data *)chunk_buf;
		bd->bd_offset = chunk_off;
		bd->bd_time = time_st;
	}
}

void show_rate(char *op, unsigned long long offset, unsigned long long *count)
{
	static time_t last;
	time_t now;
	double diff;

	now = time(NULL);
	diff = now - last;

	if (diff > 4) {
		if (last != 0) {
			if (isatty_flag)
				printf("\r");
			printf("%s offset: %14llukB %5g MB/s            ", op,
			       offset / ONE_KB, (double)(*count) /ONE_MB /diff);
			if (isatty_flag)
				fflush(stdout);
			else
				printf("\n");

			*count = 0;
		}
		last = now;
	}
}

/*
 * write_chunk: write the chunk_buf on the device. The number of write
 * operations are based on the parameters write_end, offset, and chunksize.
 */
int write_chunks(unsigned long long offset, unsigned long long write_end,
		 char *chunk_buf, size_t chunksize, time_t time_st)
{
	unsigned long long stride, count = 0;

	stride = full ? chunksize : (ONE_GB - chunksize);

	for (offset = offset & ~(chunksize - 1); offset < write_end;
	     offset += stride) {
		if (lseek64(fd, offset, SEEK_SET) == -1) {
			fprintf(stderr, "\n%s: lseek64(%llu) failed: %s\n",
				progname, offset, strerror(errno));
			return 1;
		}
		if (offset + chunksize > write_end)
			chunksize = write_end - offset;

		if (!full && offset > chunksize) {
			fill_chunk(chunk_buf, chunksize, offset, time_st);
			if (write(fd, chunk_buf, chunksize) < 0) {
				fprintf(stderr, "\n%s: write %llu failed: %s\n",
					progname, offset, strerror(errno));
				return 1;
			}
			offset += chunksize;
			if (offset + chunksize > write_end)
				chunksize = write_end - offset;
		}

		fill_chunk(chunk_buf, chunksize, offset, time_st);
		if (write(fd, chunk_buf, chunksize) < 0) {
			fprintf(stderr, "\n%s: write %llu failed: %s\n",
				progname, offset, strerror(errno));
			return 1;
		}

		count += chunksize;
		if (verbose > 1)
			show_rate("write", offset, &count);
	}
	if (verbose > 1) {
		show_rate("write", offset, &count);
		printf("\nwrite complete\n");
	}
	if (fsync(fd) == -1) {
		fprintf(stderr, "%s: fsync faild: %s\n", progname,
			strerror(errno));
			return 1;
	}
	return 0;
}

/*
 * read_chunk: reads the chunk_buf from the device. The number of read
 * operations are based on the parameters read_end, offset, and chunksize.
 */
int read_chunks(unsigned long long offset, unsigned long long read_end,
		char *chunk_buf, size_t chunksize, time_t time_st)
{
	unsigned long long stride, count = 0;

	stride = full ? chunksize : (ONE_GB - chunksize);

	if (ioctl(fd, BLKFLSBUF, 0) < 0 && verbose)
		fprintf(stderr, "%s: ioctl BLKFLSBUF failed: %s (ignoring)\n",
			progname, strerror(errno));

	for (offset = offset & ~(chunksize - 1); offset < read_end;
	     offset += stride) {
		if (lseek64(fd, offset, SEEK_SET) == -1) {
			fprintf(stderr, "\n%s: lseek64(%llu) failed: %s\n",
				progname, offset, strerror(errno));
			return 1;
		}
		if (offset + chunksize > read_end)
			chunksize = read_end - offset;

		if (!full && offset > chunksize) {
			if (read (fd, chunk_buf, chunksize) < 0) {
				fprintf(stderr, "\n%s: read %llu failed: %s\n",
					progname, offset, strerror(errno));
				return 1;
			}
			if (verify_chunk(chunk_buf, chunksize, offset,
					 time_st) != 0)
				return 1;
			offset += chunksize;
			if (offset + chunksize >= read_end)
				chunksize = read_end - offset;
		}

		if (read(fd, chunk_buf, chunksize) < 0) {
			fprintf(stderr, "\n%s: read failed: %s\n", progname,
				strerror(errno));
			return 1;
		}

		if (verify_chunk(chunk_buf, chunksize, offset, time_st) != 0)
			return 1;

		count += chunksize;
		if (verbose > 1)
			show_rate("read", offset, &count);
	}
	if (verbose > 1) {
		show_rate("read", offset, &count);
		printf("\nread complete\n");
	}
	return 0;
}

int main(int argc, char **argv)
{
	time_t time_st = 0;		/* Default timestamp */
	long long offset = 0, offset_orig; /* offset in kB */
	size_t chunksize = ONE_MB;	/* IO chunk size */
	char *chunk_buf = NULL;
	unsigned int force = 0;		/* run test run without confirmation*/
	unsigned long long dev_size = 0;
	char yesno[4];
	int mode = O_RDWR;		/* mode which device should be opened */
	int error = 0, c;

	progname = strrchr(argv[0], '/') == NULL ?
		argv[0] : strrchr(argv[0], '/') + 1;
	while ((c = getopt_long(argc, argv, "c:fhlo:pqrt:vw", longopts,
				NULL)) != -1) {
		switch (c) {
		case 'c':
			chunksize = (strtoul(optarg, NULL, 0) * ONE_MB);
			if (!chunksize) {
				fprintf(stderr, "%s: chunk size value should be"
					"nonzero and multiple of 1MB\n",
					progname);
				return -1;
			}
			break;
		case 'f':
			force = 1;
			break;
		case 'l':
			full = 1;
			break;
		case 'o':
			offset = strtoull(optarg, NULL, 0) * ONE_KB;
			break;
		case 'p':
			full = 0;
			break;
		case 'q':
			verbose = 0;
			break;
		case 'r':
			readoption = 1;
			mode = O_RDONLY;
			break;
		case 't':
			time_st = (time_t)strtoul(optarg, NULL, 0);
			break;
		case 'v':
			verbose++;
			break;
		case 'w':
			writeoption = 1;
			mode = O_WRONLY;
			break;
		case 'h':
		default:
			usage (1);
			return 0;
		}
	}
	offset_orig = offset;
	devname = argv[optind];
	if (!devname) {
		fprintf(stderr, "%s: device name not given\n", progname);
		usage (1);
		return -1;
	}

	if (readoption && writeoption)
		mode = O_RDWR;
	if (!readoption && !writeoption) {
		readoption = 1;
		writeoption = 1;
	}

	if (!force && writeoption) {
		printf("%s: permanently overwrite all data on %s (yes/no)? ",
		       progname, devname);
		scanf("%3s", yesno);
		if (!(strcasecmp("yes", yesno) || strcasecmp("y", yesno))) {
			printf("Not continuing due to '%s' response", yesno);
			return 0;
		}
	}

	if (!writeoption && time_st == 0) {
		fprintf(stderr, "%s: must give timestamp for read-only test\n",
			progname);
		usage(1);
	}

	fd = open_dev(devname, mode);
	dev_size = sizeof_dev(fd);
	if (!dev_size) {
		fprintf(stderr, "%s: cannot test on device size < 1MB\n",
			progname);
		error = 7;
		goto close_dev;
	}

	if (dev_size < (offset * 2)) {
		fprintf(stderr, "%s: device size %llu < offset %llu\n",
			progname, dev_size, offset);
		error = 6;
		goto close_dev;
	}
	if (!time_st)
		(void)time(&time_st);

	isatty_flag = isatty(STDOUT_FILENO);

	if (verbose)
		printf("Timestamp: %lu\n", time_st);

	chunk_buf = (char *)calloc(chunksize, 1);
	if (chunk_buf == NULL) {
		fprintf(stderr, "%s: memory allocation failed for chunk_buf\n",
			progname);
		error = 4;
		goto close_dev;
	}
	if (writeoption) {
		if (write_chunks(offset, dev_size, chunk_buf, chunksize,
				 time_st)) {
			error = 3;
			goto chunk_buf;
		}
		if (!full) {  /* end of device aligned to a block */
			offset = ((dev_size - chunksize + BLOCKSIZE - 1) &
				  ~(BLOCKSIZE - 1));
			if (write_chunks(offset, dev_size, chunk_buf, chunksize,
					 time_st)) {
				error = 3;
				goto chunk_buf;
			}
		}
		offset = offset_orig;
	}
	if (readoption) {
		if (read_chunks(offset, dev_size, chunk_buf, chunksize,
				time_st)) {
			error = 2;
			goto chunk_buf;
		}
		if (!full) { /* end of device aligned to a block */
			offset = ((dev_size - chunksize + BLOCKSIZE - 1) &
				  ~(BLOCKSIZE - 1));
			if (read_chunks(offset, dev_size, chunk_buf, chunksize,
					time_st)) {
				error = 2;
				goto chunk_buf;
			}
		}
		if (verbose)
			printf("\n%s: data verified successfully\n", progname);
	}
	error = 0;
chunk_buf:
	free(chunk_buf);
close_dev:
	close(fd);
	return error;
}

--Boundary_(ID_nHdyfUoCY8mBv2CgvYao2A)
Content-type: text/plain; NAME=llverfs.c; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=llverfs.c

/* -*- mode: c; c-basic-offset: 8; indent-tabs-mode: nil; -*-
 * vim:expandtab:shiftwidth=8:tabstop=8:
 *
 * GPL HEADER START
 *
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 only,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License version 2 for more details (a copy is included
 * in the LICENSE file that accompanied this code).
 *
 * You should have received a copy of the GNU General Public License
 * version 2 along with this program; If not, see
 * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
 *
 * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
 * CA 95054 USA or visit www.sun.com if you need additional information or
 * have any questions.
 *
 * GPL HEADER END
 */
/*
 * Copyright  2008 Sun Microsystems, Inc. All rights reserved
 * Use is subject to license terms.
 */
/*
 * This file is part of Lustre, http://www.lustre.org/
 * Lustre is a trademark of Sun Microsystems, Inc.
 *
 * lustre/utils/llverfs.c
 *
 * ext3 Filesystem Verification Tool.
 * This program tests the correct operation of ext3 filesystem.
 * This tool have two working modes
 * 1. full mode
 * 2. fast mode
 *	The full mode is basic mode in which program creates a subdirectory
 * in the test fileysytem, writes n(files_in_dir, default=16) large(4GB) files
 * to the directory with the test pattern at the start of each 4kb block.
 * The test pattern contains timestamp, relative file offset and per file
 * unique idenfifier(inode number). this continues until whole filesystem is
 * full and then this tooll verifies that the data in all of the test files
 * is correct.
 *	In the fast mode the tool creates a test directories with
 * EXT3_TOPDIR_FL flag set. the number of directories equals to the number
 * of block groups in the filesystem(e.g. 65536 directories for 8TB filesystem)
 * and then writes a single 1MB file in each directory. The tool then verifies
 * that the data in each file is correct.
 */

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#ifndef LUSTRE_UTILS
#define LUSTRE_UTILS
#endif
#ifndef _LARGEFILE64_SOURCE
#define _LARGEFILE64_SOURCE
#endif
#ifndef _FILE_OFFSET_BITS
#define _FILE_OFFSET_BITS 64
#endif

#include <features.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <time.h>
#include <dirent.h>
#include <mntent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/vfs.h>
#include <gnu/stubs.h>
#include <gnu/stubs.h>

#ifdef HAVE_EXT2FS_EXT2FS_H
#  include <e2p/e2p.h>
#  include <ext2fs/ext2fs.h>
#endif

#define ONE_MB (1024 * 1024)
#define ONE_GB ((unsigned long long)(1024 * 1024 * 1024))
#define BLOCKSIZE 4096

/* Structure for writing test pattern */
struct block_data {
	unsigned long long bd_offset;
	unsigned long long bd_time;
	unsigned long long bd_inode;
};
static char *progname;		    /* name by which this program was run. */
static unsigned verbose = 1;	    /* prints offset in kB, operation rate */
static int readoption;		    /* run test in read-only (verify) mode */
static int writeoption;		    /* run test in write_only mode */
char *testdir;			    /* name of device to be tested. */
static unsigned full = 1;	    /* flag to full check */
static int errno_local;		    /* local copy of errno */
static unsigned long num_files;     /* Total number of files for read/write */
static loff_t file_size = 4*ONE_GB; /* Size of each file */
static unsigned files_in_dir = 32;  /* number of files in each directioy */
static unsigned num_dirs = 30000;   /* total number of directories */
const int dirmode = S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH;
static int fd = -1;
static int isatty_flag;
static int perms =  S_IRWXU | S_IRGRP | S_IROTH;

static struct option const longopts[] =
{
	{ "chunksize", required_argument, 0, 'c' },
	{ "help", no_argument, 0, 'h' },
	{ "offset", required_argument, 0, 'o' },
	{ "long", no_argument, 0, 'l' },
	{ "partial", required_argument, 0, 'p' },
	{ "quiet", required_argument, 0, 'q' },
	{ "read", no_argument, 0, 'r' },
	{ "timestamp", required_argument, 0, 't' },
	{ "verbose", no_argument, 0, 'v' },
	{ "write", no_argument, 0, 'w' },
	{ 0, 0, 0, 0}
};

/*
 * Usages: displays help information, whenever user supply --help option in
 * command or enters incorrect command line.
 */
void usage(int status)
{
	if (status != 0)
	{
	      printf("\nUsage: %s [OPTION]... <filesystem path> ...\n",
			progname);
	      printf("ext3 filesystem verification tool.\n"
		  "\t-t {seconds} for --timestamp,  set test time"
		  "(default=current time())\n"
		  "\t-o {offset}  for --offset, directory starting offset"
		  " from which tests should start\n"
		  "\t-r run test in read (verify) mode\n"
		  "\t-w run test in write (test-pattern) mode (default=r&w)\n"
		  "\t-v for verbose\n"
		  "\t-p for --partial, for partial check (1MB files)\n"
		  "\t-l for --long, full check (4GB file with 4k blocks)\n"
		  "\t-c for --chunksize, IO chunk size (default=1048576)\n"
		  "\t-h display this help and exit\n"
		  "\t--help display this help and exit\n");
	}
	exit(status);
}

/*
 * open_file: Opens file in specified mode and returns fd.
 */
static int open_file(const char *file, int flag)
{
	fd = open(file, flag, perms);
	if (fd < 0) {
		fprintf(stderr, "\n%s: Open '%s' failed:%s\n",
			progname, file, strerror(errno));
		exit(3);
	}
	return (fd);
}

/*
 * Verify_chunk: Verifies test pattern in each 4kB (BLOCKSIZE) is correct.
 * Returns 0 if test offset and timestamp is correct otherwise 1.
 */
int verify_chunk(char *chunk_buf, size_t chunksize,unsigned long long chunk_off,
		 unsigned long long time_st, unsigned long long inode_st,
		 char *file)
{
	struct block_data *bd;
	char *chunk_end;

	for (chunk_end = chunk_buf + chunksize - sizeof(*bd);
	     (char *)chunk_buf < chunk_end;
	     chunk_buf += BLOCKSIZE, chunk_off += BLOCKSIZE) {
		bd = (struct block_data *)chunk_buf;
		if ((bd->bd_offset == chunk_off) && (bd->bd_time == time_st) &&
		    (bd->bd_inode == inode_st))
			continue;
		fprintf(stderr,"\n%s: verify %s failed offset/timestamp/inode "
			"%llu/%llu/%llu: found %llu/%llu/%llu instead\n",
			progname, file, chunk_off, time_st, inode_st,
			bd->bd_offset, bd->bd_time, bd->bd_inode);
		return 1;
	}
	return 0;
}

/*
 * fill_chunk: Fills the chunk with current or user specified timestamp
 * and  offset. The test patters is filled at the beginning of
 * each 4kB(BLOCKSIZE) blocks in chunk_buf.
 */
void fill_chunk(char *chunk_buf, size_t chunksize, loff_t chunk_off,
		time_t time_st, ino_t inode_st)
{
	struct block_data *bd;
	char *chunk_end;

	for (chunk_end = chunk_buf + chunksize - sizeof(*bd);
	     (char *)chunk_buf < chunk_end;
	     chunk_buf += BLOCKSIZE, chunk_off += BLOCKSIZE) {
		bd = (struct block_data *)chunk_buf;
		bd->bd_offset = chunk_off;
		bd->bd_time = time_st;
		bd->bd_inode = inode_st;
	}
}

/*
 * write_chunk: write the chunk_buf on the device. The number of write
 * operations are based on the parameters write_end, offset, and chunksize.
 */
int write_chunks(int fd, unsigned long long offset,unsigned long long write_end,
		 char *chunk_buf, size_t chunksize, time_t time_st,
		 ino_t inode_st, const char *file)
{
	unsigned long long stride;

	stride = full ? chunksize : (ONE_GB - chunksize);
	for (offset = offset & ~(chunksize - 1); offset < write_end;
	     offset += stride) {
		if (lseek64(fd, offset, SEEK_SET) == -1) {
			fprintf(stderr, "\n%s: lseek64(%s+%llu) failed: %s\n",
				progname, file, offset, strerror(errno));
			return 1;
		}
		if (offset + chunksize > write_end)
			chunksize = write_end - offset;
		if (!full && offset > chunksize) {
			fill_chunk(chunk_buf, chunksize, offset, time_st,
				    inode_st);
			if (write(fd, chunk_buf, chunksize) < 0) {
				if (errno == ENOSPC) {
					errno_local = errno;
					return 0;
				}
				fprintf(stderr,
					"\n%s: write %s+%llu failed: %s\n",
					progname, file, offset,strerror(errno));
				return errno;
			}
			offset += chunksize;
			if (offset + chunksize > write_end)
				chunksize = write_end - offset;
		}
		fill_chunk(chunk_buf, chunksize, offset, time_st, inode_st);
		if (write(fd, (char *) chunk_buf, chunksize) < 0) {
			if (errno == ENOSPC) {
				errno_local = errno;
				return 0;
			}
			fprintf(stderr, "\n%s: write %s+%llu failed: %s\n",
				progname, file, offset, strerror(errno));
			return 1;
		}
	}
	return 0;
}

/*
 * read_chunk: reads the chunk_buf from the device. The number of read
 * operations are based on the parameters read_end, offset, and chunksize.
 */
int read_chunks(int fd, unsigned long long offset, unsigned long long read_end,
		char *chunk_buf, size_t chunksize, time_t time_st,
		ino_t inode_st, char *file)
{
	unsigned long long stride;

	stride = full ? chunksize : (ONE_GB - chunksize);
	for (offset = offset & ~(chunksize - 1); offset < read_end;
	     offset += stride) {
		if (lseek64(fd, offset, SEEK_SET) == -1) {
			fprintf(stderr, "\n%s: lseek64(%s+%llu) failed: %s\n",
				progname, file, offset, strerror(errno));
			return 1;
		}
		if (offset + chunksize > read_end)
			chunksize = read_end - offset;
		if (!full && offset > chunksize) {
			if (read(fd, chunk_buf, chunksize) < 0) {
				fprintf(stderr,
					"\n%s: read %s+%llu failed: %s\n",
					progname, file, offset,strerror(errno));
				return 1;
			}
			if (verify_chunk(chunk_buf, chunksize, offset,
					 time_st, inode_st, file) != 0)
				return 1;
			offset += chunksize;
			if (offset + chunksize >= read_end)
				chunksize = read_end - offset;
		}
		if (read(fd, chunk_buf, chunksize) < 0) {
			fprintf(stderr, "\n%s: read %s+%llu failed: %s\n",
				progname, file, offset, strerror(errno));
			return 1;
		}
		if (verify_chunk(chunk_buf, chunksize, offset, time_st,
				 inode_st, file) != 0)
			return 1;
	}
	return 0;
}

/*
 * new_file: prepares new filename using file counter and current dir.
 */
char *new_file(char *tempfile, char *cur_dir, int file_num)
{
	sprintf(tempfile, "%s/file%03d", cur_dir, file_num);
	return tempfile;
}

/*
 * new_dir: prepares new dir name using dir counters.
 */
char *new_dir(char *tempdir, int dir_num)
{
	sprintf(tempdir, "%s/dir%05d", testdir, dir_num);
	return tempdir;
}

/*
 * show_filename: Displays name of current file read/write
 */
void show_filename(char *op, char *filename)
{
	static time_t last;
	time_t now;
	double diff;

	now = time(NULL);
	diff = now - last;
	if (diff > 4 || verbose > 2) {
		if (isatty_flag)
			printf("\r");
		printf("%s File name: %s          ", op, filename);
		if (isatty_flag)
			fflush(stdout);
		else
			printf("\n");
		last = now;
	}
}

/*
 * dir_write: This function writes directories and files on device.
 * it works for both full and fast modes.
 */
static int dir_write(char *chunk_buf, size_t chunksize,
		     time_t time_st, unsigned long dir_num)
{
	char tempfile[PATH_MAX];
	char tempdir[PATH_MAX];
	struct stat64 file;
	int file_num = 999999999;
	ino_t inode_st = 0;

#ifdef HAVE_EXT2FS_EXT2FS_H
	if (!full && fsetflags(testdir, EXT2_TOPDIR_FL))
		fprintf(stderr,
			"\n%s: can't set TOPDIR_FL on %s: %s (ignoring)\n",
			progname, testdir, strerror(errno));
#endif
	for (; dir_num < num_dirs; num_files++, file_num++) {
		if (file_num >= files_in_dir) {
			if (dir_num == num_dirs - 1)
				break;

			file_num = 0;
			if (mkdir(new_dir(tempdir, dir_num), dirmode) < 0) {
				if (errno == ENOSPC)
					break;
				if (errno != EEXIST) {
					fprintf(stderr, "\n%s: mkdir %s : %s\n",
						progname, tempdir,
						strerror(errno));
					return 1;
				}
			}
			dir_num++;
		}
		fd = open_file(new_file(tempfile, tempdir, file_num),
			       O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE);

		if (fd >= 0 && fstat64(fd, &file) == 0) {
			inode_st = file.st_ino;
		} else {
			fprintf(stderr, "\n%s: write stat64 to file %s: %s",
				progname, tempfile, strerror(errno));
			exit(1);
		}

		if (verbose > 1)
			show_filename("write", tempfile);

		if (write_chunks(fd, 0, file_size, chunk_buf, chunksize,
				 time_st, inode_st, tempfile)) {
			close(fd);
			return 1;
		}
		close(fd);

		if (errno_local == ENOSPC)
			break;
	}

	if (verbose) {
		verbose++;
		show_filename("write", tempfile);
		printf("\nwrite complete\n");
		verbose--;
	}

	return 0;
}

/*
 * dir_read: This function reads directories and files on device.
 * it works for both full and fast modes.
 */
static int dir_read(char *chunk_buf, size_t chunksize,
		    time_t time_st, unsigned long dir_num)
{
	char tempfile[PATH_MAX];
	char tempdir[PATH_MAX];
	unsigned long count = 0;
	struct stat64 file;
	int file_num = 0;
	ino_t inode_st = 0;

	for (count = 0; count < num_files && dir_num < num_dirs; count++) {
		if (file_num == 0) {
			if (dir_num == num_dirs - 1)
				break;

			new_dir(tempdir, dir_num);
			dir_num++;
		}

		fd = open_file(new_file(tempfile, tempdir, file_num),
			       O_RDONLY | O_LARGEFILE);
		if (fd >= 0 && fstat64(fd, &file) == 0) {
			inode_st = file.st_ino;
		} else {
			fprintf(stderr, "\n%s: read stat64 file '%s': %s\n",
				progname, tempfile, strerror(errno));
			return 1;
		}

		if (verbose > 1)
			show_filename("read", tempfile);

		if (count == num_files)
			file_size = file.st_size;
		if (read_chunks(fd, 0, file_size, chunk_buf, chunksize,
				time_st, inode_st, tempfile)) {
			close(fd);
			return 1;
		}
		close(fd);

		if (++file_num >= files_in_dir)
			file_num = 0;
	}
	if (verbose > 1){
		verbose++;
		show_filename("read", tempfile);
		printf("\nread complete\n");
		verbose--;
	}
	return 0;
}

int main(int argc, char **argv)
{
	time_t time_st = 0;		/* Default timestamp */
	size_t chunksize = ONE_MB;	/* IO chunk size(defailt=1MB) */
	char *chunk_buf;		/* chunk buffer */
	int error = 0;
	FILE *countfile = NULL;
	char filecount[PATH_MAX];
	unsigned long dir_num = 0, dir_num_orig = 0;/* starting directory */
	int c;

	progname = strrchr(argv[0], '/') ? strrchr(argv[0], '/') + 1 : argv[0];
	while ((c = getopt_long(argc, argv, "t:rwvplo:h",
				      longopts, NULL)) != -1) {
		switch (c) {
		case 'c':
			chunksize = (strtoul(optarg, NULL, 0) * ONE_MB);
			if (!chunksize) {
				fprintf(stderr, "%s: Chunk size value should be"
					"a multiple of 1MB\n", progname);
				return -1;
			}
			break;
		case 'l':
			full = 1;
			break;
		case 'o': /* offset */
			dir_num = strtoul(optarg, NULL, 0);
			break;
		case 'p':
			full = 0;
			break;
		case 'q':
			verbose = 0;
			break;
		case 'r':
			readoption = 1;
			break;
		case 't':
			time_st = (time_t)strtoul(optarg, NULL, 0);
			break;
		case 'w':
			writeoption = 1;
			break;
		case 'v':
			verbose++;
			break;

		case 'h':
		default:
			usage(1);
			return 0;
		}
	}
	testdir = argv[optind];

	if (!testdir) {
		fprintf(stderr, "%s: pathname not given\n", progname);
		usage(1);
		return -1;
	}
	if (!readoption && !writeoption) {
		readoption = 1;
		writeoption = 1;
	}
	if (!time_st)
		(void) time(&time_st);
	printf("Timestamp: %lu\n", (unsigned long )time_st);
	isatty_flag = isatty(STDOUT_FILENO);

	if (!full) {
#ifdef HAVE_EXT2FS_EXT2FS_H
		struct mntent *tempmnt;
		FILE *fp = NULL;
		ext2_filsys fs;

		if ((fp = setmntent("/etc/mtab", "r")) == NULL){
			fprintf(stderr, "%s: fail to open /etc/mtab in read"
				"mode :%s\n", progname, strerror(errno));
			goto guess;
		}

		/* find device name using filesystem */
		while ((tempmnt = getmntent(fp)) != NULL) {
			if (strcmp(tempmnt->mnt_dir, testdir) == 0)
				break;
		}

		if (tempmnt == NULL) {
			fprintf(stderr, "%s: no device found for '%s'\n",
				progname, testdir);
			endmntent(fp);
			goto guess;
		}

		if (ext2fs_open(tempmnt->mnt_fsname, 0, 0, 0,
				unix_io_manager, &fs)) {
			fprintf(stderr, "%s: unable to open ext3 fs on '%s'\n",
				progname, testdir);
			endmntent(fp);
			goto guess;
		}
		endmntent(fp);

		num_dirs = (fs->super->s_blocks_count +
			    fs->super->s_blocks_per_group - 1) /
			fs->super->s_blocks_per_group;
		if (verbose)
			printf("ext3 block groups: %u, fs blocks: %u "
			       "blocks per group: %u\n",
			       num_dirs, fs->super->s_blocks_count,
			       fs->super->s_blocks_per_group);
		ext2fs_close(fs);
#else
                goto guess;
#endif
		if (0) { /* ugh */
			struct statfs64 statbuf;
		guess:
			if (statfs64(testdir, &statbuf) == 0) {
				num_dirs = (long long)statbuf.f_blocks *
					statbuf.f_bsize / (128ULL << 20);
				if (verbose)
					printf("dirs: %u, fs blocks: %llu\n",
					       num_dirs,
					       (long long)statbuf.f_blocks);
			} else {
				fprintf(stderr, "%s: unable to stat '%s': %s\n",
					progname, testdir, strerror(errno));
				if (verbose)
					printf("dirs: %u\n", num_dirs);
			}
		}

		file_size = ONE_MB;
		chunksize = ONE_MB;
		files_in_dir = 1;
	}
	chunk_buf = (char *)calloc(chunksize, 1);
	if (chunk_buf == NULL) {
		fprintf(stderr, "Memory allocation failed for chunk_buf\n");
		return 4;
	}
	sprintf(filecount, "%s/%s.filecount", testdir, progname);
	if (writeoption) {
		(void)mkdir(testdir, dirmode);

		unlink(filecount);
		if (dir_num != 0) {
			num_files = dir_num * files_in_dir;
			if (verbose)
				printf("\n%s: %lu files already written\n",
				       progname, num_files);
		}
		if (dir_write(chunk_buf, chunksize, time_st, dir_num)) {
			error = 3;
			goto out;
		}
		countfile = fopen(filecount, "w");
		if (countfile != NULL) {
			if (fprintf(countfile, "%lu", num_files) < 1 ||
			    fflush(countfile) != 0) {
				fprintf(stderr, "\n%s: writing %s failed :%s\n",
					progname, filecount, strerror(errno));
			}
			fclose(countfile);
		}
		dir_num = dir_num_orig;
	}
	if (readoption) {
		if (!writeoption) {
			countfile = fopen(filecount, "r");
			if (countfile == NULL ||
			    fscanf(countfile, "%lu", &num_files) != 1) {
				fprintf(stderr, "\n%s: reading %s failed :%s\n",
					progname, filecount, strerror(errno));
				num_files = num_dirs * files_in_dir;
			} else {
				num_files -= (dir_num * files_in_dir);
			}
			if (countfile)
				fclose(countfile);
		}
		if (dir_read(chunk_buf, chunksize, time_st, dir_num)) {
			fprintf(stderr, "\n%s: Data verification failed\n",
				progname) ;
			error = 2;
			goto out;
		}
	}
	error = 0;
out:
	free(chunk_buf);
	return error;
}

--Boundary_(ID_nHdyfUoCY8mBv2CgvYao2A)--
