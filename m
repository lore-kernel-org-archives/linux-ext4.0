From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 1/2] ext4: create function to read journal inode
Date: Wed, 21 Sep 2016 21:14:50 -0400
Message-ID: <20160922011450.GB27216@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33754 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754297AbcIVBKn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Sep 2016 21:10:43 -0400
Received: by mail-qt0-f193.google.com with SMTP id p47so2113565qtc.0
        for <linux-ext4@vger.kernel.org>; Wed, 21 Sep 2016 18:10:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Factor out the code used in ext4_get_journal() to read a valid journal
inode from storage, enabling its reuse in other functions.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/super.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 50912cc..4b0ca25 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -78,6 +78,8 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
+static struct inode *ext4_get_journal_inode(struct super_block *sb,
+					    unsigned int journal_inum);
 
 /*
  * Lock ordering
@@ -4237,18 +4239,16 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
 	write_unlock(&journal->j_state_lock);
 }
 
-static journal_t *ext4_get_journal(struct super_block *sb,
-				   unsigned int journal_inum)
+static struct inode *ext4_get_journal_inode(struct super_block *sb,
+					     unsigned int journal_inum)
 {
 	struct inode *journal_inode;
-	journal_t *journal;
-
-	BUG_ON(!ext4_has_feature_journal(sb));
-
-	/* First, test for the existence of a valid inode on disk.  Bad
-	 * things happen if we iget() an unused inode, as the subsequent
-	 * iput() will try to delete it. */
 
+	/*
+	 * Test for the existence of a valid inode on disk.  Bad things
+	 * happen if we iget() an unused inode, as the subsequent iput()
+	 * will try to delete it.
+	 */
 	journal_inode = ext4_iget(sb, journal_inum);
 	if (IS_ERR(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "no journal found");
@@ -4268,6 +4268,20 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 		iput(journal_inode);
 		return NULL;
 	}
+	return journal_inode;
+}
+
+static journal_t *ext4_get_journal(struct super_block *sb,
+				   unsigned int journal_inum)
+{
+	struct inode *journal_inode;
+	journal_t *journal;
+
+	BUG_ON(!ext4_has_feature_journal(sb));
+
+	journal_inode = ext4_get_journal_inode(sb, journal_inum);
+	if (!journal_inode)
+		return NULL;
 
 	journal = jbd2_journal_init_inode(journal_inode);
 	if (!journal) {
-- 
2.1.4

