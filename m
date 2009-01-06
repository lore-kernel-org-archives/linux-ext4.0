From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Patches in the ext4 patch queue that should be marked for -stable
Date: Mon, 05 Jan 2009 21:55:58 -0500
Message-ID: <E1LK26o-0004Wm-N0@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50223 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZAFC4B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 21:56:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I believe the following patches should be destined for -stable kernel
tree in the ext4 patch queue.

Have I missed any patches?   Do you believe any of these patches
*shouldn't* be added to the stable kernel?

 * add-barrier-check-to-journal_wait_on_commit_record
 * aneesh-2-add-blocks-added-during-resize-to-bitmap
 * aneesh-3-use_EXT4_GROUP_INFO_NEED_INIT_BIT-during-resize
 * aneesh-7-dont-use-blocks-freed-but-not-yet-committed-in-buddy-cache-init
 * aneesh-8-fix-double-free-of-blocks
 * avoid-ext4-error-for-single-bg-fs
 * dont-overwrite-allocation_context-ac_status
 * ext4-Don-t-allow-new-groups-to-be-added-during-bloc.patch
 * ext4-Fix-s_dirty_blocks_counter-if-block-allocation.patch
 * ext4-Init-the-complete-page-while-building-buddy-ca.patch
 * ext4-Use-new-buffer_head-flag-to-check-uninit-group.patch
 * ext4-mark-the-blocks-inode-bitmap-beyond-end-of-gro.patch
 * fix-delalloc-writepages-to-allocate-at-correct-offset
 * fix-race-between-read_block_bitmap-and-mark_diskspace_used
 * fix-race-between-read_inode_bitmap-and-ext4_new_inode

					- Ted

