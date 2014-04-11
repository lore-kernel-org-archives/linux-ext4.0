From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext4: avoid unneeded lookup when xattr name is invalid
Date: Fri, 11 Apr 2014 15:15:07 +0800
Message-ID: <5347967B.5090401@huawei.com>
References: <1397199813-71623-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:11466 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaDKHQy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2014 03:16:54 -0400
In-Reply-To: <1397199813-71623-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_xattr_set_handle() we have checked the xattr name's length. So we should
also check it in ext4_xattr_get() to avoid unneeded lookup caused by invalid name.

In addition, we deleted the check of NULL in ext4_xattr_set_handle(), because in all
the callers of the ext4_xattr_set_handle(), the name can't be NULL.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext4/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1f5cf58..340bdfa 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -369,6 +369,9 @@ ext4_xattr_get(struct inode *inode, int name_index, const char *name,
 {
 	int error;

+	if (strlen(name) > 255)
+		return -ERANGE;
+
 	down_read(&EXT4_I(inode)->xattr_sem);
 	error = ext4_xattr_ibody_get(inode, name_index, name, buffer,
 				     buffer_size);
@@ -1073,8 +1076,6 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	unsigned long no_expand;
 	int error;

-	if (!name)
-		return -EINVAL;
 	if (strlen(name) > 255)
 		return -ERANGE;
 	down_write(&EXT4_I(inode)->xattr_sem);
-- 
1.8.5.5


.




