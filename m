Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:17129 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727015AbfAJGIb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 01:08:31 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <miaoxie@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] jbd2: set freed flag while revoking a buffer which belongs to older transaction
Date: Thu, 10 Jan 2019 14:12:02 +0800
Message-ID: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now, we capture a data corruption problem on ext4 while we're truncating
an extent index block. Imaging that if we are revoking a buffer which
has been journaled by the committing transaction, the buffer's jbddirty
flag will not be cleared in jbd2_journal_forget(), so the commit code
will set the buffer dirty flag again after refile the buffer.

fsx                               kjournald2
                                  jbd2_journal_commit_transaction
jbd2_journal_revoke                commit phase 1~5...
 jbd2_journal_forget
   belongs to older transaction    commit phase 6
   jbddirty not clear               __jbd2_journal_refile_buffer
                                     __jbd2_journal_unfile_buffer
                                      test_clear_buffer_jbddirty
                                       mark_buffer_dirty

Finally, if the freed extent index block was allocated again as data
block by some other files, it may corrupt the file data when writing
cached pages later, such as during umount time.

This patch mark buffer as freed when it already belongs to the
committing transaction in jbd2_journal_forget(), so that commit code
knows it should clear dirty bits when it is done with the buffer.

This problem can be reproduced by xfstests generic/455 easily with
seeds (3246 3247 3248 3249).

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Cc: stable@vger.kernel.org
---
 fs/jbd2/transaction.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 4b51177..fcb65f2 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1592,6 +1592,12 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 			if (was_modified)
 				drop_reserve = 1;
 		}
+
+		/*
+		 * Mark buffer as freed so that commit code know it should
+		 * clear dirty bits when it is done with the buffer.
+		 */
+		set_buffer_freed(bh);
 	}
 
 not_jbd:
-- 
2.7.4
