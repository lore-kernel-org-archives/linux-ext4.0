From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext3: fix some wrong comments
Date: Fri, 28 Feb 2014 15:28:59 +0800
Message-ID: <53103ABB.9030100@huawei.com>
References: <53100429.3000205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:25490 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaB1H3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Feb 2014 02:29:14 -0500
In-Reply-To: <53100429.3000205@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The comments in the code are wrong, because every generic_file_write()
is replaced by generic_file_aio_write().

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext3/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 384b6eb..0b94832 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1574,7 +1574,7 @@ static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
  *
  * Similar for:
  *
- *	ext3_file_write() -> generic_file_write() -> __alloc_pages() -> ...
+ *	ext3_file_write() -> generic_file_aio_write() -> __alloc_pages() -> ...
  *
  * Same applies to ext3_get_block().  We will deadlock on various things like
  * lock_journal and i_truncate_mutex.
@@ -3212,7 +3212,7 @@ out_brelse:
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





