From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Bad flexbg_overhead calculation
Date: Wed, 30 Jul 2014 01:07:10 +0000
Message-ID: <CFFDA174.B4921%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbaG3BHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2014 21:07:11 -0400
Content-Language: en-US
Content-ID: <C54941F4E960A64B80D21D7F27A57C55@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was running the "f_random_corruption" test during a build (patches
posted long ago), which formats filesystems with semi-random parameters,
and then
corrupts it and sees if e2fsck can fix it.  In this case, it failed during
mke2fs, but without any obvious reason:

./misc/mke2fs -j -t ext4 -b 4096 -I 1024 -O
sparse_super,filetype,dir_index,resize_inode -F /tmp/tt 79106
mke2fs 1.42.11 (09-Jul-2014)
Creating regular file /tmp/tt
/tmp/tt: Invalid argument passed to ext2 library while setting up
superblock



It looks like this is caused by the following check in ext2fs_initialize():

        flexbg_overhead = super->s_first_data_block + 1 +
		fs->desc_blocks + super->s_reserved_gdt_blocks +
		(__u64)flexbg_size * (2 + fs->inode_blocks_per_group);

	/*
	 * Disallow creating ext4 which breaks flex_bg metadata layout
	 * obviously.
	 */
	if (flexbg_overhead > ext2fs_blocks_count(fs->super)) {
		retval = EXT2_ET_INVALID_ARGUMENT;
		goto cleanup;
	}

I suspect the reason it is failing is due to "-I 1024", which is creating
large inodes with extra xattr space, and this is confusing the flexbg
check, though I don't think this should be considered an invalid option?


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


