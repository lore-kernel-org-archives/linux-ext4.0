From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/6] ext4: improve ext4_es_can_be_merged() to avoid a potential overflow
Date: Fri,  1 Mar 2013 02:26:40 +0800
Message-ID: <1362076004-10087-3-git-send-email-wenqing.lz@taobao.com>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40328 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3B1SLw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 13:11:52 -0500
Received: by mail-pa0-f51.google.com with SMTP id hz1so1285967pad.10
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 10:11:52 -0800 (PST)
In-Reply-To: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to improve ext4_es_can_be_merged.  We check the length
of extent to avoid a potential overflow.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents_status.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index f768f4a..a769485 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -329,17 +329,33 @@ static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 static int ext4_es_can_be_merged(struct extent_status *es1,
 				 struct extent_status *es2)
 {
-	if (es1->es_lblk + es1->es_len != es2->es_lblk)
+	__u64 es1_len, es2_len, max_len;
+
+	if (ext4_es_status(es1) ^ ext4_es_status(es2))
 		return 0;
 
-	if (ext4_es_status(es1) != ext4_es_status(es2))
+	max_len = 0xFFFFFFFFULL;
+	es1_len = es1->es_len;
+	es2_len = es2->es_len;
+
+	if (es1_len + es2_len > max_len)
 		return 0;
 
-	if ((ext4_es_is_written(es1) || ext4_es_is_unwritten(es1)) &&
-	    (ext4_es_pblock(es1) + es1->es_len != ext4_es_pblock(es2)))
+	if (es1->es_lblk + es1_len != es2->es_lblk)
 		return 0;
 
-	return 1;
+	if ((ext4_es_is_written(es1) || ext4_es_is_unwritten(es1)) &&
+	    (ext4_es_pblock(es1) + es1_len == ext4_es_pblock(es2)))
+		return 1;
+
+	if (ext4_es_is_hole(es1))
+		return 1;
+
+	/* we need to check delayed extent is without unwritten status */
+	if (ext4_es_is_delayed(es1) && !ext4_es_is_unwritten(es1))
+		return 1;
+
+	return 0;
 }
 
 static struct extent_status *
-- 
1.7.12.rc2.18.g61b472e

