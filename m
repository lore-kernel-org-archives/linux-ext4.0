From: Yaowei Bai <bywxiaobai@163.com>
Subject: [PATCH 07/17] fs/ext4: remove unnecessary new_valid_dev check
Date: Mon, 28 Sep 2015 21:50:37 +0800
Message-ID: <1443448237-5285-1-git-send-email-bywxiaobai@163.com>
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As new_valid_dev always returns 1, so !new_valid_dev check is not
needed, remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
---
 fs/ext4/namei.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9f61e76..41b6cc8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2469,9 +2469,6 @@ static int ext4_mknod(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 	int err, credits, retries = 0;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	err = dquot_initialize(dir);
 	if (err)
 		return err;
-- 
1.9.1
