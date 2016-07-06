From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH RESEND] e2fsck: update j_tail_sequence after recovery
Date: Wed, 06 Jul 2016 09:10:39 +0900
Message-ID: <1467763839-10311-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>,
	Youngjin Gil <youngjin.gil@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:39950 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbcGFAIM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jul 2016 20:08:12 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O9V003DF9PMGS50@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 06 Jul 2016 09:08:10 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When journal is released, s_sequence is set to j_tail_sequence.
But, currently, even if the recovery process is successfully completed,
the j_tail_sequence and, finally, s_sequence are never changed. By this,
when we repeat doing power-off the device suddenly and executing e2fsck
without full scan before mount, the s_sequence number will never change
and, in a very rare case, newly generated journal logs will be
surprisingly grafted to the old journal logs. In this case, out-of-date
metadata log can be replayed on the filesystem area and the filesystem
can be crashed unintentionally by journal recovery process. Therefore,
we need to update j_tail_sequence after recovery process is successfully
completed in e2fsck.

Youngjin had repeated this test and found the problem. With our test,
the filesystem crash occurred within 4 hours.

Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
---
 e2fsck/journal.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index c8ac57d..83256d8 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -948,6 +948,8 @@ static errcode_t recover_ext3_journal(e2fsck_t ctx)
 		mark_buffer_dirty(journal->j_sb_buffer);
 	}
 
+	journal->j_tail_sequence = journal->j_transaction_sequence;
+
 errout:
 	journal_destroy_revoke(journal);
 	journal_destroy_revoke_caches();
-- 
1.7.9.5

