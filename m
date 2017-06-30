From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 2/2] ext4, project: fix typo comments for quota credits reservation
Date: Fri, 30 Jun 2017 11:52:53 +0800
Message-ID: <20170630035253.63358-1-wshilong@ddn.com>
Cc: tytso@mit.edu, lixi@ddn.com, adilger@dilger.ca, wshilong@ddn.com,
        sihara@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36240 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbdF3DxN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jun 2017 23:53:13 -0400
Received: by mail-pf0-f193.google.com with SMTP id z6so15445711pfk.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Jun 2017 20:53:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/ext4_jbd2.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f976111..6dd20c8 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -43,10 +43,10 @@
 #define EXT4_XATTR_TRANS_BLOCKS		6U
 
 /* Define the minimum size for a transaction which modifies data.  This
- * needs to take into account the fact that we may end up modifying two
- * quota files too (one for the group, one for the user quota).  The
- * superblock only gets updated once, of course, so don't bother
- * counting that again for the quota updates. */
+ * needs to take into account the fact that we may end up modifying three
+ * quota files too (one for the group, one for the user quota, one for the
+ * project).  The superblock only gets updated once, of course, so don't
+ * bother counting that again for the quota updates. */
 
 #define EXT4_DATA_TRANS_BLOCKS(sb)	(EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + \
 					 EXT4_XATTR_TRANS_BLOCKS - 2 + \
-- 
2.9.3
