From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] ext4: Update reserved space after the 'correction'
Date: Fri,  8 Mar 2013 09:24:18 +0100
Message-ID: <1362731059-3508-2-git-send-email-lczerner@redhat.com>
References: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
Cc: gnehzuil.liu@gmail.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab3CHIY0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 03:24:26 -0500
In-Reply-To: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in ext4_ext_map_blocks() in delayed allocation writeback
we would update the reservation and after that check whether we claimed
cluster outside of the range of the allocation and if so, we'll give the
block back to the reservation pool.

However this also means that if the number of reserved data block
dropped to zero before the correction, we would release all the metadata
reservation as well, however we might still need it because the we're
not done with the delayed allocation and there might be more blocks to
come. This will result in error messages such as:

EXT4-fs warning (device sdb): ext4_da_update_reserve_space:361: ino 12,
allocated 1 with only 0 reserved metadata blocks (releasing 1 blocks
with reserved 1 data blocks)

This will only happen on bigalloc file system and it can be easily
reproduced using fiemap-tester from xfstests like this:

./src/fiemap-tester -m DHDHDHDHD -S -p0 /mnt/test/file

Or using xfstests such as 225.

Fix this by doing the correction first and updating the reservation
after that so that we do not accidentally decrease
i_reserved_data_blocks to zero.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 28dd8ee..cac80120 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4106,9 +4106,6 @@ got_allocated_blocks:
 			}
 		} else {
 			BUG_ON(allocated_clusters < reserved_clusters);
-			/* We will claim quota for all newly allocated blocks.*/
-			ext4_da_update_reserve_space(inode, allocated_clusters,
-							1);
 			if (reserved_clusters < allocated_clusters) {
 				struct ext4_inode_info *ei = EXT4_I(inode);
 				int reservation = allocated_clusters -
@@ -4159,6 +4156,15 @@ got_allocated_blocks:
 				ei->i_reserved_data_blocks += reservation;
 				spin_unlock(&ei->i_block_reservation_lock);
 			}
+			/*
+			 * We will claim quota for all newly allocated blocks.
+			 * We're updating the reserved space *after* the
+			 * correction above so we do not accidentally free
+			 * all the metadata reservation because we might
+			 * actually need it later on.
+			 */
+			ext4_da_update_reserve_space(inode, allocated_clusters,
+							1);
 		}
 	}
 
-- 
1.7.7.6

