From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] Don't hold spinlock while calling ext4_issue_discard()
Date: Fri, 10 Sep 2010 20:51:31 +0200
Message-ID: <1284144691-15576-2-git-send-email-lczerner@redhat.com>
References: <1284144691-15576-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, tytso@mit.edu, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab0IJSvj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Sep 2010 14:51:39 -0400
In-Reply-To: <1284144691-15576-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can't hold spinlock because we can get rescheduled.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ec2793a..c214cfc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4640,12 +4640,12 @@ do_more:
 		 * with group lock held. generate_buddy look at
 		 * them with group lock_held
 		 */
+		if (test_opt(sb, DISCARD))
+			ext4_issue_discard(sb, block_group, bit, count);
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
-		if (test_opt(sb, DISCARD))
-			ext4_issue_discard(sb, block_group, bit, count);
 	}
 
 	ret = ext4_free_blks_count(sb, gdp) + count;
-- 
1.7.2.2

