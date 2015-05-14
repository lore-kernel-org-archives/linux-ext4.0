From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't save the error information if the block device is read-only
Date: Thu, 14 May 2015 18:37:59 -0400
Message-ID: <1431643079-22882-1-git-send-email-tytso@mit.edu>
Cc: mkayyash@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37327 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964836AbbENWiG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2015 18:38:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Google-Bug-Id: 20939131
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f06d058..ca9d4a2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -294,6 +294,8 @@ static void __save_error_info(struct super_block *sb, const char *func,
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
+	if (bdev_read_only(sb->s_bdev))
+		return;
 	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
 	es->s_last_error_time = cpu_to_le32(get_seconds());
 	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
-- 
2.3.0

