From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 4/4] ext4: fix a wrong comment in __mb_check_buddy
Date: Thu, 15 Sep 2011 15:09:40 +0800
Message-ID: <1316070580-10723-4-git-send-email-hao.bigrat@gmail.com>
References: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32913 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IOHKK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 03:10:10 -0400
Received: by mail-pz0-f46.google.com with SMTP id 32so2239825pzk.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 00:10:10 -0700 (PDT)
In-Reply-To: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The comment says the bit should be 0, but the after code assert the bit to be 1.
This makes people confused, so fix it.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 99d123a..0b3d0ee 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -580,7 +580,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				continue;
 			}
 
-			/* both bits in buddy2 must be 0 */
+			/* both bits in buddy2 must be 1 */
 			MB_CHECK_ASSERT(mb_test_bit(i << 1, buddy2));
 			MB_CHECK_ASSERT(mb_test_bit((i << 1) + 1, buddy2));
 
-- 
1.7.4.1

