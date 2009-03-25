From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Update locking coments
Date: Wed, 25 Mar 2009 14:43:29 +0100
Message-ID: <1237988609-31699-3-git-send-email-jack@suse.cz>
References: <n>
 <1237988609-31699-1-git-send-email-jack@suse.cz>
 <1237988609-31699-2-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Lin Tan <tammy000@gmail.com>, "."@suse.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZCYNnc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Mar 2009 09:43:32 -0400
In-Reply-To: <1237988609-31699-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update information about locking in JBD2 revoke code. Inconsistency in comments
found by Lin Tan <tammy000@gmail.com>.

CC: Lin Tan <tammy000@gmail.com>.
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/revoke.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 257ff26..bbe6d59 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
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
@@ -401,8 +420,6 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
  * the second time we would still have a pending revoke to cancel.  So,
  * do not trust the Revoked bit on buffers unless RevokeValid is also
  * set.
- *
- * The caller must have the journal locked.
  */
 int jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 {
@@ -480,10 +497,7 @@ void jbd2_journal_switch_revoke_table(journal_t *journal)
 /*
  * Write revoke records to the journal for all entries in the current
  * revoke hash, deleting the entries as we go.
- *
- * Called with the journal lock held.
  */
