From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 27/30] tests: change result in f_bad_disconnected_inode
Date: Fri,  6 Dec 2013 17:58:14 +0800
Message-ID: <1386323897-2354-28-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62517 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3LFJ43 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:29 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so799823pbb.0
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:28 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
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

