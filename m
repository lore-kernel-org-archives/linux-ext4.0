From: Greg KH <gregkh@suse.de>
Subject: [patch 51/60] jbd2: Update locking coments
Date: Tue, 09 Jun 2009 17:14:19 -0700
Message-ID: <20090610002351.456745670@blue.kroah.org>
References: <20090610001328.251476848@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Lin Tan <tammy000@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703AbZFJDgq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:36:46 -0400
Content-Disposition: inline; filename=jbd2-update-locking-coments.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Kara <jack@suse.cz>

(cherry picked from commit 86db97c87f744364d5889ca8a4134ca2048b8f83)

Update information about locking in JBD2 revoke code. Inconsistency in
comments found by Lin Tan <tammy000@gmail.com>

CC: Lin Tan <tammy000@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jbd2/revoke.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

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
@@ -401,8 +420,6 @@ int jbd2_journal_revoke(handle_t *handle
  * the second time we would still have a pending revoke to cancel.  So,
  * do not trust the Revoked bit on buffers unless RevokeValid is also
  * set.
- *
- * The caller must have the journal locked.
  */
 int jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 {
@@ -480,10 +497,7 @@ void jbd2_journal_switch_revoke_table(jo
 /*
  * Write revoke records to the journal for all entries in the current
  * revoke hash, deleting the entries as we go.
- *
- * Called with the journal lock held.
  */
