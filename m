From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: stop issuing discards if not supported by device
Date: Wed, 10 Mar 2010 10:54:03 -0600
Message-ID: <4B97CEAB.1040004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab0CJQyL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Mar 2010 11:54:11 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2AGs9jZ009362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 11:54:10 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2AGs3Se006955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 11:54:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Turn off issuance of discard requests if the device does
not support it - similar to the action we take for barriers.
This will save a little computation time if a non-discardable
device is mounted with -o discard, and also makes it obvious
that it's not doing what was asked at mount time ...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 506713a..6ee4cac 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2556,6 +2556,7 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		}
 		ext4_unlock_group(sb, entry->group);
 		if (test_opt(sb, DISCARD)) {
+			int ret;
 			ext4_fsblk_t discard_block;
 
 			discard_block = entry->start_blk +
@@ -2563,7 +2564,12 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			trace_ext4_discard_blocks(sb,
 					(unsigned long long)discard_block,
 					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
+			ret = sb_issue_discard(sb, discard_block, entry->count);
+			if (ret == EOPNOTSUPP) {
+				ext4_warning(sb,
+					"discard not supported, disabling");
+				clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
+			}
 		}
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);

