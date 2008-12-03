From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 3/6] ext4: don't inherit inappropriate inode flags from parent
Date: Wed,  3 Dec 2008 19:55:00 +0000
Message-ID: <1228334103-15948-4-git-send-email-duaneg@dghda.com>
References: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
 <1228334103-15948-2-git-send-email-duaneg@dghda.com>
 <1228334103-15948-3-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2868 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596AbYLCUCB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 15:02:01 -0500
In-Reply-To: <1228334103-15948-3-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At present INDEX and EXTENTS are the only flags that new ext4 inodes do
NOT inherit from their parent. In addition prevent the flags DIRTY,
ECOMPR, IMAGIC, TOPDIR, HUGE_FILE and EXT_MIGRATE from being inherited.
List inheritable flags explicitly to prevent future flags from
accidentally being inherited.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ext4/ext4.h   |    8 ++++++++
 fs/ext4/ialloc.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8370ffd..63e5163 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -247,6 +247,14 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
+			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
+			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_COMPRBLK_FL | EXT4_NOCOMPR_FL |\
+			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL|\
+			   EXT4_DIRSYNC_FL)
+
 /*
  * Inode dynamic state flags
  */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 08cac9f..6fd3f3c 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -813,7 +813,7 @@ got:
 	 * newly created directory and file only if -o extent mount option is
 	 * specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
+	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */
-- 
1.5.6.4

