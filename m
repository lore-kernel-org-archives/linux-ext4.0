From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 09/12] ext4: fix the number of credits needed for ext4_ext_migrate()
Date: Sat,  9 Feb 2013 16:53:49 -0500
Message-ID: <1360446832-12724-10-git-send-email-tytso@mit.edu>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47611 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839Ab3BIVxz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Feb 2013 16:53:55 -0500
In-Reply-To: <1360446832-12724-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The migration ioctl creates a temporary inode.  Since this inode is
never linked to a directory, we don't need to reserve journal credits
required for modifying the directory.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/migrate.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 4e4fcfd..480acf4 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -456,11 +456,14 @@ int ext4_ext_migrate(struct inode *inode)
 		 */
 		return retval;
 
+	/*
+	 * Worst case we can touch the allocation bitmaps, a bgd
+	 * block, and a block to link in the orphan list.  We do need
+	 * need to worry about credits for modifying the quota inode.
+	 */
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE,
-					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
-					+ 1);
+		4 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb));
+
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
 		return retval;
-- 
1.7.12.rc0.22.gcdd159b

