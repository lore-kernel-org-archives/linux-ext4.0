From: Georg Altmann <george@george-net.de>
Subject: [PATCH] ext4: clarify error messages for mounting fs w/o journal /w journal options
Date: Fri, 12 Feb 2016 14:31:49 +0100
Message-ID: <1455283909-23354-1-git-send-email-george@george-net.de>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Georg Altmann <george@george-net.de>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Previous message was hard to understand: When mounting a ext4 fs without a
journal, but a mount option that controls journaling is used, clearly state
that the fs cannot be mounted with this option because it has no journal.

See also comments at
https://bugs.archlinux.org/task/48135

Signed-off-by: Georg Altmann <george@george-net.de>
---
 fs/ext4/super.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 486e869..4c50f0d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3716,25 +3716,25 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	} else {
 		/* Nojournal mode, all journal mount options are illegal */
 		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_checksum, fs mounted w/o journal");
+			ext4_msg(sb, KERN_ERR, "can't mount with option "
+				 "journal_checksum, fs has no journal");
 			goto failed_mount_wq;
 		}
 		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_async_commit, fs mounted w/o journal");
+			ext4_msg(sb, KERN_ERR, "can't mount with option "
+				 "journal_async_commit, fs has no journal");
 			goto failed_mount_wq;
 		}
 		if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "commit=%lu, fs mounted w/o journal",
+			ext4_msg(sb, KERN_ERR, "can't mount with option "
+				 "commit=%lu, fs has no journal",
 				 sbi->s_commit_interval / HZ);
 			goto failed_mount_wq;
 		}
 		if (EXT4_MOUNT_DATA_FLAGS &
 		    (sbi->s_mount_opt ^ sbi->s_def_mount_opt)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "data=, fs mounted w/o journal");
+			ext4_msg(sb, KERN_ERR, "can't mount with option "
+				 "data=, fs has no journal");
 			goto failed_mount_wq;
 		}
 		sbi->s_def_mount_opt &= EXT4_MOUNT_JOURNAL_CHECKSUM;
-- 
2.7.1
