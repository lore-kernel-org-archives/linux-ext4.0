From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Sun, 17 Feb 2008 10:19:35 +0200
Message-ID: <20080217081935.GN3848@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36926 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826AbYBQIUB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Feb 2008 03:20:01 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch contains the following cleanups:
- make the following needlessly global function static:
  - journal_check_used_features()
- remove the following unused EXPORT_SYMBOL's:
  - journal_set_features
  - journal_update_superblock

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 16 May 2006
- 1 May 2006
- 23 Apr 2006

 fs/jbd/journal.c    |    9 ++++-----
 include/linux/jbd.h |    2 --
 2 files changed, 4 insertions(+), 7 deletions(-)

4b48b0ddcc5e710bbc1e89e219db69000225ee28 diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..b230288 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -62,13 +62,10 @@ EXPORT_SYMBOL(journal_revoke);
 EXPORT_SYMBOL(journal_init_dev);
 EXPORT_SYMBOL(journal_init_inode);
 EXPORT_SYMBOL(journal_update_format);
-EXPORT_SYMBOL(journal_check_used_features);
 EXPORT_SYMBOL(journal_check_available_features);
-EXPORT_SYMBOL(journal_set_features);
 EXPORT_SYMBOL(journal_create);
 EXPORT_SYMBOL(journal_load);
 EXPORT_SYMBOL(journal_destroy);
-EXPORT_SYMBOL(journal_update_superblock);
 EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
@@ -1174,8 +1171,10 @@ void journal_destroy(journal_t *journal)
  * features.  Return true (non-zero) if it does.
  **/
 
-int journal_check_used_features (journal_t *journal, unsigned long compat,
-				 unsigned long ro, unsigned long incompat)
+static int journal_check_used_features(journal_t *journal,
+				       unsigned long compat,
+				       unsigned long ro,
+				       unsigned long incompat)
 {
 	journal_superblock_t *sb;
 
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index b18fd3b..e8f81ab 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -909,8 +909,6 @@ extern journal_t * journal_init_dev(struct block_device *bdev,
 				int start, int len, int bsize);
 extern journal_t * journal_init_inode (struct inode *);
 extern int	   journal_update_format (journal_t *);
-extern int	   journal_check_used_features
-		   (journal_t *, unsigned long, unsigned long, unsigned long);
 extern int	   journal_check_available_features
 		   (journal_t *, unsigned long, unsigned long, unsigned long);
 extern int	   journal_set_features
