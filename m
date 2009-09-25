From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH]ext4: Add checks whether two inodes are different
Date: Fri, 25 Sep 2009 17:31:01 +0900
Message-ID: <4ABC7FC5.5070803@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44143 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZIYIc6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Sep 2009 04:32:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Add checks whether two inodes are different to move_extent.c

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If same inode is set to orig and donor in ext4_move_extensts(),
this leads to the deadlock in mext_double_down_{read, write}.
This patch adds checks to mext_double_{down, up}_{read, write}
and if inodes are same, we take/release one semaphore from them.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c07a291..e1346cb 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -177,7 +177,8 @@ mext_double_down_read(struct inode *orig_inode, struct inode *donor_inode)
 	}

 	down_read(&EXT4_I(first)->i_data_sem);
-	down_read(&EXT4_I(second)->i_data_sem);
+	if (first != second)
+		down_read(&EXT4_I(second)->i_data_sem);
 }

 /**
@@ -203,7 +204,8 @@ mext_double_down_write(struct inode *orig_inode, struct inode *donor_inode)
 	}

 	down_write(&EXT4_I(first)->i_data_sem);
-	down_write(&EXT4_I(second)->i_data_sem);
+	if (first != second)
+		down_write(&EXT4_I(second)->i_data_sem);
 }

 /**
@@ -217,7 +219,8 @@ static void
 mext_double_up_read(struct inode *orig_inode, struct inode *donor_inode)
 {
 	up_read(&EXT4_I(orig_inode)->i_data_sem);
-	up_read(&EXT4_I(donor_inode)->i_data_sem);
+	if (orig_inode != donor_inode)
+		up_read(&EXT4_I(donor_inode)->i_data_sem);
 }

 /**
@@ -231,7 +234,8 @@ static void
 mext_double_up_write(struct inode *orig_inode, struct inode *donor_inode)
 {
 	up_write(&EXT4_I(orig_inode)->i_data_sem);
-	up_write(&EXT4_I(donor_inode)->i_data_sem);
+	if (orig_inode != donor_inode)
+		up_write(&EXT4_I(donor_inode)->i_data_sem);
 }

 /**
@@ -1002,7 +1006,7 @@ mext_check_arguments(struct inode *orig_inode,
 	}

 	/* orig and donor should be different file */
-	if (orig_inode->i_ino == donor_inode->i_ino) {
+	if (orig_inode == donor_inode) {
 		ext4_debug("ext4 move extent: The argument files should not "
 			"be same file [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);

