From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/4] xfstests: check unwritten extent preallocation in 255
Date: Mon, 28 Jan 2013 15:32:48 +0800
Message-ID: <1359358371-21411-2-git-send-email-wenqing.lz@taobao.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45375 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3A1HU0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 02:20:26 -0500
Received: by mail-pa0-f52.google.com with SMTP id fb1so1356375pad.39
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jan 2013 23:20:26 -0800 (PST)
In-Reply-To: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

255 misses call _require_xfs_io_falloc to check whether a filesystem
supports fallocate(2) to preallocate unwritten extents or not.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
---
 255 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/255 b/255
index 0083963..700c3c0 100755
--- a/255
+++ b/255
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FS QA Test No. 255
 #
-# Test Generic fallocate hole punching
+# Test Generic fallocate hole punching w/ unwritten extent
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2010 Red Hat.  All Rights Reserved.
@@ -47,6 +47,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic 
 _supported_os Linux
 
+_require_xfs_io_falloc
 _require_xfs_io_falloc_punch
 _require_xfs_io_fiemap
 
-- 
1.7.12.rc2.18.g61b472e

