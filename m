From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 3/9 v1] ext4: add physical block and status member into extent status tree
Date: Mon, 24 Dec 2012 15:55:36 +0800
Message-ID: <1356335742-11793-4-git-send-email-wenqing.lz@taobao.com>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:55562 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2LXHt3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 02:49:29 -0500
Received: by mail-da0-f43.google.com with SMTP id u36so3056964dak.16
        for <linux-ext4@vger.kernel.org>; Sun, 23 Dec 2012 23:49:28 -0800 (PST)
In-Reply-To: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

es_pblk is used to record physical block that maps to the disk.  es_status is
used to record the status of the extent.  Three status are defined, which are
written, unwritten and delayed.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents_status.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 81e9339..85115bb 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -20,10 +20,18 @@
 #define es_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
+enum {
+	EXTENT_STATUS_WRITTEN = 0,	/* written extent */
+	EXTENT_STATUS_UNWRITTEN = 1,	/* unwritten extent */
+	EXTENT_STATUS_DELAYED = 2,	/* delayed extent */
+};
+
 struct extent_status {
 	struct rb_node rb_node;
 	ext4_lblk_t es_lblk;	/* first logical block extent covers */
 	ext4_lblk_t es_len;	/* length of extent in block */
+	ext4_fsblk_t es_pblk;	/* first physical block */
+	int es_status;		/* record the status of extent */
 };
 
 struct ext4_es_tree {
-- 
1.7.12.rc2.18.g61b472e

