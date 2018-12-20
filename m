Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:57963 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725795AbeLTJTT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 04:19:19 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <wshilong@ddn.com>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH v2 1/2] ext4: fix race when setting the bitmap corrupted flag again
Date: Thu, 20 Dec 2018 17:22:20 +0800
Message-ID: <1545297741-49408-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 9af0b3d12577 "ext4: fix race when setting the bitmap corrupted
flag" want to fix race between setting inode/block bitmap corrupted
flag and reducing free group inodes/clusters counter to prevent
multiple frees. But ext4_test_and_set_bit() will invoke
__test_and_set_bit() which is non-atomic, so the race is still there.
Fix this by invoke test_and_set_bit() instead.

Fixes: 9af0b3d12577 ("ext4: fix race when setting the bitmap corrupted flag")
Cc: stable@vger.kernel.org
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Wang Shilong <wshilong@ddn.com>
---
Change since v1
 - add CC stable tag as shilong suggested.

 fs/ext4/ext4.h  | 6 ++++++
 fs/ext4/super.c | 6 ++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f89d0a..755ba14 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2888,6 +2888,12 @@ struct ext4_group_info {
 	(test_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &((grp)->bb_state)))
 #define EXT4_MB_GRP_IBITMAP_CORRUPT(grp)	\
 	(test_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &((grp)->bb_state)))
+#define EXT4_MB_GRP_TEST_AND_SET_BBITMAP_CORRUPT(grp)	\
+	(test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, \
+			  &((grp)->bb_state)))
+#define EXT4_MB_GRP_TEST_AND_SET_IBITMAP_CORRUPT(grp)	\
+	(test_and_set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, \
+			  &((grp)->bb_state)))
 
 #define EXT4_MB_GRP_WAS_TRIMMED(grp)	\
 	(test_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 53ff6c2..5b83765 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -798,16 +798,14 @@ void ext4_mark_group_bitmap_corrupted(struct super_block *sb,
 	int ret;
 
 	if (flags & EXT4_GROUP_INFO_BBITMAP_CORRUPT) {
-		ret = ext4_test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
-					    &grp->bb_state);
+		ret = EXT4_MB_GRP_TEST_AND_SET_BBITMAP_CORRUPT(grp);
 		if (!ret)
 			percpu_counter_sub(&sbi->s_freeclusters_counter,
 					   grp->bb_free);
 	}
 
 	if (flags & EXT4_GROUP_INFO_IBITMAP_CORRUPT) {
-		ret = ext4_test_and_set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT,
-					    &grp->bb_state);
+		ret = EXT4_MB_GRP_TEST_AND_SET_IBITMAP_CORRUPT(grp);
 		if (!ret && gdp) {
 			int count;
 
-- 
2.7.4
