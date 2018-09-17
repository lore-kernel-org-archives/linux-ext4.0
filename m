From: Chao Yu <yuchao0@huawei.com>
Subject: [PATCH] ext4: fix to propagate error from dquot_initialize()
Date: Mon, 17 Sep 2018 15:22:46 +0800
Message-ID: <20180917072246.25457-1-yuchao0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <chao@kernel.org>, Chao Yu <yuchao0@huawei.com>
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In ext4_ioctl_setproject(), we forgot to check error return from
dquot_initialize(), if we ignore such error, later, quota info can
be out-of-update, fix it.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 fs/ext4/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a7074115d6f6..e6d11cb07e87 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -364,7 +364,9 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 		brelse(iloc.bh);
 	}
 
-	dquot_initialize(inode);
+	err = dquot_initialize(inode);
+	if (err)
+		goto out_unlock;
 
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
-- 
2.18.0.rc1
