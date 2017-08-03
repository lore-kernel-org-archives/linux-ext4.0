From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] Add inode DAX flag
Date: Thu,  3 Aug 2017 09:22:14 +0200
Message-ID: <1501744934-30091-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751084AbdHCHWq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Aug 2017 03:22:46 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EAD6E7EA81
        for <linux-ext4@vger.kernel.org>; Thu,  3 Aug 2017 07:22:45 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch introduces the ability to add, remove and list EXT4_DAX_FL
inode flag. This flag allows us to enable DAX on per-inode basis.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/e2p/pf.c         | 1 +
 lib/ext2fs/ext2_fs.h | 5 +++--
 misc/chattr.c        | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index b4a086f..a6d3ec6 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -43,6 +43,7 @@ static struct flags_name flags_array[] = {
 	{ EXT2_NOTAIL_FL, "t", "No_Tailmerging" },
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
+	{ EXT4_DAX_FL, "x", "DAX"},
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
 	{ FS_NOCOW_FL, "C", "No_COW" },
 	{ EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 3b55000..c936f3f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -319,6 +319,7 @@ struct ext2_dx_tail {
 #define EXT2_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
+#define EXT4_DAX_FL			0x00100000 /* Use DAX for IO */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 /* EXT4_EOFBLOCKS_FL 0x00400000 was here */
 #define FS_NOCOW_FL			0x00800000 /* Do not cow file */
@@ -329,8 +330,8 @@ struct ext2_dx_tail {
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
-#define EXT2_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
-#define EXT2_FL_USER_MODIFIABLE		0x204B80FF /* User modifiable flags */
+#define EXT2_FL_USER_VISIBLE		0x205BDFFF /* User visible flags */
+#define EXT2_FL_USER_MODIFIABLE		0x205B80FF /* User modifiable flags */
 
 /*
  * ioctl commands
diff --git a/misc/chattr.c b/misc/chattr.c
index a5b401a..9db0a18 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -86,7 +86,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-pRVf] [-+=aAcCdDeijPsStTu] [-v version] files...\n"),
+		_("Usage: %s [-pRVf] [-+=aAcCdDeijPsStTux] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -104,6 +104,7 @@ static const struct flags_char flags_array[] = {
 	{ EXT2_COMPR_FL, 'c' },
 	{ EXT2_NODUMP_FL, 'd' },
 	{ EXT4_EXTENTS_FL, 'e'},
+	{ EXT4_DAX_FL, 'x'},
 	{ EXT2_IMMUTABLE_FL, 'i' },
 	{ EXT3_JOURNAL_DATA_FL, 'j' },
 	{ EXT4_PROJINHERIT_FL, 'P' },
-- 
2.7.5
