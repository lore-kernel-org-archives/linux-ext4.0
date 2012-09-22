From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 20/21 v5] tests: change result in f_bad_disconnected_inode
Date: Sat, 22 Sep 2012 12:01:08 +0800
Message-ID: <1348286469-31690-21-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2IVDvg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873803pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:36 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In this test, inode flag is some random data, and when we apply inline data
patch set we should need to handle it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 tests/f_bad_disconnected_inode/expect.1 |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

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
1.7.4.1

