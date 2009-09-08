From: "Theodore Ts'o" <tytso@mit.edu>
Subject: E2fsprogs pu branch updated
Date: Tue, 08 Sep 2009 00:06:38 -0400
Message-ID: <E1MkryY-0007nA-Qi@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43986 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZIHEGl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 00:06:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The pu branch has been rebased, so it now has the latest changes that
has been released, including the 1.41.9 updates and some more recent
ones made to the maint branch.  It also has the 64-bit patches that Eric
and Nick sent out, although they have been reworked and merged into some
of the other patches.

With this pu rebase, the following patches have been merged into the
'next' branch:

048786d debugfs: Convert to support 64-bit filesystems
4efbac6 Convert uses of super->s_*_blocks_count to ext2fs_*_blocks_count()
a63745e Use ext2fs_file_acl_block() instead of using .i_file_acl directly
c5b7b6b Fix overflow in calculation of total file system blocks
95fd65b libext2fs: create generic numeric progress meters and use them
732c8cd Use accessor functions fields for bg_flags in the block group descriptor
24a117a Convert to use io_channel_read_blk64() and io_channel_write_blk64()
d62d218 libext2fs: Fix counting routines in blknum.c to take/return __u32 counts
 76 files changed, 861 insertions(+), 709 deletions(-)

Commit d62d218 does change some of the interfaces in
lib/ext2fs/blknum.c; this doesn't represent an ABI change from previous
officially released versions of e2fsprogs, as lib/ext2fs/blknum.c is a
new file that is not in e2fsprogs 1.41.x, but it *does* represent an ABI
change from previous versions on the development branches of e2fsprogs.
So if you have shared library installed from previous 'master', 'next',
or 'pu' branches, you will need to make sure the shared library is
upgraded at the same time as the e2fsprogs binaries.

Commits on the 'pu' branch which still to be cleaned up and merged are:

f4a9f01 Fix ext2fs_set_gdt_csum() to use access functions
5de1ab5 libext2fs: last of the incorrect direct group_desc accesses
ba869cd libext2fs: enable dumpe2fs 64-bitness and fix printf formats.
ec14c4e Add some missing ext2_div64_ceil() calls
9a2e4cc fix inode->i_blocks 32-bit wrap in e2fsck/pass1.c.
0619373 Enable 64-bitness in e2image.c
338a3c0 Use 64-bit dblist functions
467b49d libext2fs: Create 64-bit dblist functions
d557ca0 parse_num_blocks() -> parse_num_blocks2()
3b78779 More random 64-bit fixes.
b194b18 More random 64-bit fixes, lots of block_iterate3
05428bb ext2fs_super_bgd_loc() -> ext2fs_super_bgd_loc2() everywhere else
8ea7edc Clean up some stragglers accessing group desc members directly
63f873f Block group descriptor accessor functions for debugfs, etc.
420ee88 Checksum conversion and more block group desc stuff
0485178 temporary checkin; about to do checksum conversion
4a3d299 resize2fs: Convert variables to support 64-bit filesystems
f2d4289 Fix bug in selecting fs type, resulting in 1K blocksize
b472868 e2fsck: Miscellaneous e2fsck-related 64-bit fixes.
419a0a8 Add 64bit option to known incompatible file system options
1b3d943 ext2fs_get_device_size -> ext2fs_get_device_size2
e8c59a7 ext2fs_block_alloc_stats -> ext2fs_block_alloc_stats2
3c4ec74 Convert to inode/block/bitmap/table loc()/loc_set() functions
ed132cc 64-bit mke2fs cleanup
 57 files changed, 1267 insertions(+), 787 deletions(-)

						- Ted
