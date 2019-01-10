Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:17101 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfAJGDL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 01:03:11 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <miaoxie@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 1/2] jbd2: fix compile warning when using JBUFFER_TRACE
Date: Thu, 10 Jan 2019 14:06:38 +0800
Message-ID: <1547100399-127915-2-git-send-email-yi.zhang@huawei.com>
In-Reply-To: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
References: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The jh pointer may be used uninitialized in the two cases below and the
compiler complain about it when enabling JBUFFER_TRACE macro, fix them.

In file included from fs/jbd2/transaction.c:19:0:
fs/jbd2/transaction.c: In function ‘jbd2_journal_get_undo_access’:
./include/linux/jbd2.h:1637:38: warning: ‘jh’ is used uninitialized in this function [-Wuninitialized]
 #define JBUFFER_TRACE(jh, info) do { printk("%s: %d\n", __func__, jh->b_jcount);} while (0)
                                      ^
fs/jbd2/transaction.c:1219:23: note: ‘jh’ was declared here
  struct journal_head *jh;
                       ^
In file included from fs/jbd2/transaction.c:19:0:
fs/jbd2/transaction.c: In function ‘jbd2_journal_dirty_metadata’:
./include/linux/jbd2.h:1637:38: warning: ‘jh’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 #define JBUFFER_TRACE(jh, info) do { printk("%s: %d\n", __func__, jh->b_jcount);} while (0)
                                      ^
fs/jbd2/transaction.c:1332:23: note: ‘jh’ was declared here
  struct journal_head *jh;
                       ^

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Cc: stable@vger.kernel.org
---
 fs/jbd2/transaction.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index c0b66a7..4b51177 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1219,11 +1219,12 @@ int jbd2_journal_get_undo_access(handle_t *handle, struct buffer_head *bh)
 	struct journal_head *jh;
 	char *committed_data = NULL;
 
-	JBUFFER_TRACE(jh, "entry");
 	if (jbd2_write_access_granted(handle, bh, true))
 		return 0;
 
 	jh = jbd2_journal_add_journal_head(bh);
+	JBUFFER_TRACE(jh, "entry");
+
 	/*
 	 * Do this first --- it can drop the journal lock, so we want to
 	 * make sure that obtaining the committed_data is done
@@ -1334,15 +1335,17 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 
 	if (is_handle_aborted(handle))
 		return -EROFS;
-	if (!buffer_jbd(bh)) {
-		ret = -EUCLEAN;
-		goto out;
-	}
+	if (!buffer_jbd(bh))
+		return -EUCLEAN;
+
 	/*
 	 * We don't grab jh reference here since the buffer must be part
 	 * of the running transaction.
 	 */
 	jh = bh2jh(bh);
+	jbd_debug(5, "journal_head %p\n", jh);
+	JBUFFER_TRACE(jh, "entry");
+
 	/*
 	 * This and the following assertions are unreliable since we may see jh
 	 * in inconsistent state unless we grab bh_state lock. But this is
@@ -1376,9 +1379,6 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	}
 
 	journal = transaction->t_journal;
-	jbd_debug(5, "journal_head %p\n", jh);
-	JBUFFER_TRACE(jh, "entry");
-
 	jbd_lock_bh_state(bh);
 
 	if (jh->b_modified == 0) {
-- 
2.7.4
