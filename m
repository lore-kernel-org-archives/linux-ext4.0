From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't give the "disabling delalloc" if not explicitly specified
Date: Sat, 13 Aug 2011 22:52:38 -0400
Message-ID: <1313290358-12611-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34480 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1HNCwm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Aug 2011 22:52:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If both delalloc and data=journalled are enabled, then a warning
message that delalloc will be disabled is displayed at mount time.
Since delalloc is the default, this means this warning is always
printed which really isn't necessary.  So disable the warning message
unless the user explicitly asked for delalloc.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/super.c |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index be593d5..b98b5a1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -916,6 +916,8 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
 #define EXT4_MOUNT_INIT_INODE_TABLE	0x80000000 /* Initialize uninitialized itables */
 
+#define EXT4_MOUNT2_DELALLOC_EXPLICIT	0x00000001 /* specified by user */
+
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
 #define set_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt |= \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..447eb45 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1817,6 +1817,7 @@ set_qf_format:
 			break;
 		case Opt_delalloc:
 			set_opt(sb, DELALLOC);
+			set_opt2(sb, DELALLOC_EXPLICIT);
 			break;
 		case Opt_block_validity:
 			set_opt(sb, BLOCK_VALIDITY);
@@ -3681,8 +3682,9 @@ no_journal:
 
 	if (test_opt(sb, DELALLOC) &&
 	    (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)) {
-		ext4_msg(sb, KERN_WARNING, "Ignoring delalloc option - "
-			 "requested data journaling mode");
+		if (test_opt2(sb, DELALLOC_EXPLICIT))
+			ext4_msg(sb, KERN_WARNING, "Ignoring delalloc option "
+				 "- requested data journaling mode");
 		clear_opt(sb, DELALLOC);
 	}
 	if (test_opt(sb, DIOREAD_NOLOCK)) {
-- 
1.7.4.1.22.gec8e1.dirty

