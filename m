From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] jbd2: preserve original nofs flag during journal restart
Date: Wed, 17 May 2017 05:33:01 -0700
Message-ID: <20170517123301.24211-1-tahsin@google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tahsin Erdogan <tahsin@google.com>
To: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36432 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753892AbdEQMdg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 May 2017 08:33:36 -0400
Received: by mail-pf0-f174.google.com with SMTP id m17so6793525pfg.3
        for <linux-ext4@vger.kernel.org>; Wed, 17 May 2017 05:33:36 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a transaction starts, start_this_handle() saves current
PF_MEMALLOC_NOFS value so that it can be restored at journal stop time.
Journal restart is a special case that calls start_this_handle() without
stopping the transaction. start_this_handle() isn't aware that the
original value is already stored so it overwrites it with current value.

For instance, a call sequence like below leaves PF_MEMALLOC_NOFS flag set
at the end:

  jbd2_journal_start()
  jbd2__journal_restart()
  jbd2_journal_stop()

Make jbd2__journal_restart() restore the original value before calling
start_this_handle().

Fixes: 81378da64de6 ("jbd2: mark the transaction context with the scope GFP_NOFS context")
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/jbd2/transaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 9ee4832b6f8b..dfd6afebdfeb 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -680,6 +680,7 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 
 	rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
 	handle->h_buffer_credits = nblocks;
+	memalloc_nofs_restore(handle->saved_alloc_context);
 	ret = start_this_handle(journal, handle, gfp_mask);
 	return ret;
 }
-- 
2.13.0.303.g4ebf302169-goog
