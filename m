From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext3: call ext3_mark_recovery_complete() when recovery is really needed
Date: Tue,  1 Nov 2011 10:06:19 +0800
Message-ID: <1320113179-27491-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59693 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1KACGk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 22:06:40 -0400
Received: by mail-vx0-f174.google.com with SMTP id e1so5362134vcg.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 Oct 2011 19:06:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Call ext3_mark_recovery_complete() in ext3_fill_super() only if
needs_recovery is non-zero.

Besides that, print out "recovery complete" message after calling
ext3_mark_recovery_complete().

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext3/super.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7beb69a..2681e0d 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2060,9 +2060,10 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
 	ext3_orphan_cleanup(sb, es);
 	EXT3_SB(sb)->s_mount_state &= ~EXT3_ORPHAN_FS;
-	if (needs_recovery)
+	if (needs_recovery) {
+		ext3_mark_recovery_complete(sb, es);
 		ext3_msg(sb, KERN_INFO, "recovery complete");
-	ext3_mark_recovery_complete(sb, es);
+	}
 	ext3_msg(sb, KERN_INFO, "mounted filesystem with %s data mode",
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
-- 
1.7.7.1

