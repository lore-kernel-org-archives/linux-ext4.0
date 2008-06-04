From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 3/3] ext4: don't inherit inappropriate inode flags from parent
Date: Wed,  4 Jun 2008 13:46:28 +0100
Message-ID: <1212583588-5754-4-git-send-email-duaneg@dghda.com>
References: <1212583588-5754-1-git-send-email-duaneg@dghda.com>
 <1212583588-5754-2-git-send-email-duaneg@dghda.com>
 <1212583588-5754-3-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1390 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYFDMrE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 08:47:04 -0400
In-Reply-To: <1212583588-5754-3-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At present INDEX and EXTENTS are the only flagis that new ext4 inodes do
NOT inherit from their parent. In addition prevent the flags DIRTY, ECOMPR,
IMAGIC, TOPDIR and HUGE_FILE from being inherited.

Signed-off-by: Duane Griffin <duaneg@dghda.com>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8158083..de07dc7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -235,6 +235,11 @@ struct ext4_group_desc
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT4_FL_INHERITED ~(EXT4_DIRTY_FL | EXT4_ECOMPR_FL | EXT4_INDEX_FL |\
+			    EXT4_IMAGIC_FL | EXT4_TOPDIR_FL |\
+			    EXT4_HUGE_FILE_FL | EXT4_EXTENTS_FL)
+
 /*
  * Inode dynamic state flags
  */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c6efbab..ff25d57 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -702,7 +702,7 @@ got:
 	 * newly created directory and file only if -o extent mount option is
 	 * specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
+	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */
-- 
1.5.3.7

