From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/18] ext4: Fix race in transient ENOSPC detection
Date: Mon, 18 Apr 2016 23:35:25 +0200
Message-ID: <1461015341-20153-3-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org,
	Matthew Wilcox <willy@linux.intel.com>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

When there are blocks to free in the running transaction, block
allocator can return ENOSPC although the filesystem has some blocks to
free. We use ext4_should_retry_alloc() to force commit of the current
transaction and return whether anything was committed so that it makes
sense to retry the allocation. However the transaction may get committed
after block allocation fails but before we call
ext4_should_retry_alloc(). So ext4_should_retry_alloc() returns false
because there is nothing to commit and we wrongly return ENOSPC.

Fix the race by unconditionally returning 1 from ext4_should_retry_alloc()
when we tried to commit a transaction. This should not add any
unnecessary retries since we had a transaction running a while ago when
trying to allocate blocks and we want to retry the allocation once that
transaction has committed anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/balloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index fe1f50fe764f..3020fd70c392 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -610,7 +610,8 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
 
-	return jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal);
+	jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal);
+	return 1;
 }
 
 /*
-- 
2.6.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
