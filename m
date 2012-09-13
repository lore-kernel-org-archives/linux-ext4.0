From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] resize2fs: enforce restrictions if the kernel doesn't do meta_bg resizing
Date: Thu, 13 Sep 2012 18:49:19 -0400
Message-ID: <1347576560-5820-5-git-send-email-tytso@mit.edu>
References: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50592 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2IMXGU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 19:06:20 -0400
In-Reply-To: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enhance the online resizing code to be more nuanced about resizing
restrictions.  If the kernel supports meta_bg resizing, then we can
skip all of the restrictions.  If the kernel does not support meta_bg
resizing, check more carefully to make sure there are enough reserved
gdt blocks, so that the user gets a clearer error message.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/online.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/resize/online.c b/resize/online.c
index 966ea1e..98190cb 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -56,12 +56,34 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		EXT2_DESC_PER_BLOCK(fs->super));
 	printf("old_desc_blocks = %lu, new_desc_blocks = %lu\n",
 	       fs->desc_blocks, new_desc_blocks);
-	if (!(fs->super->s_feature_compat &
-	      EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
-	    new_desc_blocks != fs->desc_blocks) {
-		com_err(program_name, 0,
-			_("Filesystem does not support online resizing"));
-		exit(1);
+
+	/*
+	 * Do error checking to make sure the resize will be successful.
+	 */
+	if (!meta_bg_resizing) {
+		if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+					EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+		    (new_desc_blocks != fs->desc_blocks)) {
+			com_err(program_name, 0,
+				_("Filesystem does not support online resizing"));
+			exit(1);
+		}
+
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+					EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+		    new_desc_blocks > (fs->desc_blocks +
+				       fs->super->s_reserved_gdt_blocks)) {
+			com_err(program_name, 0,
+				_("Not enough reserved gdt blocks for resizing"));
+			exit(1);
+		}
+
+		if ((ext2fs_blocks_count(sb) > MAX_32_NUM) ||
+		    (*new_size > MAX_32_NUM)) {
+			com_err(program_name, 0,
+				_("Kernel does not support resizing a file system this large"));
+			exit(1);
+		}
 	}
 
 	fd = open(mtpt, O_RDONLY);
@@ -101,13 +123,6 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		return 0;
 	}
 
-	if ((ext2fs_blocks_count(sb) > MAX_32_NUM) ||
-	    (*new_size > MAX_32_NUM)) {
-		com_err(program_name, 0,
-			_("Kernel does not support resizing a file system "
-			  "this large"));
-		exit(1);
-	}
 	size = ext2fs_blocks_count(sb);
 
 	if (ioctl(fd, EXT2_IOC_GROUP_EXTEND, &size)) {
-- 
1.7.12.rc0.22.gcdd159b

