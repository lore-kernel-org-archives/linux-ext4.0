From: Yaowei Bai <bywxiaobai@163.com>
Subject: [PATCH 06/17] fs/ext2: remove unnecessary new_valid_dev check
Date: Mon, 28 Sep 2015 21:47:25 +0800
Message-ID: <1443448045-5236-1-git-send-email-bywxiaobai@163.com>
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: viro@zeniv.linux.org.uk, jack@suse.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As new_valid_dev always returns 1, so !new_valid_dev check is not
needed, remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
---
 fs/ext2/namei.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index b4841e3..3267a80 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -143,9 +143,6 @@ static int ext2_mknod (struct inode * dir, struct dentry *dentry, umode_t mode,
 	struct inode * inode;
 	int err;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	err = dquot_initialize(dir);
 	if (err)
 		return err;
-- 
1.9.1


