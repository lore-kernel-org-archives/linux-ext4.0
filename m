From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Fix possible use after free of buffer head
Date: Thu, 29 Nov 2012 11:43:48 +0100
Message-ID: <1354185828-28545-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>,
	"Darrick J. Wong" <djwong@us.ibm.com>, stable@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2K2Kn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 05:43:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit fa77dcfafeaa6bc73293c646bfc3d5192dcf0be2 introduces block bitmap
checksum calculation into ext4_new_inode() in the case that block group
was uninitialized. However we brelse() the bitmap buffer before we
attempt to checksum it so we have no guarantee that the buffer is still
there.

Fix this by releasing the buffer after the possible checksum
computation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: stable@vger.kernel.org
---
 fs/ext4/ialloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 3a100e7..c7efa88 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -762,7 +762,6 @@ got:
 
 		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
 		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
-		brelse(block_bitmap_bh);
 
 		/* recheck and clear flag under lock if we still need to */
 		ext4_lock_group(sb, group);
@@ -775,6 +774,7 @@ got:
 			ext4_group_desc_csum_set(sb, group, gdp);
 		}
 		ext4_unlock_group(sb, group);
+		brelse(block_bitmap_bh);
 
 		if (err)
 			goto fail;
-- 
1.7.7.6

