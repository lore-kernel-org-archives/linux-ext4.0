From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Fix lock ordering bug in journal_unmap_buffer()
Date: Fri, 23 Nov 2012 18:20:21 +0100
Message-ID: <1353691221-4176-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab2KWRU1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Nov 2012 12:20:27 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 59D56A3DDD
	for <linux-ext4@vger.kernel.org>; Fri, 23 Nov 2012 18:20:26 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 09e05d48 introduced a wait for transaction commit into
journal_unmap_buffer() in the case we are truncating a buffer undergoing commit
in the page stradding i_size on a filesystem with blocksize < pagesize. Sadly
we forgot to drop buffer lock before waiting for transaction commit and thus
deadlock is possible when kjournald wants to lock the buffer.

Fix the problem by dropping the buffer lock before waiting for transaction
commit. Since we are still holding page lock (and that is OK), buffer cannot
disappear under us.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

I want to push this fix to Linus soon. JBD2 needs the fix as well but there
it affects only data=journal mode and the fix is more complex due to different
lock ordering.

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 78b7f84..7f5120b 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1961,7 +1961,9 @@ retry:
 			spin_unlock(&journal->j_list_lock);
 			jbd_unlock_bh_state(bh);
 			spin_unlock(&journal->j_state_lock);
+			unlock_buffer(bh);
 			log_wait_commit(journal, tid);
+			lock_buffer(bh);
 			goto retry;
 		}
 		/*
-- 
1.7.1

