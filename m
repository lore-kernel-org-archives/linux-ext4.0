From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] ext4/mballoc: Remove unneeded variable "err"
Date: Sat, 4 Aug 2018 19:04:56 +0800
Message-ID: <1533380696-16325-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The err is not used after initalization. So just remove the variable.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8b24d3d..e29fce2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3801,7 +3801,6 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 	unsigned long long grp_blk_start;
-	int err = 0;
 	int free = 0;
 
 	BUG_ON(pa->pa_deleted == 0);
@@ -3842,7 +3841,7 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
 	}
 	atomic_add(free, &sbi->s_mb_discarded);
 
-	return err;
+	return 0;
 }
 
 static noinline_for_stack int
-- 
1.7.12.4
