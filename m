From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Sat, 24 May 2008 19:54:20 -0400
Message-ID: <20080524235420.GD5970@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu> <20080421164144.GG9700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57991 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbYEXXyd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2008 19:54:33 -0400
Content-Disposition: inline
In-Reply-To: <20080421164144.GG9700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The two topics I really want to get done before an e2fsprogs 1.41
release is tt/journal-checksum and es/setbmap.  Fortunately both are
pretty close to being done.

						- Ted

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* tt/journal-checksum (Fri May 23 01:00:19 2008 -0400) 3 commits
 - e2fsck: Add support to check journal checksums
 - Add CRC32 (big-endian) routine for use by journal checksums
 - Re-enable byte-swapping functions for use by journal checksums

	This basically works, but it currently stops without applying
	a commit which has a failed checksum.  Probably not the right
	approach, as I discussed in a recent note to linux-ext4.

* js/64-bit (Wed May 21 12:54:28 2008 -0500) 10 commits
 . Add 64-bit openfs interface.
 . Use new ext2fs_super_and_bgd_loc2 call in libext2fs.
 . Add 64-bit closefs interface.
 . Add 64-bit ext_attr interface.
 . Add 64-bit alloc interface.
 . Add 64-bit alloc_stats interface.
 . Add 64-bit dirblock interface.
 . Use blk64_t for blocks in struct ext2_file.
 . Add new blk64_t handling functions
 . Add ext2_off64_t type.

	I did not include this in the 'pu' branch because without the
	undo manager support, it could break mke2fs.

* es/setbmap (Tue May 20 16:13:41 2008 -0500) 4 commits
 - delete unused nodes in ext2fs_extent_delete
 - libext2fs: add ext2fs_extent_set_bmap
 - libext2fs: allow ext2fs_extent_insert to split if needed
 - libext2fs: ext2fs_node_split

	This needs a once-over, and then we need to wire up the
	ext2fs_extent_set_bmap() funcion so it is called by
	ext2fs_block_iterate() and ext2fs_bmap().

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	Still on my todo list.

----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
