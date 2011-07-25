From: Ted Ts'o <tytso@mit.edu>
Subject: Re: flashing large eMMC partitions with ext4
Date: Mon, 25 Jul 2011 14:10:43 -0400
Message-ID: <20110725181043.GK3469@thunk.org>
References: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36888 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1GYSKr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 14:10:47 -0400
Content-Disposition: inline
In-Reply-To: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 23, 2011 at 12:49:28AM +0900, Round Robinjp wrote:
> Hi
> 
> I have a question regarding making ext4 image for
> large eMMC partition.
>  
> We have a 4G partition in our embedded device
> in which we want to use ext4 filesystem.
> But for that we have to create a 4G image.
> flashing this 4G image to the eMMC takes a long
> time. Is there any way to reduce this time?
> 
> For vfat, you can truncate the image leaving only
> non zero-filled blocks which makes the image very
> short and the time for flashing is reduced.
> Is something similar to that possible for ext4?

OK, so it's not obvious what problem you are trying to ask here.

It sounds like Andreas was trying to help you solve the problem of
minimizing the number of blocks written by mke2fs.

I'm guessing the problem is you've already created a file system image
which is 4G, and for which a large number of the blocks are not used,
and you're trying to optimize the amount of time it takes to flash the
image.  Is that right?

The way to do that is to use a program like zerofree.c (google it, or
see attached) to make sure the non-used blocks are zero-filled, and
then use a program like make-sparse.c (see the e2fsprogs sources, in
the contrib directory) to only write the non-zero blocks to the flash
device.

Regards,

						- Ted

--uAKRQypu60I7Lcqm
Content-Type: text/x-csrc; charset=iso-8859-1
Content-Disposition: attachment; filename="zerofree.c"
Content-Transfer-Encoding: 8bit

/*
 * zerofree - a tool to zero free blocks in an ext2 filesystem
 *
 * Copyright (C) 2004 R M Yorston
 *
 * This file may be redistributed under the terms of the GNU General Public
 * License.
 *
 * Changes:
 *
 * 2007-08-12  Allow use on filesystems mounted read-only.   Patch from
 *             Jan Krämer.
 */

#include <ext2fs/ext2fs.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

#define USAGE "usage: %s [-n] [-v] filesystem\n"

int main(int argc, char **argv)
{
	errcode_t ret ;
	int flags ;
	int superblock = 0 ;
	int open_flags = EXT2_FLAG_RW ;
	int blocksize = 0 ;
	ext2_filsys current_fs = NULL;
	unsigned long blk ;
	unsigned char *buf;
	unsigned char *empty;
	int i, c ;
	unsigned int free, nonzero ;
	double percent ;
	int old_percent ;
	int verbose = 0 ;
	int dryrun = 0 ;

	while ( (c=getopt(argc, argv, "nv")) != -1 ) {
		switch (c) {
		case 'n' :
			dryrun = 1 ;
			break ;
		case 'v' :
			verbose = 1 ;
			break ;
		default :
			fprintf(stderr, USAGE, argv[0]) ;
			return 1 ;
		}
	}

	if ( argc != optind+1 ) {
		fprintf(stderr, USAGE, argv[0]) ;
		return 1 ;
	}

	ret = ext2fs_check_if_mounted(argv[optind], &flags) ;
	if ( ret ) {
		fprintf(stderr, "%s: failed to determine filesystem mount state  %s\n",
					argv[0], argv[optind]) ;
		return 1 ;
	}

	if ( (flags & EXT2_MF_MOUNTED) && !(flags & EXT2_MF_READONLY) ) {
		fprintf(stderr, "%s: filesystem %s is mounted rw\n",
					argv[0], argv[optind]) ;
		return 1 ;
	}

	ret = ext2fs_open(argv[optind], open_flags, superblock, blocksize,
							unix_io_manager, &current_fs);
	if ( ret ) {
		fprintf(stderr, "%s: failed to open filesystem %s\n",
					argv[0], argv[optind]) ;
		return 1 ;
	}

	empty = (unsigned char *)calloc(1, current_fs->blocksize) ;
	buf = (unsigned char *)malloc(current_fs->blocksize) ;

	if ( empty == NULL || buf == NULL ) {
		fprintf(stderr, "%s: out of memory (surely not?)\n", argv[0]) ;
		return 1 ;
	}

	ret = ext2fs_read_inode_bitmap(current_fs);
	if ( ret ) {
		fprintf(stderr, "%s: error while reading inode bitmap\n", argv[0]);
		return 1 ;
	}

	ret = ext2fs_read_block_bitmap(current_fs);
	if ( ret ) {
		fprintf(stderr, "%s: error while reading block bitmap\n", argv[0]);
		return 1 ;
	}

	free = nonzero = 0 ;
	percent = 0.0 ;
	old_percent = -1 ;

	if ( verbose ) {
		fprintf(stderr, "\r%4.1f%%", percent) ;
	}

	for ( blk=current_fs->super->s_first_data_block;
			blk < current_fs->super->s_blocks_count; blk++ ) {

		if ( ext2fs_test_block_bitmap(current_fs->block_map, blk) ) {
			continue ;
		}

		++free ;

		percent = 100.0 * (double)free/
					(double)current_fs->super->s_free_blocks_count ;

		if ( verbose && (int)(percent*10) != old_percent ) {
			fprintf(stderr, "\r%4.1f%%", percent) ;
			old_percent = (int)(percent*10) ;
		}

		ret = io_channel_read_blk(current_fs->io, blk, 1, buf);
		if ( ret ) {
			fprintf(stderr, "%s: error while reading block\n", argv[0]) ;
			return 1 ;
		}

		for ( i=0; i < current_fs->blocksize; ++i ) {
			if ( buf[i] ) {
				break ;
			}
		}

		if ( i == current_fs->blocksize ) {
			continue ;
		}

		++nonzero ;

		if ( !dryrun ) {
			ret = io_channel_write_blk(current_fs->io, blk, 1, empty) ;
			if ( ret ) {
				fprintf(stderr, "%s: error while writing block\n", argv[0]) ;
				return 1 ;
			}
		}
	}

	if ( verbose ) {
		printf("\r%u/%u/%u\n", nonzero, free,
				current_fs->super->s_blocks_count) ;
	}

	ret = ext2fs_close(current_fs) ;
	if ( ret ) {
		fprintf(stderr, "%s: error while closing filesystem\n", argv[0]) ;
		return 1 ;
	}

	return 0 ;
}

--uAKRQypu60I7Lcqm--
