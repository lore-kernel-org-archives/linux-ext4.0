From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] ext4: Ensure Inode flags consistency are checked in build time
Date: Fri, 30 Nov 2012 14:11:26 -0200
Message-ID: <1354291886-18312-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab2K3QLd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 11:11:33 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qAUGBXX5009278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 11:11:33 -0500
Received: from andromeda.usersys.redhat.com (ovpn-113-76.phx2.redhat.com [10.3.113.76])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id qAUGBW5O010850
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 11:11:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Flags being used by atomic operations in inode flags (e.g.
ext4_test_inode_flag(), should be consistent with that actually stored in
inodes, i.e.: EXT4_XXX_FL.

It ensures that this consistency is checked at build-time, not at run-time.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ext4/ext4.h  | 29 +++++++++++++----------------
 fs/ext4/super.c |  1 +
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c20de1..4ac0523 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -451,25 +451,22 @@ enum {
 	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
 };
 
-#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
-#define CHECK_FLAG_VALUE(FLAG) if (!TEST_FLAG_VALUE(FLAG)) { \
-	printk(KERN_EMERG "EXT4 flag fail: " #FLAG ": %d %d\n", \
-		EXT4_##FLAG##_FL, EXT4_INODE_##FLAG); BUG_ON(1); }
-
-/*
- * Since it's pretty easy to mix up bit numbers and hex values, and we
- * can't do a compile-time test for ENUM values, we use a run-time
- * test to make sure that EXT4_XXX_FL is consistent with respect to
- * EXT4_INODE_XXX.  If all is well the printk and BUG_ON will all drop
- * out so it won't cost any extra space in the compiled kernel image.
- * But it's important that these values are the same, since we are
- * using EXT4_INODE_XXX to test for the flag values, but EXT4_XX_FL
- * must be consistent with the values of FS_XXX_FL defined in
- * include/linux/fs.h and the on-disk values found in ext2, ext3, and
- * ext4 filesystems, and of course the values defined in e2fsprogs.
+/*
+ * Since it's pretty easy to mix up bit numbers and hex values, we use a
+ * build-time check to make sure that EXT4_XXX_FL is consistent with respect to
+ * EXT4_INODE_XXX. If all is well, the macros will be dropped, so, it won't cost
+ * any extra space in the compiled kernel image, otherwise, the build will fail.
+ * It's important that these values are the same, since we are using
+ * EXT4_INODE_XXX to test for flag values, but EXT4_XXX_FL must be consistent
+ * with the values of FS_XXX_FL defined in include/linux/fs.h and the on-disk
+ * values found in ext2, ext3 and ext4 filesystems, and of course the values
+ * defined in e2fsprogs.
  *
  * It's not paranoia if the Murphy's Law really *is* out to get you.  :-)
  */
+#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
+#define CHECK_FLAG_VALUE(FLAG) BUILD_BUG_ON(!TEST_FLAG_VALUE(FLAG))
+
 static inline void ext4_check_flag_values(void)
 {
 	CHECK_FLAG_VALUE(SECRM);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..e6f6f8b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5282,6 +5282,7 @@ static int __init ext4_init_fs(void)
 	ext4_li_info = NULL;
 	mutex_init(&ext4_li_mtx);
 
+	/* Build-time check for flags consistency */
 	ext4_check_flag_values();
 
 	for (i = 0; i < EXT4_WQ_HASH_SZ; i++) {
-- 
1.7.11.7

