From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/25] resize2fs: adjust reserved_gdt_blocks when changing
 group descriptor size
Date: Thu, 17 Oct 2013 21:50:56 -0700
Message-ID: <20131018045056.7339.32813.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30759 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3JREvB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:51:01 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we're constructing the fantasy that new_fs has always been a
64bit fs, we need to adjust reserved_gdt_blocks when we start resizing
the metadata so that the size of the gdt space in the new fs reflects
the fantasy throughout the resize process.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 472aa4a..5a576a7 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -241,6 +241,24 @@ errout:
 	return retval;
 }
 
+/* Keep the size of the group descriptor region constant */
+static void adjust_reserved_gdt_blocks(ext2_filsys old_fs, ext2_filsys fs)
+{
+	if ((fs->super->s_feature_compat &
+	     EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+	    (old_fs->desc_blocks != fs->desc_blocks)) {
+		int new;
+
+		new = ((int) fs->super->s_reserved_gdt_blocks) +
+			(old_fs->desc_blocks - fs->desc_blocks);
+		if (new < 0)
+			new = 0;
+		if (new > (int) fs->blocksize/4)
+			new = fs->blocksize/4;
+		fs->super->s_reserved_gdt_blocks = new;
+	}
+}
+
 /* Toggle 64bit mode */
 static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
 {
@@ -300,6 +318,8 @@ static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
 	for (i = 0; i < rfs->old_fs->group_desc_count; i++)
 		ext2fs_group_desc_csum_set(rfs->new_fs, i);
 
+	adjust_reserved_gdt_blocks(rfs->old_fs, rfs->new_fs);
+
 	return 0;
 }
 
@@ -756,20 +776,11 @@ retry:
 	 * number of descriptor blocks, then adjust
 	 * s_reserved_gdt_blocks if possible to avoid needing to move
 	 * the inode table either now or in the future.
+	 *
+	 * Note: If we're converting to 64bit mode, we did this earlier.
 	 */
-	if ((fs->super->s_feature_compat &
-	     EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
-	    (old_fs->desc_blocks != fs->desc_blocks)) {
-		int new;
