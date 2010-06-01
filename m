From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 16/40] ext4: Issue the discard operation *before* releasing the blocks to be reused
Date: Tue,  1 Jun 2010 08:03:03 -0400
Message-ID: <1275393807-14369-16-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47388 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab0FAMDt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:49 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit b90f687018e6d6c77d981b09203780f7001407e5 upstream (as of v2.6.34-rc6)

Otherwise, we can end up having data corruption because the blocks
could get reused and then discarded!

https://bugzilla.kernel.org/show_bug.cgi?id=15579

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 301b173..2e98130 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2537,6 +2537,17 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
 			 entry->count, entry->group, entry);
 
+		if (test_opt(sb, DISCARD)) {
+			ext4_fsblk_t discard_block;
+
+			discard_block = entry->start_blk +
+				ext4_group_first_block_no(sb, entry->group);
+			trace_ext4_discard_blocks(sb,
+					(unsigned long long)discard_block,
+					entry->count);
+			sb_issue_discard(sb, discard_block, entry->count);
+		}
+
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
 		/* we expect to find existing buddy because it's pinned */
 		BUG_ON(err != 0);
@@ -2558,19 +2569,6 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			page_cache_release(e4b.bd_bitmap_page);
 		}
 		ext4_unlock_group(sb, entry->group);
-		if (test_opt(sb, DISCARD)) {
-			ext4_fsblk_t discard_block;
-			struct ext4_super_block *es = EXT4_SB(sb)->s_es;
