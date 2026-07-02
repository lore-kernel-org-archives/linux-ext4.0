Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE96E27874F;
	Thu,  2 Jul 2026 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005791; cv=none; b=eietSEQM5Ojt4VF4PIDIsvS5RnbcV94rhw4CElLH3nwxNlMEA8IA9uNoGfaVXOWSaHNFDO6uhw5Oz6Ki3phQGic9jXrqUSPx8vRv5ZoRznTklIFB89DYtt7b1UVczCl23YC5zPfJsLpKu/x7/gZ39RnqR734cWtUjdJURK/iojE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005791; c=relaxed/simple;
	bh=uVCik/NWjfjig6xxfKFz+t82MxXjZ6RqdwdVEG+HzMc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z1FoomokpORmVdFQKRjdcqrZiTWUQ/+xpvNGAy0GgtEg/6tYq24T/oJXs1XWKQqgKdop0Zl7FVqgwug+KmUwtYrC6MgZUGzgoFZnXdkfyqpfOQdyEgDSPIHDyAG31/eaWslYiSpKQHamHIxBs5sjc27O2O4AT3CzBx7/d+eaJkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=eAhuv+pu; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="eAhuv+pu"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662E3I3W1985495;
	Thu, 2 Jul 2026 15:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=TtS1bq6rGxm8XdeTLxp+QDlZmxnIX8fRzIBqXYDkCY4=; b=
	eAhuv+pu89z7wbhJXUiKTED0gm0tJrobymF5z25x4dY2VA5A7AOqNhQUoGtFkTtl
	sYP54KYFEJbcBCPsT7tnQ6ZAnabIplH+BYhwsllzZSnQX0vY/Ww8+6PKmcfqKzZt
	bQUPpnKjeGWAMMvG5xQb7umi1MwqHiOI9W+7FrH7GsD9k8f4TDeiXZSSwh2r7CyS
	J5eUXO1zdUaUWG/rLj7TnFQuuO5pb0WtFH8D9igFId9S4Wp546Qg1nbVLxNzk/GW
	y+oxk+bIDK045gT+OKP9sPeBxjqbOU6kxYuZVUFVZYBR5cwewm3u0VNJ/VKd6Cyj
	BwMFHMDRiy9Tci0VJ5DZ6Q==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r0ftvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 02 Jul 2026 15:22:37 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 2 Jul 2026 08:22:35 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 2 Jul 2026 08:22:32 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v13 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
Date: Thu, 2 Jul 2026 23:22:22 +0800
Message-ID: <20260702152225.4071746-3-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702152225.4071746-1-yun.zhou@windriver.com>
References: <20260702152225.4071746-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a46823d cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=WjeYnjZXhi5Nt7IBOn4A:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: MrHtkS1nu3PAr10ujR2s0W9-qcyM1g05
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDE2MSBTYWx0ZWRfX6ckj1eVhw7Q3
 Ivz5tec0xc2PwUVR2rZJ/lx7Yq0HlfifmnPvuY4V8wZLYwDo2Tt7Vw/6fl1d1vVBJi5FGlaCEDs
 uJamzRp1vrAIPO8gU/2ggHWbAtu5EMonWZmN0GH8joxJo5TRHMaYm3MynuGVMoM3cr9w+WNNKSh
 LsIs3KHshwEsvevh2WSJi2n97HTms8IrhqomPf0G2U6IO1PFxkOyQTFU9tENt10RlSIzt4QJk0B
 WI/qnOuRtAUItBr0zxdkl6TVK0fVV+/pVWfzdIZRmH3qD+5n40sIfup1KmzMOKD3eKHMBHQHUKW
 nAjBCADHR6oPy6Him5n6w0VURqYs+zNIV1CGpkduQ+b2d81z3R7krsgxT5znWbIBYbZ9P9g3X0k
 /mYOoLoLwzX1ZkPyjJmaKSxnIVlRrlZOrHTpJ4+xaLoI0ikN81cfkBECRrqqbCPqg8qvjBwtKT8
 0WkNa6/dPJfv3FeH2zA==
