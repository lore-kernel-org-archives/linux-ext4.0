From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: simplify calculation of blocks to free on error
Date: Mon, 15 Jul 2013 00:11:07 -0400
Message-ID: <1373861467-14834-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37810 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3GOELK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jul 2013 00:11:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_ext_map_blocks(), if we have successfully allocated the data
blocks, but then run into trouble inserting the extent into the extent
tree, most likely due to an ENOSPC condition, determine the arguments
to ext4_free_blocks() in a simpler way which is easier to prove to be
correct.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f57cc0e..5930915 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4261,8 +4261,8 @@ got_allocated_blocks:
 		/* not a good idea to call discard here directly,
 		 * but otherwise we'd need to call it every free() */
 		ext4_discard_preallocations(inode);
-		ext4_free_blocks(handle, inode, NULL, ext4_ext_pblock(&newex),
-				 ext4_ext_get_actual_len(&newex), fb_flags);
+		ext4_free_blocks(handle, inode, NULL, newblock,
+				 EXT4_C2B(sbi, allocated_clusters), fb_flags);
 		goto out2;
 	}
 
-- 
1.7.12.rc0.22.gcdd159b

