From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 20/22] tests: change result in f_bad_disconnected_inode
Date: Fri,  2 Aug 2013 17:49:47 +0800
Message-ID: <1375436989-18948-21-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33726 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346Ab3HBJvi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:51:38 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so500394pbb.13
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:51:38 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In this test, inode flag is some random data, and after we apply inline
data patch set we should need to handle it.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 tests/f_bad_disconnected_inode/expect.1 |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index 11862f6..9f9b447 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -2,9 +2,18 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 1 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
+Inode 14 has INLINE_DATA_FL flag on filesystem without inline data support.
+Clear? yes
+
+Inode 15 has INLINE_DATA_FL flag on filesystem without inline data support.
+Clear? yes
+
 Inode 15 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
+Inode 16 has INLINE_DATA_FL flag on filesystem without inline data support.
+Clear? yes
+
 Inode 16 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
-- 
1.7.9.7

