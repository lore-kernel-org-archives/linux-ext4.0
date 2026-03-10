Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E693B9DB5
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147960; cv=none; b=FB9rSKOquwo3AVUt/XuywnfXXFB3FU/7wYoICt+zbQqGmrQy0uHOFZnOwDPy1PL3obJ7bATLLFX9zLn7Jh16SBCN0p8KtCEs64XYI7dRcH8q5pZXVPLAqbNMSVKSYDZ4q2DjwFAdUcWrY7T06XipV7Vu+HAp0RP0P0gUr4ZYtxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147960; c=relaxed/simple;
	bh=KqI81TnxdsGt42OYSGKyBtd1ypmxQ28GmF5NeJiGfHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C0um8t3uyW3OrcBINdXWU86w4z9xzkF+wY6f3/Qkw249m+IXhmkRRiBQN2rUtTRexo5amIbch+PPte8mBOTYJvrv5KYKLfEIhZ360itjgF6obKvnz9irZsy8NblCACAXsQP+jS66Cstyf854FXF5KcV6TVByKh1Vumo9ZpylL1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVYys2m6WzKHMlV
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AAD524056E
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUwxF7BpaX6fAQ--.37695S7;
	Tue, 10 Mar 2026 21:05:56 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH -next 3/8] ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
Date: Tue, 10 Mar 2026 21:04:07 +0800
Message-Id: <20260310130412.3156753-4-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310130412.3156753-1-yebin@huaweicloud.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYUwxF7BpaX6fAQ--.37695S7
X-Coremail-Antispam: 1UD129KBjvJXoWxKFWrtw4fZFyfWr13JFW8JFb_yoW7CF4Dpr
	sIyr1fCr43Zas5urWxJr4DZr1Sk3W8ua17AryfK34UKFyktry8XF18t3Z0yF1YgF48WayY
	vFWrtr1UGw1fGFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxU2ApnDUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Now, only EXT4_KUNIT_TESTS=Y testcase will be compiled in 'extents.c'.
To solve this issue, the ext4 test code needs to be decoupled. The
'extents-test' module is compiled into 'ext4-test' module.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/Makefile       |  3 ++-
 fs/ext4/ext4_extents.h | 12 ++++++++++++
 fs/ext4/extents-test.c |  8 ++++----
 fs/ext4/extents.c      | 38 ++++++++++++++++++++++++++++++++------
 4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index d836c3fe311b..3baee4e7c1cf 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -14,7 +14,8 @@ ext4-y	:= balloc.o bitmap.o block_validity.o dir.o ext4_jbd2.o extents.o \
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
-ext4-test-objs				+= inode-test.o mballoc-test.o
+ext4-test-objs				+= inode-test.o mballoc-test.o \
+					   extents-test.o
 obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
 ext4-$(CONFIG_FS_ENCRYPTION)		+= crypto.o
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index c484125d963f..8318e8d97074 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -264,5 +264,17 @@ static inline void ext4_idx_store_pblock(struct ext4_extent_idx *ix,
 				     0xffff);
 }
 
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+extern int ext4_ext_space_root_idx_test(struct inode *inode, int check);
+extern struct ext4_ext_path *ext4_split_convert_extents_test(
+				handle_t *handle, struct inode *inode,
+				struct ext4_map_blocks *map,
+				struct ext4_ext_path *path,
+				int flags, unsigned int *allocated);
+extern int __ext4_ext_dirty(const char *where, unsigned int line,
+			    handle_t *handle, struct inode *inode,
+			    struct ext4_ext_path *path);
+extern int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex);
+#endif
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 7c4690eb7dad..9e055f399167 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -280,8 +280,8 @@ static int extents_kunit_init(struct kunit *test)
 	eh->eh_depth = 0;
 	eh->eh_entries = cpu_to_le16(1);
 	eh->eh_magic = EXT4_EXT_MAGIC;
-	eh->eh_max =
-		cpu_to_le16(ext4_ext_space_root_idx(&k_ctx.k_ei->vfs_inode, 0));
+	eh->eh_max = cpu_to_le16(ext4_ext_space_root_idx_test(
+					&k_ctx.k_ei->vfs_inode, 0));
 	eh->eh_generation = 0;
 
 	/*
@@ -384,8 +384,8 @@ static void test_split_convert(struct kunit *test)
 
 	switch (param->type) {
 	case TEST_SPLIT_CONVERT:
-		path = ext4_split_convert_extents(NULL, inode, &map, path,
-						  param->split_flags, NULL);
+		path = ext4_split_convert_extents_test(NULL, inode, &map,
+					path, param->split_flags, NULL);
 		break;
 	case TEST_CREATE_BLOCKS:
 		ext4_map_create_blocks_helper(test, inode, &map, param->split_flags);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae3804f36535..0942d2ed4603 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -184,9 +184,9 @@ static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
  *  - ENOMEM
  *  - EIO
  */
-static int __ext4_ext_dirty(const char *where, unsigned int line,
-			    handle_t *handle, struct inode *inode,
-			    struct ext4_ext_path *path)
+int __ext4_ext_dirty(const char *where, unsigned int line,
+		     handle_t *handle, struct inode *inode,
+		     struct ext4_ext_path *path)
 {
 	int err;
 
@@ -3144,7 +3144,7 @@ static void ext4_zeroout_es(struct inode *inode, struct ext4_extent *ex)
 }
 
 /* FIXME!! we need to try to merge to left or right after zero-out  */
-static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
+int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
 	ext4_fsblk_t ee_pblock;
 	unsigned int ee_len;
@@ -6238,6 +6238,32 @@ int ext4_ext_clear_bb(struct inode *inode)
 	return 0;
 }
 
-#ifdef CONFIG_EXT4_KUNIT_TESTS
-#include "extents-test.c"
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+int ext4_ext_space_root_idx_test(struct inode *inode, int check)
+{
+	return ext4_ext_space_root_idx(inode, check);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_space_root_idx_test);
+
+struct ext4_ext_path *ext4_split_convert_extents_test(handle_t *handle,
+			struct inode *inode, struct ext4_map_blocks *map,
+			struct ext4_ext_path *path, int flags,
+			unsigned int *allocated)
+{
+	return ext4_split_convert_extents(handle, inode, map, path,
+					  flags, allocated);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_split_convert_extents_test);
+
+EXPORT_SYMBOL_FOR_EXT4_TEST(__ext4_ext_dirty);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_zeroout);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_register_shrinker);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_map_create_blocks);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_init_tree);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_lookup_extent);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_insert_extent);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_insert_extent);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_find_extent);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_issue_zeroout);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_map_query_blocks);
 #endif
-- 
2.34.1

