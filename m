From: "Pranay Kr. Srivastava" <pranjas@gmail.com>
Subject: [PATCH 1/1]ext4: Fix WARN_ON_ONCE when marking buffer dirty
Date: Thu, 30 Jun 2016 14:12:30 +0300
Message-ID: <1467285150-15977-2-git-send-email-pranjas@gmail.com>
References: <1467285150-15977-1-git-send-email-pranjas@gmail.com>
Cc: "Pranay Kr. Srivastava" <pranjas@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467285150-15977-1-git-send-email-pranjas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Pranay Kr. Srivastava <pranjas@gmail.com>
---
 fs/ext4/super.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3822a5a..8f10715 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4327,20 +4327,6 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 
 	if (!sbh || block_device_ejected(sb))
 		return error;
-	if (buffer_write_io_error(sbh)) {
-		/*
-		 * Oh, dear.  A previous attempt to write the
-		 * superblock failed.  This could happen because the
-		 * USB device was yanked out.  Or it could happen to
-		 * be a transient write error and maybe the block will
-		 * be remapped.  Nothing we can do but to retry the
-		 * write and hope for the best.
-		 */
-		ext4_msg(sb, KERN_ERR, "previous I/O error to "
-		       "superblock detected");
-		clear_buffer_write_io_error(sbh);
-		set_buffer_uptodate(sbh);
-	}
 	/*
 	 * If the file system is mounted read-only, don't update the
 	 * superblock write time.  This avoids updating the superblock
@@ -4371,7 +4357,23 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 				&EXT4_SB(sb)->s_freeinodes_counter));
 	BUFFER_TRACE(sbh, "marking dirty");
 	ext4_superblock_csum_set(sb);
+	lock_buffer(sbh);
+	if (buffer_write_io_error(sbh)) {
+		/*
+		 * Oh, dear.  A previous attempt to write the
+		 * superblock failed.  This could happen because the
+		 * USB device was yanked out.  Or it could happen to
+		 * be a transient write error and maybe the block will
+		 * be remapped.  Nothing we can do but to retry the
+		 * write and hope for the best.
+		 */
+		ext4_msg(sb, KERN_ERR, "previous I/O error to "
+		       "superblock detected");
+		clear_buffer_write_io_error(sbh);
+		set_buffer_uptodate(sbh);
+	}
 	mark_buffer_dirty(sbh);
+	unlock_buffer(sbh);
 	if (sync) {
 		error = __sync_dirty_buffer(sbh,
 			test_opt(sb, BARRIER) ? WRITE_FUA : WRITE_SYNC);
-- 
1.9.1