X-Proofpoint-GUID: MrHtkS1nu3PAr10ujR2s0W9-qcyM1g05
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDE2MSBTYWx0ZWRfX0MTivHDiM0CC
 oQA3We1lxT4SyfC8BAygY+cr12rAKLea5bxR4FxVOvX8KuQT42ZpZ1seqD5yR4OIOBj9ZXeSd6X
 8pqjD3ARMGo1R5QgM7ifz4CCdZto7xs4JZeAZXZy6adupgkvhMAf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020161

Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
creating a lock ordering issue during mount (!SB_ACTIVE).

Add ext4_put_ea_inode() which uses iput_if_not_last() as a fast path.
If this is not the last reference, it is dropped immediately.  If this
is the last reference, the inode is linked onto a per-sb lock-free llist
via i_ea_iput_node (embedded in ext4_inode_info, sharing space with the
unused xattr_sem of EA inodes via a union) and a delayed worker
(1 jiffie) performs the final iput() in a clean context.  This avoids
per-iput memory allocation.

Flush points are placed before quota shutdown (ext4_put_super and
failed_mount9) and before freeing structures that eviction depends on
(failed_mount_wq and failed_mount3a).  Initialization is placed before
journal loading since fast commit replay may trigger evictions that call
ext4_put_ea_inode().

Also moves init_rwsem(xattr_sem) from init_once to ext4_alloc_inode to
handle slab object reuse after the union field has been overwritten.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  | 13 ++++++++++-
 fs/ext4/super.c | 18 ++++++++++++++-
 fs/ext4/xattr.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.h |  2 ++
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..b9b0ada7774b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1070,8 +1070,14 @@ struct ext4_inode_info {
 	 * between readers of EAs and writers of regular file data, so
 	 * instead we synchronize on xattr_sem when reading or changing
 	 * EAs.
+	 *
+	 * EA inodes (EXT4_EA_INODE_FL) do not use xattr_sem; they reuse
+	 * the space for deferred iput linkage.
 	 */
-	struct rw_semaphore xattr_sem;
+	union {
+		struct rw_semaphore xattr_sem;
+		struct llist_node i_ea_iput_node;
+	};
 
 	/*
 	 * Inodes with EXT4_STATE_ORPHAN_FILE use i_orphan_idx. Otherwise
@@ -1770,6 +1776,11 @@ struct ext4_sb_info {
 	struct ext4_es_stats s_es_stats;
 	struct mb_cache *s_ea_block_cache;
 	struct mb_cache *s_ea_inode_cache;
+
+	/* Deferred iput for EA inodes to avoid lock ordering issues */
+	struct llist_head s_ea_inode_to_free;
+	struct delayed_work s_ea_inode_work;
+
 	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
 
 	/* Journal triggers for checksum computation */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded..3efa5a817bef 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1303,6 +1303,8 @@ static void ext4_put_super(struct super_block *sb)
 			 &sb->s_uuid);
 
 	ext4_unregister_li_request(sb);
+	/* Drain deferred EA inode iputs while quota is still active. */
+	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 
 	destroy_workqueue(sbi->rsv_conversion_wq);
@@ -1423,6 +1425,13 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
 	ei->jinode = NULL;
+	/*
+	 * Reinitialize xattr_sem every allocation because EA inodes
+	 * share this space with i_ea_iput_node (via union) which may
+	 * have overwritten the semaphore when the slab object was
+	 * previously used as an EA inode.
+	 */
+	init_rwsem(&ei->xattr_sem);
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
 	spin_lock_init(&ei->i_completed_io_lock);
 	ei->i_sync_tid = 0;
@@ -1488,7 +1497,6 @@ static void init_once(void *foo)
 	struct ext4_inode_info *ei = foo;
 
 	INIT_LIST_HEAD(&ei->i_orphan);
-	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
 	inode_init_once(&ei->vfs_inode);
 	ext4_fc_init_inode(&ei->vfs_inode);
@@ -5497,6 +5505,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 			  ext4_has_feature_orphan_present(sb) ||
 			  ext4_has_feature_journal_needs_recovery(sb));
 
