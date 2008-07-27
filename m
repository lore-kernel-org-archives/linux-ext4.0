From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: don't abort if flushing file data failed
Date: Sat, 26 Jul 2008 20:26:54 -0400
Message-ID: <1217118414-18636-4-git-send-email-tytso@mit.edu>
References: <1217118414-18636-1-git-send-email-tytso@mit.edu>
 <1217118414-18636-2-git-send-email-tytso@mit.edu>
 <1217118414-18636-3-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38617 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756239AbYG0A1F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2008 20:27:05 -0400
In-Reply-To: <1217118414-18636-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ordered mode, the current jbd2 aborts the journal if a file data buffer
has an error.  But this behavior is unintended, and we found that it has
been adopted accidentally.

This patch undoes it and just calls printk() instead of aborting the
journal.  Unlike a similar patch submitted by Hidehiro Kawai for
ext3/jbd, we don't need to add additional error checks and set AS_EIO,
as ext4 uses generic_writepages() to flush out data buffers to disk.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd2/commit.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f8b3be8..04adcc3 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -460,8 +460,14 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * on the transaction lists.  Data blocks go first.
 	 */
 	err = journal_submit_data_buffers(journal, commit_transaction);
-	if (err)
-		jbd2_journal_abort(journal, err);
+	if (err) {
+		char b[BDEVNAME_SIZE];
+
+		printk(KERN_WARNING
+			"JBD2: Detected IO errors while flushing file data "
+			"on %s\n", bdevname(journal->j_fs_dev, b));
+		err = 0;
+	}
 
 	jbd2_journal_write_revoke_records(journal, commit_transaction);
 
-- 
1.5.6.1.205.ge2c7.dirty

