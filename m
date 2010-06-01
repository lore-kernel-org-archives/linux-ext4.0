From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 09/28] ext4: stop issuing discards if not supported by device
Date: Tue,  1 Jun 2010 12:12:56 -0400
Message-ID: <1275408795-17487-9-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56889 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab0FAQNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:22 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

commit a30eec2a8650a77f754e84b2e15f062fe652baa7 upstream (as of v2.6.34-git13)

Turn off issuance of discard requests if the device does
not support it - similar to the action we take for barriers.
This will save a little computation time if a non-discardable
device is mounted with -o discard, and also makes it obvious
that it's not doing what was asked at mount time ...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8639d5a..9c6a40d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2534,6 +2534,7 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			 entry->count, entry->group, entry);
 
 		if (test_opt(sb, DISCARD)) {
+			int ret;
 			ext4_fsblk_t discard_block;
 
 			discard_block = entry->start_blk +
@@ -2541,7 +2542,12 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			trace_ext4_discard_blocks(sb,
 					(unsigned long long)discard_block,
 					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
+			ret = sb_issue_discard(sb, discard_block, entry->count);
+			if (ret == EOPNOTSUPP) {
+				ext4_warning(sb, __func__,
+					"discard not supported, disabling");
+				clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
+			}
 		}
 
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
-- 
1.6.6.1.1.g974db.dirty

