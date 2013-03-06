From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 1/5] ext4: improve ext4_es_can_be_merged() to avoid a potential overflow
Date: Wed,  6 Mar 2013 22:17:11 +0800
Message-ID: <1362579435-6333-2-git-send-email-wenqing.lz@taobao.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60226 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3CFOCP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Mar 2013 09:02:15 -0500
Received: by mail-pb0-f48.google.com with SMTP id wy12so6004437pbc.7
        for <linux-ext4@vger.kernel.org>; Wed, 06 Mar 2013 06:02:15 -0800 (PST)
In-Reply-To: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
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
index 95796a1..dc4e4c5 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -333,17 +333,33 @@ static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
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

