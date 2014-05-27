From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] ext4: fix missing unlock on error in collapse range
Date: Tue, 27 May 2014 09:09:15 +0900
Message-ID: <000601cf793f$e5377070$afa65150$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Dan Carpenter' <dan.carpenter@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53612 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaE0AJR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2014 20:09:17 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N67009E4HRFFU70@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 27 May 2014 09:09:15 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add i_write_mutex unlock on the error handling path in collapse_range().

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ee14768..0c93423 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5447,8 +5447,10 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	/* Write out all dirty pages */
 	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
 					   LLONG_MAX);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 		return ret;
+	}
 
 	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
-- 
1.7.11-rc0

