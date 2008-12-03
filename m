From: Greg KH <gregkh@suse.de>
Subject: [patch 093/104] jbd2: dont give up looking for space so easily in
	__jbd2_log_wait_for_space
Date: Wed, 3 Dec 2008 11:56:36 -0800
Message-ID: <20081203195636.GP8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
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
	alan@lxorguk.ukuu.org.uk,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Duane Griffin <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754081AbYLCT57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:59 -0500
Content-Disposition: inline; filename="jbd2-don-t-give-up-looking-for-space-so-easily-in-__jbd2_log_wait_for_space.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let u=
s know.

------------------
=46rom: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 8c3f25d8950c3e9fe6c9849f88679b3f2a071550)

Commit 23f8b79e introducd a regression because it assumed that if
there were no transactions ready to be checkpointed, that no progress
could be made on making space available in the journal, and so the
journal should be aborted.  This assumption is false; it could be the
case that simply calling jbd2_cleanup_journal_tail() will recover the
necessary space, or, for small journals, the currently committing
transaction could be responsible for chewing up the required space in
the log, so we need to wait for the currently committing transaction
to finish before trying to force a checkpoint operation.

This patch fixes a bug reported by Mihai Harpau at:
https://bugzilla.redhat.com/show_bug.cgi?id=3D469582

This patch fixes a bug reported by Fran=E7ois Valenduc at:
http://bugzilla.kernel.org/show_bug.cgi?id=3D11840

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Duane Griffin <duaneg@dghda.com>
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/checkpoint.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -114,7 +114,7 @@ static int __try_to_free_cp_buf(struct j
  */
 void __jbd2_log_wait_for_space(journal_t *journal)
 {
-	int nblocks;
+	int nblocks, space_left;
 	assert_spin_locked(&journal->j_state_lock);
=20
 	nblocks =3D jbd_space_needed(journal);
@@ -127,25 +127,43 @@ void __jbd2_log_wait_for_space(journal_t
 		/*
 		 * Test again, another process may have checkpointed while we
 		 * were waiting for the checkpoint lock. If there are no
-		 * outstanding transactions there is nothing to checkpoint and
-		 * we can't make progress. Abort the journal in this case.
+		 * transactions ready to be checkpointed, try to recover
+		 * journal space by calling cleanup_journal_tail(), and if
+		 * that doesn't work, by waiting for the currently committing
+		 * transaction to complete.  If there is absolutely no way
+		 * to make progress, this is either a BUG or corrupted
+		 * filesystem, so abort the journal and leave a stack
+		 * trace for forensic evidence.
 		 */
 		spin_lock(&journal->j_state_lock);
 		spin_lock(&journal->j_list_lock);
 		nblocks =3D jbd_space_needed(journal);
-		if (__jbd2_log_space_left(journal) < nblocks) {
+		space_left =3D __jbd2_log_space_left(journal);
+		if (space_left < nblocks) {
 			int chkpt =3D journal->j_checkpoint_transactions !=3D NULL;
+			tid_t tid =3D 0;
=20
+			if (journal->j_committing_transaction)
+				tid =3D journal->j_committing_transaction->t_tid;
 			spin_unlock(&journal->j_list_lock);
 			spin_unlock(&journal->j_state_lock);
 			if (chkpt) {
 				jbd2_log_do_checkpoint(journal);
+			} else if (jbd2_cleanup_journal_tail(journal) =3D=3D 0) {
+				/* We were able to recover space; yay! */
+				;
+			} else if (tid) {
+				jbd2_log_wait_commit(journal, tid);
 			} else {
-				printk(KERN_ERR "%s: no transactions\n",
-				       __func__);
+				printk(KERN_ERR "%s: needed %d blocks and "
+				       "only had %d space available\n",
+				       __func__, nblocks, space_left);
+				printk(KERN_ERR "%s: no way to get more "
+				       "journal space in %s\n", __func__,
+				       journal->j_devname);
+				WARN_ON(1);
 				jbd2_journal_abort(journal, 0);
 			}
