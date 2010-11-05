From: Joe Perches <joe@perches.com>
Subject: [PATCH 37/49] fs/ext4: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:01 -0700
Message-ID: <960a7efc569f61a50346257835ce5f457a0d4c99.1288925425.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4167 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0KEDJE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:04 -0400
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/super.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 40131b7..9ed90f4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1909,9 +1909,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	size = flex_group_count * sizeof(struct flex_groups);
 	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-		sbi->s_flex_groups = vmalloc(size);
-		if (sbi->s_flex_groups)
-			memset(sbi->s_flex_groups, 0, size);
+		sbi->s_flex_groups = vzalloc(size);
 	}
 	if (sbi->s_flex_groups == NULL) {
 		ext4_msg(sb, KERN_ERR, "not enough memory for "
-- 
1.7.3.1.g432b3.dirty

