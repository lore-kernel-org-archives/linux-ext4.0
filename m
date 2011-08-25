From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/2] ext4: fix a typo in struct ext4_allocation_context
Date: Thu, 25 Aug 2011 19:36:32 +0800
Message-ID: <1314272192-7414-2-git-send-email-hao.bigrat@gmail.com>
References: <1314272192-7414-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48663 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1HYLgs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 07:36:48 -0400
Received: by gxk21 with SMTP id 21so1658175gxk.19
        for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 04:36:47 -0700 (PDT)
In-Reply-To: <1314272192-7414-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

This patch change "bext" to "best".

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 9d4a636..86a880b 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -175,7 +175,7 @@ struct ext4_allocation_context {
 	/* the best found extent */
 	struct ext4_free_extent ac_b_ex;
 
-	/* copy of the bext found extent taken before preallocation efforts */
+	/* copy of the best found extent taken before preallocation efforts */
 	struct ext4_free_extent ac_f_ex;
 
 	/* number of iterations done. we have to track to limit searching */
-- 
1.7.4.1

