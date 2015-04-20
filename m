From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] fs/ext4: remove unused header file
Date: Mon, 20 Apr 2015 15:01:23 +0800
Message-ID: <5534A443.9080802@huawei.com>
References: <1429513092-6010-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:27345 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbDTHBn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2015 03:01:43 -0400
In-Reply-To: <1429513092-6010-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bitops.h provide definitions and macros that aren't used
in fs/ext4/inode.c at all.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext4/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 035b7a0..2b04a86 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -37,7 +37,6 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
-#include <linux/bitops.h>

 #include "ext4_jbd2.h"
 #include "xattr.h"
-- 
1.9.1


.




