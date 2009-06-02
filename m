From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 15/24] jbd2: Update locking coments
Date: Tue,  2 Jun 2009 08:09:27 -0400
Message-ID: <1243944576-20915-15-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
 <1243944576-20915-14-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59310 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZFBMJu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:50 -0400
In-Reply-To: <1243944576-20915-14-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Update information about locking in JBD2 revoke code. Inconsistency in
comments found by Lin Tan <tammy000@gmail.com>.

CC: Lin Tan <tammy000@gmail.com>.
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 86db97c87f744364d5889ca8a4134ca2048b8f83)
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
