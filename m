From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] Use negative error code
Date: Fri, 10 Sep 2010 20:51:30 +0200
Message-ID: <1284144691-15576-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, tytso@mit.edu, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0IJSvh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Sep 2010 14:51:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sb_issue_discard() is returning negative error code, so check for
-EOPNOTSUPP.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4b4ad4b..ec2793a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2567,7 +2567,7 @@ static inline void ext4_issue_discard(struct super_block *sb,
 	trace_ext4_discard_blocks(sb,
 			(unsigned long long) discard_block, count);
 	ret = sb_issue_discard(sb, discard_block, count);
-	if (ret == EOPNOTSUPP) {
+	if (ret == -EOPNOTSUPP) {
 		ext4_warning(sb, "discard not supported, disabling");
 		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
 	}
-- 
1.7.2.2

