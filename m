From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix scheduling in atomic on group checksum failure
Date: Wed, 10 Feb 2016 14:58:30 +0100
Message-ID: <1455112710-18765-1-git-send-email-jack@suse.cz>
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When block group checksum is wrong, we call ext4_error() while holding
group spinlock from ext4_init_block_bitmap() or
ext4_init_inode_bitmap() which results in scheduling while in atomic.
Fix the issue by calling ext4_error() later after dropping the spinlock.

CC: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/balloc.c | 7 ++++---
 fs/ext4/ialloc.c | 6 ++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index ec0668a60678..fe1f50fe764f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -191,7 +191,6 @@ static int ext4_init_block_bitmap(struct super_block *sb,
 	/* If checksum is bad mark all blocks used to prevent allocation
 	 * essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
-		ext4_error(sb, "Checksum bad for group %u", block_group);
 		grp = ext4_get_group_info(sb, block_group);
 		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 			percpu_counter_sub(&sbi->s_freeclusters_counter,
@@ -442,14 +441,16 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	}
 	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-
 		err = ext4_init_block_bitmap(sb, bh, block_group, desc);
 		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
 		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
-		if (err)
+		if (err) {
+			ext4_error(sb, "Failed to init block bitmap for group "
+				   "%u: %d", block_group, err);
 			goto out;
+		}
 		goto verify;
 	}
 	ext4_unlock_group(sb, block_group);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 3fcfd50a2e8a..acc0ad56bf2f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -76,7 +76,6 @@ static int ext4_init_inode_bitmap(struct super_block *sb,
 	/* If checksum is bad mark all blocks and inodes use to prevent
 	 * allocation, essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
-		ext4_error(sb, "Checksum bad for group %u", block_group);
 		grp = ext4_get_group_info(sb, block_group);
 		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 			percpu_counter_sub(&sbi->s_freeclusters_counter,
@@ -191,8 +190,11 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		set_buffer_verified(bh);
 		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
-		if (err)
+		if (err) {
+			ext4_error(sb, "Failed to init inode bitmap for group "
+				   "%u: %d", block_group, err);
 			goto out;
+		}
 		return bh;
 	}
 	ext4_unlock_group(sb, block_group);
-- 
2.6.2
