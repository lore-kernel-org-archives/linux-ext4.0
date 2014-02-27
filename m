From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext3/4: remove some unnecessary comments
Date: Thu, 27 Feb 2014 17:26:09 +0800
Message-ID: <530F04B1.40105@huawei.com>
References: <1393521230-3254-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: <jack@suse.cz>, <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:27696 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaB0J0d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Feb 2014 04:26:33 -0500
In-Reply-To: <1393521230-3254-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The comments in the code are unnecessary, because every generic_file_write()
is replaced by generic_file_aio_write().

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext3/inode.c | 4 ----
 fs/ext4/inode.c | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 384b6eb..e08c2eb 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3212,10 +3212,6 @@ out_brelse:
  *
  * We are called from a few places:
  *
- * - Within generic_file_write() for O_SYNC files.
- *   Here, there will be no transaction running. We wait for any running
- *   transaction to commit.
- *
  * - Within sys_sync(), kupdate and such.
  *   We wait on commit, if tol to.
  *
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e39895..5ef32f0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4399,10 +4399,6 @@ out_brelse:
  *
  * We are called from a few places:
  *
- * - Within generic_file_write() for O_SYNC files.
- *   Here, there will be no transaction running. We wait for any running
- *   transaction to commit.
- *
  * - Within sys_sync(), kupdate and such.
  *   We wait on commit, if tol to.
  *
-- 
1.8.1.4


.




