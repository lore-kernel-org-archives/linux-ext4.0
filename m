From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] fix null handler of ioctls in no journal mode
Date: Fri, 10 Jul 2009 19:03:46 +0800
Message-ID: <1247223826-24378-1-git-send-email-bergwolf@gmail.com>
Cc: tytso@mit.edu, Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f193.google.com ([209.85.216.193]:52235 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZGJLDz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 07:03:55 -0400
Received: by pxi31 with SMTP id 31so580754pxi.33
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 04:03:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_IOC_GROUP_ADD and EXT4_IOC_GROUP_EXTEND ioctls should not flush journal
in no_journal mode.

This can be triggered by running resize2fs on a mounted no_journal partition
as follows:
mkfs.ext4 /dev/sdb1 -O ^has_journal
enlarge /dev/sdb1 in partition table
mount /dev/sdb1
resize2fs /dev/sdb1

And it will get these error message:
BUG: unable to handle kernel NULL pointer dereference at 00000014
IP: [<c039d282>] _spin_lock+0x8/0x19
*pde = 00000000 
Oops: 0002 [#1] SMP

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 fs/ext4/ioctl.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 91e75f7..9e29c0a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -191,7 +191,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err, err2;
+		int err, err2=0;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -204,9 +204,11 @@ setversion_out:
 			return err;
 
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
-		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
-		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (EXT4_SB(sb)->s_journal) {
+			jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
+			err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+			jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		}
 		if (err == 0)
 			err = err2;
 		mnt_drop_write(filp->f_path.mnt);
@@ -216,7 +218,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err, err2;
+		int err, err2=0;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -230,9 +232,11 @@ setversion_out:
 			return err;
 
 		err = ext4_group_add(sb, &input);
-		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
-		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (EXT4_SB(sb)->s_journal) {
+			jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
+			err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+			jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		}
 		if (err == 0)
 			err = err2;
 		mnt_drop_write(filp->f_path.mnt);
-- 
1.6.2-rc2.GIT

