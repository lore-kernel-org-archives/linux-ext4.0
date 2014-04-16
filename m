From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/5] ext4: Discard preallocations after removing space
Date: Wed, 16 Apr 2014 20:33:01 +0200
Message-ID: <1397673182-5326-4-git-send-email-lczerner@redhat.com>
References: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Cc: linkinjeon@gmail.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbaDPSdm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 14:33:42 -0400
In-Reply-To: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in ext4_collapse_range() and ext4_punch_hole() we're
discarding preallocation twice. Once before we attempt to do any changes
and second time after we're done with the changes.

While the second call to ext4_discard_preallocations() in
ext4_punch_hole() case is not needed, we need to discard preallocation
right after ext4_ext_remove_space() in collapse range case because in
the case we had to restart a transaction in the middle of removing space
we might have new preallocations created.

Remove unneeded ext4_discard_preallocations() ext4_punch_hole() and move
it to the better place in ext4_collapse_range()

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 2 +-
 fs/ext4/inode.c   | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9cd762c..84bb668 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5433,6 +5433,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		up_write(&EXT4_I(inode)->i_data_sem);
 		goto out_stop;
 	}
+	ext4_discard_preallocations(inode);
 
 	ret = ext4_ext_shift_extents(inode, handle, punch_stop,
 				     punch_stop - punch_start);
@@ -5445,7 +5446,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	i_size_write(inode, new_size);
 	EXT4_I(inode)->i_disksize = new_size;
 
-	ext4_discard_preallocations(inode);
 	up_write(&EXT4_I(inode)->i_data_sem);
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 56f1ff4..8765d49 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3613,7 +3613,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 		ret = ext4_free_hole_blocks(handle, inode, first_block,
 					    stop_block);
 
-	ext4_discard_preallocations(inode);
 	up_write(&EXT4_I(inode)->i_data_sem);
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
-- 
1.8.3.1

