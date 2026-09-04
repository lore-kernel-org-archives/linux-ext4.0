Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2B43B1EEE;
	Fri,  4 Sep 2026 07:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507150; cv=none; b=vEvNKH+8WcQh1SWPkI/Jt9lC38aKk5JFnLFa0JEs4cvQwBYvFFKywBha51aplw/gii+J8RxOfVZ8MZexSHUfdaTFEMGl3DXEew5l9WrRtAxSnfkjVR7mRhc75Usu17ebBOaItHEfyedCNP8Ia7CQT6kYANUW/qaLHroOCQNP+lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507150; c=relaxed/simple;
	bh=xOY2Lm5YDkZICkADu3TwD0cD3gJDODMdk993CAsAPQ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oa4aL+xFgJwkW49gb+A2UVmJz5hFoI8a+Kx7WalsugQySHGU7kN9a/WE3H6izY0AsIRXGCXJMbFZ6cNBE6zAmO89sA5t2jHcjeN5zzOrenVczcnDUtz0bfbtARfsjIdqwgPJKmWYrRSDSZkaFM1pW7Tu6HfYNkH1y4Cv8uveVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=32AVeswh; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="32AVeswh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HLDguLzm9iebYGNiy9mxz1ksVC/JrRbR0DUr/nUScuY=;
	b=32AVeswhGrDouEzpIpM10Fwh1TltViA2siahd/ovMCl2bgTFZYk6A814vPb0uQFV7Mu1hdJU8
	Dsb0XilvJRglEXM/RIj2RMtn56wWzbIayLTDPFkdBXOpdsG5Vti5kkqTXEEjhleW8SiJ2UTL8g5
	3021/Wcjx0YcbP7maBIFW4M=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hbnvL0knZz1cyVg;
	Fri,  4 Sep 2026 15:21:18 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 9FDCF4056C;
	Fri,  4 Sep 2026 15:32:08 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 4 Sep
 2026 15:32:07 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
	<jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
	<yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v4 2/2] ext4: Convert group-count barrier protocol to acquire/release
Date: Fri, 4 Sep 2026 15:32:53 +0800
Message-ID: <20260904073253.663243-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260904073253.663243-1-ruanjinjie@huawei.com>
References: <20260904073253.663243-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)

During an online resize, reading s_groups_count and s_blockfile_groups
requires strict ordering against subsequent initialized block group
metadata.

Replace the historical smp_wmb()/smp_rmb() pairs with smp_store_release()
and smp_load_acquire(). This formalizes the publish-subscribe pattern
and allows weakly-ordered architectures (e.g., arm64) to utilize native
STLR/LDAR instructions instead of full DMB fences.

Update the documentation in resize.c and ext4.h accordingly.

Assisted-by: Gemini:Gemini-3.1
Assisted-by: DeepSeek:DeepSeek-V3
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Baokun Li <libaokun@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    | 10 +++-------
 fs/ext4/mballoc.c |  6 ++----
 fs/ext4/resize.c  | 19 +++++++++++--------
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 724a27e8be61..d70b9cb09155 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3542,16 +3542,12 @@ static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
 }
 
 /*
- * Reading s_groups_count requires using smp_rmb() afterwards.  See
- * the locking protocol documented in the comments of ext4_group_add()
- * in resize.c
+ * Reading s_groups_count uses acquire semantics.
  */
 static inline ext4_group_t ext4_get_groups_count(struct super_block *sb)
 {
-	ext4_group_t	ngroups = EXT4_SB(sb)->s_groups_count;
-
-	smp_rmb();
-	return ngroups;
+	/* Pairs with smp_store_release() in ext4_update_super() */
+	return smp_load_acquire(&EXT4_SB(sb)->s_groups_count);
 }
 
 static inline ext4_group_t ext4_flex_group(struct ext4_sb_info *sbi,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 06171a11db12..a15285224cdf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -899,10 +899,8 @@ static ext4_group_t ext4_get_allocation_groups_count(
 
 	/* non-extent files are limited to low blocks/groups */
 	if (!(ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS)))
-		ngroups = EXT4_SB(ac->ac_sb)->s_blockfile_groups;
-
-	/* Pairs with smp_wmb() in ext4_update_super() */
-	smp_rmb();
+		/* Pairs with smp_store_release() in ext4_update_super() */
+		ngroups = smp_load_acquire(&EXT4_SB(ac->ac_sb)->s_blockfile_groups);
 
 	return ngroups;
 }
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 2c5b851c552a..5e3ad8393cf8 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1462,11 +1462,11 @@ static void ext4_update_super(struct super_block *sb,
 	 *
 	 * The precise rules we use are:
 	 *
-	 * * Writers must perform a smp_wmb() after updating all
-	 *   dependent data and before modifying the groups count
+	 * * Writers must use a release store when updating the groups count
+	 *   after all dependent data has been updated
 	 *
-	 * * Readers must perform an smp_rmb() after reading the groups
-	 *   count and before reading any dependent data.
+	 * * Readers must use an acquire load when reading the groups
+	 *   count before reading any dependent data.
 	 *
 	 * NB. These rules can be relaxed when checking the group count
 	 * while freeing data, as we can only allocate from a block
@@ -1474,12 +1474,15 @@ static void ext4_update_super(struct super_block *sb,
 	 * only then free after serialising in turn against that
 	 * allocation.
 	 */
-	smp_wmb();
 
 	/* Update the global fs size fields */
-	sbi->s_groups_count += flex_gd->count;
-	sbi->s_blockfile_groups = min(sbi->s_groups_count,
-			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
+	/* Pairs with smp_load_acquire() in ext4_get_groups_count() */
+	smp_store_release(&sbi->s_groups_count,
+			  sbi->s_groups_count + flex_gd->count);
+	/* Pairs with smp_load_acquire() in ext4_get_allocation_groups_count() */
+	smp_store_release(&sbi->s_blockfile_groups,
+			  min(sbi->s_groups_count,
+			      (EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb))));
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
-- 
2.34.1

