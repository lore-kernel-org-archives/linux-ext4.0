From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: Use bitops to read/modify i_flags part2
Date: Mon, 31 May 2010 12:56:45 +0400
Message-ID: <87ocfwsb3m.fsf_-_@openvz.org>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
	<1274734174-28830-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39055 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab0EaI4t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 May 2010 04:56:49 -0400
Received: by fxm10 with SMTP id 10so2235201fxm.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 May 2010 01:56:47 -0700 (PDT)
In-Reply-To: <1274734174-28830-1-git-send-email-tytso@mit.edu> (Theodore
	Ts'o's message of "Mon, 24 May 2010 16:49:34 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

"Theodore Ts'o" <tytso@mit.edu> writes:

> From: "Theodore Ts'o" <tytso@mit.edu>
>
> From: Dmitry Monakhov <dmonakhov@openvz.org>
Bad news. Bug still exist because you've missed several important chunks 
(ext4_set_inode_flags, ext4_inode_blocks) while porting original patch.
And I've missed this too on review cycle.
Please add following patch to patch-queue.


--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-Use-bitops-to-read-modify-i_flags-part2.patch

>From 3e70168f78e832457e956f32ae7581e86f8daf15 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Mon, 31 May 2010 12:41:40 +0400
Subject: [PATCH] ext4: Use bitops to read/modify i_flags part2

Some places still modified in non-atomic meaner without i_mutex held.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c3b4443..39d1c14 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4942,20 +4942,26 @@ void ext4_set_inode_flags(struct inode *inode)
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
 void ext4_get_inode_flags(struct ext4_inode_info *ei)
 {
-	unsigned int flags = ei->vfs_inode.i_flags;
-
-	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
-	if (flags & S_SYNC)
-		ei->i_flags |= EXT4_SYNC_FL;
-	if (flags & S_APPEND)
-		ei->i_flags |= EXT4_APPEND_FL;
-	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT4_IMMUTABLE_FL;
-	if (flags & S_NOATIME)
-		ei->i_flags |= EXT4_NOATIME_FL;
-	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT4_DIRSYNC_FL;
+	unsigned int vfs_fl;
+	unsigned long old_flags, new_flags;
+
+	do {
+		vfs_fl = ei->vfs_inode.i_flags;
+		old_fl = ei->i_flags;
+		new_fl = old_fl & ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
+				EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|
+				EXT4_DIRSYNC_FL);
+		if (vfs_fl & S_SYNC)
+			new_fl |= EXT4_SYNC_FL;
+		if (vfs_fl & S_APPEND)
+			new_fl |= EXT4_APPEND_FL;
+		if (vfs_fl & S_IMMUTABLE)
+			new_fl |= EXT4_IMMUTABLE_FL;
+		if (vfs_fl & S_NOATIME)
+			new_fl |= EXT4_NOATIME_FL;
+		if (vfs_fl & S_DIRSYNC)
+			new_fl |= EXT4_DIRSYNC_FL;
+	} while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl);
 }
 
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
@@ -5191,7 +5197,7 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = 0;
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		return 0;
 	}
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE))
@@ -5204,9 +5210,9 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 	} else {
-		ei->i_flags |= EXT4_HUGE_FILE_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		/* i_block is stored in file system block size */
 		i_blocks = i_blocks >> (inode->i_blkbits - 9);
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
-- 
1.6.6.1


--=-=-=--
