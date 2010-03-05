From: tytso@mit.edu
Subject: Re: [PATCH 1/3] ext4: Fix insertion point of extent in
 mext_insert_across_blocks()
Date: Fri, 5 Mar 2010 11:10:08 -0500
Message-ID: <20100305161008.GB6000@thunk.org>
References: <4B8E0679.8060706@rs.jp.nec.com>
 <20100304012508.GD3530@thunk.org>
 <4B90BEA9.9020208@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37361 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab0CEQKK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Mar 2010 11:10:10 -0500
Content-Disposition: inline
In-Reply-To: <4B90BEA9.9020208@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 05, 2010 at 05:19:53PM +0900, Akira Fujita wrote:
> 
> Sounds interesting.
> It seems to be able to try easily except (2).
> I think that we can mark block bitmap as in use with debugfs (do_setb).
> Do you have another better idea for the tool you mentioned at (2)?

The libext2fs library is very powerful.  :-)

Here's a quicky program I whipped up fairly quickly.  The code that
actually messes with the block bitmap is in the for loop; the rest is
just generic setup.  Feel free to reuse this program as a framework
for other times when you want to quickly create a program to do
something programmatic where debugfs isn't quite powerful enough for
your needs.

I have considered trying to integrate tcl into debugfs, so that you
could do this in thing more easily in debugfs directly, but it's so
easy to write throwaway C programs that I've never bothered.

Regards,

       	 		  	  - Ted

/*
 * fill-bitmap.c --- Program which writes marks roughly half of the 
 *     blocks in the filesystem as being in use.
 *
 * Compile via: cc -o fill-bitmap fill-bitmap.c -lext2fs -lcom_err
 *
 * Copyright 2010 by Theodore Ts'o.
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
 */

#include <ext2fs/ext2_fs.h>
#include <ext2fs/ext2fs.h>
#include <et/com_err.h>
#include <stdlib.h>

char *program_name;

static void usage(void)
{
	fprintf(stderr, "Usage: %s device\n", program_name);
	exit (1);
}

int main (int argc, char ** argv)
{
	errcode_t retval;
	ext2_filsys fs;
	char *device_name;
	blk_t blk;

	add_error_table(&et_ext2_error_table);
	if (argc != 2)
		usage();
	program_name = argv[0];
	device_name = argv[1];

	retval = ext2fs_open (device_name, EXT2_FLAG_RW, 0, 0,
			      unix_io_manager, &fs);
        if (retval) {
		com_err(program_name, retval, "while trying to open %s",
			device_name);
		exit(1);
	}

	retval = ext2fs_read_bitmaps(fs);
	if (retval) {
		com_err(program_name, retval, "while reading bitmaps");
		exit(1);
	}

	for (blk = fs->super->s_first_data_block;
	     blk < fs->super->s_blocks_count; blk++) {
		if (ext2fs_test_block_bitmap(fs->block_map, blk))
			continue;

		if (random() & 1)
			continue;

		ext2fs_mark_block_bitmap(fs->block_map, blk);
		ext2fs_block_alloc_stats(fs, blk, 1);
	}

	ext2fs_close(fs);
	remove_error_table(&et_ext2_error_table);
	exit (0);
}
