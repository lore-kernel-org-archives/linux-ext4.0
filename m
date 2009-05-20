From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH 1/4] Fix minor typos in jbd2's journal.c
Date: Wed, 20 May 2009 16:01:31 -0300
Message-ID: <1242846091-1086-1-git-send-email-albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	trivial@kernel.org, Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3520 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZETT1s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 15:27:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 fs/jbd2/journal.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5814410..85af8ea 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1781,7 +1781,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
  * Journal abort has very specific semantics, which we describe
  * for journal abort.
  *
- * Two internal function, which provide abort to te jbd layer
+ * Two internal function, which provide abort to the jbd layer
  * itself are here.
  */
 
@@ -1879,7 +1879,7 @@ void jbd2_journal_abort(journal_t *journal, int errno)
  * int jbd2_journal_errno () - returns the journal's error state.
  * @journal: journal to examine.
  *
- * This is the errno numbet set with jbd2_journal_abort(), the last
+ * This is the errno number set with jbd2_journal_abort(), the last
  * time the journal was mounted - if the journal was stopped
  * without calling abort this will be 0.
  *
@@ -1903,7 +1903,7 @@ int jbd2_journal_errno(journal_t *journal)
  * int jbd2_journal_clear_err () - clears the journal's error state
  * @journal: journal to act on.
  *
- * An error must be cleared or Acked to take a FS out of readonly
+ * An error must be cleared or acked to take a FS out of readonly
  * mode.
  */
 int jbd2_journal_clear_err(journal_t *journal)
@@ -1923,7 +1923,7 @@ int jbd2_journal_clear_err(journal_t *journal)
  * void jbd2_journal_ack_err() - Ack journal err.
  * @journal: journal to act on.
  *
- * An error must be cleared or Acked to take a FS out of readonly
+ * An error must be cleared or acked to take a FS out of readonly
  * mode.
  */
 void jbd2_journal_ack_err(journal_t *journal)
-- 
1.6.2.2.646.gb214

