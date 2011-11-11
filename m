From: Niu <niu@whamcloud.com>
Subject: [PATCH] libquota: fix get_dq()
Date: Fri, 11 Nov 2011 13:22:34 +0800
Message-ID: <4EBCB11A.8000203@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: adityakali@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65086 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1KKFWt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Nov 2011 00:22:49 -0500
Received: by iage36 with SMTP id e36so3766359iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 21:22:48 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Aditya

This one more fix based on your new quota patches.

>From f3f4de997890a0c50d7c8143d9046dcab93cda5d Mon Sep 17 00:00:00 2001
From: Niu Yawei <niu@whamcloud.com>
Date: Fri, 11 Nov 2011 01:11:59 +0800
Subject: [PATCH] libquota: fix get_dq()

The dq_id should be set on newly created dqout.

Signed-off-by: Niu Yawei <niu@whamcloud.com>
---
 lib/quota/mkquota.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 832b135..ac7288c 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -292,6 +292,7 @@ static struct dquot *get_dq(dict_t *dict, __u32 key)
 		}
 		memset(dq, 0, sizeof(struct dquot));
 		dict_alloc_insert(dict, UINT_TO_VOIDPTR(key), dq);
+		dq->dq_id = key;
 	}
 	return dq;
 }
-- 
1.7.1



