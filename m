From: Andrey Tsyvarev <tsyvarev@ispras.ru>
Subject: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if ext4_mb_init() fails
Date: Mon, 12 May 2014 12:23:59 +0400
Message-ID: <1399883039-2978-1-git-send-email-tsyvarev@ispras.ru>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Caches from 'ext4_groupinfo_caches' may be in use by other mounts, which have already existed.
So, it is incorrect to destroy them when newly requested mount fails.

Found by Linux File System Verification project (linuxtesting.org).

Signed-off-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
---
 fs/ext4/mballoc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 04a5c75..becea1d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2607,7 +2607,7 @@ int ext4_mb_init(struct super_block *sb)
 	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
 	if (sbi->s_locality_groups == NULL) {
 		ret = -ENOMEM;
-		goto out_free_groupinfo_slab;
+		goto out;
 	}
 	for_each_possible_cpu(i) {
 		struct ext4_locality_group *lg;
@@ -2632,8 +2632,6 @@ int ext4_mb_init(struct super_block *sb)
 out_free_locality_groups:
 	free_percpu(sbi->s_locality_groups);
 	sbi->s_locality_groups = NULL;
-out_free_groupinfo_slab:
-	ext4_groupinfo_destroy_slabs();
 out:
 	kfree(sbi->s_mb_offsets);
 	sbi->s_mb_offsets = NULL;
-- 
1.8.3.1
