From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/2] ext3: use proper little-endian bitops
Date: Mon, 30 May 2011 22:47:16 +0900
Message-ID: <1306763236-13751-2-git-send-email-akinobu.mita@gmail.com>
References: <1306763236-13751-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306763236-13751-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Using __test_and_set_bit_le() with ignoring its return value
can be replaced with __set_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/resize.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 213a794..c7918f5 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -148,7 +148,7 @@ static void mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
 
 	ext3_debug("mark end bits +%d through +%d used\n", start_bit, end_bit);
 	for (i = start_bit; i < ((start_bit + 7) & ~7UL); i++)
-		__test_and_set_bit_le(i, bitmap);
+		__set_bit_le(i, bitmap);
 	if (i < end_bit)
 		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
 }
@@ -222,7 +222,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 
 	if (ext3_bg_has_super(sb, input->group)) {
 		ext3_debug("mark backup superblock %#04lx (+0)\n", start);
-		__test_and_set_bit_le(0, bh->b_data);
+		__set_bit_le(0, bh->b_data);
 	}
 
 	/* Copy all of the GDT blocks into the backup in this group */
@@ -254,7 +254,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			brelse(gdb);
 			goto exit_bh;
 		}
-		__test_and_set_bit_le(bit, bh->b_data);
+		__set_bit_le(bit, bh->b_data);
 		brelse(gdb);
 	}
 
@@ -278,15 +278,15 @@ static int setup_new_group_blocks(struct super_block *sb,
 			brelse(gdb);
 			goto exit_bh;
 		}
-		__test_and_set_bit_le(bit, bh->b_data);
+		__set_bit_le(bit, bh->b_data);
 		brelse(gdb);
 	}
 	ext3_debug("mark block bitmap %#04x (+%ld)\n", input->block_bitmap,
 		   input->block_bitmap - start);
-	__test_and_set_bit_le(input->block_bitmap - start, bh->b_data);
+	__set_bit_le(input->block_bitmap - start, bh->b_data);
 	ext3_debug("mark inode bitmap %#04x (+%ld)\n", input->inode_bitmap,
 		   input->inode_bitmap - start);
-	__test_and_set_bit_le(input->inode_bitmap - start, bh->b_data);
+	__set_bit_le(input->inode_bitmap - start, bh->b_data);
 
 	/* Zero out all of the inode table blocks */
 	for (i = 0, block = input->inode_table, bit = block - start;
@@ -309,7 +309,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			goto exit_bh;
 		}
 		brelse(it);
-		__test_and_set_bit_le(bit, bh->b_data);
+		__set_bit_le(bit, bh->b_data);
 	}
 
 	err = extend_or_restart_transaction(handle, 2, bh);
-- 
1.7.4.4
