From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: remove redundant 'extern' keyword for function-definition
Date: Fri,  6 May 2011 16:19:27 +0800
Message-ID: <1304669967-5677-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54943 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1EFITk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2011 04:19:40 -0400
Received: by pwi15 with SMTP id 15so1333722pwi.19
        for <linux-ext4@vger.kernel.org>; Fri, 06 May 2011 01:19:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/ialloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..ace7aef 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1235,7 +1235,7 @@ unsigned long ext4_count_dirs(struct super_block * sb)
  * inode allocation from the current group, so we take alloc_sem lock, to
  * block ext4_claim_inode until we are finished.
  */
-extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
+int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 				 int barrier)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
-- 
1.7.1