+	ext4_init_ea_inode_work(sbi);
+
 	if (ext4_has_feature_mmp(sb) && !sb_rdonly(sb)) {
 		err = ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block));
 		if (err)
@@ -5747,6 +5757,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	return 0;
 
 failed_mount9:
+	/* Drain deferred EA inode iputs before quota shutdown */
+	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 failed_mount8: __maybe_unused
 	ext4_release_orphan_info(sb);
@@ -5767,6 +5779,8 @@ failed_mount8: __maybe_unused
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
 failed_mount_wq:
+	/* Drain deferred EA inode iputs before freeing structures */
+	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
 	sbi->s_ea_inode_cache = NULL;
 
@@ -5777,6 +5791,8 @@ failed_mount8: __maybe_unused
 		ext4_journal_destroy(sbi, sbi->s_journal);
 	}
 failed_mount3a:
+	/* Drain deferred EA inode iputs from journal replay */
+	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
 	/* flush s_sb_upd_work before sbi destroy */
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..d5bccc64b032 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -3025,6 +3025,66 @@ void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
 	kfree(ea_inode_array);
 }
 
+
+/*
+ * Worker function for deferred EA inode iput.  Processes all inodes queued
+ * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
+ */
+static void ext4_ea_inode_work(struct work_struct *work)
+{
+	struct ext4_sb_info *sbi = container_of(to_delayed_work(work),
+						struct ext4_sb_info,
+						s_ea_inode_work);
+	struct llist_node *node = llist_del_all(&sbi->s_ea_inode_to_free);
+
+	while (node) {
+		struct ext4_inode_info *ei = container_of(node,
+					struct ext4_inode_info, i_ea_iput_node);
+		node = node->next;
+		iput(&ei->vfs_inode);
+	}
+}
+
+/*
+ * Release a VFS reference on an EA inode.  Must be used instead of iput()
+ * in any context where xattr_sem or a jbd2 handle is held.
+ *
+ * If this is not the last reference, drops it immediately via
+ * iput_if_not_last() with no further action needed.
+ *
+ * If this is the last reference, the inode is linked onto a per-sb
+ * llist via i_ea_iput_node (embedded in ext4_inode_info, sharing space
+ * with the unused xattr_sem) and a delayed worker performs the final
+ * iput() in a clean context.
+ *
+ * Note: while an inode is on s_ea_inode_to_free, the unconsumed i_count
+ * reference (still 1) keeps it in the inode cache, so any concurrent
+ * iget() bumps i_count to >= 2 and iput_if_not_last() will succeed.
+ * Nobody will add the inode a second time until ext4_ea_inode_work()
+ * drops that reference via iput().
+ */
+void ext4_put_ea_inode(struct inode *inode)
+{
+	if (!inode)
+		return;
+	WARN_ON_ONCE(!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL));
+	if (iput_if_not_last(inode))
+		return;
+	llist_add(&EXT4_I(inode)->i_ea_iput_node,
+		  &EXT4_SB(inode->i_sb)->s_ea_inode_to_free);
+	/*
+	 * Use a short delay to allow multiple EA inodes to accumulate,
+	 * reducing workqueue wakeups when several are released together.
+	 */
+	schedule_delayed_work(&EXT4_SB(inode->i_sb)->s_ea_inode_work, 1);
+}
+
+void ext4_init_ea_inode_work(struct ext4_sb_info *sbi)
+{
+	init_llist_head(&sbi->s_ea_inode_to_free);
+	INIT_DELAYED_WORK(&sbi->s_ea_inode_work, ext4_ea_inode_work);
+}
+
 /*
  * ext4_xattr_block_cache_insert()
  *
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 1fedf44d4fb6..2ff4b6eccd40 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -190,6 +190,8 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 				   struct ext4_xattr_inode_array **array,
 				   int extra_credits);
 extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
+extern void ext4_init_ea_inode_work(struct ext4_sb_info *sbi);
+extern void ext4_put_ea_inode(struct inode *inode);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			    struct ext4_inode *raw_inode, handle_t *handle);
-- 
2.43.0

