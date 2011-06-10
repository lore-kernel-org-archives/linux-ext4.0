From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] ext2fs: fix error handling in ext2fs_add_dir_block
Date: Fri, 10 Jun 2011 01:33:07 -0600
Message-ID: <1307691187-12854-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:3961 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1FJHdI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 03:33:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext2fs_add_dir_block() the dblist allocation size was changed to
grow as the number of items in the dblist increases.  However, the
error handling in case of allocation failure wasn't changed to match.

Fix the error case to revert to the old allocation size on failure.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/dblist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/dblist.c b/lib/ext2fs/dblist.c
index 8ee61b4..c0a3dfe 100644
--- a/lib/ext2fs/dblist.c
+++ b/lib/ext2fs/dblist.c
@@ -172,7 +172,7 @@ errcode_t ext2fs_add_dir_block2(ext2_dblist dblist, ext2_ino_t ino,
 					   sizeof(struct ext2_db_entry2),
 					   &dblist->list);
 		if (retval) {
-			dblist->size -= 100;
+			dblist->size = old_size / sizeof(struct ext2_db_entry2);
 			return retval;
 		}
 	}
-- 
1.7.3.4

