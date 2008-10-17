From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Remove unused mount options: nomballoc, mballoc, nocheck
Date: Fri, 17 Oct 2008 09:27:40 -0400
Message-ID: <1224250060-31979-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34875 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753986AbYJQN1m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 09:27:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These mount options don't actually do anything any more, so remove
them.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    1 -
 fs/ext4/super.c |   11 ++---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6690a41..4880cc3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -511,7 +511,6 @@ do {									       \
 /*
  * Mount flags
  */
-#define EXT4_MOUNT_CHECK		0x00001	/* Do mount-time checks */
 #define EXT4_MOUNT_OLDALLOC		0x00002  /* Don't use the new Orlov allocator */
 #define EXT4_MOUNT_GRPID		0x00004	/* Create files with directory's group */
 #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging messages */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a97e9eb..95127f0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -904,7 +904,7 @@ static const struct export_operations ext4_export_ops = {
 enum {
 	Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
 	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_nouid32, Opt_nocheck, Opt_debug, Opt_oldalloc, Opt_orlov,
+	Opt_nouid32, Opt_debug, Opt_oldalloc, Opt_orlov,
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
@@ -915,7 +915,7 @@ enum {
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents, Opt_i_version,
-	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_delalloc, Opt_nodelalloc,
+	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 	Opt_inode_readahead_blks
 };
 
@@ -933,8 +933,6 @@ static const match_table_t tokens = {
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_nouid32, "nouid32"},
-	{Opt_nocheck, "nocheck"},
-	{Opt_nocheck, "check=none"},
 	{Opt_debug, "debug"},
 	{Opt_oldalloc, "oldalloc"},
 	{Opt_orlov, "orlov"},
@@ -973,8 +971,6 @@ static const match_table_t tokens = {
 	{Opt_extents, "extents"},
 	{Opt_noextents, "noextents"},
 	{Opt_i_version, "i_version"},
-	{Opt_mballoc, "mballoc"},
-	{Opt_nomballoc, "nomballoc"},
 	{Opt_stripe, "stripe=%u"},
 	{Opt_resize, "resize"},
 	{Opt_delalloc, "delalloc"},
@@ -1073,9 +1069,6 @@ static int parse_options(char *options, struct super_block *sb,
 		case Opt_nouid32:
 			set_opt(sbi->s_mount_opt, NO_UID32);
 			break;
-		case Opt_nocheck:
-			clear_opt(sbi->s_mount_opt, CHECK);
-			break;
 		case Opt_debug:
 			set_opt(sbi->s_mount_opt, DEBUG);
 			break;
-- 
1.5.6.1.205.ge2c7.dirty

