From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] inode.c: only update the icache for ext2_inode
Date: Thu, 27 Feb 2014 21:09:24 -0500
Message-ID: <20140228020924.GA17178@thunk.org>
References: <1388740541-28123-1-git-send-email-liezhi.yang@windriver.com>
 <1388740541-28123-2-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sgh@sgh.dk, linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35049 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaB1DC5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Feb 2014 22:02:57 -0500
Content-Disposition: inline
In-Reply-To: <1388740541-28123-2-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 03, 2014 at 04:15:40AM -0500, Robert Yang wrote:
> We read the cache when:
> 
> bufsize == sizeof(struct ext2_inode)
> 
> so we should update the cache in the same rule, otherwise there would be
> errors, for example:
> 
> cache[0]: cached ino 14 when bufsize = 128 by ext2fs_write_inode_full()
> cache[1]: cached ino 14 when bufsize = 156 by ext2fs_read_inode_full()
> 
> Then update the cache:
> cache[0]: cached ino 15 when bufsize = 156 by ext2fs_read_inode_full()
> 
> And the ino 14 would hit the cache[1] when bufsize = 128 (but it was
> cached by bufsize = 156), so there would be errors.

So I've been looking at this code, and it looks like what we have is
correct.  The inode cache is a writethrough cache of the first 128
bytes of the inode, which means that we always update the on-disk
image as well as updating the first 128 bytes of the inode.

Yoru change would actually add a bug, because if the inode 14 was in
the cache, and then we tried to write a large inode, skipping the
inode cache update would mean that a subsequent read of a original
inode size would result in inode cache not being updated, and there
would thus be stale data in the cache.

Here's a test program which proves that what we have right now is
working.  If you think there's a problem, could you perhaps try
adjusting this program to show what you think is the bug?

	       	       	       	    	      - Ted

/*
 * Test read/write inode functions
 */

#include <string.h>
#include <fcntl.h>
#include <ctype.h>
#include <termios.h>
#include <time.h>
#include <getopt.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>

#include <et/com_err.h>
#include <ext2fs/ext2fs.h>

extern int isatty(int);

static const char * program_name = "tst_rwinode";
static const char * device_name = NULL;
static int debug = 0;

static void usage(void)
{
	fprintf(stderr,
		"Usage: %s [-F] [-I inode_buffer_blocks] device\n",
		program_name);
	exit(1);
}

static void PRS(int argc, char *argv[])
{
	int		flush = 0;
	int		c;
#ifdef MTRACE
	extern void	*mallwatch;
#endif
	errcode_t	retval;

	setbuf(stdout, NULL);
	setbuf(stderr, NULL);
	add_error_table(&et_ext2_error_table);

	if (argc && *argv)
		program_name = *argv;
	while ((c = getopt (argc, argv, "d")) != EOF)
		switch (c) {
		case 'd':
			debug++;
			break;
		default:
			usage ();
		}
	device_name = argv[optind];
}

int main (int argc, char *argv[])
{
	errcode_t	retval = 0;
	ext2_filsys	fs;
	ext2_ino_t	ino;
	__u32	num_inodes = 0;
	struct ext2_inode_large large_inode;
	struct ext2_inode inode;
	ext2_inode_scan	scan;
	int err = 0;

	PRS(argc, argv);

	retval = ext2fs_open(device_name, EXT2_FLAG_RW,
			     0, 0, unix_io_manager, &fs);
	if (retval) {
		com_err(program_name, retval, "while trying to open '%s'",
			device_name);
		exit(1);
	}

	retval = ext2fs_read_bitmaps(fs);
	if (retval) {
		com_err(program_name, retval, "while reading bitmaps");
		exit(1);
	}

	retval = ext2fs_new_inode(fs, EXT2_ROOT_INO, 0644,
				  NULL, &ino);
	if (retval) {
		com_err(program_name, retval,
			"while trying to allocate inode");
		exit(1);
	}

	if (debug)
		printf("Using inode %u\n", ino);

	memset(&inode, 0, sizeof(inode));
	inode.i_size = 123;

	retval = ext2fs_write_new_inode(fs, ino, &inode);
	if (retval) {
		com_err(program_name, retval,
			"while trying to write inode %u", ino);
		exit(1);
	}

	memset(&inode, 0, sizeof(inode));

	retval = ext2fs_read_inode(fs, ino, &inode);
	if (retval) {
		com_err(program_name, retval,
			"while reading inode %u", ino);
		exit(1);
	}
	printf("inode size: %u\n", inode.i_size);
	if (inode.i_size != 123) {
		printf("Bad inode size!!\n");
		err++;
	}

	memset(&large_inode, 0, sizeof(large_inode));
	retval = ext2fs_read_inode_full(fs, ino,
					(struct ext2_inode *) &large_inode,
					sizeof(large_inode));
	if (retval) {
		com_err(program_name, retval,
			"while reading large inode %u", ino);
		exit(1);
	}

	printf("large inode size: %u\n", large_inode.i_size);
	if (large_inode.i_size != 123) {
		printf("Bad inode size!!\n");
		err++;
	}

	large_inode.i_size = 456;
	large_inode.i_crtime = 789;

	retval = ext2fs_write_inode_full(fs, ino,
					 (struct ext2_inode *) &large_inode,
					 sizeof(large_inode));
	if (retval) {
		com_err(program_name, retval,
			"while write large inode %u", ino);
		exit(1);
	}

	memset(&inode, 0, sizeof(inode));
	retval = ext2fs_read_inode(fs, ino, &inode);
	if (retval) {
		com_err(program_name, retval,
			"while reading inode %u", ino);
		exit(1);
	}
	printf("inode size: %u\n", inode.i_size);
	if (inode.i_size != 456) {
		printf("Bad inode size!!\n");
		err++;
	}

	memset(&large_inode, 0, sizeof(large_inode));
	retval = ext2fs_read_inode_full(fs, ino,
					(struct ext2_inode *) &large_inode,
					sizeof(large_inode));
	if (retval) {
		com_err(program_name, retval,
			"while reading large inode %u", ino);
		exit(1);
	}

	printf("large inode size: %u\n", large_inode.i_size);
	printf("large inode crtime: %u\n", large_inode.i_crtime);

	if (large_inode.i_size != 456) {
		printf("Bad inode size!!\n");
		err++;
	}
	if ((EXT2_INODE_SIZE(fs->super) > 128) &&
	    large_inode.i_crtime != 789) {
		printf("Bad crtime!!\n");
		err++;
	}

	retval = ext2fs_close(fs);
	if (retval) {
		com_err(program_name, retval,
			"while trying to close the filesystem");
		exit(1);
	}

	if (err == 0)
		printf("Test succeed!\n");

	remove_error_table(&et_ext2_error_table);
	exit(err);
}
