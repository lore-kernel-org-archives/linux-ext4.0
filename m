From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] ext4: fix the deadlock in ext4_ordered_write_end()
Date: Thu, 13 Oct 2011 11:05:52 +0900
Message-ID: <4E964780.4080105@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, adilger.kernel@dilger.ca
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42002 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab1JMCGb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Oct 2011 22:06:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If ext4_jbd2_file_inode() in ext4_ordered_write_end() fails
for some reasons, this function returns to caller
without unlocking the page.
It leads to the deadlock, and the patch fixes this issue.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 986e238..69dc2c6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -909,7 +909,11 @@ static int ext4_ordered_write_end(struct file *file,
 			ext4_orphan_add(handle, inode);
 		if (ret2 < 0)
 			ret = ret2;
+	} else {
+		unlock_page(page);
+		page_cache_release(page);
 	}
+
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
