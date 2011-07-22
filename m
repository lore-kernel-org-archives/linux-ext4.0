From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 3/3] ext4: correct comment for ext4_ext_check_cache
Date: Fri, 22 Jul 2011 10:23:41 +0800
Message-ID: <1311301421-10533-3-git-send-email-hao.bigrat@gmail.com>
References: <1311301421-10533-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1GVCXx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2011 22:23:53 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so2818129pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 19:23:53 -0700 (PDT)
In-Reply-To: <1311301421-10533-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The comment for ext4_ext_check_cache has a litte mistake.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a4d6216..cb8285d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2052,7 +2052,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 }
 
 /*
- * ext4_ext_in_cache()
+ * ext4_ext_check_cache()
  * Checks to see if the given block is in the cache.
  * If it is, the cached extent is stored in the given
  * cache extent pointer.  If the cached extent is a hole,
-- 
1.7.4.1

