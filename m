From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH] ext4: Don't set EXTENTS_FL flag for fast symlinks
Date: Mon, 04 Feb 2008 14:20:36 +0100
Message-ID: <1202131236.6573.5.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55137 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYBDNRx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 08:17:53 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 577281A16EB
	for <linux-ext4@vger.kernel.org>; Mon,  4 Feb 2008 14:18:02 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 20590-09 for <linux-ext4@vger.kernel.org>;
 Mon,  4 Feb 2008 14:17:58 +0100 (CET)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 4EB971A16F3
	for <linux-ext4@vger.kernel.org>; Mon,  4 Feb 2008 14:16:54 +0100 (CET)
Received: from [127.0.0.1] (frecb000755.frec.bull.fr [129.183.101.79])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 2DDBF272B9
	for <linux-ext4@vger.kernel.org>; Mon,  4 Feb 2008 14:16:52 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't set EXTENTS_FL flag for fast symlinks

From: Valerie Clement <valerie.clement@bull.net>

For fast symbolic links, the file content is stored in the i_block[]
array, which is not compatible with the new file extents format.
e2fsck reports error on such files because EXTENTS_FL is set.
Don't set the EXTENTS_FL flag when creating fast symlinks.

In the case of file migration, skip fast symbolic links.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>

---

 fs/ext4/migrate.c |    6 ++++++
 fs/ext4/namei.c   |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 3ebc233..9ee1f7c 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -414,6 +414,12 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
 		return -EINVAL;
 
+	if (S_ISLNK(inode->i_mode) && inode->i_blocks == 0)
+		/*
+		 * don't migrate fast symlink
+		 */
+		return retval;
+
 	down_write(&EXT4_I(inode)->i_data_sem);
 	handle = ext4_journal_start(inode,
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 67b6d8a..71273c5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2234,6 +2234,7 @@ retry:
 		inode->i_op = &ext4_fast_symlink_inode_operations;
 		memcpy((char*)&EXT4_I(inode)->i_data,symname,l);
 		inode->i_size = l-1;
+		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 	}
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	err = ext4_add_nondir(handle, dentry, inode);
