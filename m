From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: fix undefined bit shift result in ext4_fill_flex_info
Date: Wed,  3 Oct 2012 09:11:47 +0200
Message-ID: <1349248307-31225-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab2JCHLz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Oct 2012 03:11:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The result of the bit shift expression in
'1 << sbi->s_log_groups_per_flex' can be undefined in the case that
s_log_groups_per_flex is 31 because the result of the shift is bigger
than INT_MAX. In reality this probably should not cause much problems
since we'll end up with INT_MIN which will then be converted into
'unsigned int' type, but nevertheless according to the ISO C99 the
result is actually undefined.

Fix this by changing the left operand to 'unsigned int' type.

Note that the commit d50f2ab6f050311dbf7b8f5501b25f0bf64a439b already
tried to fix the undefined behaviour, but this was missed.

Thanks to Laszlo Ersek for pointing this out and suggesting the fix.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Laszlo Ersek <lersek@redhat.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 69c55d4..95b9c8e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1929,7 +1929,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 		sbi->s_log_groups_per_flex = 0;
 		return 1;
 	}
-	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
+	groups_per_flex = 1U << sbi->s_log_groups_per_flex;
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-- 
1.7.7.6

