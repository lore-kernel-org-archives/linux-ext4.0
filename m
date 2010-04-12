From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 1/5] ext2: Use ext2_clear_super_error() in ext2_sync_fs()
Date: Mon, 12 Apr 2010 22:41:41 +0200
Message-ID: <1271104905-8804-2-git-send-email-jblunck@suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab0DLUmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 16:42:04 -0400
In-Reply-To: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2_sync_fs() used to duplicate the code from ext2_clear_super_error().

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/super.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 42e4a30..dbebbf0 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1120,8 +1120,8 @@ static void ext2_clear_super_error(struct super_block *sb)
 		 * be remapped.  Nothing we can do but to retry the
 		 * write and hope for the best.
 		 */
-		printk(KERN_ERR "EXT2-fs: %s previous I/O error to "
-		       "superblock detected", sb->s_id);
+		ext2_msg(sb, KERN_ERR,
+		       "previous I/O error to superblock detected\n");
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
@@ -1164,20 +1164,7 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
 
 	lock_kernel();
-	if (buffer_write_io_error(sbh)) {
-		/*
-		 * Oh, dear.  A previous attempt to write the
-		 * superblock failed.  This could happen because the
-		 * USB device was yanked out.  Or it could happen to
-		 * be a transient write error and maybe the block will
-		 * be remapped.  Nothing we can do but to retry the
-		 * write and hope for the best.
-		 */
-		ext2_msg(sb, KERN_ERR,
-		       "previous I/O error to superblock detected\n");
-		clear_buffer_write_io_error(sbh);
-		set_buffer_uptodate(sbh);
-	}
+	ext2_clear_super_error(sb);
 
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
-- 
1.6.4.2

