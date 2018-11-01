Return-Path: <SRS0=aByE=NM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:59042 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbeKAK4p (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2018 06:56:45 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-ext4@vger.kernel.org>
Subject: [PATCH] Ext4: fix ENOSPC when both quota and dioread_nolock are enabled
Date: Thu,  1 Nov 2018 09:54:29 +0800
Message-Id: <1541037269-96483-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With dioread_nolock, unwritten extents are converted in IO completion, and
these extents may be merged with siblings.

ext4_writepages() has reserved a handle to hold 2 credits for inode update
and extent update and the handle will be used in IO completion as we can't
start journal after clearing PageWriteback (due to locking rules).

However, if quota is enabled, the following enospc situation could happen,

ext4_convert_unwritten_extents
  ext4_ext_try_to_merge
    ext4_ext_try_to_merge_up
      ext4_journal_extend(handle, 2) # extend 2 credits for
                                     # bitmap/group_desc
      ext4_free_blocks()
        dquot_free_block
	  // use 3 credits for 3 quota types
	  // use 1 credit for inode update
	# update bitmap block
	# update group desc block
        # either of two updates may hit enospc
        # as ->h_buffer_credits has been consumed out.

In ext4_ext_try_to_merge(), per-inode extent tree may be collasped into
inode and ext4_free_blocks() will then free the unneeded blocks, but with
quota being enabled, there aren't enough credits to process updates and we
end up with -ENOSPC.

As this is a corner case, instead of adding credits in ext4_writepages(),
this just extends more credits for quota when doing merge-up.

Fixes: ecb94f5fdf4b (ext4: collapse a single extent tree block into the inode if possible)
CC: stable@vger.kernel.org # v3.6-rc1+
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/ext4/extents.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6dea5441..ff2498355e3c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1812,6 +1812,7 @@ static void ext4_ext_try_to_merge_up(handle_t *handle,
 	size_t s;
 	unsigned max_root = ext4_ext_space_root(inode, 0);
 	ext4_fsblk_t blk;
+	int credits = 2;
 
 	if ((path[0].p_depth != 1) ||
 	    (le16_to_cpu(path[0].p_hdr->eh_entries) != 1) ||
@@ -1820,10 +1821,12 @@ static void ext4_ext_try_to_merge_up(handle_t *handle,
 
 	/*
 	 * We need to modify the block allocation bitmap and the block
-	 * group descriptor to release the extent tree block.  If we
+	 * group descriptor to release the extent tree block.  If
+	 * quota is enabled, updates on quota are also needed.  If we
 	 * can't get the journal credits, give up.
 	 */
-	if (ext4_journal_extend(handle, 2))
+	credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
+	if (ext4_journal_extend(handle, credits))
 		return;
 
 	/*
-- 
1.8.3.1
