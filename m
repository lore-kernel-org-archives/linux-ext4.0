Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98AB41D23D;
	Tue,  1 Sep 2026 02:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230546; cv=none; b=h/+Bjmc8x/pL+a7POx3UNeUapt4a7vahNNegn4n9T1nWRN/bUrBtIlWyBvTOdvycn1r8o5QGdXo0YhUkFlb30r4Zn83i8Ls70RyF7TuSjHx8GYiSIozfBwNpfz3l+7KWo9F80U/ySvIxTUN0vUC3zPkvUEfjZ4XhQyugtD3NxtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230546; c=relaxed/simple;
	bh=pADLIDDDAa+lhGsyTlXoetDrztywb5yDxiTzspAGBzY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f04zqKVIYMWAS1fflPnl1QltXYyGEj3hvqDuCyQ/zqPOzpIbjVHVJjNrz0gG0INlj9JHYd/h3RZAlhH/loupaJNCRwaEQbIS1+WG/005mJcF8BmtOlJM28hPZlSmVSfkwN8xBGFKX7zXTkVC9oXXo8Yz2V6r6mc4cN1P3GhGbwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=53B12CPQ; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="53B12CPQ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iH00vTqUXFP44+YZhDZSDGKnnR3KFEyl0IM9Pe/tVLE=;
	b=53B12CPQYRWRKa5gqDtuoUGWsm1oHSiifC4JGWdfAVl4rFPT2lC1C0tVRMzhXLCkAVhJH2+wL
	01JI5nBn1I2mufrWDunC94QgP8Zwwx1EfEbULJWhS5IHjrKwyDrZmfXytMBUaRH5oFHElaByvZn
	DfK1Pf8R89hd2mIFe1ETWuQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hYqbY0tdczpSvd;
	Tue,  1 Sep 2026 10:30:49 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E0E3202E6;
	Tue,  1 Sep 2026 10:42:07 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:42:06 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<ruanjinjie@huawei.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH v2 08/12] ext4: Convert group-count barrier protocol to acquire/release
Date: Tue, 1 Sep 2026 10:42:30 +0800
Message-ID: <20260901024234.135119-9-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260901024234.135119-1-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500011.china.huawei.com (7.185.36.131)

During an online resize, reading s_groups_count and s_blockfile_groups
requires strict ordering against subsequent initialized block group
metadata.

Replace the historical smp_wmb()/smp_rmb() pairs with smp_store_release()
and smp_load_acquire(). This formalizes the publish-subscribe pattern
and allows weakly-ordered architectures (e.g., arm64) to utilize native
STLR/LDAR instructions instead of full DMB fences.

Update the documentation in resize.c and ext4.h accordingly.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Baokun Li <libaokun@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Assisted-by: Gemini:Gemini-3.1
Assisted-by: DeepSeek:DeepSeek-V3
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
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

