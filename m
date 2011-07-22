From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/3] ext4: correct the debug message in ext4_ext_insert_extent
Date: Fri, 22 Jul 2011 10:23:40 +0800
Message-ID: <1311301421-10533-2-git-send-email-hao.bigrat@gmail.com>
References: <1311301421-10533-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1GVCXv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2011 22:23:51 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so2818129pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 19:23:51 -0700 (PDT)
In-Reply-To: <1311301421-10533-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The debug message in ext4_ext_insert_extent before moving extent
is incorrect (the "from xx to xx").

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3966839..a4d6216 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1839,7 +1839,7 @@ has_space:
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_len(newext),
-				nearex, len, nearex + 1, nearex + 2);
+				nearex, len, nearex, nearex + 1);
 		memmove(nearex + 1, nearex, len);
 		path[depth].p_ext = nearex;
 	}
-- 
1.7.4.1

