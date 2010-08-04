From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/4] Ext4 check for negative err from sb_issue_discard
Date: Wed,  4 Aug 2010 17:30:13 +0200
Message-ID: <1280935813-4478-4-git-send-email-lczerner@redhat.com>
References: <1280935813-4478-1-git-send-email-lczerner@redhat.com>
Cc: jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab0HDPa2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 11:30:28 -0400
In-Reply-To: <1280935813-4478-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sb_issue_discard is returning negative error code, so check for
negative value instead of positive.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a16a813..a8fe7f1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2589,7 +2589,7 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 					(unsigned long long)discard_block,
 					entry->count);
 			ret = sb_issue_discard(sb, discard_block, entry->count);
-			if (ret == EOPNOTSUPP) {
+			if (ret == -EOPNOTSUPP) {
 				ext4_warning(sb,
 					"discard not supported, disabling");
 				clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
-- 
1.7.2

