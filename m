From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] pu branch: fix more direct fs->group_desc accesses
Date: Thu, 24 Sep 2009 21:28:59 -0500
Message-ID: <4ABC2AEB.4050909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbZIYC3A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Sep 2009 22:29:00 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8P2T4vM032558
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2009 22:29:04 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8P2Sxv5008168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2009 22:29:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes still more direct accesses to fs->group_desc
fields off a normal array index (group_desc[i]).  Since
we have variable sized group_desc depending on the group_desc
size, these all must go through accessor functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 7ba7782..88cf411 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -415,7 +415,10 @@ static errcode_t parse_gd_csum(struct field_set_info *info, char *arg)
 
 	if (strcmp(arg, "calc") == 0) {
 		ext2fs_group_desc_csum_set(current_fs, set_bg);
-		set_gd = current_fs->group_desc[set_bg];
+		memcpy(&set_gd, ext2fs_group_desc(current_fs,
+					current_fs->group_desc,
+					set_bg),
+			sizeof(set_gd));
 		printf("Checksum set to 0x%04x\n",
 		       ext2fs_bg_checksum(current_fs, set_bg));
 		return 0;
@@ -570,10 +573,14 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 		return;
 	}
 
-	set_gd = current_fs->group_desc[set_bg];
+	memcpy(&set_gd, ext2fs_group_desc(current_fs,
+				current_fs->group_desc, set_bg),
+		sizeof(set_gd));
 
 	if (ss->func(ss, argv[3]) == 0) {
-		current_fs->group_desc[set_bg] = set_gd;
+		memcpy(ext2fs_group_desc(current_fs,
+				current_fs->group_desc, set_bg),
+		       &set_gd, sizeof(set_gd));
 		ext2fs_mark_super_dirty(current_fs);
 	}
 }
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index cc3a884..a04d560 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -303,7 +303,7 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 	}
 #else
 	super_shadow = fs->super;
-	group_shadow = fs->group_desc;
+	group_shadow = ext2fs_group_desc(fs, fs->group_desc, 0);
 #endif
 
 	/*
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index a6661b7..b99be26 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -204,9 +204,9 @@ int main(int argc, char **argv)
 		ext2fs_block_bitmap_loc_set(fs, i, 124);
 		ext2fs_inode_bitmap_loc_set(fs, i, 125);
 		ext2fs_inode_table_loc_set(fs, i, 126);
-		fs->group_desc[i].bg_free_blocks_count = 31119;
-		fs->group_desc[i].bg_free_inodes_count = 15701;
-		fs->group_desc[i].bg_used_dirs_count = 2;
+		ext2fs_bg_free_blocks_count_set(fs, i, 31119);
+		ext2fs_bg_free_inodes_count_set(fs, i, 15701);
+		ext2fs_bg_used_dirs_count_set(fs, i, 2);
 		ext2fs_bg_flags_zap(fs, i);
 	};
 
@@ -249,7 +249,7 @@ int main(int argc, char **argv)
 	csum1 = ext2fs_group_desc_csum(fs, 0);
 	ext2fs_bg_checksum_set(fs, 0, csum1);
 	print_csum("csum_new", fs, 0);
-	fs->group_desc[0].bg_free_blocks_count = 1;
+	ext2fs_bg_free_blocks_count_set(fs, 0, 1);
 	csum2 = ext2fs_group_desc_csum(fs, 0);
 	print_csum("csum_blk", fs, 0);
 	if (csum1 == csum2) {
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index c81f625..dea3366 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1021,9 +1021,9 @@ static int ext2fs_is_meta_block(ext2_filsys fs, blk_t blk)
 {
 	dgrp_t group;
 	group = ext2fs_group_of_blk(fs, blk);
-	if (fs->group_desc[group].bg_block_bitmap == blk)
+	if (ext2fs_block_bitmap_loc(fs, group) == blk)
 		return 1;
-	if (fs->group_desc[group].bg_inode_bitmap == blk)
+	if (ext2fs_inode_bitmap_loc(fs, group) == blk)
 		return 1;
 	return 0;
 }
@@ -1233,20 +1233,20 @@ static int group_desc_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 	blk_t blk, new_blk;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		blk = fs->group_desc[i].bg_block_bitmap;
+		blk = ext2fs_block_bitmap_loc(fs, i);
 		if (ext2fs_test_block_bitmap2(bmap, blk)) {
 			new_blk = translate_block(blk);
 			if (!new_blk)
 				continue;
-			fs->group_desc[i].bg_block_bitmap = new_blk;
+			ext2fs_block_bitmap_loc_set(fs, i, new_blk);
 		}
 
-		blk = fs->group_desc[i].bg_inode_bitmap;
+		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (ext2fs_test_block_bitmap2(bmap, blk)) {
 			new_blk = translate_block(blk);
 			if (!new_blk)
 				continue;
-			fs->group_desc[i].bg_inode_bitmap = new_blk;
+			ext2fs_inode_bitmap_loc_set(fs, i, new_blk);
 		}
 	}
 	return 0;
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 9a70b27..0d3f05f 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -438,7 +438,8 @@ retry:
 		for (i = fs->group_desc_count;
 		     i < old_fs->group_desc_count; i++) {
 			free_gdp_blocks(fs, reserve_blocks,
-					&old_fs->group_desc[i]);
+					ext2fs_group_desc(old_fs,
+						old_fs->group_desc, i));
 		}
 		retval = 0;
 		goto errout;

