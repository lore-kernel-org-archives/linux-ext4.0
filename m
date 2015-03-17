From: Wei Yuan <weiyuan.wei@huawei.com>
Subject: [PATCH] ext4: Remove useless condition in if statement.
Date: Tue, 17 Mar 2015 09:31:54 +0800
Message-ID: <1426555914-731-1-git-send-email-weiyuan.wei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:44840 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbbCQB2W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2015 21:28:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In this if statement, the previous condition is useless, the later one has covered it.

Signed-off-by: Weiyuan <weiyuan.wei@huawei.com>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1e09fc7..f2ccad7 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -639,8 +639,7 @@ ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s)
 		free += EXT4_XATTR_LEN(name_len);
 	}
 	if (i->value) {
-		if (free < EXT4_XATTR_SIZE(i->value_len) ||
-		    free < EXT4_XATTR_LEN(name_len) +
+		if (free < EXT4_XATTR_LEN(name_len) +
 			   EXT4_XATTR_SIZE(i->value_len))
 			return -ENOSPC;
 	}
--
2.1.0

