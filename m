From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: Fix flag handling in ext4_split_convert_extents()
Date: Mon, 31 Mar 2014 11:11:33 +0200
Message-ID: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
Cc: dan.carpenter@oracle.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaCaJLj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 05:11:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In commit 1f0e51771281 "ext4: Introduce FALLOC_FL_ZERO_RANGE flag
for fallocate" we've introduced wrong flag handling. Fix it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 243a02e..491208c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3644,13 +3644,13 @@ static int ext4_split_convert_extents(handle_t *handle,
 	ee_len = ext4_ext_get_actual_len(ex);
 
 	/* Convert to unwritten */
-	if (flags | EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
+	if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
 		split_flag |= EXT4_EXT_DATA_VALID1;
 	/* Convert to initialized */
-	} else if (flags | EXT4_GET_BLOCKS_CONVERT) {
+	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		split_flag |= ee_block + ee_len <= eof_block ?
 			      EXT4_EXT_MAY_ZEROOUT : 0;
-		split_flag |= (EXT4_EXT_MARK_UNINIT2 & EXT4_EXT_DATA_VALID2);
+		split_flag |= (EXT4_EXT_MARK_UNINIT2 | EXT4_EXT_DATA_VALID2);
 	}
 	flags |= EXT4_GET_BLOCKS_PRE_IO;
 	return ext4_split_extent(handle, inode, path, map, split_flag, flags);
-- 
1.8.3.1

