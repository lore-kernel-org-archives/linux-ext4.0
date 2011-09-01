From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/16] ext4: Calculate and verify checksums for inode bitmaps
Date: Wed, 31 Aug 2011 17:31:28 -0700
Message-ID: <20110901003127.31048.13983.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Compute and verify the checksum of the inode bitmap; the checkum is stored in
the block group descriptor.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h   |    3 ++-
 fs/ext4/ialloc.c |   33 ++++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bc7ace1..248cbd2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -279,7 +279,8 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
 	__le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
-	__u32	bg_reserved2[3];
+	__le32	bg_inode_bitmap_csum;	/* crc32c(uuid+group+ibitmap) */
+	__u32	bg_reserved2[2];
 };
 
 /*
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..53faffc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -82,12 +82,18 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 		ext4_free_inodes_set(sb, gdp, 0);
 		ext4_itable_unused_set(sb, gdp, 0);
 		memset(bh->b_data, 0xff, sb->s_blocksize);
+		ext4_bitmap_csum_set(sb, block_group,
+				     &gdp->bg_inode_bitmap_csum, bh,
+				     (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
 		return 0;
 	}
 
 	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
 	ext4_mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), sb->s_blocksize * 8,
 			bh->b_data);
+	ext4_bitmap_csum_set(sb, block_group, &gdp->bg_inode_bitmap_csum, bh,
+			     (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 
 	return EXT4_INODES_PER_GROUP(sb);
 }
@@ -118,12 +124,12 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		return NULL;
 	}
 	if (bitmap_uptodate(bh))
-		return bh;
+		goto verify;
 
 	lock_buffer(bh);
 	if (bitmap_uptodate(bh)) {
 		unlock_buffer(bh);
-		return bh;
+		goto verify;
 	}
 
 	ext4_lock_group(sb, block_group);
@@ -131,6 +137,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
 		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
+		set_buffer_verified(bh);
 		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
 		return bh;
@@ -144,7 +151,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		 */
 		set_bitmap_uptodate(bh);
 		unlock_buffer(bh);
-		return bh;
+		goto verify;
 	}
 	/*
 	 * submit the buffer_head for read. We can
@@ -161,6 +168,21 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
+
+verify:
+	ext4_lock_group(sb, block_group);
+	if (!buffer_verified(bh) &&
+	    !ext4_bitmap_csum_verify(sb, block_group,
+				     desc->bg_inode_bitmap_csum, bh,
+				     (EXT4_INODES_PER_GROUP(sb) + 7) / 8)) {
+		ext4_unlock_group(sb, block_group);
+		put_bh(bh);
+		ext4_error(sb, "Corrupt inode bitmap - block_group = %u, "
+			   "inode_bitmap = %llu", block_group, bitmap_blk);
+		return NULL;
+	}
+	ext4_unlock_group(sb, block_group);
+	set_buffer_verified(bh);
 	return bh;
 }
 
@@ -265,6 +287,8 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		ext4_used_dirs_set(sb, gdp, count);
 		percpu_counter_dec(&sbi->s_dirs_counter);
 	}
+	ext4_bitmap_csum_set(sb, block_group, &gdp->bg_inode_bitmap_csum,
+			     bitmap_bh, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 
@@ -784,6 +808,9 @@ static int ext4_claim_inode(struct super_block *sb,
 			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
 		}
 	}
+	ext4_bitmap_csum_set(sb, group, &gdp->bg_inode_bitmap_csum,
+			     inode_bitmap_bh,
+			     (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 err_ret:
 	ext4_unlock_group(sb, group);
