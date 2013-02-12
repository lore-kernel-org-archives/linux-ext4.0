From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH linux-next] jbd: start_this_handle(): remove kfree() redundant null check
Date: Tue, 12 Feb 2013 11:23:24 -0700
Message-ID: <1360693404-61617-1-git-send-email-tim.gardner@canonical.com>
Cc: Tim Gardner <tim.gardner@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

smatch analysis:

fs/jbd/transaction.c:236 start_this_handle() info: redundant null
 check on new_transaction calling kfree()

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/jbd/transaction.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 071d690..ee40b4e 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -232,8 +232,7 @@ repeat_locked:
 
 	lock_map_acquire(&handle->h_lockdep_map);
 out:
-	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
+	kfree(new_transaction);
 	return ret;
 }
 
-- 
1.7.9.5
