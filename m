From: "Theodore Ts'o" <tytso@mit.edu>
Subject: 2.6.23-rc8-ext4-1 patchset released
Date: Thu, 04 Oct 2007 01:59:28 -0400
Message-ID: <E1IdJk8-0002oh-1m@candygram.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60946 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760113AbXJDF7b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:59:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I've just released the 2.6.23-rc9-ext4-1.  It collapses some patches in
preparation for pushing them to Linus, and adds some of cleanup patches
that had been incorporated into Andrew's broken-out-2007-10-01-04-09
series.  It also has some new development patches in the unstable (not
yet ready to push to mainline) portion of the patch series.

It's available in the standard place:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.23-rc9-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=summary

and

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.23-rc9-ext4-1

                                                        - Ted

+ # pulled from rc8-mm2
+ jbd2-ext4-cleanups-convert-to-kzalloc.patch

+ # also in akpm's broken-out-2007-10-01-04-09
+ jbd2-fix-commit-code-to-properly-abort-journal.patch
+ 
+ # pulled from akpm's broken-out-2007-10-01-04-09
+ jbd2-debug-code-cleanup.patch

+ # pulled from akpm's broken-out-2007-10-01-04-09
+ remove-ifdef-config_ext4_index.patch 

+ # Large blocksize support for ext4
+ ext4_large_blocksize_support.patch
+ ext4_rec_len_overflow_with_64kblk_fix-v2.patch

+ # Large blocksize support for ext2/3
+ # Will drop these patches once they are in akmp's mm tree
+ ext2_large_blocksize_support.patch
+ ext3_large_blocksize_support.patch
+ ext2_rec_len_overflow_with_64kblk_fix-v2.patch
+ ext3_rec_len_overflow_with_64kblk_fix-v2.patch

+ # New patchset
+ ext4-convert_bg_block_bitmap_to_bg_block_bitmap_lo.patch
+ ext4-convert_bg_inode_bitmap_and_bg_inode_table.patch
+ ext4-convert_s_blocks_count_to_s_blocks_count_lo.patch
+ ext4-convert_s_r_blocks_count_and_s_free_blocks_count.patch
+ ext4-convert_ext4_extent.ee_start_to_ext4_extent.ee_start_lo.patch
+ ext4-convert_ext4_extent_idx.ei_leaf_to_ext4_extent_idx.ei_leaf_lo.patch
+ ext4-sparse-fix.patch

+ # Large block support for blocksize > pagesize
+ # Needed for Christoph Lameter's largeblock patchset
+ # to support large block on system that
+ # blocksize > pagesize
+ jbd-blocks-reservation-fix-for-large-blk.patch
+ jbd2-blocks-reservation-fix-for-large-blk.patch

+ ext4_fix_setup_new_group_blocks_locking.patch
+ ext4_lighten_up_resize_transaction_requirements.patch
