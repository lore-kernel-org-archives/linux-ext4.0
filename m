From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] jbd2: Simplify error path on allocation failure in do_get_write_access()
Date: Thu,  2 Apr 2015 15:58:17 +0200
Message-ID: <1427983100-29889-3-git-send-email-jack@suse.cz>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbbDBN61 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 09:58:27 -0400
In-Reply-To: <1427983100-29889-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We were acquiring bh_state_lock when allocation of buffer failed in
do_get_write_access() only to be able to jump to a label that releases
the lock and does all other checks that don't make sense for this error
path. Just jump into the right label instead.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 2b75f0f109be..1995ea539e96 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -956,8 +956,7 @@ repeat:
 					       __func__);
 					JBUFFER_TRACE(jh, "oom!");
 					error = -ENOMEM;
-					jbd_lock_bh_state(bh);
-					goto done;
+					goto out;
 				}
 				goto repeat;
 			}
-- 
2.1.4

