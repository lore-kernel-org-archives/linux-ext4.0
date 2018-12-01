Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:32962 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbeLALvP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 06:51:15 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 3/9] chattr/lsattr: Support casefold attribute
Date: Fri, 30 Nov 2018 19:39:04 -0500
Message-Id: <20181201003910.18982-4-krisman@collabora.com>
In-Reply-To: <20181201003910.18982-1-krisman@collabora.com>
References: <20181201003910.18982-1-krisman@collabora.com>
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
 misc/chattr.1.in     | 8 +++++++-
 misc/chattr.c        | 3 ++-
 4 files changed, 13 insertions(+), 4 deletions(-)

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
index c7d62b8d40b2..19bd94da008a 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -339,10 +339,11 @@ struct ext2_dx_tail {
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
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 028ae9e7ca4c..5949d096687b 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -29,7 +29,7 @@ The operator '+' causes the selected attributes to be added to the
 existing attributes of the files; '-' causes them to be removed; and '='
 causes them to be the only attributes that the files have.
 .PP
-The letters 'aAcCdDeijPsStTu' select the new attributes for the files:
+The letters 'aAcCdDeFijPsStTu' select the new attributes for the files:
 append only (a),
 no atime updates (A),
 compressed (c),
@@ -37,6 +37,7 @@ no copy on write (C),
 no dump (d),
 synchronous directory updates (D),
 extent format (e),
+case-insensitive directory lookups (F),
 immutable (i),
 data journalling (j),
 project hierarchy (P),
@@ -119,6 +120,11 @@ set or reset using
 although it can be displayed by
 .BR lsattr (1).
 .PP
+A directory with the 'F' attribute set indicates that all the path
+lookups inside that directory are made in a case-insensitive fashion.
+This attribute can only be changed in empty directories on file systems
+with the fname_encoding feature enabled.
+.PP
 A file with the 'i' attribute cannot be modified: it cannot be deleted or
 renamed, no link can be created to this file, most of the file's
 metadata can not be modified, and the file can not be opened in write mode.
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
2.20.0.rc1
