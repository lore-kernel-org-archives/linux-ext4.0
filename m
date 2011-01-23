From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 3/3] : Update ocfs2 for the changed jbd2 transaction
 allocation routines
Date: Sat, 22 Jan 2011 19:36:38 -0800
Message-ID: <AANLkTi=xq=LF4EYoqb1o9=yVYnGD4i0t6qR6KnwduOOM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mkatiyar@gmail.com
To: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40896 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1AWDg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jan 2011 22:36:59 -0500
Received: by qwa26 with SMTP id 26so2978154qwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 22 Jan 2011 19:36:58 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Update ocfs2 to use the updated transaction allocation routine. They
still pass the old flag.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ocfs2/journal.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index faa2303..6435a58 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -356,11 +356,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super
*osb, int max_buffs)

 	/* Nested transaction? Just return the handle... */
 	if (journal_current_handle())
-		return jbd2_journal_start(journal, max_buffs);
+		return jbd2_journal_start(journal, max_buffs, false);

 	down_read(&osb->journal->j_trans_barrier);

-	handle = jbd2_journal_start(journal, max_buffs);
+	handle = jbd2_journal_start(journal, max_buffs, false);
 	if (IS_ERR(handle)) {
 		up_read(&osb->journal->j_trans_barrier);

@@ -444,7 +444,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 		     "jbd2_journal_extend failed, trying "
 		     "jbd2_journal_restart\n");
 		status = jbd2_journal_restart(handle,
-					      old_nblocks + nblocks);
+					      old_nblocks + nblocks, false);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
-- 
1.6.0.4


-- 
Thanks -
Manish
==================================
[$\*.^ -- I miss being one of them
==================================
