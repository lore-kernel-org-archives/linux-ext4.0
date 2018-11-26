Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44538 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbeK0JPm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 04:15:42 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 03/12] chattr/lsattr: Support casefold attribute
Date: Mon, 26 Nov 2018 17:19:40 -0500
Message-Id: <20181126221949.12172-4-krisman@collabora.com>
In-Reply-To: <20181126221949.12172-1-krisman@collabora.com>
References: <20181126221949.12172-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This flag can be set on directories to request insensitive file name
lookups.

I used the letter 'F', referring to "caseFold" for lack of a better
option.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/e2p/pf.c         | 1 +
 lib/ext2fs/ext2_fs.h | 5 +++--
 misc/chattr.c        | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index 884f1671edae..0c6998c4b766 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -44,6 +44,7 @@ static struct flags_name flags_array[] = {
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
 	{ FS_NOCOW_FL, "C", "No_COW" },
+	{ EXT4_CASEFOLD_FL, "F", "Casefold" },
 	{ EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
 	{ EXT4_PROJINHERIT_FL, "P", "Project_Hierarchy" },
 	{ EXT4_VERITY_FL, "V", "Verity" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 36ae7ae41c47..032f83ed5ed3 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -340,10 +340,11 @@ struct ext2_dx_tail {
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data */
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
+#define EXT4_CASEFOLD_FL		0x40000000 /* Casefolded file */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
-#define EXT2_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
-#define EXT2_FL_USER_MODIFIABLE		0x204B80FF /* User modifiable flags */
+#define EXT2_FL_USER_VISIBLE		0x604BDFFF /* User visible flags */
+#define EXT2_FL_USER_MODIFIABLE		0x604B80FF /* User modifiable flags */
 
 /*
  * ioctl commands
diff --git a/misc/chattr.c b/misc/chattr.c
index a5b401a741b7..a5d60170bdb6 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -86,7 +86,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-pRVf] [-+=aAcCdDeijPsStTu] [-v version] files...\n"),
+		_("Usage: %s [-pRVf] [-+=aAcCdDeijPsStTuF] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -112,6 +112,7 @@ static const struct flags_char flags_array[] = {
 	{ EXT2_NOTAIL_FL, 't' },
 	{ EXT2_TOPDIR_FL, 'T' },
 	{ FS_NOCOW_FL, 'C' },
+	{ EXT4_CASEFOLD_FL, 'F' },
 	{ 0, 0 }
 };
 
-- 
2.19.2
