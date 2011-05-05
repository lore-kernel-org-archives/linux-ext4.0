From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Fix forever sleeping process in do_get_write_access()
Date: Thu,  5 May 2011 16:08:37 +0200
Message-ID: <1304604517-8759-1-git-send-email-jack@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52230 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab1EEOIn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 10:08:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In do_get_write_access() we wait on BH_Unshadow bit for buffer to get
from shadow state. The waking code in journal_commit_transaction() has
a bug because it does not issue a memory barrier after the buffer is moved
from the shadow state and before wake_up_bit() is called. Thus a waitqueue
check can happen before the buffer is actually moved from the shadow state
and waiting process may never be woken. Fix the problem by issuing proper
barrier.

Reported-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

  This patch is in my tree to be submitted during the next merge window.

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 69b1804..f486ff6 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -722,8 +722,13 @@ wait_for_iobuf:
                    required. */
 		JBUFFER_TRACE(jh, "file as BJ_Forget");
 		journal_file_buffer(jh, commit_transaction, BJ_Forget);
-		/* Wake up any transactions which were waiting for this
-		   IO to complete */
+		/*
+		 * Wake up any transactions which were waiting for this
+		 * IO to complete. The barrier must be here so that changes
+		 * by journal_file_buffer() take effect before wake_up_bit()
+		 * does the waitqueue check.
+		 */
+		smp_mb();
 		wake_up_bit(&bh->b_state, BH_Unshadow);
 		JBUFFER_TRACE(jh, "brelse shadowed buffer");
 		__brelse(bh);
-- 
1.7.1

