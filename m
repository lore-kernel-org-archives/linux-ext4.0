From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 2 Jun 2008 22:40:37 -0400
Message-ID: <20080603024037.GL23119@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu> <20080421164144.GG9700@mit.edu> <20080524235420.GD5970@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37810 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753057AbYFCCks (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 22:40:48 -0400
Content-Disposition: inline
In-Reply-To: <20080524235420.GD5970@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* js/64-bit (Mon Jun 2 22:29:26 2008 -0400) 11 commits
 - libext2fs: Add 64-bit support to the undo manager
 - Add 64-bit openfs interface.
 - Use new ext2fs_super_and_bgd_loc2 call in libext2fs.
 - Add 64-bit closefs interface.
 - Add 64-bit ext_attr interface.
 - Add 64-bit alloc interface.
 - Add 64-bit alloc_stats interface.
 - Add 64-bit dirblock interface.
 - Use blk64_t for blocks in struct ext2_file.
 - Add new blk64_t handling functions
 - Add ext2_off64_t type.
* es/setbmap (Mon Jun 2 20:36:52 2008 -0400) 4 commits
 + Teach ext2fs_extent_delete() to remove an empty extent node from
   the tree
 + libext2fs: add new function ext2fs_extent_set_bmap()
 + Teach ext2fs_extent_insert() to split the current node if
   necessary
 + libext2fs: Teach extent.c how to split nodes
* tt/journal-checksum (Fri May 23 01:00:19 2008 -0400) 3 commits
 - e2fsck: Add support to check journal checksums
 - Add CRC32 (big-endian) routine for use by journal checksums
 - Re-enable byte-swapping functions for use by journal checksums
* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps
* next (Mon Jun 2 21:40:02 2008 -0400) 6 commits
 + f_extents2: Add new test case testing e2fsck's support for extents
 + e2fsck: Detect unordered extents in an extent node
 + e2fsck: Wire up callback functions for _alloc_block() and
   _block_alloc_stats()
 + libext2fs: Add callback functions for _alloc_block() and
   _block_alloc_stats()
 + Wire ext2fs_bmap2() to use ext2fs_extent_set_bmap()
 + Wire ext2fs_block_iterate2() to use ext2fs_extent_set_bmap()
