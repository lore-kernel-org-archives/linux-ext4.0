From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Fix minor typos in jbd2's journal.c
Date: Thu, 21 May 2009 10:39:47 -0300
Message-ID: <1242913187-4151-1-git-send-email-albertito@blitiri.com.ar>
References: <alpine.LNX.2.00.0905211043100.13917@wotan.suse.de>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	tytso@mit.edu, jack@suse.cz, trivial@kernel.org,
	Alberto Bertogli <albertito@blitiri.com.ar>
To: jkosina@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2779 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZEUNny (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 May 2009 09:43:54 -0400
In-Reply-To: <alpine.LNX.2.00.0905211043100.13917@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---

On Thu, May 21, 2009 at 10:44:03AM +0200, Jiri Kosina wrote:
> > - * Two internal function, which provide abort to te jbd layer
> > + * Two internal function, which provide abort to the jbd layer
> 
> function*s*, while you are at it?

Fixed, thanks!
		Alberto


 fs/jbd2/journal.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5814410..371a17e 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1781,7 +1781,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
  * Journal abort has very specific semantics, which we describe
  * for journal abort.
  *
- * Two internal function, which provide abort to te jbd layer
+ * Two internal functions which provide abort to the jbd layer
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

