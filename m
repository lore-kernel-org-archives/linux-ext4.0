From: Li Xi <pkuelelixi@gmail.com>
Subject: [v1 4/4] Add inherit flags for project quota
Date: Thu, 29 Oct 2015 00:42:13 +0900
Message-ID: <1446046933-26571-5-git-send-email-lixi@ddn.com>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35565 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966288AbbJ1Pmb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2015 11:42:31 -0400
Received: by pasz6 with SMTP id z6so10451663pas.2
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2015 08:42:31 -0700 (PDT)
In-Reply-To: <1446046933-26571-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add EXT4_PROJINHERIT_FL to enable inherit feature
for project quota.

Signed-off-by: Li Xi <lixi@ddn.com>
Change-Id: I61491333eabcc33ccc09fa1ed5f8ffe4c4220e57
---
 lib/e2p/pf.c         |    1 +
 lib/ext2fs/ext2_fs.h |    5 +++--
 misc/chattr.c        |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index 8961727..27421a6 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -46,6 +46,7 @@ static struct flags_name flags_array[] = {
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
 	{ FS_NOCOW_FL, "C", "No_COW" },
 	{ EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
+	{ EXT4_PROJINHERIT_FL, "P", "Project_Iherit" },
 	{ 0, NULL, NULL }
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 036e6ad..4e46f22 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -327,10 +327,11 @@ struct ext2_dx_tail {
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data */
+#define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
-#define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-#define EXT2_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
+#define EXT2_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
+#define EXT2_FL_USER_MODIFIABLE		0x204B80FF /* User modifiable flags */
 
 /*
  * ioctl commands
diff --git a/misc/chattr.c b/misc/chattr.c
index e55d693..40069c9 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -83,7 +83,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=aAcCdDeijsStTu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=aAcCdDeijPsStTu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -103,6 +103,7 @@ static const struct flags_char flags_array[] = {
 	{ EXT4_EXTENTS_FL, 'e'},
 	{ EXT2_IMMUTABLE_FL, 'i' },
 	{ EXT3_JOURNAL_DATA_FL, 'j' },
+	{ EXT4_PROJINHERIT_FL, 'P' },
 	{ EXT2_SECRM_FL, 's' },
 	{ EXT2_UNRM_FL, 'u' },
 	{ EXT2_NOTAIL_FL, 't' },
-- 
1.7.1

