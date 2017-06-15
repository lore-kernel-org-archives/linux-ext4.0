From: Chao Yu <yuchao0@huawei.com>
Subject: [PATCH] ext4: check return value of kstrtoull correctly in reserved_clusters_store
Date: Thu, 15 Jun 2017 17:57:30 +0800
Message-ID: <20170615095730.36627-1-yuchao0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yuchao0@huawei.com>, <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

kstrtoull returns 0 on success, however, in reserved_clusters_store we
will return -EINVAL if kstrtoull returns 0, it makes us fail to update
reserved_clusters value through sysfs.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Miao Xie <miaoxie@huawei.com>
---
 fs/ext4/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index d74dc5f81a04..48c7a7d55ed3 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -100,7 +100,7 @@ static ssize_t reserved_clusters_store(struct ext4_attr *a,
 	int ret;
 
 	ret = kstrtoull(skip_spaces(buf), 0, &val);
-	if (!ret || val >= clusters)
+	if (ret || val >= clusters)
 		return -EINVAL;
 
 	atomic64_set(&sbi->s_resv_clusters, val);
-- 
2.13.1.388.g69e6b9b4f4a9
