From: Jan Kara <jack@suse.cz>
Subject: [PATCH RESEND] jbd: Update locking coments
Date: Tue,  7 Apr 2009 15:11:28 +0200
Message-ID: <1239109888-18700-1-git-send-email-jack@suse.cz>
References: <y>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Lin Tan <tammy000@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZDGNLa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 09:11:30 -0400
In-Reply-To: <y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update information about locking in JBD revoke code. Inconsistency in comments
found by Lin Tan <tammy000@gmail.com>.

CC: Lin Tan <tammy000@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/revoke.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

  Andrew, could you please merge the patch? Ted has already merged JBD2
equivalent.

									Honza

diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index c7bd649..3e9afc2 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -55,6 +55,25 @@
  *			need do nothing.
  * RevokeValid set, Revoked set:
  *			buffer has been revoked.
+ *
+ * Locking rules:
+ * We keep two hash tables of revoke records. One hashtable belongs to the
+ * running transaction (is pointed to by journal->j_revoke), the other one
+ * belongs to the committing transaction. Accesses to the second hash table
+ * happen only from the kjournald and no other thread touches this table.  Also
+ * journal_switch_revoke_table() which switches which hashtable belongs to the
+ * running and which to the committing transaction is called only from
+ * kjournald. Therefore we need no locks when accessing the hashtable belonging
+ * to the committing transaction.
+ *
+ * All users operating on the hash table belonging to the running transaction
+ * have a handle to the transaction. Therefore they are safe from kjournald
+ * switching hash tables under them. For operations on the lists of entries in
+ * the hash table j_revoke_lock is used.
+ *
+ * Finally, also replay code uses the hash tables but at this moment noone else
+ * can touch them (filesystem isn't mounted yet) and hence no locking is
+ * needed.
  */
 
 #ifndef __KERNEL__
@@ -402,8 +421,6 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
  * the second time we would still have a pending revoke to cancel.  So,
  * do not trust the Revoked bit on buffers unless RevokeValid is also
  * set.
- *
- * The caller must have the journal locked.
  */
 int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 {
@@ -481,10 +498,7 @@ void journal_switch_revoke_table(journal_t *journal)
 /*
  * Write revoke records to the journal for all entries in the current
  * revoke hash, deleting the entries as we go.
- *
- * Called with the journal lock held.
  */
