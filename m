From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/4] ext4: Use return value from sb_issue_discard()
Date: Mon, 27 Sep 2010 16:09:57 +0200
Message-ID: <1285596600-28358-2-git-send-email-lczerner@redhat.com>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0I0OKN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 10:10:13 -0400
In-Reply-To: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use return value from sb_issue_discard() as return value in
ext4_issue_discard(). Since sb_issue_discard() may result in more
serious errors than just -EOPNOTSUPP it is worth to inform user of this
function about them to handle error cases properly.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 66c3535..93eb6c2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2603,7 +2603,7 @@ int ext4_mb_release(struct super_block *sb)
 	return 0;
 }
 
-static inline void ext4_issue_discard(struct super_block *sb,
+static inline int ext4_issue_discard(struct super_block *sb,
 		ext4_group_t block_group, ext4_grpblk_t block, int count)
 {
 	int ret;
@@ -2617,6 +2617,7 @@ static inline void ext4_issue_discard(struct super_block *sb,
 		ext4_warning(sb, "discard not supported, disabling");
 		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
 	}
+	return ret;
 }
 
 /*
-- 
1.7.2.3

