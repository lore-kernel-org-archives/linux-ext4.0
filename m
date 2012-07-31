From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 35/36 v4] tests: change test f_bad_disconnected_inode to support inline_data feature
Date: Tue, 31 Jul 2012 19:48:28 +0800
Message-ID: <1343735309-30579-36-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54597 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2GaLkv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:51 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so5889814ghr.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:51 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
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
