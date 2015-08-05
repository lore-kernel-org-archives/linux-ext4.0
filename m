From: mhocko@kernel.org
Subject: [RFC 6/8] ext3: Do not abort journal prematurely
Date: Wed,  5 Aug 2015 11:51:22 +0200
Message-ID: <1438768284-30927-7-git-send-email-mhocko@kernel.org>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
Cc: <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Michal Hocko <mhocko@suse.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

journal_get_undo_access is relying on GFP_NOFS allocation yet it is
essential for the journal transaction:

[   83.256914] journal_get_undo_access: No memory for committed data
[   83.258022] EXT3-fs: ext3_free_blocks_sb: aborting transaction: Out
of memory in __ext3_journal_get_undo_access
[   83.259785] EXT3-fs (hdb1): error in ext3_free_blocks_sb: Out of
memory
[   83.267130] Aborting journal on device hdb1.
[   83.292308] EXT3-fs (hdb1): error: ext3_journal_start_sb: Detected
aborted journal
[   83.293630] EXT3-fs (hdb1): error: remounting filesystem read-only

Since "mm: page_alloc: do not lock up GFP_NOFS allocations upon OOM"
these allocation requests are allowed to fail so we need to use
__GFP_NOFAIL to imitate the previous behavior.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/jbd/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index bf7474deda2f..6c60376a29bc 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -887,7 +887,7 @@ int journal_get_undo_access(handle_t *handle, struct buffer_head *bh)
 
 repeat:
 	if (!jh->b_committed_data) {
-		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
+		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS | __GFP_NOFAIL);
 		if (!committed_data) {
 			printk(KERN_ERR "%s: No memory for committed data\n",
 				__func__);
-- 
2.5.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
