From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Sat, 31 Jan 2009 00:25:39 -0500
Message-ID: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43104 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZAaFZm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Jan 2009 00:25:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've updated the ext4 backport branches on the ext4 git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
   http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

The for-stable branch is branched off of 2.6.28.2, and has a candidate
set of patches to be included in the next stable release.  The
for-stable-2.6.27 branch is branched off of 2.6.27.13.  

I'm more confident with the 2.6.28 stable candidate than the 2.6.27
stable candidates at the moment, but given that we just missed the
2.6.27.14 and 2.6.28.3 release cycles, that should give us plenty of
time to test the patches.

						- Ted


mainline 2.6.28  2.6.27
    commit-description
-------------------------------------------------------------------------
f99b2589 99186e9 50137b9b
    ext4: Add support for non-native signed/unsigned htree hash algorithms

2a21e37e a24d2c3 c6ee3785
    ext4: tone down ext4_da_writepages warnings

791b7f08 09dd336 20a5992c
    ext4: Fix the delalloc writepages to allocate blocks at the right offset.

565a9617 98da3f7 8fac34d1
    ext4: avoid ext4_error when mounting a fs with a single bg

ff7ef329 d77464d a3d3507c
    ext4: Widen type of ext4_sb_info.s_mb_maxs[]

fd98496f 956559e d0c7cd8e
    jbd2: Add barrier not supported test to journal_wait_on_commit_record

032115fc faa39cf 672ccd67
    ext4: Don't overwrite allocation_context ac_status

e21675d4 f45872d 44e83b40
    ext4: Add blocks added during resize to bitmap

920313a7 36a926a de7c44e7
    ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize

c3a326a6 34bb72b d0bbe797
    ext4: cleanup mballoc header files

c894058d -----   71ae3e25
    ext4: Use an rbtree for tracking blocks freed during transaction.

7a2fcbf7 cbf340c c71f2a67
    ext4: don't use blocks freed but not yet committed in buddy cache init
    
e8134b27 8e5ffb2 0d047b2d
    ext4: Fix race between read_block_bitmap() and mark_diskspace_used()

39341867 2298c89 78114d26
    ext4: Fix the race between read_inode_bitmap() and ext4_new_inode()

e97fcd95 469496b b04246c8
    jbd2: Add BH_JBDPrivateStart

2ccb5fb9 bfb49c0 bf79ca1d
    ext4: Use new buffer_head flag to check uninit group bitmaps initialization

648f5879 08d0947 ba08e9a6
    ext4: mark the blocks/inode bitmap beyond end of group as used

8556e8f3 18d5cb0 fd3bd090
    ext4: Don't allow new groups to be added during block allocation

29eaf024 a38467c fb8c1296
    ext4: Init the complete page while building buddy cache

0087d9fb 462dbdb -----
    ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc

4ec11028 c457db2 850eb20e
    ext4: Add sanity checks for the superblock before mounting the filesystem

06a279d6 cd676b5 713e7106
    ext4: only use i_size_high for regular files

e6b8bc09 4a81724 312eaf17
    ext4: Add sanity check to make_indexed_dir

a21102b5 1b1872b 0f30c439
    ext3: Add sanity check to make_indexed_dir

08ec8c38 a062e44 2ea34131
    jbd2: On a __journal_expect() assertion failure printk "JBD2", not "EXT3-fs"

fdff73f0 e041093 b86f4c8d
    ext4: Initialize the new group descriptor when resizing the filesystem

