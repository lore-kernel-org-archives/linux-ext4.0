From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH 2/2] Extract 'ext4_sb_info' variable
Date: Mon, 17 Sep 2012 10:47:17 -0700
Message-ID: <1347904037-24229-2-git-send-email-anatol.pomozov@gmail.com>
References: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Cc: dmonakhov@openvz.org, Anatol Pomozov <anatol.pomozov@gmail.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33456 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2IQRr6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2012 13:47:58 -0400
Received: by mail-lb0-f202.google.com with SMTP id ge1so416750lbb.1
        for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 10:47:57 -0700 (PDT)
In-Reply-To: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It makes the code more compact and consistent. This change is
a refactoring that does not change any functionality.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 fs/ext4/namei.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6863cdf..f9846e4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2359,15 +2359,16 @@ static int empty_dir(struct inode *inode)
 int ext4_orphan_add(handle_t *handle, struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!EXT4_SB(sb)->s_journal)
+	if (!sbi->s_journal)
 		return 0;
 	if (!ext4_handle_valid(handle))
 		return 0;
 
-	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
+	mutex_lock(&sbi->s_orphan_lock);
 	if (!list_empty(&EXT4_I(inode)->i_orphan))
 		goto out_unlock;
 
@@ -2380,8 +2381,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	J_ASSERT((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 		  S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
 
-	BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
+	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
 	if (err)
 		goto out_unlock;
 
@@ -2393,12 +2394,12 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	 * orphan list. If so skip on-disk list modification.
 	 */
 	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
-		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)))
+		(le32_to_cpu(sbi->s_es->s_inodes_count)))
 			goto mem_insert;
 
 	/* Insert this inode at the head of the on-disk orphan list... */
-	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
-	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
+	NEXT_ORPHAN(inode) = le32_to_cpu(sbi->s_es->s_last_orphan);
+	sbi->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
 	err = ext4_handle_dirty_super(handle, sb);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
@@ -2414,13 +2415,13 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	 * anyway on the next recovery. */
 mem_insert:
 	if (!err)
-		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
+		list_add(&EXT4_I(inode)->i_orphan, &sbi->s_orphan);
 
 	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
 	jbd_debug(4, "orphan inode %lu will point to %d\n",
 			inode->i_ino, NEXT_ORPHAN(inode));
 out_unlock:
-	mutex_unlock(&EXT4_SB(sb)->s_orphan_lock);
+	mutex_unlock(&sbi->s_orphan_lock);
 	ext4_std_error(inode->i_sb, err);
 	return err;
 }
@@ -2433,24 +2434,23 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 {
 	struct list_head *prev;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	struct ext4_sb_info *sbi;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	__u32 ino_next;
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if (!sbi->s_journal)
 		return 0;
 	/* ext4_handle_valid() assumes a valid handle_t pointer */
 	if (handle && !ext4_handle_valid(handle))
 		return 0;
 
-	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
+	mutex_lock(&sbi->s_orphan_lock);
 	if (list_empty(&ei->i_orphan))
 		goto out;
 
 	ino_next = NEXT_ORPHAN(inode);
 	prev = ei->i_orphan.prev;
-	sbi = EXT4_SB(inode->i_sb);
 
 	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
 
@@ -2496,7 +2496,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 out_err:
 	ext4_std_error(inode->i_sb, err);
 out:
-	mutex_unlock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
+	mutex_unlock(&sbi->s_orphan_lock);
 	return err;
 
 out_brelse:
-- 
1.7.12

