From: Sheng Yong <shengyong1@huawei.com>
Subject: [PATCH 1/2] ext2: remove unused header files
Date: Wed, 4 Mar 2015 05:52:02 +0000
Message-ID: <1425448323-220091-1-git-send-email-shengyong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:25070 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbCDFkn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2015 00:40:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused header files, and header files which are included in ext2.h.

Signed-off-by: Sheng Yong <shengyong1@huawei.com>
---
 fs/ext2/acl.c   | 4 ----
 fs/ext2/super.c | 1 -
 2 files changed, 5 deletions(-)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 27695e6..e2a6f61 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -4,10 +4,6 @@
  * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
  */
 
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/fs.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d0e746e..9b42e0f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -18,7 +18,6 @@
 
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-- 
1.8.3.4

