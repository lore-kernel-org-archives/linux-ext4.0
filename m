From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 35/35 v3] tests: change test f_bad_disconnected_inode to support inline_data feature
Date: Sun,  1 Jul 2012 21:48:58 +0800
Message-ID: <1341150538-32047-36-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2GANly (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:54 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469913pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:54 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In this test, inode flag is some random data, and when we apply inline data
patch set we should need to handle it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 tests/f_bad_disconnected_inode/expect.1 |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index 11862f6..9b7f7d8 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -2,7 +2,16 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 1 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
-Inode 15 has EXTENTS_FL flag set on filesystem without extents support.
+Inode 11 has INLINE_DATA_FL flag set on filesystem without inline data support.
+Clear? yes
+
+Inode 13 has INLINE_DATA_FL flag set on filesystem without inline data support.
+Clear? yes
+
+Inode 14 has INLINE_DATA_FL flag set on filesystem without inline data support.
+Clear? yes
+
+Inode 15 has INLINE_DATA_FL flag set on filesystem without inline data support.
 Clear? yes
 
 Inode 16 has EXTENTS_FL flag set on filesystem without extents support.
@@ -15,18 +24,6 @@ Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Inode 2 ref count is 4, should be 3.  Fix? yes
 
-i_file_acl for inode 13 (...) is 4218798225, should be zero.
-Clear? yes
-
-Inode 13 (...) has invalid mode (0117003).
-Clear? yes
-
-i_file_acl for inode 14 (...) is 2892851642, should be zero.
-Clear? yes
-
-Inode 14 (...) has invalid mode (0154247).
-Clear? yes
