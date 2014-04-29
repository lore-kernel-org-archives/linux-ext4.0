From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Use sbi in ext4_orphan_del()
Date: Wed, 30 Apr 2014 01:32:32 +0200
Message-ID: <1398814353-11904-2-git-send-email-jack@suse.cz>
References: <1398814353-11904-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaD2Xcl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 19:32:41 -0400
In-Reply-To: <1398814353-11904-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use sbi pointer consistently in ext4_orphan_del() instead of opencoding
it sometimes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1cb84f78909e..411957326827 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2622,22 +2622,20 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 {
 	struct list_head *prev;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	struct ext4_sb_info *sbi;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	__u32 ino_next;
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
-	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
+	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
-	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
+	mutex_lock(&sbi->s_orphan_lock);
 	if (list_empty(&ei->i_orphan))
 		goto out;
 
 	ino_next = NEXT_ORPHAN(inode);
 	prev = ei->i_orphan.prev;
-	sbi = EXT4_SB(inode->i_sb);
 
 	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
 
@@ -2683,7 +2681,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 out_err:
 	ext4_std_error(inode->i_sb, err);
 out:
-	mutex_unlock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
+	mutex_unlock(&sbi->s_orphan_lock);
 	return err;
 
 out_brelse:
-- 
1.8.1.4

