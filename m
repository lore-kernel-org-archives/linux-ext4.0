From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: re-enable -o discard functionality in no-journal mode
Date: Tue, 18 Sep 2012 13:28:56 -0400
Message-ID: <1347989336-29238-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Anatol Pomozov <anatol.pomozov@gmail.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51333 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab2IRR3F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 13:29:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a revert of commit b56ff9d397ce, which removed the call to
ext4_issue_discard() to fix a BUG reported because
ext4_issue_discard() was being called from inside a block group
spinlock.  As it turns out this bug had already been fixed by Lukas
Czerner in commit 53fdcf992d61 by the simple expedient of moving when
we call ext4_issue_discard() outside the spinlock.

So it should be safe to re-enable this functionality, which I tested
by putting an BUG_ON(in_atomic) just after the restored callsite to
ext4_issue_discard.

Addresses-Google-Bug: #6750518

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 fs/ext4/mballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2102c20..2c7c082 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4656,6 +4656,8 @@ do_more:
 		 * with group lock held. generate_buddy look at
 		 * them with group lock_held
 		 */
+		if (test_opt(sb, DISCARD))
+			ext4_issue_discard(sb, block_group, bit, count);
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
 		mb_free_blocks(inode, &e4b, bit, count_clusters);
-- 
1.7.12.rc0.22.gcdd159b

