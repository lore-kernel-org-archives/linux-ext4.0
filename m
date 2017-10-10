From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: retry allocations conservatively
Date: Tue, 10 Oct 2017 11:45:45 -0400
Message-ID: <20171010154545.3787-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58460 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932243AbdJJPpw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 10 Oct 2017 11:45:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we no longer try to reserve metadata blocks for delayed
allocations (which tended to overestimate the required number of
blocks significantly), we really don't need retry allocations when the
disk is very full as aggressively any more.

The only time when it makes sense to retry an allocation is if we have
freshly deleted blocks that will only become available after a
transaction commit.  And if we lose that race, it's not worth it to
try more than once.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/balloc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e04ec868e37e..a3798b25a8dc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -600,22 +600,21 @@ int ext4_claim_free_clusters(struct ext4_sb_info *sbi,
  * ext4_should_retry_alloc() is called when ENOSPC is returned, and if
  * it is profitable to retry the operation, this function will wait
  * for the current or committing transaction to complete, and then
- * return TRUE.
- *
- * if the total number of retries exceed three times, return FALSE.
+ * return TRUE.  We will only retry once.
  */
 int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 {
 	if (!ext4_has_free_clusters(EXT4_SB(sb), 1, 0) ||
-	    (*retries)++ > 3 ||
+	    (*retries)++ > 1 ||
 	    !EXT4_SB(sb)->s_journal)
 		return 0;
 
-	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
