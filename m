From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Sun, 21 Mar 2010 22:01:06 +0800
Message-ID: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:58840 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0CUOBH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Mar 2010 10:01:07 -0400
Received: by gxk9 with SMTP id 9so2836890gxk.8
        for <linux-ext4@vger.kernel.org>; Sun, 21 Mar 2010 07:01:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Sun Mar 21 21:59:35     2010

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc3.c	2010-03-21 21:37:18.000000000 +0800
@@ -2360,6 +2360,24 @@ err_freesgi:
 	return -ENOMEM;
 }

+static void ext4_mb_destroy_backend(struct super_block *sb)
+{
+	ext4_group_t ngroups = ext4_get_groups_count(sb);
+	ext4_group_t i;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int j;
+	int num_meta_group_infos = (ngroups + EXT4_DESC_PER_BLOCK(sb) -1)
+					>> EXT4_DESC_PER_BLOCK_BITS(sb);
+	for (i = 0; i < ngroups; i++)
+		kfree(ext4_get_group_info(sb, i));
+
+	for (j = 0; j < num_meta_group_infos; j++)
+		kfree(sbi->s_group_info[j]);
+
+	kfree(sbi->s_group_info);
+	iput(sbi->s_buddy_cache);
+}
+
 int ext4_mb_init(struct super_block *sb, int needs_recovery)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -2419,6 +2437,7 @@ int ext4_mb_init(struct super_block *sb,
 	if (sbi->s_locality_groups == NULL) {
 		kfree(sbi->s_mb_offsets);
 		kfree(sbi->s_mb_maxs);
+		ext4_mb_destroy_backend(sb);
 		return -ENOMEM;
 	}
 	for_each_possible_cpu(i) {
