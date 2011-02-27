From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: suppress verbose debugging information if malloc-debug is off
Date: Sun, 27 Feb 2011 17:24:19 -0500
Message-ID: <1298845459-22066-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45417 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab1B0Xdf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Feb 2011 18:33:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If CONFIG_EXT4_DEBUG is enabled, then if a block allocation fails due
to disk being full, a verbose debugging message is printed, even if
the malloc-debug switch has not been enabled.  Suppress the debugging
message so that nothing is printed unless malloc-debug has been turned
on.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 66bee72..2f6f0dd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3912,7 +3912,8 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 	struct super_block *sb = ac->ac_sb;
 	ext4_group_t ngroups, i;
 
-	if (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)
+	if (!mb_enable_debug ||
+	    (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED))
 		return;
 
 	printk(KERN_ERR "EXT4-fs: Can't allocate:"
-- 
1.7.3.1

