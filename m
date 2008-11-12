From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 16/17] ext2fs_block_alloc_stats -> ext2fs_block_alloc_stats2
Date: Tue, 11 Nov 2008 19:43:09 -0800
Message-ID: <1226461390-5502-17-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <1226461390-5502-13-git-send-email-vaurora@redhat.com>
 <1226461390-5502-14-git-send-email-vaurora@redhat.com>
 <1226461390-5502-15-git-send-email-vaurora@redhat.com>
 <1226461390-5502-16-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYKLDoH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:44:07 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3i7D3007479
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:44:07 -0500
In-Reply-To: <1226461390-5502-16-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 e2fsck/pass1b.c |    2 +-
 e2fsck/pass2.c  |    8 +++++---
 e2fsck/pass3.c  |    4 ++--
 e2fsck/rehash.c |    2 +-
 e2fsck/super.c  |    4 ++--
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index f6695bd..8fbdfcd 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -571,7 +571,7 @@ static int delete_file_block(ext2_filsys fs,
 				*block_nr);
 	} else {
 		ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
-		ext2fs_block_alloc_stats(fs, *block_nr, -1);
+		ext2fs_block_alloc_stats2(fs, *block_nr, -1);
 	}
 
 	return 0;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index da868a8..3d94856 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1171,7 +1171,7 @@ static int deallocate_inode_block(ext2_filsys fs,
 	    (*block_nr >= ext2fs_blocks_count(fs->super)))
 		return 0;
 	ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
-	ext2fs_block_alloc_stats(fs, *block_nr, -1);
+	ext2fs_block_alloc_stats2(fs, *block_nr, -1);
 	return 0;
 }
 
@@ -1212,8 +1212,10 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 		}
 		if (count == 0) {
 			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
-						   ext2fs_file_acl_block(&inode));
-			ext2fs_block_alloc_stats(fs, ext2fs_file_acl_block(&inode), -1);
+						ext2fs_file_acl_block(&inode));
+			ext2fs_block_alloc_stats2(fs,
+					        ext2fs_file_acl_block(&inode),
+					        -1);
 		}
 		ext2fs_file_acl_block_set(&inode, 0);
 	}
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 5102438..e81575f 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -430,7 +430,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 		return 0;
 	}
 	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
-	ext2fs_block_alloc_stats(fs, blk, +1);
+	ext2fs_block_alloc_stats2(fs, blk, +1);
 
 	/*
 	 * Next find a free inode.
@@ -752,7 +752,7 @@ static int expand_dir_proc(ext2_filsys fs,
 	ext2fs_free_mem(&block);
 	*blocknr = new_blk;
 	ext2fs_mark_block_bitmap2(ctx->block_found_map, new_blk);
-	ext2fs_block_alloc_stats(fs, new_blk, +1);
+	ext2fs_block_alloc_stats2(fs, new_blk, +1);
 	es->newblocks++;
 
 	if (es->num == 0)
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 857f4f4..0135702 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -625,7 +625,7 @@ static int write_dir_block(ext2_filsys fs,
 		e2fsck_read_bitmaps(wd->ctx);
 		blk = *block_nr;
 		ext2fs_unmark_block_bitmap2(wd->ctx->block_found_map, blk);
-		ext2fs_block_alloc_stats(fs, blk, -1);
+		ext2fs_block_alloc_stats2(fs, blk, -1);
 		*block_nr = 0;
 		wd->cleared++;
 		return BLOCK_CHANGED;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index bbcc3b9..b7415e4 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -141,7 +141,7 @@ static int release_inode_block(ext2_filsys fs,
 		retval |= BLOCK_CHANGED;
 	}
 
-	ext2fs_block_alloc_stats(fs, blk, -1);
+	ext2fs_block_alloc_stats2(fs, blk, -1);
 	return retval;
 }
 
@@ -211,7 +211,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 			return 1;
 		}
 		if (count == 0)
-			ext2fs_block_alloc_stats(fs,
+			ext2fs_block_alloc_stats2(fs,
 						 ext2fs_file_acl_block(inode),
 						 -1);
 		ext2fs_file_acl_block_set(inode, 0);
-- 
1.5.6.5

