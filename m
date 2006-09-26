From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:33:43 +0200
Message-ID: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41959 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932083AbWIZOdw
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:33:52 -0400
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hello, 

i've updated e2fsprogs to be in sync with the latest kernel changes; here is
a summary of all changes:

01-head_20060918

	this is a diff between 1.39 and a mercurial snapshot from sep 18,
	2006. It's here just to allow people to apply the patch set on
	e2fsprogs-1.39
	
02-percent

	fixes division by zero in e2p_percent(), already posted few days ago

The following are the patches that Andreas posted, no changes:

03-inode_prealloc
04-extents
05-extents_htree
06-eacheck

The following are for 64bit support; they do the same as the patch set i
posted the last time but with various bugs fixed; they are reorganised and
cleaned up:

07-pblk_ondisk_blocknum

	convert all 32bit on-disk block number definitions (currently __u32,
	blk_t, unsigned long, unsigned int...) to pblk_t that is defined as
	__u32. In this way we are sure that blk_t is used only in memory. 
	Later, this would allow to make blk_t 64bit without disturbing any
	programs (this would just eat more momory and use 64bit arithmetic).


08-use_64bit_io

	use 64bit offsets and block numbers (unsigned long long) in
	*_read_blk, *_write_blk, and friends.

09-use_64bit_block_numbers

	add the 64BIT incompat feature (make blk_t 64bit and add "_hi" bits
	un super block and descruptors)

10-extents_48bit_block_numbers

	makes extents code use *_hi bits: updated according Andreas'
	comments.

11-desc_size

	allow larger block group descriptors. The in memory ext2_group_desc
	structure can have an arbitrary size (the on-disk on still have to
	be a power of 2). This change is necessary in order to enlarge block
	groups later.

12-move_block_number_hi_bits

	moves group descriptors "*_hi" bits to the larger part of the
	ext2_group_desc structure.

I've successfully tested them on a x84_64 arch with a 20TB device with the
latest kernel patches.

The complete e2fsprogs and kernel patch sets are available here:

http://www.bullopensource.org/ext4/20060926/

Comments?

-- Alexandre
