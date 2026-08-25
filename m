Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2B03FB06D;
	Tue, 25 Aug 2026 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651645; cv=none; b=cKJq6rkr+58ZpV9KWwxPXrt5nf7N2VR1dn7Phep2Mtqd5oXn20/56Km0s3SJi9q+8MQLr+fd6lrI6kyGfH35ppt9BXhNjN2e2A1YBv/1qa8o8sumX+ddP/sn9hsq8YTukJ5DfUu+81EDo68cGeRdAlcv0DXnWsDZjIVa8Ver82I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651645; c=relaxed/simple;
	bh=la5SIXh7VmOWGNdBMkVtitWg5X6h0luDBgmfHpw8bZQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgrdlCONu2xbelK8/I8ZbLBv2v1ZLV3Hjmal4Qm0crvcslhSzUCn++Rub7nJSPer+XJfGFOkKndgtpsOd2Kk6XwjzxHIDyUrHVtTqwIwUd+Rm2QszOuGwE+cLVYJlTvIUbtXWa3rsIkm57e2M1wHQPF6Yb/xLCea86V30YImpyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zqLw0SmT; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zqLw0SmT"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0y/8nOHVwx4gd6YkQJrH19CZDSX5NFv5nerKnpz559g=;
	b=zqLw0SmTgcAmrAmtZ1/OivLzntqgkQr31UYG/wwciFKdvURjaGaafU/N4jfSdDCypMp9lG1GJ
	M0gbbjETsWsHB4+NThl0jY08Pnyn28ksoTjnTXSMtYKL3Qtn4vflGGiql5x23MykQ23ZAspc5Xc
	5vS1gp5hH8cnh//bs7xokvQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWd1mMVz1K9BV;
	Tue, 25 Aug 2026 17:43:09 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 6A06F40565;
	Tue, 25 Aug 2026 17:53:54 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:52 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>,
	<akpm@linux-foundation.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <horms@kernel.org>,
	<socketcan@hartkopp.net>, <mkl@pengutronix.de>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<liuhangbin@gmail.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH 07/11] ext4: Convert group-count barrier protocol to acquire/release
Date: Tue, 25 Aug 2026 17:54:18 +0800
Message-ID: <20260825095422.3166067-8-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825095422.3166067-1-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
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

Assisted-by: Gemini:Gemini-3.1
Assisted-by: DeepSeek:DeepSeek-V3
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

