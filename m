From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext4: fix some wrong comments
Date: Fri, 28 Feb 2014 15:27:52 +0800
Message-ID: <53103A78.3050402@huawei.com>
References: <5310053D.6080808@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:25356 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaB1H2Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Feb 2014 02:28:24 -0500
In-Reply-To: <5310053D.6080808@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The comments in the code are wrong, because every generic_file_write()
is replaced by generic_file_aio_write().

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e39895..c218294 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4399,7 +4399,7 @@ out_brelse:
  *
  * We are called from a few places:
  *
- * - Within generic_file_write() for O_SYNC files.
+ * - Within generic_file_aio_write() for O_SYNC files.
  *   Here, there will be no transaction running. We wait for any running
  *   transaction to commit.
  *
-- 
1.8.1.4


.




_______________________________________________
kernel.openeuler mailing list
kernel.openeuler@huawei.com
http://rnd-openeuler.huawei.com/mailman/listinfo/kernel.openeuler





