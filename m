From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 4/4]JBD2: sparse pointer use of zero as null
Date: Thu, 17 Jan 2008 11:48:23 -0800
Message-ID: <1200599303.4134.34.camel@localhost.localdomain>
References: <12004403661489-git-send-email-jonas.bonn@gmail.com>
	 <20080115155914.c72aaea9.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51532 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbYAQTsR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 14:48:17 -0500
In-Reply-To: <20080115155914.c72aaea9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ported from upstream jbd changes to jbd2

sparse pointer use of zero as null

Get rid of sparse related warnings from places that use integer as NULL
pointer.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd2/transaction.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.24-rc7/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.24-rc7.orig/fs/jbd2/transaction.c	2008-01-16 17:49:48.000000000 -0800
+++ linux-2.6.24-rc7/fs/jbd2/transaction.c	2008-01-16 18:06:33.000000000 -0800
@@ -1182,7 +1182,7 @@ int jbd2_journal_dirty_metadata(handle_t
 	}
 
 	/* That test should have eliminated the following case: */
-	J_ASSERT_JH(jh, jh->b_frozen_data == 0);
+	J_ASSERT_JH(jh, jh->b_frozen_data == NULL);
 
 	JBUFFER_TRACE(jh, "file as BJ_Metadata");
 	spin_lock(&journal->j_list_lock);
@@ -1532,7 +1532,7 @@ void __jbd2_journal_temp_unlink_buffer(s
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	if (jh->b_jlist != BJ_None)
-		J_ASSERT_JH(jh, transaction != 0);
+		J_ASSERT_JH(jh, transaction != NULL);
 
 	switch (jh->b_jlist) {
 	case BJ_None:
@@ -1601,11 +1601,11 @@ __journal_try_to_free_buffer(journal_t *
 	if (buffer_locked(bh) || buffer_dirty(bh))
 		goto out;
 
-	if (jh->b_next_transaction != 0)
+	if (jh->b_next_transaction != NULL)
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_transaction != 0 && jh->b_cp_transaction == 0) {
+	if (jh->b_transaction != NULL && jh->b_cp_transaction == NULL) {
 		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
 			/* A written-back ordered data buffer */
 			JBUFFER_TRACE(jh, "release data");
@@ -1613,7 +1613,7 @@ __journal_try_to_free_buffer(journal_t *
 			jbd2_journal_remove_journal_head(bh);
 			__brelse(bh);
 		}
-	} else if (jh->b_cp_transaction != 0 && jh->b_transaction == 0) {
+	} else if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
@@ -1973,7 +1973,7 @@ void __jbd2_journal_file_buffer(struct j
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	J_ASSERT_JH(jh, jh->b_transaction == transaction ||
-				jh->b_transaction == 0);
+				jh->b_transaction == NULL);
 
 	if (jh->b_transaction && jh->b_jlist == jlist)
 		return;

 
